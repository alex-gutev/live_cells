import '../value_cell.dart';
import 'compute_cell.dart';

/// Utility methods for creating new cells by applying functions on their values.
extension ComputeExtension<T> on ValueCell<T> {
  /// Create a new cell, with a value which is computed by applying a function on this cell's value
  ///
  /// The value of the returned cell is the return value of [fn], a function of one argument,
  /// when applied on the this cell's value.
  ValueCell<U> apply<U>(U Function(T value) fn) =>
      ComputeCell(
          compute: () => fn(value),
          arguments: [this]
      );
}