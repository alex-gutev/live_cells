import '../base/exceptions.dart';
import '../base/keys.dart';
import '../compute_cell/compute_cell.dart';
import '../meta_cell/meta_cell.dart';
import '../value_cell.dart';

/// Extends [ValueCell] with facilities for handling exceptions thrown while computing values
extension ErrorCellExtension<T> on ValueCell<T> {
  /// Create a cell which handles exceptions thrown while computing the value of [this].
  ///
  /// If an exception is thrown while computing the value of [this], the cell
  /// returns the value of [other].
  ///
  /// [E] is the type of exception to handle. By default, if this is not
  /// explicitly given, all exceptions are handled.
  ///
  /// A keyed cell is returned, which is unique for a given [this], [other] and
  /// exception type [E].
  ValueCell<T> onError<E extends Object>(ValueCell<T> other) => ValueCell.computed(() {
    try {
      return this();
    }
    on E {
      return other();
    }
  }, key: _OnErrorKey<E>(this, other));

  /// Create a cell which captures exceptions thrown during the computation of this cell.
  ///
  /// If [this] cell throws an exception during the computation of its value,
  /// the returned cell evaluates to the thrown exception.
  ///
  /// If [this] cell does not throw during the computation of its value, the
  /// value of the returned cell is `null` if [all] is `true`. If [all] is
  /// `false`, its value is not updated.
  ///
  /// If [E] is given, only exceptions of type [E] are captured, otherwise all
  /// exceptions are captured.
  ///
  /// A keyed cell is returned, which is unique for a given [this], [all] and
  /// exception type [E].
  ValueCell<E?> error<E extends Object>({bool all = false}) => ValueCell.computed(() {
    try {
      this();
    }
    on E catch (e) {
      return e;
    }
    catch (e) {
      // To prevent errors being propagated through this cell
    }

    if (!all) {
      ValueCell.none();
    }

    return null;
  }, key: _ErrorCellKey<E>(this, all));

  /// Returns a cell that evaluates to the value of [value] when the value of this is uninitialized.
  ///
  /// The returned cell evaluates to the value of the cell [value] if this cell
  /// throws an [UninitializedCellError] or [PendingAsyncValueError] exception.
  ///
  /// A keyed cell is returned, which is unique for a given [this] and [value].
  ValueCell<T> initialValue(ValueCell<T> value) =>
      onError<UninitializedCellError>(value)
          .loadingValue(value);

  /// Returns a cell that evaluates to the value of [value] while an async value is loading..
  ///
  /// The returned cell evaluates to the value of the cell [value] if this cell
  /// throws a [PendingAsyncValueError] exception.
  ///
  /// A keyed cell is returned, which is unique for a given [this] and [value].
  ValueCell<T> loadingValue(ValueCell<T> value) =>
      onError<PendingAsyncValueError>(value);

  /// Create a cell that evaluates to [ValueCell.none()] while the cell's value is uninitialized.
  ///
  /// The returned cell evaluates to [ValueCell.none()], when this cell throws
  /// an [UninitializedCellError], [PendingAsyncValueError] or [EmptyMetaCellError]
  ValueCell<T> get whenReady => ComputeCell(
    key: _WhenReadyKey(this),
    arguments: {this},
    compute: () {
      try {
        return value;
      }
      on UninitializedCellError {
        return ValueCell.none();
      }
      on PendingAsyncValueError {
        return ValueCell.none();
      }
      on EmptyMetaCellError{
        return ValueCell.none();
      }
    },
  );
}

/// Key identifying a cell created with `onError`
class _OnErrorKey<T> extends CellKey2<ValueCell, ValueCell> {
  _OnErrorKey(super.value1, super.value2);
}

/// Key identifying a cell created with `error()`
class _ErrorCellKey<T> extends CellKey2<ValueCell, bool> {
  _ErrorCellKey(super.value1, super.value2);
}

/// Key identifying a cell created with .whenReady
class _WhenReadyKey extends CellKey1<ValueCell> {
  _WhenReadyKey(super.value);
}