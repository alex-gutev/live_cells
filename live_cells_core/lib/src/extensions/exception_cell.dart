import 'package:live_cells_core/src/extensions/compute_extension.dart';

import '../base/keys.dart';
import '../value_cell.dart';

/// Provides the [exception] method for creating a cell that throws an exception.
extension ExceptionCellExtension<T extends Object> on ValueCell<T> {
  /// Create a cell that throws [this] is an exception.
  ValueCell<U> exception<U>() => apply((value) => throw value,
    key: _ExceptionCellKey<T>(this)
  );
}

/// Key identifying a cell created with [ExceptionCellExtension.exception]
class _ExceptionCellKey<T> extends CellKey1<ValueCell<T>> {
  _ExceptionCellKey(super.value);
}