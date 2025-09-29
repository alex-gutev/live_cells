import 'package:meta/meta.dart';

import 'base/auto_key.dart';
import 'base/types.dart';
import 'base/cell_equality_factory.dart';
import 'base/exceptions.dart';
import 'cell_watch/cell_watcher.dart';
import 'compute_cell/dynamic_compute_cell.dart';
import 'base/cell_observer.dart';

part 'constant_cell.dart';
part 'base/dependent_cell.dart';
part 'equality/eq_cell.dart';
part 'equality/neq_cell.dart';

/// Base value cell interface.
abstract class ValueCell<T> {
  /// The cell's value
  T get value;

  const ValueCell();

  /// Create a value cell with a constant value
  const factory ValueCell.value(T value) = ConstantCell<T>;

  /// Create a cell which computes its value using the function [compute].
  ///
  /// Any cell referenced in [compute] by the [call] method is considered an
  /// argument cell. Any change in the value of an argument cell will result
  /// in the value of the returned cell being recomputed.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  /// The created cell is identified by [key] if non-null.
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
  factory ValueCell.computed(T Function() compute, {
    key,
    bool changesOnly = false
  }) => DynamicComputeCell(
      compute,
      key: key,
      changesOnly: changesOnly
  );

  /// Register a callback function to be called whenever the values of the referenced cells change.
  ///
  /// The function [watch] is called whenever the values of the cells referenced
  /// within the function with the [call] method changes. The function is always
  /// called once immediately before [watch] returns.
  ///
  /// If [key] is not null and a [CellWatcher] identified by [key] has already
  /// been created, and has not been stopped, this [CellWatcher] object
  /// references the same watch function.
  ///
  /// **NOTE**: [CellWatcher.stop] must be called on the returned object when the
  /// watch function should no longer be called.
  ///
  /// **NOTE**: The watch function is started automatically, thus there is no
  /// need to call [CellWatcher.start].
  static CellWatcher watch(WatchCallback watch, {key}) =>
      DynamicCellWatcher(
          callback: watch,
          key: key
      )..start();

  /// Stop computation of the current cell's value.
  ///
  /// When this method is called within a cell's value computation function,
  /// the cell's value is not recomputed. Instead the cell's current value is
  /// preserved.
  ///
  /// If this method is called when a cell's initial value is being computed,
  /// the cell's initial value is set to [defaultValue].
  ///
  /// If [defaultValue] is null, and this method is used during the computation
  /// of the initial value of a cell with a value type that is not nullable,
  /// an `UninitializedCellError` is thrown.
  static none([defaultValue]) => throw StopComputeException(defaultValue);

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

  /// Track this cell as an argument of the current compute/watch function.
  ///
  /// This is provided to increase readability in the case that the value of a
  /// cell is not used, but is required to trigger updates to the current cell.
  void observe() {
    ComputeArgumentsTracker.trackArgument(this);

    try {
      value;
    }
    catch (e) {
      // Prevent exception from propagating to caller
    }
  }

  /// Returns a new [ValueCell] which compares the value of this cell to another cell for equality.
  ///
  /// The returned [ValueCell] has a value of true when this cell and [other] have the same
  /// value according to the equality relation, and a value of false otherwise.
  ///
  /// The observers of the returned [ValueCell] are notified when either the value of this cell
  /// or [other] changes.
  ValueCell<bool> eq<U>(ValueCell<U> other) => equalityCellFactory.makeEq(this, other);

  /// Returns a new [ValueCell] which compares the value of this cell to another cell for inequality.
  ///
  /// The returned [ValueCell] has a value of false when this cell and [other] have the same
  /// value according to the equality relation, and a value of true otherwise.
  ///
  /// The observers of the returned [ValueCell] are notified when either the value of this cell
  /// or [other] changes.
  ValueCell<bool> neq<U>(ValueCell<U> other) => equalityCellFactory.makeNeq(this, other);

  /// Return a factory for creating equality and inequality comparison cells.
  EqualityCellFactory get equalityCellFactory => DefaultCellEqualityFactory();

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