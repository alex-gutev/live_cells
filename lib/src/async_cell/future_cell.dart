import '../base/cell_listeners.dart';
import '../base/managed_cell.dart';
import '../equality/cell_equality.dart';

part 'future_cell_impl.dart';

/// Represents reading FutureCell.value before Future has completed
class NoCellValueError implements Exception {
  @override
  String toString() => 'FutureCell.value accessed when hasValue = false';
}

/// Interface for a ValueCell which takes its value from a future
abstract class FutureCell<T> extends ManagedCell<T> {
  /// Does the cell have a value?
  ///
  /// This should be true after the future has completed, or if the cell has been
  /// given a default value.
  bool get hasValue;

  FutureCell();

  /// Create a FutureCell which takes its value from [future]
  ///
  /// If [defaultValue] is not null, or [T] is a nullable type, the
  /// cell's is initialized to [defaultValue] until the future completes and
  /// [hasValue] is true.
  factory FutureCell.fromFuture(Future<T> future, {
    T? defaultValue
  }) => _FutureCellImpl(future, defaultValue: defaultValue);
}