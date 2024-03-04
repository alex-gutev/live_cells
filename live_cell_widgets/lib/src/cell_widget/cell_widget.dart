import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:live_cell_widgets/src/restoration/cell_restoration_manager.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';

part 'cell_initializer.dart';
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
abstract class CellWidget extends StatelessWidget {
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
  /// The returned widget includes the [CellInitializer] mixin, which allows the
  /// [CellWidgetContextExtension.cell] method to be called on the [BuildContext]
  /// passed to [builder].
  ///
  /// If [restorationId] is non-null it is used as the restoration ID for
  /// restoring the state of the cells created using
  /// [CellWidgetContextExtension.cell].
  ///
  /// Example:
  ///
  /// ```dart
  /// WidgetCell.builder((context) => Text('The value of cell a is ${a()}'))
  /// ```
  factory CellWidget.builder(WidgetBuilder builder, {
    Key? key,
    String? restorationId
  }) => _WidgetCellBuilder(builder,
    key: key,
    restorationId: restorationId,
  );

  @override
  StatelessElement createElement() => restorationId != null
      ? _RestorableCellWidgetElement(this, restorationId!)
      : _CellWidgetElement(this);
}

/// [CellWidget] with the [build] method defined by [builder].
class _WidgetCellBuilder extends CellWidget with CellInitializer {
  /// Widget builder function
  final WidgetBuilder builder;

  /// Create a [CellWidget] with [build] defined by [builder].
  _WidgetCellBuilder(this.builder, {
    super.key,
    super.restorationId
  });

  @override
  Widget build(BuildContext context) => builder(context);
}

/// Element for [CellWidget].
///
/// Keeps track of cells that were referenced during the [build] method and
/// automatically marks the widget for rebuilding if the value of a referenced
/// cell changes.
class _CellWidgetElement extends StatelessElement {
  _CellWidgetElement(super.widget) {
    _observer = _WidgetCellObserver(markNeedsBuild);
  }

  Set<ValueCell> _arguments = HashSet();
  late _WidgetCellObserver _observer;

  /// If true the widget hasn't been built for the first time yet.
  var _firstBuild = true;

  /// The number of non-keyed cells defined in the [build] method.
  var _numCells = 0;

  /// Generate a key for the cell at index [index].
  _WidgetCellKey _generateCellKey(int index) {
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

  _WidgetCellKey _cellKeyForIndex(int index) {
    return _WidgetCellKey(this, index);
  }

  @override
  Widget build() {
    final Set<ValueCell> newArguments = HashSet();

    var keyIndex = 0;

    late final Widget widget;

    try {
      AutoKey.withAutoKeys(() => _generateCellKey(keyIndex++), () {
        widget = ComputeArgumentsTracker.computeWithTracker(() => super.build(), (cell) {
          newArguments.add(cell);

          if (!_arguments.contains(cell)) {
            _arguments.add(cell);
            cell.addObserver(_observer);
          }
        });
      });
    }
    finally {
      _firstBuild = false;
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
  void unmount() {
    for (final cell in _arguments) {
      cell.removeObserver(_observer);
    }

    _arguments.clear();

    _disposeCells();

    super.unmount();
  }

  /// Dispose the state of all cells defined during the build method.
  ///
  /// This is necessary to remove mutable cell state from the global state
  /// table.
  void _disposeCells() {
    for (var i = 0; i < _numCells; i++) {
      final key = _cellKeyForIndex(i);
      CellState.maybeGetState(key)?.removeAllObservers();
    }
  }
}

class _RestorableCellWidgetElement extends _CellWidgetElement {
  final String _restorationId;

  _RestorableCellWidgetElement(super.widget, this._restorationId);

  @override
  Widget build() => CellRestorationManager(
      builder: super.build,
      restorationId: _restorationId
  );
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

/// Key identifying a cell defined within CellWidget.build.
class _WidgetCellKey extends CellKey2<BuildContext, int> {
  _WidgetCellKey(super.value1, super.value2);
}