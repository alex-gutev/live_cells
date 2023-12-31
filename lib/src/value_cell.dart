import 'package:flutter/foundation.dart';
import 'compute_cell/dynamic_compute_cell.dart';
import 'base/cell_observer.dart';

part 'constant_cell.dart';
part 'base/dependent_cell.dart';
part 'equality/cell_equality.dart';
part 'equality/eq_cell.dart';
part 'equality/neq_cell.dart';

/// Base value cell interface.
abstract class ValueCell<T> {
  /// The cell's value
  T get value;

  ValueCell();

  /// Create a value cell with a constant value
  factory ValueCell.value(T value) => ConstantCell(value);

  /// Create a cell which computes its value using the function [compute].
  ///
  /// Any cell referenced in [compute] by the [call] method is considered an
  /// argument cell. Any change in the value of an argument cell will result
  /// in the value of the returned cell being recomputed.
  ///
  /// Example:
  ///
  /// ```dart
  /// // `a` and `b` are both [ValueCell]'s
  /// final sum = ValueCell.computed(() => a() + b());
  /// ```
  ///
  /// The cell `sum` computes the sum of cells `a` and `b`. Whenever the value
  /// of either `a` or `b` changes, the value of `sum` is recomputed.
  factory ValueCell.computed(T Function() compute) =>
      DynamicComputeCell(compute);


  /// Retrieve the value of the cell.
  ///
  /// The difference between this method and the [value] property is that if this
  /// method is called inside a value computation function of a computational cell
  /// which tracks its arguments at runtime, this cell will automatically
  /// be added as an argument of the computational cell such that its value is
  /// recomputed whenever the value of this cell changes.
  T call() {
    ComputeArgumentsTracker.trackArgument(this);
    return value;
  }

  /// Returns a new [ValueCell] which compares the value of this cell to another cell for equality.
  ///
  /// The returned [ValueCell] has a value of true when this cell and [other] have the same
  /// value according to the equality relation, and a value of false otherwise.
  ///
  /// The observers of the returned [ValueCell] are notified when either the value of this cell
  /// or [other] changes.
  ValueCell<bool> eq<U>(ValueCell<U> other);

  /// Returns a new [ValueCell] which compares the value of this cell to another cell for inequality.
  ///
  /// The returned [ValueCell] has a value of false when this cell and [other] have the same
  /// value according to the equality relation, and a value of true otherwise.
  ///
  /// The observers of the returned [ValueCell] are notified when either the value of this cell
  /// or [other] changes.
  ValueCell<bool> neq<U>(ValueCell<U> other);

  /// Register an observer of the cell to be called when the cell's value changes.
  void addObserver(CellObserver observer);

  /// Remove an observer that was previously registered with [addObserver].
  ///
  /// If [addObserver] was called more than once for [observer],
  /// [removeObserver] must be called the same number of times before [observer]
  /// is removed.
  ///
  /// Once removed [observer] is not called again.
  ///
  /// If [observer] is not a registered observer of the cell, this method does
  /// nothing.
  void removeObserver(CellObserver observer);
}