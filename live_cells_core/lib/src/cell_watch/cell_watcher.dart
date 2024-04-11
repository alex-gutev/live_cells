import 'dart:collection';

import '../base/exceptions.dart';
import '../base/types.dart';
import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
import '../stateful_cell/cell_update_manager.dart';
import '../value_cell.dart';

/// Maintains the state of a *cell watcher*.
///
/// A *cell watcher* is a function which is called whenever the values of the
/// cells referenced within it change.
class CellWatcher {
  /// Initialize the *cell watcher*
  ///
  /// The [watch] function is called immediately to determine the argument cells
  /// referenced within it.
  ///
  /// **NOTE**: This method should be called at most once.
  void init(WatchCallback watch) {
    _observer.init(watch);
  }

  /// Stop watching the referenced cells.
  ///
  /// The [watch] function is not called again after this method is called.
  void stop() {
    _observer.stop();
  }

  /// Exit the watch function on the first call.
  ///
  /// When this method is called during the initial call to the watch function,
  /// the watch function is exited immediately. On subsequent calls this method
  /// does nothing
  ///
  /// **NOTE**: Don't use this method within a try block unless the try block
  /// excludes [StopComputeException].
  void afterInit() {
    if (_observer._initialCall) {
      throw ValueCell.none();
    }
  }

  // Private
  
  final _observer = _CellWatchObserver();
}

/// Watch (with handle argument) callback function signature.
///
/// This signatures adds a [CellWatcher] argument to the signature, which is
/// the handle to the watch function's state.
typedef WatchStateCallback = void Function(CellWatcher state);

/// A cell watch function which receives the watch state as an argument.
class Watch extends CellWatcher {
  /// Register [watch] to be called whenever the values of the cells referenced within it change.
  ///
  /// The function [watch] is called, with the created [Watch] object passed to
  /// it as an argument, whenever the values of the cells referenced within it
  /// change. [watch] is called once before the constructor returns to determine
  /// the initial cells referenced within it.
  ///
  /// This allows the [stop] and [afterInit] methods to be called from within
  /// [watch].
  Watch(WatchStateCallback watch) {
    init(() => watch(this));
  }
}

/// Cell observer which calls a *cell watcher* function
class _CellWatchObserver implements CellObserver {
  /// The cell watcher function
  late final WatchCallback watch;

  /// Set of cells referenced within [watch]
  final Set<ValueCell> _arguments = HashSet();

  /// Are the referenced cells in the process of updating their values
  var _isUpdating = false;

  /// Is the observer waiting for [update] to be called with didChange equal to true.
  var _waitingForChange = false;

  /// Has the watch function never been called?
  var _initialCall = true;

  /// Has the watch function been stopped?
  var _stopped = false;

  /// Initialize the observer with a [watch] function.
  void init(WatchCallback watch) {
    this.watch = watch;
    _callWatchFn();
    _initialCall = false;
  }

  /// Remove the observer from the referenced cells
  void stop() {
    for (final cell in _arguments) {
      cell.removeObserver(this);
    }

    _arguments.clear();
    _stopped = true;
  }

  /// Call [watch] and track referenced cells
  void _callWatchFn() {
    try {
      ComputeArgumentsTracker.computeWithTracker(watch, (cell) {
        if (!_stopped && !_arguments.contains(cell)) {
          _arguments.add(cell);
          cell.addObserver(this);
        }
      });
    }
    on StopComputeException {
      // Stop execution of watch function
    }
    catch (e, st) {
      debugPrint('Unhandled exception in ValueCell.watch(): $e\n$st');
    }
  }

  /// Schedule the watch function to be called.
  void _scheduleWatchFn() {
    CellUpdateManager.addPostUpdateCallback(_callWatchFn);
  }

  @override
  bool get shouldNotifyAlways => false;

  @override
  void update(ValueCell cell, bool didChange) {
    if (_isUpdating || (didChange && _waitingForChange)) {
      _isUpdating = false;
      _waitingForChange = !didChange;
      
      if (didChange) {
        _scheduleWatchFn();
      }
    }
  }

  @override
  void willUpdate(ValueCell cell) {
    if (!_isUpdating) {
      _isUpdating = true;
      _waitingForChange = false;
    }
  }
}