import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../base/notifier_cell.dart';
import '../compute_cell/dynamic_mutable_compute_cell.dart';
import '../value_cell.dart';

/// Interface for a [ValueCell] of which the [value] property can be set explicitly
abstract class MutableCell<T> extends ValueCell<T> {
  /// Create a mutable cell with its value initialized to [value]
  factory MutableCell(T value) => _MutableCellImpl(value);

  /// Create a computational cell which can also have its value set directly.
  ///
  /// The [compute] function is called to compute the value of the cell as a
  /// function of one or more argument cells. Any cell referenced in [compute]
  /// by the [call] method is considered an argument cell. Any change in the
  /// value of an argument cell will result in the value of the returned cell
  /// being recomputed.
  ///
  /// **NOTE**: All argument cells referenced in [compute] must be [MutableCell]'s.
  ///
  /// Additionally this cell can also have its value changed by setting the
  /// [value] property directly. When the [value] property is set, [reverse]
  /// is called, with the newly assigned value. [reverse] should set the values
  /// of the argument cells such that calling [compute] again will produce the
  /// same value that was assigned to the [value] property.
  ///
  /// [reverse] is called in a batch update, by [batch], so that the values of
  /// the argument cells are set simultaneously.
  ///
  /// Example:
  ///
  /// ```dart
  /// final a = MutableCell(1);
  /// final b = MutableCell.computed(() => a() + 1, (b) => {
  ///   a.value = b - 1;
  /// });
  /// ```
  factory MutableCell.computed(T Function() compute, void Function(T value) reverse) =>
      DynamicMutableComputeCell(
          compute: compute,
          reverseCompute: reverse
      );

  /// Set the value of the cell.
  ///
  /// Unless [isBatchUpdate] is true, the observers of the cell should be
  /// notified by calling the methods of [CellObserver] in the following order:
  ///
  /// 1. [CellObserver.willUpdate()]
  /// 2. Set value of cell
  /// 3. [CellObserver.update()]
  set value(T value);

  /// Is a batch update of cells currently in progress, *see [MutableCell.batch]*.
  @protected
  static bool get isBatchUpdate => _batched;

  /// Notify the observers of the cell that the cell's value will change.
  ///
  /// If [isEqual] is true it indicates that the new value is equal to the
  /// previous value.
  ///
  /// This is called before the value of the cell has been set during a batch
  /// update, *see [MutableCell.batch]*.
  @protected
  void notifyWillUpdate([bool isEqual = false]);

  /// Notify the observers of the cell that the cell's value has change.
  ///
  /// If [isEqual] is true it indicates that the new value is equal to the
  /// previous value.
  ///
  /// This is called after the value of a batch update of cells,
  /// *see [MutableCell.batch]*. At this point the value of the [value] property
  /// will have been set to the new value of the cell.
  @protected
  void notifyUpdate([bool isEqual = false]);

  /// Set the value of multiple [MutableCell]'s simultaneously.
  ///
  /// [fn] is called. Within [fn] setting [MutableCell.value] sets the value
  /// of the cell but does not trigger an immediate update of its observer cells.
  /// Instead the observers of the modified cells are only notified when [fn]
  /// returns.
  static void batch(void Function() fn) {
    if (_batched) {
      fn();
    }
    else {
      _beginBatch();

      try {
        fn();
      }
      finally {
        _endBatch();
      }
    }
  }

  /// Add a cell to the batch update list.
  ///
  /// This method should be called by subclasses of [MutableCell] when
  /// [value] is being set while [isBatchUpdate] is true. The observers of [cell]
  /// are notified, by [notifyUpdate] after the batch update is complete.
  ///
  /// If [isEqual] is true it indicates that the new value is equal to the
  /// previous value.
  @protected
  static void addToBatch(MutableCell cell, bool isEqual) {
    _batchList.update(cell, (value) => value && isEqual, ifAbsent: () => isEqual);
  }

  /// Private

  /// Is a batch update currently ongoing?
  static var _batched = false;

  /// Set of cells of which the observers should be notified after the current batch update.
  ///
  /// The map is indexed by the cell object, with the value being a boolean
  /// which is true if the new value of the cell is equal to the previous value.
  static final Map<MutableCell, bool> _batchList = LinkedHashMap();

  /// Begin a update update.
  static void _beginBatch() {
    _batched = true;
    _batchList.clear();
  }

  /// End a batch update and notify the observers of the affected cells.
  static void _endBatch() {
    _batched = false;

    for (final entry in _batchList.entries) {
      entry.key.notifyUpdate(entry.value);
    }

    _batchList.clear();
  }
}

class _MutableCellImpl<T> extends NotifierCell<T> implements MutableCell<T> {
  _MutableCellImpl(super.value);

  @override
  set value(T value) {
    if (MutableCell.isBatchUpdate) {
      final isEqual = value == this.value;

      notifyWillUpdate(isEqual);
      setValue(value);

      MutableCell.addToBatch(this, isEqual);
    }
    else {
      super.value = value;
    }
  }
}