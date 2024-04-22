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

Luckily you can define cells directly in the build function of a
`CellWidget.builder`. `CellWidget` keeps track of the cells that were
defined in the build function and persists their state between builds
of the widget, so you don't have to use a `StatefulWidget`. This is
very convenient for cells which manage state that is local to a
widget.

Using `CellWidget.builder`, the counter can be implemented as follows:

```dart title="Defining cells directly in CellWidget.builder"
CellWidget.builder((context) {
    final count = MutableCell(0);

    return ElevatedButton(
        child: Text('${count()}'),
        onPressed: () => count.value++
    );
});
```

The `count` cell is defined directly in the build function provided to
`CellWidget.builder`. This is functionally equivalent to the
implementation using `StatefulWidget`, however much more succinct.

More than one cell can be defined in the build function:

```dart title="Multiple cells defined in CellWidget.builder"
CellWidget.builder((context) {
    final count1 = MutableCell(0);
    final count2 = MutableCell(0);

    return Column(
        children: [
            ElevatedButton(
                child: Text('${count1()}'),
                onPressed: () => count1.value++
            ),
            ElevatedButton(
                child: Text('${count2()}'),
                onPressed: () => count2.value++
            )
        ]
    );
});
```

In the example above, two separate cells are defined in a single build
function, each representing a different counter.

:::warning 

When defining cells directly within `CellWidget.builder`,
the definitions should not be placed in:

* Conditionals
* Loops
* Callback and builder functions of widgets nested within the `CellWidget`.

:::

:::tip[Examples of good definitions]

The following cell definitions within `CellWidget.builder` are good:

```dart
CellWidget.builder((_) {
    final a = MutableCell(0);
    final b = MutableCell(1);
    ...
});
```

:::

:::danger[Examples of badly placed definitions]

The following are examples of badly placed cell definitions in
`CellWidget.builder`. Don't do the following:

```dart
CellWidget.builder((_) {
    if (...) {
        // Bad because the definition appears
        // within a conditional
        final a = MutableCell(0);
    }
    
    while (...) {
        // Bad because the definition appears
        // within a loop
        final b = MutableCell(1);
    }
    
    return Builder((_) {
        // Bad because the definition is no longer in
        // the build function provided to CellWidget.builder,
        // but in a nested widget builder function.
        final c = MutableCell(2);
        ...
    });
});
```

If you end up doing something similar to the above, `CellWidget` will
not be able to persist the state of the defined cells between builds.

:::

## Watching cells in widgets

Like cells, watch functions can be defined, using `ValueCell.watch`
directly in the build function of a `CellWidget`. The watch function
is registered on the first build of the widget, and is automatically
stopped when the widget is unmounted.

:::note

The `watch` function is called once when it is registered during the
first build of the widget. Rebuilding the widget does not cause the
watch function to be called again.

:::

:::caution

The same rules apply to the placement of watch function definitions,
that apply to the placement of cell definitions within
`CellWidget.builder`.

:::


```dart title="Watch function in widget"
CellWidget.builder((context) {
    final count = MutableCell(0);

    ValueCell.watch(() => print('Count ${count()}'));

    return ElevatedButton(
        child: Text('${count()}'),
        onPressed: () => count.value++
    );
});
```

## Subclassing CellWidget

We'll be using `CellWidget.builder` throughout the documentation,
since its succinct and convenient. However, if you want to make a
widget which will be used in more than one place, you should subclass
`CellWidget` instead.

A `CellWidget` subclass can observe and define cells, and watch
functions, in the `build` method, just like `CellWidget.builder`:

The counter example using a `CellWidget` subclass:

```dart title="CellWidget subclass"
class Counter extends CellWidget {
    @override
    Widget build(BuildContext context) {
        final count = MutableCell(0);

        ValueCell.watch(() => print('Count: ${count()}'));

        return ElevatedButton(
            child: Text('${count()}'),
            onPressed: () => count.value++
        );
    }
}
```

:::note

The magic that allows you to define cells directly within
`CellWidget.builder` works by assigning a numerically indexed key to
each cell that is defined within the build function/method. That's why
you should avoid placing definitions within loops and
conditionals. Cell keys will be covered in the advanced section of the
documentation but if you're curious you can skip ahead to [Cell
Keys](/docs/advanced/cell-keys).

:::
