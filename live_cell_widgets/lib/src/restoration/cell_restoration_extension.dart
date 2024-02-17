import 'package:live_cells_core/live_cells_core.dart';

import 'cell_restoration_manager.dart';

/// Provides the [restore] method for restoring the state of the cell.
extension CellRestorationExtension<T extends ValueCell> on T {
  /// Register the cell for restoration and restore its state.
  ///
  /// This method may only be called within a [StaticWidget] build function,
  /// with a non-null [StaticWidget.restorationId].
  ///
  /// This cell must be a [RestorableCell].
  ///
  /// Only cells holding values encodable by [StandardMessageCodec],
  /// can have their state restored. To restore the state of cells holding other
  /// value types, a suitable [CellValueCoder] has to be provided in [coder].
  ///
  /// Returns [this].
  T restore({
    CellValueCoder coder = const CellValueCoder()
  }) {
    assert(
      this is RestorableCell,
      'ValueCell.restore() called on a cell, which is not a RestorableCell. '
          'Either change the cell to a RestorableCell or remove the `.restore()` '
          'call.'
    );

    CellRestorationManagerState.activeState.registerCell(
      cell: this as RestorableCell,
      coder: coder
    );

    return this;
  }
}