## 0.18.0

New features:

* Meta Cells
  
  A meta cell (`MetaCell`) is a cell that points to another cell. The value of a meta cell is the
  value of the pointed to cell, and its observers are notified when the pointed to cell's value 
  changes.

  The pointed to cell can be changed multiple times.

  Example:

  ```dart
  final a = MutableCell(0);
  final b = MutableCell(1);
  
  final meta = MetaCell<int>();
  
  meta.setCell(a);
  print(meta.value); // 0
  
  meta.setCell(b);
  print(meta.value); // 1
  ```

* The `.hold()` method for keeping a cell active until it is released with `.release()`

  ```dart
  final a = MutableCell(0, key: aKey);
  
  // Ensure that a is active
  final hold = a.hold();
  ...
  // Allow a to be disposed
  hold.release();
  ```
  
Breaking Changes:

* Removed `dispose()` method from `MutableCell` interface.
* Reading/writing the value of a keyed `MutableCell` while it is inactive now throws an
  `InactivePersistentStatefulCellError`.

  Use `.hold()` to ensure a keyed `MutableCell` is active before using it.

## 0.17.0

New features:

* Functionality for automatically generating cell keys, using `AutoKey`.
* Mutable cells can now have keys.

## 0.16.1

* Add exception handling in initial call to cell watch functions.
* Improve unhandled exception notices.

## 0.16.0

New features:

* `and()`, `or()` and `not()` now return keyed cells.

* The following methods for waiting for changes in cell values:
  * `.nextChange()`
  * `.untilValue()`
  * `.untilTrue()`
  * `.untilFalse()`
  
* `ActionCell`
  
  A cell without a value, used solely to represent actions and events.

## 0.15.1

* Fix issue with `.isCompleted` having incorrect value when `Future` completes with an error.

## 0.15.0

New features:

* `.awaited` property on cells holding a `Future`. 

  Returns a cell which evaluates to the value of the `Future` when completed, throws 
  an `UninitializedCellError` when it is pending.
  
* `.isCompleted` property on cells holding a `Future`. 
  
  Returns a cell which evaluates to `true` when the `Future` is complete, `false` while it is
  pending.
  
* `.initialValue(...)` which returns a cell with takes on the value of the given cell until it 
  is initialized.

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