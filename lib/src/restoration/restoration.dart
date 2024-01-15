import 'package:live_cells/live_cells.dart';

/// Interface for a cell which can have its value restored after initialization
abstract class RestorableCell<T> extends ValueCell<T> {
  /// Restore the value of the cell after initialization
  ///
  /// This method should set the value of the cell without notifying the
  /// observer cells.
  ///
  /// This method is only called right after construction before any observer
  /// cells are added.
  void restoreValue(T value);
}

/// Cell value encoder and decoder interface.
///
/// The base implementation simply passes through the values both in [encode]
/// and [decode].
///
/// This class should be subclassed to support cell restoration of cells holding
/// non-primitive values.
class CellValueCoder<T> {
  const CellValueCoder();

  /// Convert [value] to a primitive value.
  Object? encode(T value) {
    return value;
  }

  /// Construct a [T] from a primitive value.
  T decode(Object? primitive) {
    return primitive as T;
  }
}