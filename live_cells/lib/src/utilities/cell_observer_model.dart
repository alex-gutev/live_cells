import 'package:flutter/cupertino.dart';

import '../cell_watch/cell_watcher.dart';
import '../value_cell.dart';

/// Provides the [watch] method for observing changes in cell.
///
/// Usage:
///
///  1. Create a subclass
///  2. Call [watch] in your methods to observe changes to cells
///  3. Call [dispose] once the model is no longer used
abstract class CellObserverModel {
  /// Register a cell watch function [fn].
  ///
  /// See [ValueCell.watch] for more details.
  ///
  /// The returned [CellWatcher] is automatically stopped when [dispose]
  /// is called.
  @protected
  CellWatcher watch(void Function() fn) {
    final watch = ValueCell.watch(fn);
    _watchers.add(watch);

    return watch;
  }

  /// Stop calling all watch functions registered with [watch]
  void dispose() {
    for (final watch in _watchers) {
      watch.stop();
    }
  }

  // Private

  /// List of registered watch functions
  final List<CellWatcher> _watchers = [];
}