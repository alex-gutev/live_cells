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