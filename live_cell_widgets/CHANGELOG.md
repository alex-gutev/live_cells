## 0.17.0

Changes:

* Upgrade minimum Flutter version to 3.32.0.

## 0.16.1

* Improve documentation of live widgets.

* Fix issue with `setState` being called after the widget is unmounted.

## 0.16.0

* New widgets:

  * `LiveFloatingActionButton`
  * `LiveIconButton`
  * `LiveInkWell`
  * `LiveInteractiveViewer`

## 0.15.0

### New Features

* Live widgets wrappers now provide every constructor that is provided by the wrapped Flutter
  widgets.

  For example, the `LiveFilledButton` widget, which is a wrapper over Flutter's `FilledButton`
  now also provides the `.icon` and `.tonal` constructors in addition to the default constructor:

  ```dart
  LiveFilledButton.icon(
    icon: Icon(...),
    label: Text(...),
  
    press: pressActionCell
  )
  ```

### Breaking Changes

* Removed `StaticWidget`

  **Reason**: Doesn't interact well with inherited widgets

  **Replacement**: `CellWidget`

* Removed `CellHooks` mixin

  **Reason**:: It's obsolete since cells can be defined directly in the build method of a
  `CellWidget`

  **Replacement**: Define cells and watch functions directly in the build method/function of a
  `CellWidget`

* Removed `bind` methods provided by *Live* widgets

  **Reason**: There are few use cases for it and it is difficult to implement for widgets that 
  provide multiple constructors

  **Replacement**: Crate a new widget using the `CellWidget` constructor

* Live button widgets (`LiveFilledButton`, `LiveElevatedButton`, etc.) now take `ActionCell`s
  for the `press` and `longPress` arguments instead of `MetaCell<void>`.

  **Reason**: This makes the button widgets easier to use

* Minimum required Flutter version is now 3.29.3

## 0.14.1

* Fix issue with widgets not updating if triggered by cell changes during build phase.

## 0.14.0

* Bump major version since widgets library now requires Flutter 3.29.2

## 0.13.1

* Increase `live_cells_core` version to `1.1.0`.
* Deprecate `StaticWidget`.

## 0.13.0

* Remove deprecated widgets library.
* Increase `live_cells_core` version to `1.0.0`.

## 0.12.5

Increase `live_cells_core` version to `0.25.0`.

## 0.12.4

* Fix issue with cell state restoration.

## 0.12.3

* Fix typos in README.

## 0.12.2

* Update README.

## 0.12.1

* Fix typos in changelog.

## 0.12.0

Breaking changes:

* The minimum Flutter version has been increased to 3.24.3.
* The `live_cells_widgets` library is deprecated. Use the `live_cells_ui` library.
* The `live_cells_ui` library provides the same functionality as `live_cells_widgets` 
  with the following differences:

  * The widgets are prefixed with `Live` instead of `Cell`, e.g. `LiveTextField` from `live_cells_ui`
    is the equivalent to `CellTextField` from `live_cell_widgets`

  * Only those properties which represent user input are cells, the rest are regular values. For example
    in `LiveSwitch` only the `value` and `enabled` properties are cells.
  
  * `live_cells_ui` does not provide wrappers for widgets which do not take input from the user,
    for example there is no `LiveText` equivalent to `CellText`. Wrap a regular `Text` widget in a
    `CellWidget.builder` or a `CellWidget` subclass for reactivity.

## 0.11.0

* Update `live_cells_core` dependency to 0.24.0
* Update widget wrappers to Flutter 3.24.3

## 0.10.1

New widgets:

* `CellCheckboxMenuButton`
* `CellCheckboxTheme`
* `CellChipTheme`
* `CellColoredBox`
* `CellColoredFilter`
* `CellCheckedPopupMenuItem`
* `CellChoiceChip`
* `CellCloseButton`
* `CellContraintsTransformBox`

## 0.10.0

New features:

* Watch functions can now be defined directly in the build method of a `CellWidget` without 
  `CellHooks`:

  ```dart
  CellWidget.builder((_) {
    final cell = MutableCell(...);
  
    ValueCell.watch(() {
      final c = cell();
      ...
    })
    ...
  });
  ```

## 0.9.0

New widgets:

* `CellPageView`

  A `PageView` with the current page controlled by a `page` cell:

  ```dart
  final page = MutableCell(0);
  
  return CellPageView(
    page: page,
    animate: true.cell
    duration: Duration(milliseconds: 100).cell,
    curves: Curves.easeIn.cell
    
    children: [
       Page1(),
       Page2(),
       ...
    ].cell
  );
  ```
  
  The current page can be changed by setting the `page` cell.

  ```dart
  page.value = 2;
  ```

  The current page can also be observed by observing the same `page` cell.

## 0.8.2

* Increase `live_cells_core` version to `0.22.0`

## 0.8.1

* Increase `live_cells_core` version to `0.21.0`

## 0.8.0

New widgets:

* `CellBanner`
* `CellBlockSemantics`
* `CellVisibility`

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
