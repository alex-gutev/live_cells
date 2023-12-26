## 0.1.0

* Initial release.

## 0.1.1

* Fix package directory structure

## 0.1.2

* Fix dart doc issues

## 0.2.0

New features:

* Stronger guarantees that a `StoreCell` will not hold an outdated value
* Shorthand `.cell` constructor for creating constant value cells
* Shorthand `List.computeCell` constructor for creating multi-argument computational cells
* Arithmetic and comparison operator overloads to create computational cells directly using expressions such as `a + b`

Breaking changes:

* `ValueCell` is no longer a `ValueListenable`
* `ValueCell.addListener` and `ValueCell.removeListener` are replaced with `addObserver` and `removeObserver`
* New `CellObserver` interface for observing changes to the values of cells
* `ValueCell.listenable` provided to use `ValueCell` as a `ValueListenable`