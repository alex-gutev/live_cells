part of 'cell_watcher.dart';

/// Maintains the association between keys and cell watch functions
class _CellWatchTable {
  /// Get the watch function observer associated with [key].
  ///
  /// If no such function exists, [create] is called and the return value of
  /// [create] is associated with [key].
  static _CellWatchObserver getObserver(key, _CellWatchObserver Function() create) {
    return key != null
        ? _observers.putIfAbsent(key, create)
        : create();
  }

  /// Get the observer of the watch function identified by [key] if any.
  static _CellWatchObserver? maybeGetObserver(key) =>
      key != null ? _observers[key] : null;

  /// Remove the observer associated with [key] if any
  static void remove(key) {
    _observers.remove(key);
  }

  // Private

  /// Map associating keys to watch function observers.
  static final Map<dynamic, _CellWatchObserver> _observers = HashMap();
}