import '../value_cell.dart';

/// Extends [ValueCell] with facilities for handling exceptions thrown while computing values
extension ErrorCellExtension<T> on ValueCell<T> {
  /// Create a cell which handles exceptions thrown while computing the value of [this].
  ///
  /// If an exception is thrown while computing the value of [this], the cell
  /// returns the value of [other].
  ///
  /// [E] is the type of exception to handle. By default, if this is not
  /// explicitly given, all exceptions are handled.
  ValueCell<T> on<E extends Object>(ValueCell<T> other) => ValueCell.computed(() {
    try {
      return this();
    }
    on E {
      return other();
    }
  });
}