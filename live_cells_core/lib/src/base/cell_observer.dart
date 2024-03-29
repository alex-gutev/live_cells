import '../value_cell.dart';

/// Interface for observing changes to the value of a [ValueCell]
abstract class CellObserver {
  /// Should the observer be notified if the new value of the cell is equal to the previous value?
  ///
  /// If false the observer is only notified if the new value is different
  /// from the previous value.
  bool get shouldNotifyAlways => false;

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
  /// If it is known that the value of [cell] has not changed, [didChange] is
  /// false otherwise a value of true for [didChange] indicates that [cell]'s
  /// value may have changed (but necessarily has).
  ///
  /// [cell.value] now holds the cell's new value.
  void update(ValueCell cell, bool didChange);
}