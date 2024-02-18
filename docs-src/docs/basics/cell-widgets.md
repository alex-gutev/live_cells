---
title: Cells in Widgets
description: Using cells in widgets
sidebar_position: 2
---

# Cells in Widgets

Cells would be pretty boring if you could not use them in widgets.

The simplest way to use the value of a cell in a widget is with
`CellWidget.builder`, which creates a widget that observes one or more
cells. Whenever the values of the observed cells change, the widget is
rebuilt.

```dart title="CellWidget.builder"
CellWidget.builder((context) => Text('Count: ${count()}'));
```

The example above creates a widget that observes the value of a
`count` cell and displays it in a `Text` widget. Whenever the value of
`count` changes, the widget is rebuilt.

Let's put this together to build a simple counter:

```dart title="Counter using cells"
class Counter extends StatefulWidget {
    @override
    State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
    final count = MutableCell(0);

    @override
    Widget build(BuildContext context) => ElevatedButton(
        child: CellWidget.Builder((_) => Text('${count()}')),
        onPressed: () => count.value++
    );
}
```

The example above:

* Defines a button which increments a `count` cell when pressed.
* The value of the `count` cell is displayed in the child of the
  `ElevatedButton` using `CellWidget.Builder`.
* Pressing the button results in the widget being rebuilt and hence
  the new counter value being displayed.

:::info
Unlike `ValueNotifier` and `ChangeNotifier` you don't have to call
`dispose` on cells.
:::

## Defining cells directly in the build method

In the previous section the `count` cell, which holds the value of the
counter, is stored in the `State` class of a `StatefulWidget`. This is
a good starting point, but it will quickly get tiring if you need to
define cells that depend on other cells also defined in the same
`State` class. Besides that having to use a `StatefulWidget` just to
define a cell is verbose and annoying.

Luckily `CellWidget` provides functionality for defining cells
directly in the widget build function. The `cell` method, of the
`context` parameter passed to the widget builder function, creates a
cell which is persisted between builds of the widget.

Using `CellWidget.builder`, the counter can be implemented as follows:

```dart title="Defining cells using context.cell"
Widget counter() => CellWidget.builder((context) {
    final count = context.cell(() => MutableCell(0));

    return ElevatedButton(
        child: Text('${count()}'),
        onPressed: count.value++
    );
});
```

The `count` cell is defined directly in the build function of
`CellWidget.builder`, using `context.cell`.

The `cell` method takes a function which defines the cell. This
function is called the first time the widget is built. On subsequent
builds, the cell created during the first build is returned.

This is functionally equivalent to the implementation using
`StatefulWidget`, however much more succinct.

The `cell` method can be used to define multiple cells in a single
build function:

```dart title="Multiple cells defined using context.cell"
CellWidget.builder((context) {
    final count1 = context.cell(() => MutableCell(0));
    final count2 = context.cell(() => MutableCell(0));

    return Column(
        children: [
            ElevatedButton(
                child: Text('${count1()}'),
                onPressed: count1.value++
            ),
            ElevatedButton(
                child: Text('${count2()}'),
                onPressed: count2.value++
            )
        ]
    );
});
```

In the example above, two separate cells are defined in a single
build function using `context.cell`, each representing a different
counter.

:::warning
Calls to `context.cell` should not be placed in:

* Conditionals
* Loops
* Nested widget builder functions such as those used with `Builder`
  and `ValueListenableBuilder`.
:::

:::warning
`context.cell` should only be called on the `BuildContext` of a widget
created using `CellWidget.builder`, or a `CellWidget` subclass that
mixes in `CellInitializer`, more on this in the next section.
:::

You can also define watch functions within `CellWidget.builder` using
`context.watch`. Like `context.cell`, the watch function is only set up
during the first build. Unlike a watch function defined using
`ValueCell.watch`, the watch function is automatically stopped when
the `CellWidget`, in which it is defined, is removed from the tree.

```dart title="Watch function in widget"
Widget counter() => CellWidget.builder((context) {
    final count = context.cell(() => MutableCell(0));

    context.watch(() => print('Count ${count()}'));

    return ElevatedButton(
        child: Text('${count()}'),
        onPressed: count.value++
    );
});
```

## Subclassing CellWidget

If you prefer subclassing you can subclass `CellWidget` and override
its build method, instead of passing a build function to
`CellWidget.builder`.

**NOTE**: To use the `cell` and `watch` methods, the mixin
`CellInitializer` has to be included by the subclass. This mixin
also provides `cell` and `watch` methods directly to the subclass.

The counter example using a `CellWidget` subclass:

```dart title="CellWidget subclass"
class Counter extends CellWidget with CellInitializer {
    @override
    Widget build(BuildContext context) {
        final count = cell(() => MutableCell(0));

        return ElevatedButton(
            child: Text('${count()}'),
            onPressed: count.value++
        );
    }
}
```
