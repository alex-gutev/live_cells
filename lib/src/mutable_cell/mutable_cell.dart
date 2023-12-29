import '../base/notifier_cell.dart';

/// A [ValueCell] of which the [value] property can be set explicitly.
class MutableCell<T> extends NotifierCell<T> {
  MutableCell(super.value);

  @override
  set value(T value) {
    if (_batched) {
      if (value != this.value) {
        notifyWillUpdate();
        setValue(value);

        _batchList.add(this);
      }
    }
    else {
      super.value = value;
    }
  }

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