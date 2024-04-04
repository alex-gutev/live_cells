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

New widgets:

* `CellBanner`
* `CellBlockSemantics`
* `CellVisibility`

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

* Combining Action Cells:

  Multiple action cells can now be combined into a single cell, which notifies its observers, whenever
  any of the actions trigger, using `List.combined`

  Example:

  ```dart
  final a1 = ActionCell();
  final a2 = ActionCell();
  
  final all = [a1, a2].combined;
  ```

Breaking Changes:

* Async cells created with `.wait`, `.waitLast`, `.awaited` now throw an `PendingAsyncValueError`
  instead of `UninitializedCellError` when the cell value is referenced while the future is pending.

  This does not affect code which uses `.initialValue` to handle these errors.

* Renamed `onPressed` and `onLongPress` of cell Material buttons to `press` and `longPress`,
  respectively.

  The purpose of this change, is to later allow callback based event handlers to be added using
  `onPressed` and `onLongPress`

Other Changes:

* Computed cells no longer run the computation function on initialization. Instead the first run
  of the computation function is deferred to the first time the cell value is referenced.

  NOTE: This changes slightly the semantics of computed cells, especially dynamic computed cells
  which are now dormant until their value is referenced at least once.

* Clarify semantics of `ValueCell.none`:

  If a `null` default value is given and `ValueCell.none` is used during the computation of the
  initial value of a cell, `UninitializedCellError` is thrown.

* Bug fix: Unhandled exceptions in a `ValueCell.watch` no longer propagate out of the watch function.


## 0.18.4

* Improve action cell example.

## 0.18.3

* Add example of action cells to example project.

## 0.18.2

* Allow setting cell values in watch functions.

## 0.18.1

Additions from core:

* Add `.whenReady` property on `MetaCell`s.

  This property creates a cell that evaluates to `ValueCell.none` while the meta cell is empty.

* Add `MetaCell.inject` method as an alias for `MetaCell.setCell`.
* Allow watch functions to be terminated using `ValueCell.none()` like compute functions.

## 0.18.0

New features from core:

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

* A `.hold()` method for keeping a cell active until it is released with `.release()`

  ```dart
  final a = MutableCell(0, key: aKey);
  
  // Ensure that a is active
  final hold = a.hold();
  ...
  // Allow a to be disposed
  hold.release();
  ```

New widgets:

* `CellElevatedButton`
* `CellFilledButton`
* `CellOutlinedButton`
* `CellTextButton`

Breaking Changes:

* Removed `dispose()` method from `MutableCell` interface.
* Reading/writing the value of a keyed `MutableCell` while it is inactive now throws an
  `InactivePersistentStatefulCellError`.

  Use `.hold()` to ensure a keyed `MutableCell` is active before using it.

## 0.17.0

New features:

* Automatic key generation for unkeyed cells defined in the `build` method of `CellWidget` and
  `CellWidget.builder`.

  This allows cells local to a `CellWidget` to be defined directly in the build method/function
  without having to use `.cell(() => ...)`

  With version 0.4.0:

  ```dart
  class Example extends CellWidget with CellInitializer {
    @override
    Widget build(BuildContext context) {
      final count = cell(() => MutableCell(0));
      ...
    }
  }
  ```

  This can now be simplified to the following with version 0.5.0:

  ```dart
  class Example extends CellWidget {
    @override
    Widget build(BuildContext context) {
      final count = MutableCell(0);
      ...
    }
  }
  ```

**Breaking Changes**:

* `CellInitializer` has been renamed to `CellHooks`
*
* `.cell()` and `.watch()` have been moved from `BuildContext` to `CellHookContext`.

  This will not affect code that uses `CellWidget.builder`.

* State restoration options have been removed from `.cell()`. Use `.restore()` instead.

## 0.16.2

Changes from core:

* Add exception handling to initial cell watch function calls.
* Improve unhandled exception notices.

## 0.16.1

* Fix typos in Changelog.

## 0.16.0

New features from core:

* `and()`, `or()` and `not()` now return keyed cells.

* The following methods for waiting for changes in cell values:
  * `.nextChange()`
  * `.untilValue()`
  * `.untilTrue()`
  * `.untilFalse()`

* `ActionCell`

  A cell without a value, used solely to represent actions and events.

New widgets:

* `CellAbsorbPointer`
* `CellAnimatedCrossFade`
* `CellAnimatedFractionallySizedBox`
* `CellAnimatedPositionedDirectional`
* `CellAnimatedRotation`
* `CellAnimatedScale`
* `CellAnimatedSlide`
* `CellAnimatedSwitcher`
* `CellAnnotatedRegion`

Other changes:

* Removed deprecated `computeCell` and `computeWidget` extension methods on `List`
* Removed deprecated `RestorableCellWidget`

## 0.15.1

* Fix issue with `.isCompleted` having incorrect value when `Future` completes with an error.

## 0.15.0

New features from core:

* `.awaited` property on cells holding a `Future`.

  Returns a cell which evaluates to the value of the `Future` when completed, throws
  an `UninitializedCellError` when it is pending.

* `.isCompleted` property on cells holding a `Future`.

  Returns a cell which evaluates to `true` when the `Future` is complete, `false` while it is
  pending.

* `.initialValue(...)` which returns a cell with takes on the value of the given cell until it
  is initialized.


## 0.14.2

* Fix async examples in README.

## 0.14.1

Minor additions from core:

* `.waitLast` property which is the same as `.wait` but if a new Future is received before the
  previous one has completed, the previous future is dropped.

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

* Improvements to `CellWidget`:
  * Unused dependencies are untracked.
  * Widget properties can now be bound to different cells between builds.

## 0.12.1

* Increase live_cells_core dependency version to 0.12.3
* Increase live_cell_widgets dependency version to 0.2.2

## 0.12.0

New features in core:

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

New features in widgets library:

* Simplified state restoration:

  * No need to use `RestorableCellWidget`
  * Add `restorationId` directly on `CellWidget` / `StaticWidget`.
  * Added `.restore()` method for cell state restoration in `StaticWidget`

* New Widgets:
  * `CellRow`
  * `CellColumn`

## 0.11.2

Bump `live_cell_widgets` dependency version to 0.1.1:

* Fix bug in StaticWidget.builder.

## 0.11.1

Move documentation to: <https://alex-gutev.github.io/live_cells/docs/intro>

## 0.11.0

This release divides the functionality of this package among component packages:

* [live_cell_core](https://pub.dev/packages/live_cells_core)
* [live_cell_widgets](https://pub.dev/packages/live_cell_widgets)

Additionally the full documentation is now available at: <https://docs.page/alex-gutev/live_cells>.

New Features:

* Wrapper classes for more widgets
* `.peek` property for accessing the value of a cell without triggering a recomputation

Breaking Changes:

* Minimum SDK version increased to 3.0.0
* All properties of the widgets provided by `live_cell_widgets` are now cells

## 0.10.3

* Change `live_cell_annotations` version to `0.2.0`.

## 0.10.2

* Fix bug: Handle exceptions thrown during computation of the initial values of cells.

## 0.10.1

* Move annotations into separate package: [https://pub.dev/packages/live_cell_annotations](live_cell_annotations).

## 0.10.0

New features:

* Keyed cells, cells with the same key reference a shared state.
* Lightweight mutable computed cells.
* `CellExtension` annotation for automatically generating `ValueCell` accessors for classes, using
  the `live_cell_extension` package (which will be released soon).

This release also comes with major changes to the implementation. These changes are only breaking to
code which creates user-defined `ValueCell` subclasses:

* Removed the following internal implementation classes and mixins from the public API:
  * `EqCell`
  * `NeqCell`
  * `NotifierCell`
  * `CellEquality`
  * `CellListeners`
  * `ObserverCell`

## 0.9.1

* Fixed bug with accessing previous cell values

## 0.9.0

New features:

* Constant `bool`, `null`, `Enum` and `Duration` cells can now be created with the `cell` property,
  e.g. `true.cell`.
* Utilities for working with cells holding a `Duration`.
* `CellObserverModel` for creating classes which observe one or more cells
* Add `selection` cell parameter to `CellTextField` constructor for observing and controlling the 
  field's selection.

## 0.8.1

* Correct typos and errors in readme examples

## 0.8.0

New features:

* Ability to access the previous values of cells with `.previous`
* Ability to abort a cell value update with `ValueCell.none()`
* `and`, `or`, `not` and `select` methods on bool cells
* Exception handling using `onError` and `error`
* Clarified how exceptions are propagated between cells

## 0.7.0

New features:

* `ValueCell.watch` and `CellInitializer.watch` for calling a function whenever the values of cells
  change.
* State restoration of cells with `RestorableCellWidget`

## 0.6.1

* Fix potential issues
* Fix typos and improve README

## 0.6.0

New features:

* `Maybe` type and `MaybeCell` for error handling
* `errorValue` argument of `mutableString` method to control value in case of errors during parsing
* Remove restriction that arguments of *mutable computed cells* be mutable cells

Breaking changes:

* Add `shouldNotifyAlways` property to `CellObserver` interface

Improvements and bug fixes:

* Simplify implementation of `CellInitializer.cell`
* Allow updated cell value to be accessed even when the cell has no observers
* Fix bug in `BuildContext.cell` method
* Fix bug in `CellTextField`

## 0.5.2

* Fix potential issues

## 0.5.1

* Fix typos and bugs in examples in README

## 0.5.0

New features:

* `ValueCell.computed` constructor for creating computed cells with dynamic dependencies
* `MutableCell.computed` constructor for creating mutable computed cells with dynamic dependencies
* `CellWidget` can now also track the cells it depends on at runtime
* `mutableString` extension method on `MutableCell`'s holding an `int`, `double`, `num` or `string`

Breaking changes:

* `CellWidget.cell` method has been moved to `CellListeners` mixin
* `CellWidgetBuilder` has been removed in favour of `CellWidget.builder` constructor

Improvements:

* Simplified examples demonstrating core concepts only
* Simplified and streamlined API
* Improved README
* Bug fixes

## 0.4.1

* Bug fixes

## 0.4.0

* Simplify implementation of `CellWidget`. Subclasses now override `build` instead of `buildChild`.

## 0.3.1

* Bug fixes

## 0.3.0

New features:

* Mutable computational cells
* Batch updates
* `CellWidget` base class for creating widgets make use of cells
* `CellWidgetBuilder` for creating `CellWidget`'s without subclassing
* New widgets in widgets library:
  * `CellCheckbox`
  * `CellCheckboxListTile`
  * `CellRadio`
  * `CellRadioListTile`
  * `CellSlider`
  * `CellSwitch`
  * `CellSwitchListTile`
* Shorthand `List.computeWidget` method for creating widgets which depend on multiple cells

Breaking changes:

* `MutableCell` is now an interface with a factory constructor
* `CellObserver` interface methods now take *observed cell* as arguments
* Removed `CellBuilder`

## 0.2.3

* Fix issue with `CellTextField`

## 0.2.2

* Fix issue with List.computeCell method
* Fix issues with unit tests

## 0.2.1

* Fix issues with examples in README

## 0.2.0

New features:

* Stronger guarantees that a `StoreCell` will not hold an outdated value
* Shorthand `.cell` property for creating constant value cells
* Shorthand `List.computeCell` method for creating multi-argument computational cells
* Arithmetic and comparison operator overloads to create computational cells directly using expressions such as `a + b`

Breaking changes:

* `ValueCell` is no longer a `ValueListenable`
* `ValueCell.addListener` and `ValueCell.removeListener` are replaced with `addObserver` and `removeObserver`
* New `CellObserver` interface for observing changes to the values of cells
* `ValueCell.listenable` property provided to use `ValueCell` as a `ValueListenable`

## 0.1.2

* Fix dart doc issues

## 0.1.1

* Fix package directory structure

## 0.1.0

* Initial release.

