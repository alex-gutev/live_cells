## 0.14.1

Minor additions:

* `.waitLast` property which is the same as `.wait` but if a new Future is recevied before the
  previous one has resolved, the previous value update is dropped.

## 0.14.0

New features for asynchronous cells:

* `.wait` property for creating a cell that `await`s a `Future` held in another cell.
* `.delayed` for creating a cell that takes the value of another cell but only notifies its 
  observers after a given delay.

Breaking changes:

* Removed `DelayCell`.

## 0.13.0

* `.cell` extension property is now available on all types
* Additions to `Iterable` cell extension:
  * `cast<E>()` method
  * `map()` method
* Additions to `List` cell extension:
  * `cast<E>()` method
  * `mapCells()` method

## 0.12.3

* Fix potential issues when the computed value of a mutable computed cell is the same as its
  assigned value.

## 0.12.2

* Fix issue with recomputing the value of mutable computed cells.

## 0.12.1

* Reduce minimum version of `meta` dependency

## 0.12.0

New features:

* Record extension methods for creating lightweight computed (and mutable computed) cells:

  ```dart
  (a, b).apply((a,b) => a + b);
  (a, b).mutableApply((a,b) => a + b, (v) {...});
  ```

* `changesOnly` option in cell constructors. When this option is set to true, the cell only
  notifies its observers when its value has actually changed.

* Relaxed restriction that `MutableCellView` only accept a single argument

* Extensions which allow Iterable, List, Map and Set methods and properties to be used directly on
  cells:

  ```dart
  ValueCell<List<int>> listCell;
  ValueCell<int> index;
  ... 
  final elementI = listCell[index];
  final length = listCell.length;
  ```

Breaking changes:

* `CellObserver.update` now takes a second `didChange` parameter. This only affects code that
  uses the `CellObserver` interface directly.
* `DependentCell`, `ComputeCell` and `MutableCellView` now take an argument `Set` as opposed to an
  `argument` List. This only affects code which instantiates these classes directly.
* Remove `CellListenableExtension`. This will be moved to the `live_cell_widgets` package.

Other changes:

* Removed dependency on Flutter. This package can now be used in pure Dart applications.
* Deprecated `ListComputeExtension`, i.e. `[a, b].computeCell(...)`. Use the record compute extensions
  instead.

## 0.11.0

* Core live cell definitions extracted from `live_cells` package to this package.