import 'dart:collection';

import '../base/cell_observer.dart';
import '../value_cell.dart';

/// Cell creation function for [ValueCell] holding a [T]
typedef CellCreator<T> = ValueCell<T> Function();

/// Table mapping keys to active [ValueCell] instances
class CellTable {
  /// Get the singleton instance
  factory CellTable() => _instance;

  /// Call [fn] with an acquired instance of the cell identified by [key].
  /// 
  /// 1. The instance of the cell identified by [key] is created if it doesn't exist
  ///    or its reference count is incremented if it does.
  ///    
  /// 2. [fn] is called with the acquired instance
  /// 
  /// 3. The reference count of the instance is decremented
  ///
  /// Returns the value returned by [fn].
  R useCell<R,T>(key, CellCreator<T> create, R Function(ValueCell<T> cell) fn) {
    try {
      return fn(_acquire(key, create));
    }
    finally {
      _release(key);
    }
  }

  /// Call [fn] with the instance of the cell identified by [key].
  ///
  /// If the cell identified by [key] exists, [fn] is called and the
  /// value returned by [fn] is returned.
  ///
  /// If the cell does not exist, [fn] is not called and `null` is returned.
  R? withCell<R, T>(key, R Function(ValueCell<T> cell) fn) {
    final ref = _cells[key];
    return ref != null ? fn(ref.cell as ValueCell<T>) : null;
  }

  /// Add an observer to the cell identified by [key].
  /// 
  /// The reference count of the cell is incremented.
  void addObserver<T>(key, CellCreator<T> create, CellObserver observer) {
    _acquire(key, create).addObserver(observer);
  }

  /// Remove an observer from the cell identified by [key].
  ///
  /// If the cell exists and [observer] was an actual observer, the reference
  /// count of the cell is decremented.
  bool removeObserver(key, CellObserver observer) {
    final ref = _cells[key];

    if (ref?.cell.removeObserver(observer) ?? false) {
      _release(key);
      return true;
    }

    return false;
  }

  // Private

  static final CellTable _instance = CellTable._internal();

  CellTable._internal();

  /// Maps keys to [_CellRef]'s
  final Map<dynamic, _CellRef> _cells = HashMap();

  /// Get the cell referenced by [key] and increment its reference count.
  ///
  /// If there is no cell corresponding to [key], a new one is created
  /// using [create] with an initial reference count of 1.
  ValueCell<T> _acquire<T>(key, CellCreator<T> create) {
    final ref = _cells.update(
        key, _incRef,
        ifAbsent: () => _CellRef(cell: create())
    );

    return ref.cell as ValueCell<T>;
  }

  /// Decrement the reference count of the cell referenced by [key].
  ///
  /// Once the reference count of a cell becomes 0, it is removed from the
  /// table.
  bool _release(key) {
    final ref = _cells[key];

    if (ref != null && --ref.count == 0) {
      return _cells.remove(key) == null;
    }

    return false;
  }

  /// Increment the reference count of the cell held by [ref]
  _CellRef _incRef(_CellRef ref) {
    ref.count++;
    return ref;
  }
}

/// Holds a [ValueCell] and its reference count
class _CellRef {
  /// The cell
  final ValueCell cell;

  /// Cell reference count
  var count = 1;

  _CellRef({required this.cell});
}