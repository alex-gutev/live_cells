import '../base/keys.dart';
import '../compute_cell/compute_cell.dart';
import 'conversion_extensions.dart';
import 'error_handling_extension.dart';
import '../meta_cell/meta_cell.dart';
import '../value_cell.dart';

/// Provides methods for handling [EmptyMetaCellError].
extension MetaCellExtension<T extends Object?> on MetaCell<T> {
  /// Create a cell that evaluates to the value of [cell] when this meta cell is empty.
  ///
  /// **NOTE**: The returned cell will evaluate to the value of [cell] until,
  /// the value of the cell, pointed to by this meta cell, changes its value.
  ValueCell<T> withDefault(ValueCell<T> cell) =>
      onError<EmptyMetaCellError>(cell);

  /// Create a cell that evaluates to [ValueCell.none()] when this meta cell is empty.
  ValueCell<T> get whenReady => ComputeCell(
    key: _MetaCellExtensionKey(this, #whenReady),
    arguments: {this},
    compute: () {
      try {
        return value;
      }
      on EmptyMetaCellError {
        return ValueCell.none();
      }
    },
  );
}

/// Provides methods for handling [EmptyMetaCellError]
extension ActionMetaCellExtension on MetaCell<void> {
  /// Create a cell that handles [EmptyMetaCellError]s thrown by this cell.
  ValueCell<void> get onTrigger =>
    onError<EmptyMetaCellError>(null.cell);
}

/// Key identifying a cell produced by an extensions on [MetaCell].
class _MetaCellExtensionKey extends CellKey2<MetaCell, Symbol> {
  _MetaCellExtensionKey(super.value1, super.value2);
}