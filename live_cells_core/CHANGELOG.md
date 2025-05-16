# 1.2.0

Minor breaking change:

* Rename `InactiveMetaCelLError` to `InactiveMetaCellError`.

# 1.1.0

New features:

* `CellExtension` now also generates comparator and hash functions for an annotated class:

  ```dart
  @CellExtension()
  class Point {
    final int x;
    final int y;
  
    ...
  
    @override
    bool operator ==(Object other) =>
      _$PointEquals(this, other);
  
    @override
    int get hashCode => _$PointHash(this); 
  }
  ```

  Additionally the `DataClass` annotation can be used to generate comparator and hash functions
  for a class without generating a cell extension.

# 1.0.0

New features:

* `.exception()` method for creating a cell that throws the exception held in its value:

  ```dart
  final e = MutableCell(Exception('An exception!'));
  final exceptionCell = e.exception();
  
  // Throws Exception('An exception!')
  e();
  ```

* Mutable variants of `.contains()` and `.containsAll()` extension methods

  `.contains()` and `.containsAll()` now return mutable cells when called on
  mutable cells containing sets. 

  When the value of the `contains(...)` cell is set to true the item is added to the set, and
  when set to false the item is removed from the set:

  ```dart
  final set = MutableCell({1, 2, 3, 4});
  
  // contains1 is now a MutableCell
  final contains1 = set.contains(1.cell);
  
  // Setting its value to false removes 1 from [set].
  contains1.value = false;
  
  print(contains1.value); // Prints 2, 3, 4
  
  // Setting its value to true adds the element to the [set].
  contains1.value = true;
  
  print(contains1.value); // Prints 1, 2, 3, 4
  ```

  Similarly when the value of the `.containsAll` cell is set, the items in the iterable passed to
  it are added/removed from the set.

* `.removeAt()` method on cells holding lists:

  ```dart
  final l = MutableCell([1, 2, 3, 4]);
  
  // Remove the element at index 2
  l.removeAt(2);
  
  print(l.value); // Prints 1, 2, 4
  
  l.removeAt(0);
  print(l.value); // 2, 4 
  ```

* `UniqueCellKey`, which can be used as a cell key to specify that a cell is not functionally 
  equivalent to any other cell.

  This is useful to prevent a cell from being assigned a key contexts, such as within the build
  method of a `CellWidget`, where a key is automatically assigned to a cell if it isn't explicitly 
  provided during the construction of the cell.

# 0.25.0

New features:

* New `format` argument on `mutableString()` extension methods.

  Example:

  ```dart
  final germanFormat = NumberFormat("#,##0.00", "de_DE");
  
  final a = MutableCell(1.0);
  final strA = a.mutableString(format: germanFormat);
  
  a.value = 2.5;
  print(strA.value); // 2,50
  
  strA.value = '12,30';
  print(a.value); // 12.3
  ```

# 0.24.2

New features:

* `coalesce` extension method on `MutableCell`s.

  When `coalesce` is called on a `MutableCell`, a `MutableCell` is now returned. This allows
  assigning the value of the cell on which the method is called via the cell returned by `coalesce`.

  Example:

  ```dart
  final a = MutableCell<int?>(null);
  final b = MutableCell(-1);
  
  // c is a MutableCell
  final c = a.coalesce(b);
  
  ValueCell.watch(() {
    print('A = ${a()}');
  });
  
  ValueCell.watch(() {
    print('C = ${c()}');
  });
  
  b.value = 1; // Prints 'A = 1' and 'C = 1'
  
  // Assigning value of 'c' assigns value of 'a'
  c.value = 2; // Prints 'A = 2' and 'C = 2'
  
  // Doesn't print anything since the value of 'a' is not null
  b.value = 3;
  ```

# 0.24.1

New features:

* `reset` parameter in `MutableCell` constructor.

  This allows the value of a shared state mutable cell to be reset to the initial value
  when a new cell is created.

  Example:

  ```dart
  final myKey = MyKey();
  
  final a = MutableCell(1, key: myKey);
  
  ValueCell.watch(() {
    print(a.value);
  }); // Prints 1
  
  // Create a new shared state cell and reset the value of all
  // cells with key 'myKey' to 2
  
  final b = MutableCell(2, 
    key: myKey,
    reset: true
  );
  print(a.value); // Prints 2
  print(b.value); // Prints 2
  ```
  
* `.mutableCell` property for quickly creating a mutable cell initialized to a given value.

  Example:

  ```dart
  // Create mutable cell with an initial value of 1
  final a = 1.mutableCell;
  
  print(a.value); // 1
  a.value = 2
  
  print(a.value); // 2
  ```

# 0.24.0

New features:

* `.transform<...>()` for casting a cell's value type

  Example:

  ```
  ValueCell<Base> base = ...;
  final derived = base.transform<Derived>();
  ```

Bug fixes:

* Fix edge case bug in `mutableApply`.

# 0.23.5

* Fix issue with return type of `MutableCell.notNull` extension method

# 0.23.4

New features:

* `.notNull` extension method on `MutableCell`

# 0.23.3

* Fix issue with dependency tracking in mutable computed cells.

## 0.23.2

Debugging Improvements:

* Exceptions held in a `Maybe` are now rethrown with the stack trace of the exception, when the
  `Maybe` is unwrapped with `Maybe.unwrap`.

## 0.23.1

* Fixed bug with automatic watch function key generation.

## 0.23.0

New features:

* Watch function keys.

  Watch functions can now be identified by keys, like cells, provided in the `ValueCell.watch` and
  `Watch` constructor.

  ```dart
  final w1 = ValueCell.watch(() { ... }, key: 'key1');
  final w2 = ValueCell.watch(() { ... }, key: 'key2');
  
  w1 == w2; // true
  
  // Stops both w1 and w2 since they have the same keys
  w1.stop();
  ```

## 0.22.0

New Features:

* `Watch`

  Registers a watch function that has access to its own handle. 

  This can be used to 1) stop a watch function directly from within the watch function and 2)
  prevent code from running on the first call of the watch function.

  ```dart
  final watch = Watch((state) {
    final value = a();
    
    state.afterInit();
  
    // The following is only run after the first call
    print('A = $value');
    
    if (value > 10) {
      state.stop();
    }
  });
  ```

## 0.21.1

* Fix bug in `AsyncState` comparison.

## 0.21.0

New features:

* `.asyncState` for creating a cell that evaluates to the state of a cell holding a `Future`.

  `.asyncState` evaluates to an `AsyncState` which is a sealed union of:

  * `AsyncStateLoading`
  * `AsyncStateData`
  * `AsyncStateError`

Changes:

* Convert `Maybe` to a sealed union of:

  * `MaybeValue`
  * `MaybeError`

  This change does not break existing code.

## 0.20.4

* Fixed bug with deferred cell initialization not happening in `MetaCell`:

  Sometimes a cell was not initialized when it is injected in a `MetaCell`. This update ensures, that
  every every cell injected in a `MetaCell` is properly initialized.

## 0.20.3

* Fixed bug in `.coalesce()`: If coalesce value cell throws an exception it is
  propagated regardless of whether the cell, on which the method is called, is null or not. 

## 0.20.2

* Improvements to cell updating algorithm.
* Fixed bug in `awaited` cells.

## 0.20.1

New features:

* `MutableMetaCell` and `ActionMetaCell`, which allow `MutableCell`s to have their values set,
  and `ActionCell`s to be triggered from `MetaCell`s.

Minor changes:

* The `.chain(...)` method can now be called on `ValueCell<void>`. Previously it could only be
  called on an `ActionCell`.

## 0.20.0

New features:

* `SelfCell`

  A computed cell which can access it's own value via the `self` argument:

  ```dart
  final increment = ActionCell();
  final cell = SelfCell((self) {
    increment.observe();
    return self() + 1;
  });
  ```

* Action cell chaining with `.chain(...)`

  `.chain(...)` creates an action cell that calls a user provided function when triggered. This
  function can decide whether to trigger the chained action or not.

* Null checking utilities:

  * `.notNull`

    Returns a cell with a value guaranteed to be non-null. If the value of the cell, on which the
    property is used, is `null`, a `NullCellError` exception is thrown.
  
  * `.coalesce(...)`

    Returns a cell that replaces null values in the cell, on which the method is used, with the value
    of another cell.

## 0.19.0

New features:

* Effect Cells

  These can be created with `.effect()` on an action cell (`ValueCell<void>`). An effect cell
  is guaranteed to only be run once per trigger of the action cell on which the `.effect()` method
  is called. This is useful for running side effects, while still being able to observe the result
  of the effect as a cell.

  Example:
  
  ```dart
  final result = action.effect(() async {
    return await submitForm();
  });
  ```

Breaking Changes:

* Async cells created with `.wait`, `.waitLast`, `.awaited` now throw an `PendingAsyncValueError`
  instead of `UninitializedCellError` when the cell value is referenced while the future is pending.

  This does not affect code which uses `.initialValue` to handle these errors.

Other Changes:

* Computed cells no longer run the computation function on initialization. Instead the first run
  of the computation function is deferred to the first time the cell value is referenced.

  NOTE: This changes slightly the semantics of computed cells, especially dynamic computed cells
  which are now dormant until their value is referenced at least once.

* Clarify semantics of `ValueCell.none`:

  If a `null` default value is given and `ValueCell.none` is used during the computation of the
  initial value of a cell, `UninitializedCellError` is thrown.

## 0.18.4

* Allow setting cell values in watch functions.

## 0.18.3

* Add `.whenReady` property on `MetaCell`s.

  This property creates a cell that evaluates to `ValueCell.none` while the meta cell is empty.

* Add `MetaCell.inject` method as an alias for `MetaCell.setCell`.
* Allow watch functions to be terminated using `ValueCell.none()` like compute functions.

## 0.18.2

* Add `.withDefault()` and `.onTrigger` methods for handling `EmptyMetaCellError`.

## 0.18.1

* Add `key` argument to `ActionCell` constructor.

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