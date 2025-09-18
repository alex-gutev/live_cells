part of 'cell_watcher.dart';

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
      _onWatch();
    }
    on StopComputeException {
      // Stop execution of watch function
    }
    catch (e, st) {
      debugPrint('Unhandled exception in ValueCell.watch(): $e\n$st');
    }
  }

  void _onWatch() {
    ComputeArgumentsTracker.computeWithTracker(watch, (cell) {
      if (!_stopped && !_arguments.contains(cell)) {
        _arguments.add(cell);
        cell.addObserver(this);
      }
    });
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

/// Observer for watch function with arguments specified at compile time
class _StaticCellWatchObserver extends _CellWatchObserver {
  /// Create an watch function observer with given [arguments]
  _StaticCellWatchObserver(Iterable<ValueCell> arguments) {
    _arguments.addAll(arguments);

    for (final arg in arguments) {
      arg.addObserver(this);
    }
  }

  @override
  void _onWatch() => watch();
}