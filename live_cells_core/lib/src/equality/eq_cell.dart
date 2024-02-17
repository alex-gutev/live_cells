part of '../value_cell.dart';

/// A cell which evaluates to true when the values of two cells are equal under `==`.
///
/// [T] is the value type of the first cell, and [U] is the value type of the second cell.
class EqCell<T,U> extends DependentCell<bool> {
  EqCell(this._cellA, this._cellB) : super(
      {_cellA, _cellB},
      key: _EqCellKey(_cellA, _cellB)
  );
  
  @override
  bool get value => _cellA.value == _cellB.value;

  // Private

  final ValueCell<T> _cellA;
  final ValueCell<U> _cellB;
}

class _EqCellKey {
  final ValueCell a;
  final ValueCell b;

  _EqCellKey(this.a, this.b);

  @override
  bool operator ==(Object other) => other is _EqCellKey &&
      a == other.a &&
      b == other.b;

  @override
  int get hashCode => Object.hash(runtimeType, a, b);
}