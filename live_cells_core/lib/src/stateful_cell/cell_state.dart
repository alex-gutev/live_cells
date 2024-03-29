import 'dart:collection';

import 'package:meta/meta.dart';

import '../base/types.dart';
import '../base/cell_observer.dart';
import 'cell_update_manager.dart';
import 'stateful_cell.dart';

/// Holds the state of a [StatefulCell].
///
/// The cell state is responsible for keeping track of the observers of the
/// cell and whatever is necessary for computing the cell's value
class CellState<T extends StatefulCell> {
  /// The cell associated with this state
  final T cell;

  /// The key identifying the cell.
  final dynamic key;

  /// Has this state been disposed.
  ///
  /// After a state has been disposed it should no longer be used
  bool get isDisposed => _isDisposed;

  /// Does this cell have at least one observer?
  bool get isActive => !_isDisposed && _observers.isNotEmpty;

  /// Create a state for [cell] identified by [key].
  CellState({
    required this.cell,
    required this.key
  });

  /// Get the state for the cell identified by [key].
  ///
  /// If [key] is null, [create] is called to create a new [CellState] which
  /// is returned.
  ///
  /// If [key] is non-null and it identifies a cell with an existing state, the
  /// existing state is returned. If there is no existing state a new state is
  /// created using [create], the state is associated with [key] so that
  /// future calls to [getState] with the same key return the same state,
  /// and the state is returned.
  static T getState<T extends CellState>(key, T Function() create) {
    return key != null
        ? _cellStates.putIfAbsent(key, create) as T
        : create();
  }

  /// Get the state for the cell identified by [key] if it exists.
  ///
  /// If [key] is non-null and a state for the cell identified by [key] exists,
  /// it is returned, otherwise null is returned.
  static T? maybeGetState<T extends CellState>(key) => _cellStates[key] as T?;

  /// Initialize the cell state.
  ///
  /// This method is called before adding the first observer. Adding observers
  /// to other cells and acquiring resources should be done in this method,
  /// rather than in the constructor.
  void init() {}

  /// Teardown the cell state.
  ///
  /// This method is called after removing the last observer. After the method
  /// is called this state object should no longer be used or interacted with.
  ///
  /// Subclasses should override this method to remove observers on other cells
  /// and release resources acquired in [init], as well as to include any
  /// additional cleanup logic.
  @mustCallSuper
  void dispose() {
    _isDisposed = true;
    _cellStates.remove(key);
  }

  /// Add an observer which is notified of changes in the value of the cell.
  ///
  /// If this is the first observer that is being added, [init] is called.
  void addObserver(CellObserver observer) {
    assert(!_isDisposed);

    if (_observers.isEmpty) {
      init();
    }

    _observers.update(observer, (count) => count + 1, ifAbsent: () => 1);
  }

  /// Remove an observer, so that it is no longer notified of changes in the value of the cell.
  ///
  /// If this is the last observer that is being removed, [dispose] is called
  /// and [isDisposed] will return true. After that this state object should
  /// no longer be used, and a new state object should be created if the cell
  /// is still used.
  void removeObserver(CellObserver observer) {
    assert(!_isDisposed);

    final count = _observers[observer];

    if (count != null) {
      if (count > 1) {
        _observers[observer] = count - 1;
      }
      else {
        _observers.remove(observer);
        
        if (_observers.isEmpty) {
          dispose();
        }
      }
    }
  }

  /// Notify the observers of the cell that the cell's value will change.
  ///
  /// This should be called before the value of the cell has actually changed.
  ///
  /// If [isEqual] is true then only the observers, for which
  /// [CellObserver.shouldNotifyAlways] is true, are notified.
  void notifyWillUpdate({
    bool isEqual = false,
  }) {
    assert(!_isDisposed);

    assert(++_notifyCount > 0, 'Notify count is less than zero at the start of the update cycle.\n\n'
      'This indicates that there have been more calls to CellState.notifyUpdate '
        'than CellState.notifyWillUpdate, in the previous update cycle. The number of '
        'calls to notifyUpdate should match exactly the number of calls to notifyWillUpdate.\n\n'
        'This indicates a bug in Live Cells unless the error originates from a'
        'ValueCell subclass provided by a third party, in which case it indicates'
        "a bug in the third party's code."
    );

    for (final observer in _observers.keys.toList(growable: false)) {
      try {
        if (!isEqual || observer.shouldNotifyAlways) {
          observer.willUpdate(cell);
        }
      }
      catch (e, st) {
        debugPrint('Unhandled exception in CellObserver.willUpdate: $e\n$st');
      }
    }
  }

  /// Notify the observers of the cell that the cell's value has changed.
  ///
  /// This should be called after the value of the cell has changed to a new
  /// value following a [notifyWillChange] call.
  ///
  /// If [isEqual] is true then only the observers, for which
  /// [CellObserver.shouldNotifyAlways] is true, are notified.
  ///
  /// A value of false for [didChange] indicates that the cell's values has not
  /// changed. A value of true indicates that it may have changed.
  void notifyUpdate({
    bool isEqual = false,
    bool didChange = true
  }) {
    assert(!_isDisposed);
    assert(--_notifyCount >= 0, 'Notify count is less than zero when calling CellState.notifyUpdate.\n\n'
        'This indicates that there have been more calls to CellState.notifyUpdate '
        'than CellState.notifyWillUpdate, in the current update cycle. The number of '
        'calls to notifyUpdate should match exactly the number of calls to notifyWillUpdate.\n\n'
        'This indicates a bug in Live Cells unless the error originates from a'
        'ValueCell subclass provided by a third party, in which case it indicates'
        "a bug in the third party's code."
    );

    final wasUpdating = CellUpdateManager.beginCellUpdates();

    for (final observer in _observers.keys.toList(growable: false)) {
      try {
        if (!isEqual || observer.shouldNotifyAlways) {
          observer.update(cell, !isEqual && didChange);
        }
      }
      catch (e, st) {
        debugPrint('Unhandled exception in CellObserver.update: $e\n$st');
      }
    }

    CellUpdateManager.endCellUpdates(wasUpdating);
  }

  // Private

  /// Maps cell key's to their corresponding [CellState]
  ///
  /// This map only holds [CellStates] for which [CellState.isDisposed] is false.
  static final Map<dynamic, CellState> _cellStates = HashMap();

  var _isDisposed = false;

  /// Number of times the observers were notified of changes to this cell,
  /// during the current update cycle.
  ///
  /// This is increment when [notifyWillUpdate] is called, and decrement when
  /// [notifyUpdate] is called. The purpose of this counter is to ensure, that
  /// the number of times [notifyWillUpdate] is called matches, the number of times
  /// [notifyUpdate] is called, ideally that should only be once.
  ///
  /// NOTE: This counter is only used during debug mode.
  var _notifyCount = 0;

  /// Map of cell observers
  ///
  /// The map is indexed by the observer object with the corresponding values
  /// storing a count of how many times [addObserver] was called for a given
  /// observer.
  final Map<CellObserver, int> _observers = HashMap();
}