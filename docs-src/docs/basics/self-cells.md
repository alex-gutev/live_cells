---
title: Self Cells
description: A cell which can access its own value
sidebar_position: 14
---

# Self Cells

A *self cell* is a computed cell that can access its own value within
its value computation function. 

## Defining Self Cells

Self cells are created with the
[SelfCell](https://pub.dev/documentation/live_cells/latest/live_cells/SelfCell-class.html)
constructor, which takes the value computation function just like
`ValueCell.computed`. However, unlike `ValueCell.computed`, the
value computation function is passed a `self` argument. The `self`
argument is a function which when called returns the current value of
the cell.

```dart title="Self Cell Example"
final increment = ActionCell();

final count = SelfCell((self) {
    increment.observe();
    return self() + 1;
}, initialValue: 0);
```

In the example above a self cell `count` is defined which observes an
action cell, `increment`. The value of the `count` cell is one plus
its previous value, and it is updated whenever the `increment` action
cell is triggered.

Note the `initialValue` argument, which takes the initial value to be
returned by `self`, in this case `0`. `initialValue` can be omitted in
which case, the first call to `self` results in
`UninitializedCellError` being thrown.

:::note

If `initialValue` is omitted, the value type of the self cell can no
longer be deduced and thus has to be specified manually,
e.g. `SelfCell<int>(...)`.

:::

```dart

ValueCell.watch(() {
    print('${count()}');
}); // Prints 1

increment.trigger(); // Prints 2
increment.trigger(); // Prints 3

```

:::info

The `self` argument is a function which returns the value, rather than
being the value itself. The reason for this is that the value of the
self cell can be an exception. In this case calling `self` rethrows
the exception.

:::

## Defining Operations on State

Combined with action cell chaining, which we saw in [Action
Cells](action-cells), we can use different logic for updating the self
cell's value, depending on which action cell was triggered:

```dart
final recompute = ActionCell();
final delta = MutableCell(1);

final increment = recompute.chain(() {
    MutableCell.batch(() {
      recompute.trigger();
      delta.value = 1;
    });
});

final decrement = recompute.chain(() {
    MutableCell.batch(() {
      recompute.trigger();
      delta.value = -1;
    });
});

final count = SelfCell((self) {
    recompute.observe();
    return self() + delta();
}, initialValue: 0);
```

In this example the value of the `count` cell is incremented when the
`increment` action cell is triggered, and decremented when the
`decrement` action cell is triggered. 

```dart
ValueCell.watch(() {
    print('${count()}');
}); // Prints 1;

increment.trigger(); // Prints: 2
increment.trigger(); // Prints: 3

decrement.trigger(); // Prints: 2
```

This is achieved by defining `increment` and `decrement` as chained
action cells, which trigger the `recompute` cell and set the value of
`delta` to `1` and `-1`, respectively. It is necessary to trigger the
`recompute` cell, because assigning `1` to `delta` while its value is
already `1` will not cause `count` to be recomputed. The same applies
when assigning `-1` to `delta` while its value is already `-1`.

This allows you to define a set of "operations" on the state of a self
cell. For example, this definition of `count` can be packaged in a
factory function, which exposes the `count`, `increment` and
`decrement` cells:

```dart
(ValueCell<int>, ActionCell, ActionCell) counter() {
    // Definition from previous example
    ...
    return (count, increment, decrement)
};
```

Or you can opt for a more structured approach such as the following:

```dart
@immutable
class Counter {
    final ValueCell<int> count;
    final ActionCell increment;
    final ActionCell decrement;
    
    factory Counter() {
        // Definition from previous example
        ...
        return Counter._internal(
            count: count,
            increment: increment,
            decrement: decrement
        );
    }
    
    const Counter._internal({
        required this.count,
        required this.increment,
        required this.decrement
    });
}
```

This allows users of our newly packaged counter, to observe and modify
the counter's state, but does not allow the users to directly modify
the value of `delta`.

```dart
final counter = Counter();

ValueCell.watch(() {
    print('${counter.count()}');
}); // Prints: 1

counter.increment.trigger(); // Prints 2
counter.decrement.trigger(); // Prints 1
```

:::tip

You can store any value in a `SelfCell`, even instances of your own
classes.

:::

## Pitfalls:

Be aware of the following pitfalls when using self cells:

* Self cells need at least one observer to function correctly,
  otherwise they will not have a state where they can keep track of
  their own value.
* Once a self cell is disposed, when its last observer is removed, the
  value returned by `self` is reset to the value provided in
  `initialValue`.
