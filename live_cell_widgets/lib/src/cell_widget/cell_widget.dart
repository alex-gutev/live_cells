import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:live_cell_widgets/src/restoration/cell_restoration_manager.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';

part 'cell_observer_state.dart';

/// A widget which is rebuilt in response to changes in the values of [ValueCell]'s.
///
/// When the value of a [ValueCell] is referenced within the [build] method,
/// using [ValueCell.call], the widget is automatically rebuilt whenever the
/// value of the referenced cell changes.
///
/// Example:
///
/// ```dart
/// class Example extends WidgetCell {
///   final ValueCell<int> a;
///
///   Example({
///     super.key
///     required this.a
///   });
///
///   @override
///   Widget build(BuildContext context) {
///     return Text('The value of cell a is ${a()}');
///   }
/// }
/// ```
///
/// In the above example, the widget is rebuilt automatically whenever the
/// value of cell `a` is changed.
///
/// Cells defined directly within the [build] will have their state persisted
/// between builds. For this to happen the following rules have to be
/// observed:
///
/// 1. Cells should not be defined conditionally or in loops.
/// 2. Cells should not be defined in callback or builder functions of widgets
///    nested in this widget.
///
/// The following is an example of correctly placed cell definitions:
///
/// ```dart
/// @override
/// Widget build (BuildContext context) {
///   final count = MutableCell(0);
///   final next = ValueCell.computed(() => count() + 1);
///   ...
/// }
/// ```
///
/// The following is an example of incorrectly placed cell definitions:
///
/// ```dart
/// @override
/// Widget build (BuildContext context) {
///   if (...) {
///     // This is bad because the cell is defined conditionally
///     final count = MutableCell(0);
///   }
///
///   while (...) {
///     // This is bad because the definition appears within a loop
///     final count = MutableCell(0);
///   }
///
///   return Builder((context) {
///     // This is bad because the definition appears in a builder function
///     // of a nested widget and the [CellWidget] will not be able to persist
///     // its state between builds.
///     final count = MutableCell(0);
///   });
/// }
/// ```
abstract class CellWidget extends StatefulWidget {
  /// Restoration ID to use for restoring the cell state
  ///
  /// If null state restoration is not performed.
  final String? restorationId;

  const CellWidget({
    super.key,
    this.restorationId
  });

  /// Create a [CellWidget] with the [build] method defined by [builder].
  ///
  /// This allows a widget, which is dependent on the values of one or more cells,
  /// to be defined without subclassing.
  ///
  /// Cells defined directly within [builder] will have their state restored
  /// between builds. The same rules must be observed when defining cells in
  /// [builder] that must be observed when defining cells in the [build]
  /// method of a [CellWidget] subclass.
  ///
  /// If [restorationId] is non-null it is used as the restoration ID for
  /// restoring the state of the cells created within [builder].
  ///
  /// Example:
  ///
  /// ```dart
  /// WidgetCell.builder((context) => Text('The value of cell a is ${a()}'))
  /// ```
  factory CellWidget.builder(Widget Function(BuildContext context) builder, {
    Key? key,
    String? restorationId
  }) => _CellWidgetBuilder(builder,
    key: key,
    restorationId: restorationId,
  );

  /// Build the widget underneath this widget in the tree
  Widget build(BuildContext context);
  
  @override
  State<CellWidget> createState() => _RestorableCellWidgetState();
}

/// [CellWidget] with the [build] method defined by [builder].
class _CellWidgetBuilder extends CellWidget {
  /// Widget builder function
  final Widget Function(BuildContext context) builder;

  /// Create a [CellWidget] with [build] defined by [builder].
  const _CellWidgetBuilder(this.builder, {
    super.key,
    super.restorationId
  });

  @override
  Widget build(BuildContext context) => builder(context);
}

class _CellWidgetState extends State<CellWidget> {
  Set<ValueCell> _arguments = HashSet();
  late _WidgetCellObserver _observer;

  /// Observer used to keep the cells active
  final _holdObserver = _HoldCellObserver();

  /// If true the widget hasn't been built for the first time yet.
  var _firstBuild = true;

  /// The number of non-keyed cells defined in the [build] method.
  var _numCells = 0;

  /// The number of watch functions registered in the [build] method.
  var _numWatchers = 0;
  
  @override
  void initState() {
    super.initState();
    _observer = _WidgetCellObserver(_rebuild);
  }
  
  /// Generate a key for the cell at index [index].
  _WidgetCellKey _generateCellKey(ValueCell cell, int index) {
    if (_firstBuild) {
      assert(index == _numCells, 'This indicates a bug in live_cell_widgets. '
          'Please report it.');
      _numCells++;

      return _WidgetCellKey(this, index);
    }

    assert(index < _numCells,
      'More cells defined during this build of the '
        'widget than in the previous build. This usually happens when a cell definition '
        'is placed within a conditional or loop inside the CellWidget.build method.'
    );

    return _cellKeyForIndex(index);
  }

  /// Generate a key for the watch function at index [index].
  _WidgetCellKey _generateWatchKey(CellWatcher watcher, int index) {
    if (_firstBuild) {
      assert(index == _numWatchers, 'This indicates a bug in live_cell_widgets. '
          'Please report it.');
      _numWatchers++;

      return _WidgetCellKey(this, index);
    }

    assert(index < _numWatchers,
      'More watch functions registered during this build of the '
        'widget than in the previous build. This usually happens when a watch functionn '
        'is registered conditionally or in a loop inside the CellWidget.build method.'
    );

    return _cellKeyForIndex(index);
  }

  _WidgetCellKey _cellKeyForIndex(int index) {
    return _WidgetCellKey(this, index);
  }

  /// Trigger a rebuild of the widget
  ///
  /// If the widget tree is currently in the build phase, the build is scheduled
  /// using [addPostFrameCallback].
  void _rebuild() {
    switch (SchedulerBinding.instance.schedulerPhase) {
      case SchedulerPhase.idle:
      case SchedulerPhase.postFrameCallbacks:
        setState(() {});

      case SchedulerPhase.transientCallbacks:
      case SchedulerPhase.midFrameMicrotasks:
      case SchedulerPhase.persistentCallbacks:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<ValueCell> newArguments = HashSet();

    var keyIndex = 0;
    var watchKeyIndex = 0;

    late final Widget widget;

    // List of cells to keep active while widget is mounted
    final holdCells = <ValueCell>[];

    generateKey(ValueCell cell) {
      if (_firstBuild && cell is StatefulCell) {
        holdCells.add(cell);
      }

      return _generateCellKey(cell, keyIndex++);
    }

    generateWatchKey(CellWatcher watcher) => _generateWatchKey(watcher, watchKeyIndex++);

    try {
      AutoKey.withAutoWatchKeys(generateWatchKey, () {
        AutoKey.withAutoKeys(generateKey, () {
          widget = ComputeArgumentsTracker.computeWithTracker(() => this.widget.build(context), (cell) {
            newArguments.add(cell);

            if (!_arguments.contains(cell)) {
              _arguments.add(cell);
              cell.addObserver(_observer);
            }
          });
        });
      });
    }
    finally {
      _firstBuild = false;
    }

    for (final cell in holdCells) {
      cell.addObserver(_holdObserver);
    }

    // Stop observing cells which are no longer referenced

    for (final arg in _arguments) {
      if (!newArguments.contains(arg)) {
        arg.removeObserver(_observer);
      }
    }

    _arguments = newArguments;

    return widget;
  }

  @override
  void dispose() {
    for (final cell in _arguments) {
      cell.removeObserver(_observer);
    }

    _arguments.clear();

    _disposeCells();
    _stopWatchFunctions();

    super.dispose();
  }

  /// Dispose the state of all cells defined during the build method.
  ///
  /// This is necessary to remove mutable cell state from the global state
  /// table.
  void _disposeCells() {
    for (var i = 0; i < _numCells; i++) {
      final key = _cellKeyForIndex(i);
      CellState.maybeGetState(key)?.removeObserver(_holdObserver);
    }
  }

  /// Stop all watch functions defined in the widget build method
  void _stopWatchFunctions() {
    for (var i = 0; i < _numWatchers; i++) {
      final key = _cellKeyForIndex(i);
      CellWatcher.stopByKey(key);
    }
  }
}

class _RestorableCellWidgetState extends _CellWidgetState {
  @override
  Widget build(BuildContext context) => 
      widget.restorationId != null ? CellRestorationManager(
          builder: () => super.build(context), 
          restorationId: widget.restorationId!
      ) : super.build(context);
}

/// [CellObserver] that calls a callback when all argument cells have updated
/// their values.
class _WidgetCellObserver extends CellObserver {
  /// Callback function to call
  final VoidCallback listener;

  /// Are the argument cells in the process of updating their values?
  var _isUpdating = false;

  /// Is the observer waiting for [update] to be called with didChange equal to true.
  var _waitingForChange = false;

  _WidgetCellObserver(this.listener);

  @override
  void update(ValueCell cell, bool didChange) {
    if (_isUpdating || (didChange && _waitingForChange)) {
      _isUpdating = false;
      _waitingForChange = !didChange;

      if (didChange) {
        listener();
      }
    }
  }

  @override
  void willUpdate(ValueCell cell) {
    if (!_isUpdating) {
      _isUpdating = true;
      _waitingForChange = false;
    }
  }
}

/// A 'dummy' observer used to keep a cell active while a CellWidget is mounted
class _HoldCellObserver extends CellObserver {
  @override
  void update(ValueCell<dynamic> cell, bool didChange) {}

  @override
  void willUpdate(ValueCell<dynamic> cell) {}
}

/// Key identifying a cell defined within CellWidget.build.
class _WidgetCellKey extends CellKey2<State, int> {
  _WidgetCellKey(super.value1, super.value2);
}