/// Interface for observing changes to the value of a [ValueCell]
abstract class CellObserver {
  /// The observed cell will change its value.
  ///
  /// This method is called when the value of an ancestor of the cell has been
  /// changed however the value of the observed cell has not been recomputed.
  ///
  /// The [ValueCell.value] property of the observed cell still holds the
  /// cell's previous value.
  void willUpdate();

  /// The observed cell has changed its value.
  ///
  /// This method is called after the value of the observed cell has been
  /// recomputed.
  ///
  /// The [ValueCell.value] property of the observed cell will now hold the
  /// cell's new value.
  void update();

  /// The observed will not change its value.
  ///
  /// This method is called if the observed cell was marked for changes (that
  /// is [willUpdate] was called) but its new value is the same as its
  /// previous value.
  void willNotUpdate();
}