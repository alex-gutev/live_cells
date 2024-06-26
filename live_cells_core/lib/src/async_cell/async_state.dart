import '../base/exceptions.dart';
import '../base/none_cell.dart';
import '../extensions/conversion_extensions.dart';
import '../extensions/error_handling_extension.dart';
import '../extensions/wait_cell_extension.dart';
import '../value_cell.dart';

/// Base class representing the state of an asynchronous cell
///
/// An asynchronous cell can be in one of the following states:
///
/// * The loading state represented by the class [AsyncStateLoading].
///
///   This state indicates that the asynchronous cell value is still pending.
///
/// * The data state represented by the class [AsyncStateData].
///
///   This state indicates that the asynchronous value is ready and has
///   been computed successfully.
///
/// * The error state represented by the class [AsyncStateError].
///
///   This state indicates that an exception was thrown while computing the
///   asynchronous value.
sealed class AsyncState<T> {
  /// Is this a data state?
  bool get isData => false;

  /// Is this an error state?
  bool get isError => false;

  /// Is this a pending asynchronous value state?
  bool get isLoading => false;

  /// The last value to which the [Future] completed or null if none.
  ///
  /// **NOTE**: This records the last value completed by a [Future] that was
  /// held in the cell while the value completed. If a [Future] is replaced with
  /// another [Future] before it completes, the completed value is not recorded.
  final T? lastValue;

  const AsyncState([this.lastValue]);

  /// Create an async state for a cell holding a [Future].
  ///
  /// 1. If the [Future] held in [cell] is pending, an [AsyncStateLoading] state
  ///    is returned.
  ///
  /// 2. If the [Future] held in [cell] is complete with a value, an
  ///    [AsyncStateData] state is returned.
  ///
  /// 3. If the [Future] held in [cell] completed with an error, an
  ///    [AsyncStateError] state is returned.
  ///
  factory AsyncState.forCell(FutureCell<T> cell) =>
      makeState(current: cell.awaited);
  
  static AsyncState<T> makeState<T>({
    required ValueCell<T> current,
  }) {
    final last = (current as ValueCell<T?>)
        .onError(NoneCell())
        .onError(null.cell);

    try {
      return AsyncStateData(current(), last());
    }
    on PendingAsyncValueError {
      return AsyncStateLoading(last());
    }
    catch (e, trace) {
      return AsyncStateError(e, trace, last());
    }
  }
}

/// Represents the value state.
///
/// An asynchronous cell is in this state when the [Future] held in it completes
/// with a value.
class AsyncStateData<T> extends AsyncState<T> {
  /// The completed value of the [Future].
  final T value;

  /// Create an [AsyncState] representing the data state with [value].
  AsyncStateData(this.value, [super.lastValue]);

  @override
  bool get isData => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncStateData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          lastValue == other.lastValue;

  @override
  int get hashCode => Object.hash(runtimeType, value, lastValue);
}

/// Represents the error state.
///
/// An asynchronous cell is in this state when the [Future] held in it completes
/// with an error.
class AsyncStateError<T> extends AsyncState<T> {
  /// The error thrown while computing the asynchronous value
  final Object error;

  /// The stacktrace of the exception that was thrown
  final StackTrace stackTrace;

  /// Create an [AsyncState] representing the error state with [error].
  AsyncStateError(this.error, [StackTrace? trace, super.lastValue]) :
      stackTrace = trace ?? StackTrace.current;

  @override
  bool get isError => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncStateError &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          lastValue == other.lastValue;

  @override
  int get hashCode => Object.hash(runtimeType, error, lastValue);
}

/// Represents the loading state.
///
/// An asynchronous cell is in this state when the [Future] held in it is still
/// pending.
class AsyncStateLoading<T> extends AsyncState<T> {
  @override
  bool get isLoading => true;

  AsyncStateLoading([super.lastValue]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncStateLoading &&
          runtimeType == other.runtimeType &&
          lastValue == other.lastValue;

  @override
  int get hashCode => Object.hash(runtimeType, lastValue);
}