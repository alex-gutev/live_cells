import '../base/cell_observer.dart';
import '../value_cell.dart';

/// Provides the [hold] method for keeping a cell active.
extension CellHolderExtension on ValueCell {
  /// Ensure that this cell is active.
  ///
  /// This method keeps this cell active until [CellHolder.release] is called
  /// on the returned [CellHolder].
  ///
  /// This method is useful for cells which do not function unless they have
  /// at least one observer.
  CellHolder hold() => CellHolder(this);
}

/// A "holder" that keeps a cell active until it is released explicitly
class CellHolder {
  /// Hold a cell and keep it active until [release] is called.
  CellHolder(this._cell) {
    _cell.addObserver(_observer);
  }

  /// Release the held cell.
  ///
  /// If the cell has no observers, the cell is deactivated.
  void release() {
    _cell.removeObserver(_observer);
  }

  // Private

  final ValueCell _cell;

  final _observer = _CellHolderObserver();
}

/// A dummy observer to keep a cell active.
class _CellHolderObserver extends CellObserver {
  @override
  void update(ValueCell<dynamic> cell, bool didChange) {}

  @override
  void willUpdate(ValueCell<dynamic> cell) {}
}