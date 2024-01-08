import 'package:flutter/cupertino.dart';

import '../value_cell.dart';
import 'cell_observer.dart';
import 'notifier_cell.dart';

/// Implements the [CellObserver] interface for cells of which the value depends on other cells.
///
/// This cell provides an implementation of [CellObserver.willUpdate] and
/// [CellObserver.update] which keep track of whether the cells value should
/// be recomputed.
///
/// Classes which make use of this mixin, should check the [stale] property
/// within [value]. If [stale] is true, the cell's value should be recomputed.
mixin ObserverCell<T> on NotifierCell<T> implements CellObserver {
  /// Should the cell's value be recomputed
  @protected
  var stale = false;

  @override
  void willUpdate(ValueCell cell) {
    if (!_updating) {
      _updating = true;
      _oldValue = value;

      notifyWillUpdate();
      stale = true;
    }
  }

  @override
  void update(ValueCell cell) {
    if (_updating) {
      if (value != _oldValue) {
        notifyUpdate();
      }

      stale = false;
      _updating = false;
      _oldValue = null;
    }
  }

  /// Private

  /// Is a cell value update currently in progress
  var _updating = false;

  /// The cell's value at the start of the current update cycle
  T? _oldValue;
}