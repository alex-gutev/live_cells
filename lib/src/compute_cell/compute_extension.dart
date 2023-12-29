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

/// Extends [List] with a method for creating a [ComputeCell] with the argument
/// cells given in the list.
extension ListComputeExtension on List {
  /// Create a [ComputeCell] with compute function [fn] and argument cell list [this].
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn].
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ValueCell<U> computeCell<U>(U Function() fn) =>
      ComputeCell(compute: fn, arguments: cast<ValueCell>());
}