import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../value_cell.dart';
import 'neq_cell.dart';

/// A cell which evaluates to true when the values of two cells are equal under `==`.
///
/// [T] is the value type of the first cell, and [U] is the value type of the second cell.
class EqCell<T,U> extends ValueCell<bool> {
  EqCell(this._cellA, this._cellB) :
      _listenable = Listenable.merge([_cellA, _cellB]);
  
  @override
  bool get value => _cellA.value == _cellB.value;
  
  @override
  void addListener(VoidCallback listener) {
    _listenable.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listenable.removeListener(listener);
  }

  @override
  ValueCell<bool> eq<P>(ValueCell<P> other) => EqCell(this, other);

  @override
  ValueCell<bool> neq<P>(ValueCell<P> other) => NeqCell(this, other);
  
  /// Private

  final ValueListenable<T> _cellA;
  final ValueListenable<U> _cellB;

  /// The [Listenable] to which observers are added
  final Listenable _listenable;
}