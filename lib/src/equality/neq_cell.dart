part of '../value_cell.dart';

/// A cell which evaluates to true when the values of two cells are not equal under `==`.
///
/// [T] is the value type of the first cell, and [U] is the value type of the second cell.
class NeqCell<T,U> extends DependentCell<bool> {
  NeqCell(this._cellA, this._cellB) :
        super([_cellA, _cellB]);

  @override
  bool get value => _cellA.value != _cellB.value;

  @override
  ValueCell<bool> eq<P>(ValueCell<P> other) => EqCell(this, other);

  @override
  ValueCell<bool> neq<P>(ValueCell<P> other) => NeqCell(this, other);

  /// Private

  final ValueCell<T> _cellA;
  final ValueCell<U> _cellB;
}