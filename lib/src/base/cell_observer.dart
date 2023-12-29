import '../value_cell.dart';

/// Interface for observing changes to the value of a [ValueCell]
abstract class CellObserver {
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