import 'dart:collection';

import '../value_cell.dart';

/// Cell creation function for [ValueCell] holding a [T]
typedef CellCreator<T> = ValueCell<T> Function();

/// Table mapping keys to active [ValueCell] instances
class CellTable {
  /// Get the singleton instance
  factory CellTable() => _instance;

  /// Get the cell referenced by [key] and increment its reference count.
  ///
  /// If there is no cell corresponding to [key], a new one is created
  /// using [create] with an initial reference count of 1.
  ValueCell<T> acquire<T>(key, CellCreator<T> create) {
    final ref = _cells.update(
        key, _incRef,
        ifAbsent: () => CellRef(cell: create())
    );

    return ref.cell as ValueCell<T>;
  }

  /// Decrement the reference count of the cell referenced by [key].
  /// 
  /// Once the reference count of a cell becomes 0, it is removed from the
  /// table.
  bool release(key) {
    final ref = _cells[key];

    if (ref != null && --ref.count == 0) {
      return _cells.remove(key) == null;
    }

    return false;
  }

  // Private

  static final CellTable _instance = CellTable._internal();

  CellTable._internal();

  /// Maps keys to [CellRef]'s
  final Map<dynamic, CellRef> _cells = HashMap();

  /// Increment the reference count of the cell held by [ref]
  CellRef _incRef(CellRef ref) {
    ref.count++;
    return ref;
  }
}

/// Holds a [ValueCell] and its reference count
class CellRef {
  /// The cell
  final ValueCell cell;

  /// Cell reference count
  int count;

  CellRef({required this.cell, this.count = 1});
}