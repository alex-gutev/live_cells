import '../value_cell.dart';

/// Interface for observing changes to the value of a [ValueCell]
abstract class CellObserver {
  /// Should the observer be notified if the new value of the cell is equal to the previous value?
  ///
  /// If false the observer is only notified if the new value is different
  /// from the previous value.
  bool get shouldNotifyAlways => false;

  /// Should this observer be notified for a given value change?
  ///
  /// This method is called prior to calling [willUpdate] and its return value
  /// determines whether [willUpdate] will be called (true) or not (false).
  ///
  /// [cell] is the observed cell, of which the value will be set to [newValue]
  /// after [willUpdate] is called on all its observers.
  ///
  /// **NOTE**: This function is only called if [newValue] is known, which is
  /// generally only the case when setting the value of a [MutableCell].
  bool shouldNotify(ValueCell cell, newValue) => true;

  /// The observed cell will change its value.
  ///
  /// This method is called when the value of an ancestor of [cell] has been
  /// changed however the value of [cell] has not been recomputed.
  ///
  /// [cell.value] still holds the cell's previous value.
  void willUpdate(ValueCell cell);

  /// The observed cell has changed its value.
  ///
  /// This method is called after the value of [cell] has been
  /// recomputed.
  ///
  /// [cell.value] now holds the cell's new value.
  void update(ValueCell cell);
}