This package provides wrappers over Flutter widgets which allow their properties to be accessed
and controlled by `ValueCell`'s, a `ValueNotifier`-like interface. If you're new to **Live Cells**
see the [live_cells](https://pub.dev/packages/live_cells) package for a getting started guide,
documentation and examples.

## Features

* This library allows you to write this:

  ```dart
  @override
  Widget build(BuildContext context) {
    final content = MutableCell('');
    
    return Column([
      Text(content()),
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

  @override
  Widget build(BuildContext context) {
    final switchState = MutableCell(true);

    return Column([
      LiveSwitch(
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
prefixed with `Live`, e.g. `LiveTextField` is the wrapper for Flutter's `TextField`, `LiveSwitch` 
is the wrapper for Flutter's `Switch`. Each wrapper class provides a constructor which accepts the 
same arguments (with a few exceptions) as the constructor of the equivalent Flutter widget.

## Additional information

* For the full list of the wrapper classes provided, check this package's API documentation.
* For an introduction to `ValueCell`'s and their capabilities, visit the 
  [live_cells](https://pub.dev/packages/live_cells) package.
* If you'd like a wrapper class for a specific widget, open an issue on the package's Github
  repository.