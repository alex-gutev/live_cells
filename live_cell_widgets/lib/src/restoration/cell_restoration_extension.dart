import 'package:live_cells_core/live_cells_core.dart';

import 'cell_restoration_manager.dart';

/// Provides the [restore] method for restoring the state of the cell.
extension CellRestorationExtension<T extends ValueCell> on T {
  /// Register the cell for restoration and restore its state.
  ///
  /// This method may only be called within a [CellWidget] or [StaticWidget]
  /// build method, with a non-null "restorationId".
  ///
  /// This cell must be a [RestorableCell].
  ///
  /// Only cells holding values encodable by [StandardMessageCodec],
  /// can have their state restored. To restore the state of cells holding other
  /// value types, a suitable [CellValueCoder] has to be provided in [coder].
  ///
  /// If [optional] is true, state restoration is only attempted if the cell is
  /// in a context where cell state restoration is supported. If false,
  /// attempting to restore a cell outside of a context providing cell restoration,
  /// violates an assertion.
  ///
  /// Returns [this].
  T restore({
    CellValueCoder coder = const CellValueCoder(),
    optional = false
  }) {
    assert(
      this is RestorableCell,
      'ValueCell.restore() called on a cell, which is not a RestorableCell. '
          'Either change the cell to a RestorableCell or remove the `.restore()` '
          'call.'
    );

    if (!optional || CellRestorationManagerState.isActive) {
      CellRestorationManagerState.activeState.registerCell(
          cell: this as RestorableCell,
          coder: coder
      );
    }

    return this;
  }
}