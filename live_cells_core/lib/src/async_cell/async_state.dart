import '../base/exceptions.dart';
import '../base/none_cell.dart';
import '../extensions/error_handling_extension.dart';
import '../extensions/wait_cell_extension.dart';

/// Base class representing the state of an asynchronous cell
///
/// An asynchronous cell can be in one of the following states:
///
/// * The loading state represented by the class [AsyncStateLoading].
///
///   This state indicates that the asynchronous cell value is still pending.
///
/// * The data state represented by the class [AsyncStateData]/
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

  /// The last value that was successfully computed
  final T? lastValue;

  /// Create an [AsyncState] with a given last successful value.
  AsyncState([this.lastValue]);

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
  factory AsyncState.forCell(FutureCell<T> cell) {
    final last = cell.wait.onError(NoneCell());
    try {
      return AsyncStateData(cell.awaited(), last());
    }
    on PendingAsyncValueError {
      return AsyncStateLoading();
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
}

/// Represents the loading state.
///
/// An asynchronous cell is in this state when the [Future] held in it is still
/// pending.
class AsyncStateLoading<T> extends AsyncState<T> {
  @override
  bool get isLoading => true;
}