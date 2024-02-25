## 0.3.2

* Update `live_cells_core` dependency version to `0.15.0`

## 0.3.1

* Update `live_cells_core` dependency version to `0.14.0`

## 0.3.0

* Improvements to `CellWidget`:
  * Unused dependencies are untracked.
  * Widget properties can now be bound to different cells between builds.

## 0.2.2

* Increase core dependency version to 0.12.3

## 0.2.1

* Relax live_cells_core dependency version constraint.

## 0.2.0

* Simplified state restoration:

  * No need to use `RestorableCellWidget`
  * Add `restorationId` directly on `CellWidget` / `StaticWidget`.
  * Added `.restore()` method for cell state restoration in `StaticWidget`

New Widgets:

* `CellRow`
* `CellColumn`

## 0.1.1

* Fix bug with StaticWidget.builder

## 0.1.0

* Move widget wrapper classes from `live_cells` package to this package.
