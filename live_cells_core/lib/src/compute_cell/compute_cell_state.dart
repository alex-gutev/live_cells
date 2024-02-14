import 'package:flutter/foundation.dart';

import '../stateful_cell/cell_state.dart';
import '../base/exceptions.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

/// A cell state with a computed value.
///
/// This class should be subclassed to provide an implementation of the [compute]
/// method, which is called when the cell's value should be recomputed.
///
/// The [value] property of this state object retrieves the cell's value.
abstract class ComputeCellState<T, S extends StatefulCell> extends CellState<S>
    with ObserverCellState<S> {
  /// Set of argument cells
  final Set<ValueCell> arguments;

  /// Create a ComputeCellState with a set of [argument] cells
  ///
  /// An observer is added to every cell in [arguments] when this state is
  /// initialized and removed when this state is disposed. Cells may be
  /// added to [arguments] after [init] has been called as long as this state
  /// has been added as an observer to the cells with [ValueCell.addListener].
  ComputeCellState({
    required super.cell,
    required super.key,
    required this.arguments
  });

  /// Compute the value of the cell.
  ///
  /// This method should be overridden by subclasses to compute the value.
  ///
  /// **NOTE**: There is no need to handle [StopComputeException], it is already
  /// handled.
  @protected
  T compute();

  /// Retrieve the value of the cell.
  ///
  /// If [stale] is true, [compute] is called to compute a new value.
  T get value {
    if (stale) {
      try {
        _value = compute();
      }
      on StopComputeException catch (e) {
        if (!_hasValue) {
          _value = e.defaultValue;
        }
      }

      stale = false;
      _hasValue = true;
    }

    return _value;
  }

  /// Set the value directly.
  ///
  /// This is provided to allow for implementing cells which function both
  /// as mutable cells and computed cells.
  @protected
  void setValue(T value) {
    _value = value;
  }

  @override
  bool get shouldNotifyAlways => false;

  @override
  bool shouldNotify(ValueCell cell, newValue) => true;

  // Private

  /// The value
  late T _value;

  var _hasValue = false;

  @override
  void init() {
    super.init();

    for (final arg in arguments) {
      arg.addObserver(this);
    }
  }

  @override
  void dispose() {
    for (final arg in arguments) {
      arg.removeObserver(this);
    }

    super.dispose();
  }
}