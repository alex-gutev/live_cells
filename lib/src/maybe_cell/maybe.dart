import 'package:live_cells/live_cells.dart';

import '../mutable_cell/mutable_cell.dart';

/// Container that either holds a value or an exception that was raised while computing the value.
class Maybe<T> {
  /// The value or `null` if there was an error during computation
  final T? value;

  /// Exception thrown during the computation of [value].
  ///
  /// If [value] was computed successfully, this is `null`.
  final error;

  /// Create a [Maybe] that holds a computed value.
  Maybe(this.value) : error = null;

  /// Create a [Maybe] that holds the exception [error].
  ///
  /// The resulting [Maybe] represents a failure to compute a value.
  Maybe.error(this.error) : value = null;

  /// Compute a value using [compute] and wrap the result in a [Maybe].
  ///
  /// [compute] is called to compute the value. If [compute] returns normally,
  /// a [Maybe] holding a value is created.
  ///
  /// If [compute] throws an exception a [Maybe] holding an error is created
  /// using [Maybe.error].
  factory Maybe.wrap(T Function() compute) {
    try {
      return Maybe(compute());
    }
    catch (e) {
      return Maybe.error(e);
    }
  }

  /// Get the wrapped value or throw [error] if this [Maybe] represents an error.
  T get unwrap {
    if (error != null) {
      throw error;
    }

    return value as T;
  }
}

/// A [MutableCell] holding a [Maybe] value
typedef MaybeCell<T> = MutableCell<Maybe<T>>;

/// Extends [MutableCell] with the [maybe] method for creating a [MaybeCell].
extension CellMaybeExtension<T> on MutableCell<T> {
  /// Creates a [MaybeCell] which wraps [this] cell's value.
  ///
  /// The returned cell is a mutable computed cell that wraps [this] cell's
  /// value in a [Maybe].
  ///
  /// When the [MaybeCell]'s value is assigned, the value of [this] cell is set
  /// to the value wrapped by the [Maybe] if the [Maybe] is holding a value. If
  /// the [Maybe] holds an exception, the value of this cell is unchanged.
  MaybeCell<T> maybe() {
    return [this].mutableComputeCell(() => Maybe(value), (maybe) {
      try {
        value = maybe.unwrap;
      }
      catch (e) {
        // Do Nothing
      }
    });
  }
}

/// Extends [MaybeCell] with [Maybe] property accessors.
extension MaybeCellExtension<T> on MaybeCell<T> {
  /// A cell which evaluates to the [error] of the [Maybe].
  ValueCell get error => [this].computeCell(() => value.error);

  /// A cell which evaluates to the unwrapped value (by [Maybe.unwrap]) of the [Maybe].
  ValueCell get unwrap => [this].computeCell(() => value.unwrap);
}