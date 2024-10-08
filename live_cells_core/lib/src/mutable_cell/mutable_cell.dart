import 'package:meta/meta.dart';

import '../compute_cell/dynamic_mutable_compute_cell.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/cell_update_manager.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

part 'mutable_cell_base.dart';

/// Interface for a [ValueCell] of which the [value] property can be set explicitly
abstract class MutableCell<T> extends ValueCell<T> {
  /// Create a mutable cell with its value initialized to [value].
  ///
  /// If [reset] is true and a cell with the same [key] has been created,
  /// the shared value of the cells is reset to [value].
  factory MutableCell(T value, {
    key,
    bool reset = false
  }) => _MutableCellImpl(value,
      key: key,
      reset: reset
  );

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
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  /// Example:
  ///
  /// ```dart
  /// final a = MutableCell(1);
  /// final b = MutableCell.computed(() => a() + 1, (b) => {
  ///   a.value = b - 1;
  /// });
  /// ```
  factory MutableCell.computed(T Function() compute, void Function(T value) reverse, {
    bool changesOnly = false,
    key
  }) => DynamicMutableComputeCell(
      compute: compute,
      reverseCompute: reverse,
      changesOnly: changesOnly,
      key: key
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

  // Private

  /// Is a batch update currently ongoing?
  static var _batched = false;

  /// List of cell states of which the observers should be notified after the current batch update.
  ///
  /// Each element of the list is a record, with the state held in the first
  /// record element and a boolean indicating whether the assigned value is
  /// equal to the current value of the cell, held in the second element.
  static final List<(CellState, bool)> _batchList = [];

  /// Add a cell state to the batch update list.
  ///
  /// If [isEqual] is true it indicates that the new value is equal to the
  /// previous value.
  static void _addToBatch(CellState state, bool isEqual) {
    _batchList.add((state, isEqual));
  }

  /// Begin a update update.
  static void _beginBatch() {
    _batched = true;
    _batchList.clear();
  }

  /// End a batch update and notify the observers of the affected cells.
  static void _endBatch() {
    var wasUpdating = CellUpdateManager.beginCellUpdates();

    _batched = false;

    for (final (state, isEqual) in _batchList) {
      state.notifyUpdate(isEqual: isEqual);
    }

    _batchList.clear();

    CellUpdateManager.endCellUpdates(wasUpdating);
  }
}

class _MutableCellImpl<T> extends MutableCellBase<T> implements RestorableCell<T> {
  _MutableCellImpl(this._initialValue, {
    super.key,
    bool reset = false
  }) {
    if (reset && hasState) {
      state.value = _initialValue;
    }
  }

  /// The initial value
  final T _initialValue;

  @override
  Object? dumpState(CellValueCoder coder) {
    return coder.encode(value);
  }

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    this.state.setValue(coder.decode(state));
  }

  @override
  MutableCellState<T, MutableCellBase<T>> createMutableState({
    MutableCellState<T, MutableCellBase<T>>? oldState
  }) => MutableCellState(cell: this, key: key)..setValue(
      oldState?.value ?? _initialValue
  );
}