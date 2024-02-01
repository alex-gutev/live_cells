part of '../value_cell.dart';

/// A cell which evaluates to true when the values of two cells are not equal under `==`.
///
/// [T] is the value type of the first cell, and [U] is the value type of the second cell.
class NeqCell<T,U> extends DependentCell<bool> {
  NeqCell(this._cellA, this._cellB) : super(
      [_cellA, _cellB],
      key: _NeqCellKey(_cellA, _cellB)
  );

  @override
  bool get value => _cellA.value != _cellB.value;

  // Private

  final ValueCell<T> _cellA;
  final ValueCell<U> _cellB;
}

class _NeqCellKey {
  final dynamic a;
  final dynamic b;

  _NeqCellKey(this.a, this.b);

  @override
  bool operator ==(Object other) => other is _NeqCellKey &&
      a == other.a &&
      b == other.b;

  @override
  int get hashCode => Object.hash(runtimeType, a, b);
}