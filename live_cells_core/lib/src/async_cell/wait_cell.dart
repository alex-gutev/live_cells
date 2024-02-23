import 'dart:async';

import '../base/exceptions.dart';
import '../base/keys.dart';
import '../maybe_cell/maybe.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import '../previous_values/prev_value_cell.dart';

/// A cell which waits for a [Future] held in another cell to complete.
///
/// Until the [Future] completes, accessing the [value] of the cell will throw
/// an [UninitializedCellError].
class WaitCell<T> extends StatefulCell<T> {
  /// Create a cell which waits for the [Future] held in [arg] to complete
  WaitCell({
    required this.arg,
    this.lastOnly = false
  }) : super(key: _WaitCellKey(arg, lastOnly));

  @override
  T get value {
    final state = this.state as _WaitCellState<T>?;

    if (state != null) {
      return state.value;
    }

    throw UninitializedCellError();
  }

  // Private

  /// Argument cell holding [Future]
  final ValueCell<Future<T>> arg;
  
  /// Should only the last future be awaited?
  final bool lastOnly;

  @override
  CellState<StatefulCell> createState() => _WaitCellState<T>(
      cell: this,
      key: key
  );
}

/// State for [WaitCell]
class _WaitCellState<T> extends CellState<WaitCell<T>>
    with ObserverCellState<WaitCell<T>> {
  /// Awaited [Future] value
  Maybe<T> _value = Maybe.error(UninitializedCellError());

  /// Cancellation handler for currently awaited future
  AsyncCancellationHandler? _handler;

  _WaitCellState({
    required super.cell,
    required super.key
  });

  T get value => _value.unwrap;

  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();

    cell.arg.addObserver(this);
    _updateValue(_getValue());
  }

  @override
  void dispose() {
    cell.arg.removeObserver(this);
    _handler?.cancel();

    super.dispose();
  }

  @override
  void onWillUpdate() {
    // Prevent observers from being notified before delay
  }

  @override
  void onUpdate(bool didChange) {
    // Prevent observers from being notified before delay
  }

  @override
  void postUpdate() {
    super.postUpdate();
    if (cell.lastOnly) {
      _handler?.cancel();
    }

    _updateValue(_getValue());
  }

  /// Get a [Future] which resolves to the current value of [arg], wrapped in a [Maybe].
  Future<Maybe<T>> _getValue() {
    return Maybe.wrapAsync(() => cell.arg.value);
  }

  /// Await [future] and update this cell's value while notifying observers.
  Future<void> _updateValue(Future<Maybe<T>> future) async {
    final oldHandler = _handler;
    final newHandler = _handler = AsyncCancellationHandler();

    await oldHandler?.wait;

    await newHandler.waitFuture(future, (value) {
      notifyWillUpdate();
      _value = value;
      notifyUpdate();
    });
  }
}

/// Allows waiting for completion and cancellation of a task that is awaiting a [Future]
class AsyncCancellationHandler {
  final _completer = Completer<void>();

  /// Wait for the task to complete.
  /// 
  /// The returned [Future] resolves with a value when the task either 
  /// completes, or is cancelled.
  Future<void> get wait => _completer.future.catchError((_, __) {});

  /// Cancel the task managed by this handler
  void cancel() {
    if (!_completer.isCompleted) {
      _completer.completeError(CancelComputeException());
    }
  }

  /// Complete the task managed by this handler
  void finish() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  /// Await a [future] using this handler.
  /// 
  /// If the task is cancelled, by [cancel], before the [future] is resolved,
  /// a [CancelComputeException] is thrown.
  /// 
  /// If the future is resolved first, the handler is marked as completed, by
  /// [finish]
  /// 
  /// The resolved value of the [Future] is returned.
  Future<T> compute<T>(Future<T> future) async {
    await Future.any([future, _completer.future]);
    finish();

    return await future;
  }

  /// Await [future] while handling cancellation.
  ///
  /// When the value of [future] is resolved, [fn] is called with the resolved
  /// value passed as an argument. If the handler is cancelled before [future]
  /// resolves, [fn] is not called.
  ///
  /// This method handles [CancelComputeException].
  Future<void> waitFuture<T>(Future<T> future, void Function(T) fn) async {
    try {
      fn(await compute(future));
    }
    on CancelComputeException {
      future.ignore();
    }
  }
}

/// Key identifying a [WaitCell].
class _WaitCellKey<T> extends ValueKey2<ValueCell<T>, bool> {
  /// Create a key for identifying a [WaitCell].
  ///
  /// The key identifies a [WaitCell] which waits for the value held in argument
  /// cell [value].
  _WaitCellKey(super.value1, super.value2);
}