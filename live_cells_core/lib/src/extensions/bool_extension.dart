import '../base/keys.dart';
import '../compute_cell/compute_cell.dart';
import 'compute_extension.dart';
import '../value_cell.dart';

/// Extends [bool] cells with logical and selection operators
extension BoolCellExtension on ValueCell<bool> {
  /// Create a new cell which is the logical and of [this] and [other].
  ///
  /// A keyed cell is returned which is unique for [this] cell and [other].
  ValueCell<bool> and(ValueCell<bool> other) => ComputeCell(
      compute: () => value && other.value,
      arguments: {this, other},
      key: _AndCellKey(this, other)
  );

  /// Create a new cell which is the logical or of [this] and [other].
  ///
  /// A keyed cell is returned which is unique for [this] cell and [other].
  ValueCell<bool> or(ValueCell<bool> other) => ComputeCell(
      compute: () => value || other.value,
      arguments: {this, other},
      key: _OrCellKey(this, other)
  );

  /// Create a new cell which is the logical not of [this].
  ///
  /// A keyed cell is returned which is unique for [this] cell.
  ValueCell<bool> not() => apply((value) => !value,
    key: _NotCellKey(this)
  );

  /// Create a new cell which selects between the values of two cells based on [this].
  ///
  /// If [this] is true, the cell evaluates to the value of [ifTrue].
  ///
  /// If [this] is false, the cell evaluates to the value of [ifFalse] if it is
  /// a cell. Otherwise if [ifFalse] is null, the cell's value is not updated.
  ValueCell<T> select<T>(ValueCell<T> ifTrue, [ValueCell<T>? ifFalse]) => ifFalse != null
      ? ValueCell.computed(() => this() ? ifTrue() : ifFalse())
      : ValueCell.computed(() => this() ? ifTrue() : ValueCell.none());
}

/// Key identifying a cell created with [BoolCellExtension.and]
class _AndCellKey extends CellKey2<ValueCell<bool>, ValueCell<bool>> {
  _AndCellKey(super.value1, super.value2);
}

/// Key identifying a cell created with [BoolCellExtension.or]
class _OrCellKey extends CellKey2<ValueCell<bool>, ValueCell<bool>> {
  _OrCellKey(super.value1, super.value2);
}

/// Key identifying a cell created with [BoolCellExtension.not]
class _NotCellKey extends CellKey1<ValueCell<bool>> {
  _NotCellKey(super.value);
}