import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'cell_observer.dart';
import 'managed_cell.dart';

/// Provides functionality for adding, removing and notifying observers of a cell
///
/// This mixin provides implementations of the [addObserver] and [removeObserver]
/// methods of the [ValueCell] interface.
///
/// The [init] and [dispose] methods of [ManagedCell] are called respectively
/// when the first observer is added, and the last observer is removed.
mixin CellListeners<T> on ManagedCell<T> {
  /// Has the cell been initialized
  @protected
  bool get isInitialized => _observers.isNotEmpty;
  
  /// Does this cell have observers for which [CellObserver.shouldNotifyAlways] is true?
  @protected
  bool get hasShouldNotifyAlways => _nNotifyAlways > 0;

  @override
  void addObserver(CellObserver observer) {
    if (!isInitialized) {
      init();
    }

    _observers.update(observer, (count) => count + 1, ifAbsent: () => 1);
    
    if (observer.shouldNotifyAlways) {
      _nNotifyAlways++;
    }
  }

  @override
  void removeObserver(CellObserver observer) {
    final count = _observers[observer];

    if (count != null) {
      if (observer.shouldNotifyAlways) {
        assert(_nNotifyAlways > 0);
        _nNotifyAlways--;
      }
      
      if (count > 1) {
        _observers[observer] = count - 1;
      }
      else {
        _observers.remove(observer);

        if (!isInitialized) {
          dispose();
        }
      }
    }
  }

  /// Notify the observers of the cell that the cell's value will change.
  ///
  /// This should be called before the value of the cell has actually changed.
  @protected
  void notifyWillUpdate() {
    for (final observer in _observers.keys) {
      try {
        observer.willUpdate(this);
      }
      catch (e, st) {
        if (kDebugMode) {
          print('Error in CellObserver.preUpdate: $e - $st');
        }
      }
    }
  }

  /// Notify the observers of the cell that the cell's value has changed.
  ///
  /// This should be called after the value of the cell has changed to a new
  /// value following a [notifyWillChange] call.
  @protected
  void notifyUpdate() {
    for (final observer in _observers.keys) {
      try {
        observer.update(this);
      }
      catch (e, st) {
        if (kDebugMode) {
          print('Error in CellObserver.update: $e - $st');
        }
      }
    }
  }

  /// Private

  /// Map of cell observers
  ///
  /// The map is indexed by the observer object with the corresponding values
  /// storing a count of how many times [addObserver] was called for a given
  /// observer.
  final Map<CellObserver, int> _observers = HashMap();
  
  /// Number of observers for which [CellObserver.shouldNotifyAlways] is true
  var _nNotifyAlways = 0;
}