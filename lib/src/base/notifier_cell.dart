import 'package:flutter/foundation.dart';

import '../value_cell.dart';
import 'cell_listeners.dart';
import 'managed_cell.dart';

/// A [ValueCell] that stores its own value and manages its own observers.
///
/// This class should be subclassed when a cell is required to store its value
/// rather than computing it on demand.
abstract class NotifierCell<T> extends ManagedCell<T> with CellEquality<T>, CellListeners<T> {
  /// Creates a [NotifierCell] with an initial value.
  NotifierCell(this._value);

  /// The stored value of the cell.
  ///
  /// When this property is set the following steps are performed:
  ///
  ///  1. The [CellObserver.willUpdate] method of the cell's observers is called.
  ///  2. The value is changed
  ///  3. The [CellObserver.update] method of the cell's observers is called.
  ///
  /// If this property is set to a value which is identical to its previous value
  /// the above steps are not performed.
  @override
  T get value => _value;

  @protected
  set value(T value) {
    if (_value == value) {
      return;
    }

    notifyWillUpdate();
    _value = value;
    notifyUpdate();
  }

  /// Set the value of the cell without notifying the cell's observers.
  @protected
  void setValue(T value) {
    _value = value;
  }

  /// Private

  /// The cell's value
  T _value;
}