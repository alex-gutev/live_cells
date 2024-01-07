import '../mutable_cell/mutable_cell.dart';
import '../mutable_cell/mutable_dependent_cell.dart';

/// A cell with a value computed by a user provided function which can also be set explicitly.
class MutableComputeCell<T> extends MutableDependentCell<T> {
  /// Create a [MutableComputeCell] with a given compute and reverse compute function.
  ///
  /// The [compute] function is called with no arguments whenever
  /// the value of at least one cell in [arguments] changes. It should return
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
  /// [arguments] is a list of argument cells on which the value of the cell
  /// depends. The cells included in this list must be [MutableCell]'s.
  ///
  /// Example:
  ///
  /// ```dart
  /// final a = MutableCell(1);
  ///
  /// final b = MutableComputeCell(
  ///   arguments: [a],
  ///   compute: () => a.value + 1,
  ///   reverseCompute: (b) {
  ///     a.value = b - 1;
  ///   }
  /// );
  ///
  /// ```
  MutableComputeCell({
    required T Function() compute,
    required void Function(T) reverseCompute,
    required Set<MutableCell> arguments
  }) : _compute = compute, _reverseCompute = reverseCompute, super(arguments);

  @override
  T compute() => _compute();

  @override
  void reverseCompute(T value) {
    _reverseCompute(value);
  }

  /// Private

  final T Function() _compute;
  final void Function(T) _reverseCompute;
}