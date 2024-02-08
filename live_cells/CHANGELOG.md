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

