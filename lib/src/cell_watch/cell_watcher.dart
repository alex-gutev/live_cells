import 'dart:collection';
import 'dart:ui';

import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
import '../value_cell.dart';

/// Maintains the state of a *cell watcher*.
///
/// A *cell watcher* is a function which is called whenever the values of the
/// cells referenced within it change.
class CellWatcher {
  /// The watcher function
  final VoidCallback watch;

  /// Create a *cell watcher*
  ///
  /// The function [watch] is called whenever the values of the cells referenced
  /// within the function with the [call] method changes. The function is always
  /// called once immediately before this constructor returns.
  CellWatcher(this.watch) :
      _observer = _CellWatchObserver(watch);

  /// Stop watching the referenced cells.
  ///
  /// The [watch] function is not called again after this method is called.
  void stop() {
    _observer.stop();
  }

  // Private
  
  final _CellWatchObserver _observer;
}

/// Cell observer which calls a *cell watcher* function
class _CellWatchObserver implements CellObserver {
  /// The cell watcher function
  final VoidCallback watch;

  /// Set of cells referenced within [watch]
  final Set<ValueCell> _arguments = HashSet();

  /// Are the referenced cells in the process of updating their values
  var _isUpdating = false;

  /// Create a cell observer which calls *cell watcher* [watch]
  _CellWatchObserver(this.watch) {
    _callWatchFn();
  }

  /// Remove the observer from the referenced cells
  void stop() {
    for (final cell in _arguments) {
      cell.removeObserver(this);
    }
  }

  /// Call [watch] and track referenced cells
  void _callWatchFn() {
    ComputeArgumentsTracker.computeWithTracker(watch, (cell) {
      if (!_arguments.contains(cell)) {
        _arguments.add(cell);
        cell.addObserver(this);
      }
    });
  }

  @override
  bool get shouldNotifyAlways => false;

  @override
  void update(ValueCell cell) {
    if (_isUpdating) {
      _isUpdating = false;
      _callWatchFn();
    }
  }

  @override
  void willUpdate(ValueCell cell) {
    _isUpdating = true;
  }
}