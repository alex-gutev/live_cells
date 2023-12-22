import 'package:flutter/foundation.dart';

import 'value_cell.dart';
import 'cell_listeners.dart';
import 'managed_cell.dart';

/// A [ValueCell] that stores its own value and manages its own listeners
///
/// This class should be subclassed when a cell is required to store its value
/// rather than computing it on demand.
abstract class NotifierCell<T> extends ManagedCell<T> with CellEquality<T>, CellListeners<T> {
  /// Creates a [NotifierCell] with an initial value
  NotifierCell(this._value);

  @override
  T get value => _value;

  @protected
  set value(T value) {
    if (_value == value) {
      return;
    }

    _value = value;
    notifyListeners();
  }

  /// Private

  /// The cell's value
  ///
  /// The listeners of the cell are notified only when the value is replaced
  /// with a value that is not equal to the old value as evaluated by the
  /// equality operator ==.
  T _value;
}