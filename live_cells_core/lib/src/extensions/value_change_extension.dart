import 'dart:async';

import '../value_cell.dart';

/// Provides functionality for waiting until a cell changes its value
extension ValueChangeExtension<T> on ValueCell<T> {
  /// Returns a [Future] that completes with the next value of this cell, when it is updated.
  Future<T> nextValue() async {
    var isFirst = true;
    final completer = Completer<T>();

    final watcher = ValueCell.watch(() {
      try {
        final value = this();

        if (!isFirst && !completer.isCompleted) {
          completer.complete(value);
        }
      }
      catch (e, trace) {
        if (!isFirst && !completer.isCompleted) {
          completer.completeError(e, trace);
        }
      }

      isFirst = false;
    });

    try {
      return await completer.future;
    }
    finally {
      watcher.stop();
    }
  }

  /// Returns a [Future] that completes when the value of this cell equals [value].
  ///
  /// If the value of this cell is already equal to [value], the [Future] completes
  /// immediately.
  ///
  /// **NOTE**: An observer is added to this cell, and only removed when the
  /// cell's value equals [value]. If this never happens, the observer is never
  /// removed.
  Future<void> untilValue<U>(U value) async {
    final completer = Completer();

    final watcher = ValueCell.watch(() {
      try {
        if (!completer.isCompleted && this() == value) {
          completer.complete();
        }
      }
      catch (e) {
        // Prevent error from being printed to console
      }
    });

    await completer.future;
    watcher.stop();
  }
}

/// Provides functionality for waiting until the value of a [bool] cell is true or false.
extension BoolValueChangeExtension on ValueCell<bool> {
  /// Returns a [Future] that completes when the value of this cell is true.
  ///
  /// If the value of this cell is already true, the [Future] completes
  /// immediately.
  ///
  /// **NOTE**: An observer is added to this cell, and only removed when the
  /// cell's value is true. If this never happens, the observer is never
  /// removed.
  Future<void> untilTrue() async => untilValue(true);

  /// Returns a [Future] that completes when the value of this cell is false.
  ///
  /// If the value of this cell is already false, the [Future] completes
  /// immediately.
  ///
  /// **NOTE**: An observer is added to this cell, and only removed when the
  /// cell's value is false. If this never happens, the observer is never
  /// removed.
  Future<void> untilFalse() async => untilValue(false);
}