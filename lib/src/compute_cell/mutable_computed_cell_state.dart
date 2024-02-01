import 'package:flutter/foundation.dart';

import '../mutable_cell/mutable_cell.dart';
import '../mutable_cell/mutable_dependent_cell.dart';
import '../value_cell.dart';
import 'compute_cell_state.dart';

/// Cell state for a mutable computed cell.
///
/// This provides a public [value] setter which sets the value of the
/// cell directly.
class MutableComputedCellState<T, S extends MutableDependentCell> extends ComputeCellState<T, S> {
  MutableComputedCellState({
    required super.cell,
    required super.key,
    required super.arguments
  });

  @override
  T compute() => cell.compute();

  @override
  T get value {
    if (stale) {
      _computed = true;
    }

    return super.value;
  }

  set value(T value) {
    final isEqual = this.value == value;

    _reverse = true;
    notifyWillUpdate(isEqual);

    updating = false;
    stale = false;
    _computed = false;

    setValue(value);

    MutableCell.batch(() {
      try {
        cell.reverseCompute(value);
      }
      catch (e, st) {
        if (kDebugMode) {
          print('Exception in MutableDependentCell reverse computation function: $e - $st');
        }
      }
    });

    if (MutableCell.isBatchUpdate) {
      MutableCell.addToBatch(cell, isEqual);
    }
    else {
      notifyUpdate(isEqual);
    }

    _reverse = false;
  }

  // Private

  /// Is a reverse computation being performed?
  var _reverse = false;

  /// Is the current value computed or assigned using the [value] property.
  var _computed = true;

  @override
  bool get shouldNotifyAlways => true;

  @override
  void willUpdate(ValueCell cell) {
    if (!_reverse) {
      super.willUpdate(cell);
    }
  }
}