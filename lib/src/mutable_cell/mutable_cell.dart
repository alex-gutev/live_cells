import 'package:flutter/foundation.dart';

import '../base/notifier_cell.dart';
import '../value_cell.dart';

/// Interface for a [ValueCell] of which the [value] property can be set explicitly
abstract class MutableCell<T> extends ValueCell<T> {
  /// Create a mutable cell with its value initialized to [value]
  factory MutableCell(T value) => _MutableCellImpl(value);

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
  /// This is called before the value of the cell has been set during a batch
  /// update, *see [MutableCell.batch]*.
  @protected
  void notifyWillUpdate();

  /// Notify the observers of the cell that the cell's value has change.
  ///
  /// This is called after the value of a batch update of cells,
  /// *see [MutableCell.batch]*. At this point the value of the [value] property
  /// will have been set to the new value of the cell.
  @protected
  void notifyUpdate();

  /// Set the value of multiple [MutableCell]'s simultaneously.
  ///
  /// [fn] is called. Within [fn] setting [MutableCell.value] sets the value
  /// of the cell but does not trigger an immediate update of its observer cells.
  /// Instead the observers of the modified cells are only notified when [fn]
  /// returns.
  static void batch(void Function() fn) {
    _beginBatch();
    fn();
    _endBatch();
  }

  /// Private

  /// Is a batch update currently ongoing?
  static var _batched = false;

  /// List of cells of which the observers should be notified after the current batch update
  static final List<MutableCell> _batchList = [];

  /// Begin a update update.
  static void _beginBatch() {
    _batched = true;
    _batchList.clear();
  }

  /// End a batch update and notify the observers of the affected cells.
  static void _endBatch() {
    _batched = false;

    for (final cell in _batchList) {
      cell.notifyUpdate();
    }

    _batched = false;
    _batchList.clear();
  }
}

class _MutableCellImpl<T> extends NotifierCell<T> implements MutableCell<T> {
  _MutableCellImpl(super.value);

  @override
  set value(T value) {
    if (MutableCell._batched) {
      if (value != this.value) {
        notifyWillUpdate();
        setValue(value);

        MutableCell._batchList.add(this);
      }
    }
    else {
      super.value = value;
    }
  }
}