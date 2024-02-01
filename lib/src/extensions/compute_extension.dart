import '../compute_cell/mutable_compute_cell.dart';
import '../mutable_cell/mutable_cell.dart';
import '../value_cell.dart';
import '../compute_cell/compute_cell.dart';

/// Utility methods for creating new cells by applying functions on their values.
extension ComputeExtension<T> on ValueCell<T> {
  /// Create a new cell, with a value which is computed by applying a function on this cell's value
  ///
  /// The value of the returned cell is the return value of [fn], a function of one argument,
  /// when applied on the this cell's value.
  ValueCell<U> apply<U>(U Function(T value) fn, {key}) =>
      ComputeCell(
          compute: () => fn(value),
          arguments: [this],
          key: key
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
  ValueCell<U> computeCell<U>(U Function() fn, {key}) =>
      ComputeCell(
          compute: fn,
          arguments: cast<ValueCell>(),
          key: key
      );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and argument cell list [this].
  ///
  /// The [compute] function is called with no arguments whenever
  /// the value of at least one cell in [this] changes. It should return
  /// the cell's value.
  ///
  /// The [reverseCompute] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [compute]
  /// again will produce the same value that was passed to [reverseCompute].
  ///
  /// [reverseCompute] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// **NOTE:** Every element of [this] should be a [MutableCell].
  MutableCell<U> mutableComputeCell<U>(U Function() compute, void Function(U) reverse, {key}) =>
      MutableComputeCell(
          compute: compute,
          reverseCompute: reverse,
          arguments: cast<ValueCell>().toSet(),
          key: key
      );
}