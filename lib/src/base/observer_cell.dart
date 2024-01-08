import 'package:flutter/cupertino.dart';

import '../value_cell.dart';
import 'cell_listeners.dart';
import 'cell_observer.dart';

/// Implements the [CellObserver] interface for cells of which the value depends on other cells.
///
/// This cell provides an implementation of [CellObserver.willUpdate] and
/// [CellObserver.update] which keep track of whether the cells value should
/// be recomputed.
///
/// Classes which make use of this mixin, should check the [stale] property
/// within [value]. If [stale] is true, the cell's value should be recomputed.
mixin ObserverCell<T> on CellListeners<T> implements CellObserver {
  /// Should the cell's value be recomputed
  @protected
  var stale = false;

  /// Is a cell value update currently in progress
  @protected
  var updating = false;

  @override
  void willUpdate(ValueCell cell) {
    if (!updating) {
      updating = true;

      notifyWillUpdate();
      stale = true;
    }
  }

  @override
  void update(ValueCell cell) {
    if (updating) {
      notifyUpdate();

      updating = false;
    }
  }
}