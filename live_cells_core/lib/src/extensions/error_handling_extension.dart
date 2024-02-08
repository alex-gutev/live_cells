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
  ValueCell<T> onError<E extends Object>(ValueCell<T> other) => ValueCell.computed(() {
    try {
      return this();
    }
    on E {
      return other();
    }
  });

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
  });
}