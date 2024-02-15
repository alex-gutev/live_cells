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
  /// If [willChange] is non-null, it is called to determine whether the cell's
  /// value will change for a change in the value of an argument cell. It is
  /// called with the argument cell and its new value passed as arguments. The
  /// function should return true if the cell's value may change, and false if
  /// it can be determined with certainty that it wont. **NOTE**: this function
  /// is only called if the new value of the argument cell is known, see
  /// [CellObserver.willChange] for more information.
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
    required List<ValueCell> arguments,
    super.key,
    super.willChange
  }) : super(arguments);

  @override
  T get value => compute();
  
  // Private

  final T Function() compute;
}