import 'package:live_cells_core/live_cells_core.dart';

/// Provides methods for handling [EmptyMetaCellError].
extension MetaCellExtension<T extends Object?> on MetaCell<T> {
  /// Create a cell that evaluates to the value of [cell] when this meta cell is empty.
  ///
  /// **NOTE**: The returned cell will evaluate to the value of [cell] until,
  /// the value of the cell, pointed to by this meta cell, changes its value.
  ValueCell<T> withDefault(ValueCell<T> cell) =>
      onError<EmptyMetaCellError>(cell);
}

/// Provides methods for handling [EmptyMetaCellError]
extension ActionMetaCellExtension on MetaCell<void> {
  /// Create a cell that handles [EmptyMetaCellError]s thrown by this cell.
  ValueCell<void> get onTrigger =>
    onError<EmptyMetaCellError>(null.cell);
}