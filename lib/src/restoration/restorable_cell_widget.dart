import 'dart:collection';

import 'package:flutter/widgets.dart';

import '../base/cell_observer.dart';
import '../cell_watch/cell_watcher.dart';
import '../value_cell.dart';
import 'restoration.dart';
import '../cell_widget/cell_widget.dart';

/// Provides functionality for creating cells which support state restoration.
///
/// Cells created using the [cell] method are persisted between builds of the
/// widget, see [CellInitializer.cell] for more information. Additionally, the
/// state of these cells is restored during state restoration of the application.
abstract class RestorableCellWidget extends StatelessWidget {
  /// Restoration id used to identify the state of the widget, see [RestorationMixin.restorationId]
  String get restorationId;

  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// This method has the same functionality as [CellInitializer.cell] with the
  /// addition that the state of the created cells is restored when restoring
  /// the widget state.
  ///
  /// For state restoration to happen the following conditions need to be met:
  ///
  /// 1. The widget must be within a route which is restorable, see
  ///    [Navigator.restorablePush].
  /// 2. The cell returned by [create] must be a [RestorableCell].
  ///
  /// If [restorable] is false, the state of the returned cell is not restored.
  /// If [restorable] is true, an assertion is violated if the cell returned
  /// by [create] is not a [RestorableCell]. Otherwise if [restorable] is null
  /// (the default) the state of the cell is only restored if the cell
  /// is a [RestorableCell].
  ///
  /// **NOTE**: Only cells holding values encodable by [StandardMessageCodec],
  /// can have their state restored. To restore the state of cells holding other
  /// value types, a [CellValueCoder] subclass has to be implemented for the
  /// value types. To use a [CellValueCoder] subclass, provide the constructor of
  /// the subclass in [coder].
  ///
  /// **NOTE**: This method may only be called within the [build] method.
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create, {
    bool? restorable,
    CellValueCoder Function() coder = CellValueCoder.new
  }) {
    assert(
        _RestorableCellWidgetState._activeState != null,
        'RestorableCellWidget.cell() called from outside build method. '
        'This usually happens when you call cell() from a widget builder function '
        'that is called after the build method returns, such as the builder functions '
        'used with the Builder and ValueListenableBuilder widgets. '
        'To fix this place the cell creation directly within the build '
        'method of the RestorableCellWidget.');

    if (restorable ?? true) {
      return _RestorableCellWidgetState._activeState!.getRestorableCell(
          create: create,
          makeCoder: coder,
          forceRestore: restorable ?? false
      );
    }
    else {
      return _RestorableCellWidgetState._activeState!.getCell(create);
    }
  }

  /// Register a callback to be called whenever the values of cells change.
  ///
  /// The function [watch] is called whenever the values of the cells referenced
  /// within it using [ValueCell.call] change. [watch] is called once immediately
  /// after it is registered.
  ///
  /// [watch] is not called after the widget is removed from the tree.
  ///
  /// **NOTE**: The callback is only registered once during the first build,
  /// and will not be registered again on subsequent builds.
  ///
  /// **NOTE**: This method may only be called within the [build] method.
  void watch(VoidCallback watch) {
    assert(
        _RestorableCellWidgetState._activeState != null,
        'RestorableCellWidget.watch() called from outside build method. '
        'This usually happens when you call watch() from a widget builder function '
        'that is called after the build method returns, such as the builder functions '
        'used with the Builder and ValueListenableBuilder widgets. '
        'To fix this place the call to watch() directly within the build '
        'method of the RestorableCellWidget.'
    );

    _RestorableCellWidgetState._activeState!.getWatcher(watch);
  }

  @override
  StatelessElement createElement() => _RestorableCellWidgetElement(
      this,
      restorationId: restorationId
  );
}

/// Element holding a [RestorableCellWidget]
class _RestorableCellWidgetElement extends StatelessElement {
  /// Restoration identifier to user
  final String restorationId;

  _RestorableCellWidgetElement(super.widget, {
    required this.restorationId
  });

  @override
  Widget build() {
    return _RestorableCellWidget(
        builder: super.build,
        restorationId: restorationId
    );
  }
}

/// Widget responsible for restoring the state of the cells
class _RestorableCellWidget extends StatefulWidget {
  /// Child widget builder function
  final Widget Function() builder;

  /// Restoration identifier to use
  final String restorationId;

  const _RestorableCellWidget({
    required this.builder,
    required this.restorationId
  });

  @override
  State<_RestorableCellWidget> createState() => _RestorableCellWidgetState();
}

class _RestorableCellWidgetState extends State<_RestorableCellWidget> with
    CellObserverState, RestorationMixin {
  /// State of the RestorableWidgee currently being built
  static _RestorableCellWidgetState? _activeState = null;

  /// Restorable list holding the saved cell states
  final _cellStates = _RestorableCellStateList();

  /// Is this the first build of the widget
  var _isFirstBuild = true;

  /// List of created cells
  final List<ValueCell> _cells = [];

  /// Index of the cell to retrieve/create when calling [getCell]/[getRestorableCell].
  var _curCell = 0;

  /// Index of the saved state to use when restoring the cell in [getRestorableCell].
  var _curCellState = 0;

  /// Observes the restorable cells for changes in their values
  late final _observer = _RestorableWidgetCellObserver(_cellStates);

  /// List of registered cell watchers
  final List<CellWatcher> _watchers = [];

  /// Index of watcher to retrieve/create when calling [getWatcher]
  var _curWatcher = 0;

  /// Retrieve/create the current cell.
  ///
  /// During the first build of the widget, [create] is called to create a new
  /// instance at the current cell index.
  ///
  /// In subsequent builds, [getCell] returns the existing cell instance at the
  /// current cell index.
  ///
  /// The cell index is advanced when calling this method.
  V getCell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    if (_isFirstBuild) {
      final cell = create();
      _cells.add(cell);
      _curCell++;

      return cell;
    }

    assert(
        _curCell < _cells.length,
        'RestorableCellWidget.cell() was called more times in this build of the '
        'widget than in the previous build. This usually happens when a call to '
        'cell() is placed inside a conditional or loop.'
    );

    return _cells[_curCell++] as V;
  }

  /// Retrieve/create the current cell, and restore its value.
  ///
  /// Like [getCell] but also restores the value of the cell, if there is a
  /// saved value. If there is no saved cell value, the cell is registered for
  /// restoration.
  ///
  /// If [forceRestore] is true an assertion is violated if the cell returned
  /// by [create] is not a [RestorableCell]. If [forceRestore] is false and
  /// the cell returned by [create] is not a [RestorableCell], its state is
  /// not restored.
  ///
  /// [makeCoder] is a [CellValueCoder] constructor to use when encoding/decoding
  /// the cell's value.
  ///
  /// The cell index is advanced when calling this method.
  V getRestorableCell<T, V extends ValueCell<T>>({
    required CreateCell<V> create,
    required CellValueCoder Function() makeCoder,
    required bool forceRestore,
  }) {
    final cell = getCell(create);

    if (_isFirstBuild) {
      assert(
        !forceRestore || cell is RestorableCell<T>,
        'RestorableCellWidget.cell(): cell returned by creation function is not '
        'a RestorableCell. You are seeing this error because you\'ve created a '
        'cell with cell(..., restore: true) which is not a RestorableCell. To '
        'fix this either return a RestorableCell from the creation function or '
        'call cell() without the restore argument.'
      );

      if (cell is! RestorableCell<T>) {
        return cell;
      }

      final coder = makeCoder();

      if (_curCellState < _cellStates.length) {
        cell.restoreState(_cellStates[_curCellState], coder);
      }
      else {
        _cellStates.add(cell.dumpState(coder));
      }

      final index = _curCellState;

      _observer.addCell(
          cell: cell,
          index: index,
          coder: coder
      );

      _curCellState++;
    }

    return cell;
  }

  /// Retrieve/create the current *cell watcher*.
  ///
  /// During the first build of the widget, a new cell watcher is created with
  /// watch function [watch], at the current watcher index.
  ///
  /// In subsequent builds, [getWatcher] returns the existing [CellWatcher]
  /// instance at the current watcher index.
  ///
  /// The watcher index is advanced when calling this method.
  CellWatcher getWatcher(VoidCallback watch) {
    if (_isFirstBuild) {
      final watcher = CellWatcher(watch);
      _watchers.add(watcher);
      _curWatcher++;

      return watcher;
    }

    assert(
        _curWatcher < _watchers.length,
        'RestorableCellWidget.watch() was called more times in this build of the '
        'widget than in the previous build. This usually happens when a call to '
        'watch() is placed inside a conditional or loop.'
    );

    return _watchers[_curWatcher++];
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_cellStates, 'live_cells_cell_values');
  }

  @override
  void dispose() {
    _observer.dispose();
    _cellStates.dispose();

    for (final watcher in _watchers) {
      watcher.stop();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previousActiveState = _activeState;

    try {
      _activeState = this;

      _curCell = 0;
      _curCellState = 0;
      _curWatcher = 0;

      return observe(widget.builder);
    }
    finally {
      _isFirstBuild = false;
      _activeState = previousActiveState;
    }
  }
}

/// Observes restorable cells for changes in their values.
///
/// Whenever the value of an observed cell changes, its state is saved in a
/// [_RestorableCellStateList].
class _RestorableWidgetCellObserver implements CellObserver {
  /// The restorable list into which to save the cell states.
  final _RestorableCellStateList _values;

  /// Maps cells to the indices, within [_values] at which to save their state.
  final Map<RestorableCell, int> _indices = HashMap();

  /// Maps cells to the [CellValueCoder] objects to use for encoding their values.
  final Map<RestorableCell, CellValueCoder> _coders = HashMap();

  /// Set of cells updated during the current update cycle
  final Set<RestorableCell> _updatedCells = HashSet();

  /// Is an update cycle ongoing?
  var _isUpdating = false;

  _RestorableWidgetCellObserver(this._values);

  /// Stop observing the cells for changes.
  /// 
  /// **NOTE**: This method must be called otherwise resources will be leaked.
  void dispose() {
    for (final cell in _indices.keys) {
      cell.removeObserver(this);
    }
  }
  
  /// Start observing [cell] for changes and save its state at [index] within [_values].
  /// 
  /// [coder] is the [CellValueCoder] used for encoding the cell's value.
  void addCell({
    required RestorableCell cell,
    required int index,
    required CellValueCoder coder
  }) {
    if (!_indices.containsKey(cell)) {
      _indices[cell] = index;
      _coders[cell] = coder;

      cell.addObserver(this);
    }
  }

  @override
  bool get shouldNotifyAlways => true;

  @override
  void update(covariant RestorableCell<dynamic> cell) {
    if (_isUpdating) {
      for (final cell in _updatedCells) {
        final index = _indices[cell]!;
        final coder = _coders[cell]!;

        _values[index] = cell.dumpState(coder);
      }

      _isUpdating = false;
      _updatedCells.clear();

      _values.notifyChanged();
    }
  }

  @override
  void willUpdate(ValueCell<dynamic> cell) {
    _isUpdating = true;
    _updatedCells.add(cell as RestorableCell);
  }
}

/// A [RestorableProperty] holding a list of saved cell states.
class _RestorableCellStateList extends RestorableProperty<List>{
  /// List of saved cell states
  List _states = [];

  /// Number of saved cell states in list
  int get length => _states.length;

  /// Retrieve the saved cell state at [index].
  operator [](int index) => _states[index];

  /// Set the saved cell state at [index].
  ///
  /// [state] must be of a type supported by [StandardMessageCodec].
  operator []=(int index, state) {
    _states[index] = state;
  }

  /// Append a new saved state to the list.
  void add(state) {
    _states.add(state);
  }

  /// Notify the observers of this property that the list of saved cell states has changd.
  void notifyChanged() {
    notifyListeners();
  }

  @override
  List createDefaultValue() {
    return [];
  }

  @override
  List fromPrimitives(Object? data) {
    return data as List;
  }

  @override
  void initWithValue(List value) {
    _states = value;
  }

  @override
  Object? toPrimitives() {
    // The list has to be copied otherwise the updated list is not saved.
    return List.from(_states);
  }
}