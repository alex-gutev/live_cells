import 'package:live_cells/live_cells.dart';
import 'package:live_cells/src/base/cell_listeners.dart';
import 'package:live_cells/src/base/managed_cell.dart';

/// Represents reading FutureCell.value before Future has completed
class NoCellValueError implements Exception {
  @override
  String toString() => 'FutureCell.value accessed when hasValue = false';
}

/// ValueCell which takes its value from a future
class FutureCell<T> extends ManagedCell<T> with CellEquality<T>, CellListeners<T> {
  /// Does the cell have a value?
  ///
  /// This is true after the future has completed, or if the cell has been
  /// given a default value.
  bool get hasValue => _hasValue;

  /// Create a FutureCell which takes its value from [future]
  ///
  /// If [defaultValue] is not null, or [T] is a nullable type, the
  /// cell's is initialized to [defaultValue] until the future completes and
  /// [hasValue] is true.
  FutureCell(Future<T> future, {
    T? defaultValue
  }) {
    if (defaultValue != null) {
      _hasValue = true;
      _value = defaultValue;
    }
    else if (null is T) {
      _hasValue = true;
      _value = null as T;
    }

    future.then((value) {
      _hasValue = true;
      _value = value;

      notifyListeners();
    });
  }

  @override
  T get value {
    if (!_hasValue) {
      throw NoCellValueError();
    }

    return _value;
  }

  /// Private

  var _hasValue = false;
  late T _value;
}