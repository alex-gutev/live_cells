import 'dart:collection';

import '../base/auto_key.dart';
import '../base/exceptions.dart';
import '../base/types.dart';
import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
import '../stateful_cell/cell_update_manager.dart';
import '../value_cell.dart';

part 'cell_watch_table.dart';
part 'cell_watch_observer.dart';

/// Maintains the state of a *cell watcher*.
///
/// A *cell watcher* is a function which is called whenever the values of the
/// cells referenced within it change.
abstract class CellWatcher {
  /// The watch callback function
  WatchCallback get callback;

  /// Has the watch function been called once to initialize its dependencies.
  bool get isInitialized => !_observer._initialCall;

  /// Create a [CellWatcher] identified by [key].
  ///
  /// If [key] is not null and a [CellWatcher] identified by [key] has already
  /// been created, and has not been stopped, this [CellWatcher] object
  /// references the same watch function.
  CellWatcher({key}) {
    this.key = key ?? AutoKey.autoWatchKey(this);
    _observer = _CellWatchTable.getObserver(this.key, _makeObserver);
  }

  /// Start the *cell watcher*
  ///
  /// The [watch] function is called immediately to determine the argument cells
  /// referenced within it.
  ///
  /// **NOTE**: This method should be called at most once.
  void start() {
    _observer.init(callback);
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

  /// Create the observer for the watch function
  _CellWatchObserver _makeObserver() => 
      _CellWatchObserver();
}

/// A [CellWatcher] which determines the argument cells at run time.
class DynamicCellWatcher extends CellWatcher {
  @override
  final WatchCallback callback;

  DynamicCellWatcher({
    super.key,
    required this.callback
  });
}

/// Watch (with handle argument) callback function signature.
///
/// This signatures adds a [CellWatcher] argument to the signature, which is
/// the handle to the watch function's state.
typedef WatchStateCallback = void Function(CellWatcher state);

/// A cell watch function which receives the watch state as an argument.
class Watch extends CellWatcher {
  /// The watch callback function
  final WatchStateCallback watch;

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
  ///
  /// **NOTE**: The watch function is started automatically.
  Watch(this.watch, {super.key}) {
    start();
  }

  @override
  WatchCallback get callback =>_watchCallback;

  void _watchCallback() {
    watch(this);
  }
}

/// A cell watcher with [arguments] that are specified at construction
///
/// Unlike [CellWatcher] and [Watch], this cell watcher does not track the cells
/// referenced in the watch function.
class StaticCellWatcher extends CellWatcher {
  @override
  final WatchCallback callback;

  /// The argument cells observed by the watch function
  final Iterable<ValueCell> arguments;
  
  StaticCellWatcher({
    super.key,
    required this.arguments,
    required this.callback
  });
  
  @override
  _CellWatchObserver _makeObserver() {
    return _StaticCellWatchObserver(arguments);
  }
}