This package provides wrappers over Flutter widgets which allow their properties to be accessed
and controlled by `ValueCell`'s, a `ValueNotifier`-like interface. If you're new to **Live Cells**
see the [live_cells](https://pub.dev/packages/live_cells) package for a getting started guide,
documentation and examples.

## Features

* This library allows you to write this:

  ```dart
  final content = MutableCell('');

  @override
  Widget build(BuildContext context) {
    return Column([
      CellText(data: content),
      ElevatedButton(
        child: Text('Say Hi!'),
        onPressed: () => content.value = 'Hi!'
      )
    ]);
  }
  ```

  Instead of this:

  ```dart
  final content = ValueNotifier('');

  @override
  void dispose() {
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column([
      ValueListenableBuilder(
        valueListenable: content,
        builder: (context, content, _) => Text(content)
      ),
      ElevatedButton(
        child: Text('Say Hi!'),
        onPressed: () => content.value = 'Hi!'
     )
   ]);
  }
  ```

* Data can flow in both ways, which allows you to write this:

  ```dart
  final switchState = MutableCell(true);

  @override
  Widget build(BuildContext context) {
    return Column([
      CellSwitch(
        value: switchState
      )
    ]);
  }
  ```

  instead of this:

  ```dart
  final switchState = ValueNotifier(true);

  @override
  void dispose() {
    switchState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column([
      ValueListenableBuilder(
        valueListenable: switchState,
        builder: (context, value, _) => Switch(
            value: value,
            onChanged: (value) => switchState.value = value
        )
      )
    ]);
  }
  ```

* Much less verbose than setting up (and disposing) `ValueNotifier`'s and `ValueListenableBuilder`'s.
* Eliminates the need for controller objects (still a work in progress).
* `ValueCell`'s can be defined as an expression of other `ValueCell`'s allowing for a declarative
  style of programming. `ValueNotifiers` cannot.
* `ValueCell`'s do not have to be disposed manually.

## Usage

The provided wrapper classes are named the same as their corresponding Flutter widget classes but 
prefixed with `Cell`, e.g. `CellText` is the wrapper for Flutter's `Text`, `CellSwitch` is the 
wrapper for Flutter's `Switch`.

Each wrapper class provides a constructor which accepts the same arguments (with a few exceptions)
as the constructor of the equivalent Flutter widget, but instead of taking raw values each argument
takes a `ValueCell`. The only exception is the `key` argument which is not a `ValueCell`.

Every wrapper class also provides a `bind` method which creates a copy of the widget but with
different values (`ValueCell`'s) for some of the properties. 

For example, the following:

```dart
final text = CellText(data: 'hello'.cell) // Initialize with a const 'hello'
  .bind(data: content)    // Bind the data property to the cell `content`
  .bind(style: textStyle); // Bind the style property to the cell `textStyle`
```

is equivalent to:

```dart
final text = CellText(
  data: content,
  style: textStyle
);
```

## Additional information

* For the full list of the wrapper classes provided, check this package's API documentation.
* For an introduction to `ValueCell`'s and their capabilities, visit the 
  [live_cells](https://pub.dev/packages/live_cells) package.
* If you'd like a wrapper class for a specific widget, open an issue on the package's Github
  repository.