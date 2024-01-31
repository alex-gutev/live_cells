import '../value_cell.dart';

/// A cell, of which the value is computed by a user provided function.
class ComputeCell<T> extends DependentCell<T> {
  /// Create a [ComputeCell] with a given compute function.
  ///
  /// The [compute] function is called with no arguments whenever
  /// the [value] of the cell is accessed. It should return the cell's value.
  ///
  /// [arguments] is a list of argument cells on which the value of the cell
  /// depends. The observers of this cell are notified whenever the values of
  /// the argument cells change.
  ///
  /// Example:
  ///
  /// ```dart
  /// final ValueCell<int> a = ...;
  /// final ValueCell<int> b = ...;
  /// ...
  /// // A ValueCell that computes the sum of the values of two cells
  /// final c = ComputeCell(
  ///    arguments: [a, b],
  ///    compute: () => a.value + b.value
  /// );
  /// ```
  ComputeCell({
    required this.compute,
    required List<ValueCell> arguments
  }) : super(arguments);

  @override
  T get value => compute();
  
  // Private

  final T Function() compute;
}