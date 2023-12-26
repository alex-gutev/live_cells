import 'package:flutter/foundation.dart';
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