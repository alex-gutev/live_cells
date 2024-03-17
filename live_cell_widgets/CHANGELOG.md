## 0.7.0

Breaking Changes:

* Rename `onPressed` and `onLongPress` of cell Material buttons to `press` and `longPress`,
  respectively.

  The purpose of this change, is to later allow callback based event handlers to be added using
  `onPressed` and `onLongPress`

Bug Fixes:

* Fix bug with exception handling in `toWidget()`.

## 0.6.0

New widgets:

* `CellElevatedButton`
* `CellFilledButton`
* `CellOutlinedButton`
* `CellTextButton`

## 0.5.0

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

## 0.4.0

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

* Minimum core dependency version updated to `0.16.0`
* Removed deprecated methods and `RestorableCellWidget`

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
