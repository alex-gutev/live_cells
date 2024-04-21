import 'dart:collection';

import '../base/auto_key.dart';
import '../base/exceptions.dart';
import '../base/types.dart';
import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
import '../stateful_cell/cell_update_manager.dart';
import '../value_cell.dart';

part 'cell_watch_table.dart';

/// Maintains the state of a *cell watcher*.
///
/// A *cell watcher* is a function which is called whenever the values of the
/// cells referenced within it change.
class CellWatcher {
  /// Has the watch function been called once to initialize its dependencies.
  bool get isInitialized => !_observer._initialCall;

  /// Create a [CellWatcher] identified by [key].
  ///
  /// If [key] is not null and a [CellWatcher] identified by [key] has already
  /// been created, and has not been stopped, this [CellWatcher] object
  /// references the same watch function.
  CellWatcher({key}) {
    this.key = key ?? AutoKey.autoWatchKey(this);
    _observer = _CellWatchTable.getObserver(key, _CellWatchObserver.new);
  }

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
    _CellWatchTable.remove(key);
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

  /// Stop the watch function identified by [key].
  ///
  /// If [key] does not identify a watch function, this method does nothing.
  static void stopByKey(dynamic key) {
    if (key != null) {
      _CellWatchTable.maybeGetObserver(key)?.stop();
      _CellWatchTable.remove(key);
    }
  }

  @override
  bool operator ==(Object other) => other is CellWatcher &&
      runtimeType == other.runtimeType &&
      (key != null ? key == other.key : super == other);

  @override
  int get hashCode => Object.hash(runtimeType, key);

  // Private
  
  late final _CellWatchObserver _observer;

  /// Key identifying watch function
  late final dynamic key;
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
  ///
  /// If [key] is not null and a [CellWatcher] identified by [key] has already
  /// been created, and has not been stopped, this [CellWatcher] object
  /// references the same watch function.
  Watch(WatchStateCallback watch, {super.key}) {
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
    if (_initialCall) {
      this.watch = watch;
      _callWatchFn();
      _initialCall = false;
    }
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