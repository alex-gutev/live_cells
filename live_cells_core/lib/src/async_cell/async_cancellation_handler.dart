import 'dart:async';

import '../base/exceptions.dart';

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
    if (_completer.isCompleted) {
      throw CancelComputeException();
    }

    _completer.complete();
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
