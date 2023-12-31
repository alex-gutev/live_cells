part of '../value_cell.dart';

/// Adds implementations of [ValueCell.eq] and [ValueCell.neq]
mixin CellEquality<T> on ValueCell<T> {
  @override
  ValueCell<bool> eq<U>(ValueCell<U> other) => EqCell(this, other);

  @override
  ValueCell<bool> neq<U>(ValueCell<U> other) => NeqCell(this, other);
}