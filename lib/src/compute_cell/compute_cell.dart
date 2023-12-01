import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../equality/cell_equality.dart';
import '../value_cell.dart';

/// A cell, of which the value is computed by a user provided function.
class ComputeCell<T> extends ValueCell<T> with CellEquality<T> {
  /// Create a [ComputeCell] with a given compute function.
  ///
  /// The [compute] function is called with no arguments whenever
  /// the [value] of the cell is accessed. It should return the cell's value.
  ///
  /// [arguments] is a [Listenable] which should notify its observers whenever
  /// the value of this cell should be recomputed, that is [compute] should be
  /// called again.
  ///
  /// A typical strategy is for [arguments] to invoke its listeners whenever the
  /// values of one or more [ValueCell]'s, which are used in [compute],
  /// change. This can be achieved by wrapping the [ValueCell]'s in a single
  /// [Listenable] using [Listenable.merge]
  ///
  /// Example:
  ///
  /// ```dart
  /// final ValueCell<int> a = ...;
  /// final ValueCell<int> b = ...;
  /// ...
  /// // A ValueCell that computes the sum of the values of two cells
  /// final c = ComputeCell(
  ///    arguments: Listenable.merge([a, b]),
  ///    compute: () => a.value + b.value
  /// );
  /// ```
  ComputeCell({
    required this.compute,
    required this.arguments
  });

  @override
  T get value => compute();
  
  @override
  void addListener(VoidCallback listener) {
    arguments.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    arguments.removeListener(listener);
  }
  
  /// Private

  final Listenable arguments;
  final T Function() compute;
}