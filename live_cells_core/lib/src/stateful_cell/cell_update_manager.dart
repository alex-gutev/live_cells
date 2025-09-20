import '../base/types.dart';

/// Provides functionality for managing the cell value update cycle
class CellUpdateManager {
  /// Is a cell update cycle currently in progress
  static bool get isUpdating => _isUpdating;

  /// Begin a cell update cycle, if one is not in progress already.
  ///
  /// Returns true if a cycle was already in progress, false otherwise.
  static bool beginCellUpdates() {
    final isUpdating = _isUpdating;

    _isUpdating = true;
    return isUpdating;
  }

  /// End a cell update cycle.
  ///
  /// NOTE: The cell update cycle is only ended in [wasUpdating] was false. In
  /// general the same value should be passed for [wasUpdating] as was returned
  /// by [beginCellUpdates].
  ///
  /// This method may only be called if [isUpdating] is true.
  static void endCellUpdates(bool wasUpdating) {
    assert(_isUpdating,
      'CellUpdateManager.endCellUpdates called outside of a cell update cycle.'
    );

    if (!wasUpdating) {
      _isUpdating = false;
      _runPostUpdateCallbacks();
    }
  }

  /// Schedule a callback to run after the current update cycle.
  ///
  /// This method may only be called if [isUpdating] is true.
  static void addPostUpdateCallback(PostUpdateCallback callback) {
    assert(_isUpdating,
      'CellUpdateManager.addPostUpdateCallback called outside of a cell update cycle.'
    );

    _postUpdateCallbacks.add(callback);
  }

  // Private

  /// Is a cell update cycle currently in progress?
  static var _isUpdating = false;

  /// List of scheduled post update callbacks.
  static var _postUpdateCallbacks = <PostUpdateCallback>[];

  /// Are post update callbacks currently being run?
  static var _isPostUpdate = false;

  /// Run all scheduled post update callbacks and clear the list.
  static void _runPostUpdateCallbacks() {
    if (_isPostUpdate) {
      return;
    }

    try {
      _isPostUpdate = true;

      // Run all post update callbacks including those added by post update
      // callbacks

      while (_postUpdateCallbacks.isNotEmpty) {
        final callbacks = _postUpdateCallbacks;
        _postUpdateCallbacks = [];

        for (final callback in callbacks) {
          callback();
        }
      }
    }
    finally {
      _isPostUpdate = false;
    }
  }
}