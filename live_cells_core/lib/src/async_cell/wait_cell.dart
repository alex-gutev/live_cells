import 'dart:async';

import '../base/exceptions.dart';
import 'async_cell_state_mixin.dart';

import '../base/keys.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

/// A cell which waits for a [Future] held in another cell to complete.
///
/// Until the [Future] completes, accessing the [value] of the cell will throw
/// a [PendingAsyncValueError].
class WaitCell<T> extends StatefulCell<T> {
  /// Create a cell which waits for the [Future] held in [arg] to complete
  WaitCell({
    required this.arg,
    this.lastOnly = false
  }) : super(key: _WaitCellKey(arg, lastOnly));

  @override
  T get value {
    final state = this.state as _WaitCellState<T>?;

    if (state != null) {
      return state.value;
    }

    throw UninitializedCellError();
  }

  // Private

  /// Argument cell holding [Future]
  final ValueCell<Future<T>> arg;
  
  /// Should only the last future be awaited?
  final bool lastOnly;

  @override
  CellState<StatefulCell> createState() => _WaitCellState<T>(
      cell: this,
      key: key
  );
}

/// State for [WaitCell]
class _WaitCellState<T> extends CellState<WaitCell<T>>
    with ObserverCellState<WaitCell<T>>, AsyncCellStateMixin<T,WaitCell<T>> {
  _WaitCellState({
    required super.cell,
    required super.key
  });

  @override
  void onWillUpdate() {
    // Prevent observers from being notified before delay
  }

  @override
  void onUpdate(bool didChange) {
    // Prevent observers from being notified before delay
  }

  @override
  ValueCell<Future<T>> get argCell => cell.arg;

  @override
  bool get lastOnly => cell.lastOnly;
}

/// Key identifying a [WaitCell].
class _WaitCellKey<T> extends CellKey2<ValueCell<T>, bool> {
  /// Create a key for identifying a [WaitCell].
  ///
  /// The key identifies a [WaitCell] which waits for the value held in argument
  /// cell [value].
  _WaitCellKey(super.value1, super.value2);
}