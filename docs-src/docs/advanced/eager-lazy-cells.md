---
title: Eager and Lazy Cells
description: Controlling the evaluation strategy of cells
sidebar_position: 3
---

# Eager and Lazy Cells

Stateful computed cells, created with `ValueCell.computed` are lazy by
default. This means the value of the cell is only computed, if it is
actually referenced. If the value of a computed is never referenced,
it is never computed, even if the computed cell is being observed.

:::note

The value of a lazy computed cell is cached until its argument cells
change, but its not computed until it is referenced for the first
time.

:::

## Eager cells

An eager computed cell always recomputes its value when its argument
cells change. The following cells, for example, are eager:

* Previous value cells (created with `.previous`)
* Asynchronous cells (created with `.wait`, `.waitLast`, `.awaited`)

A computed cell can be made eager by providing a value of `true` to
the `changesOnly` argument of `ValueCell.computed`. This also changes
the behaviour of the cell, such that it only notifies its observers
of changes to its value, only if the value has actually changed.

Example:

```dart
final a = MutableCell(0);

final isEven = ValueCell.computed(() => a().isEven,
    changesOnly: true
);

final watch = ValueCell.watch(() {
    print('${a.peek()}.isEven: ${isEven()}')
});
```

In this example a cell `isEven` is defined which is equal to `true`
when the value of `a` is an even number and equal to `false` when the
value of `a` is an odd number.

:::note

A watch function is defined that prints the value of `isEven` to the
console. The watch function is only called when `isEven` notifies its
observers, since `a` is only observed via `a.peek`.

:::

When `changesOnly` is `true` the following code:

```dart
a.value = 1;
a.value = 2;
a.value = 4;
a.value = 6;
a.value = 8;
a.value = 10;
a.value = 11;
```

results in the following being printed to the console:

```
1.isEven: false
2.isEven: true
11.isEven: false
```

Notice the watch function was not called when the values `4`, `6`, `8`
and `10` were assigned to `a`. This is because the value of `isEven`
did not change with those assignments.

If `changesOnly` is `false`, which is the default if `changesOnly` is
omitted, the following is printed to the console:

```
1.isEven: false
2.isEven: true
4.isEven: true
6.isEven: true
8.isEven: true
10.isEven: true
11.isEven: false
```

Notice that the watch function is now called even if the value of
`isEven` did not change. This is because the value of `a`, which is a
dependency of `isEven` and hence causes the value of `isEven` to be
recomputed. Since `changesOnly` is `false`, `isEven` does not check
whether the newly computed value is equal to the previous value.

:::tip

`changesOnly: true` can be used to ensure that the value of a cell is
always updated even when its value is not referenced. This is useful to
avoid the pitfall with `ValueCell.none` mentioned in [Aborting a
computation](/docs/basics/cell-expressions#aborting-a-computation).

:::

## Store and mutable computed cells

The `changesOnly` argument is accepted by the `.store()`, which
creates a cell that caches the value of another cell. This can be used
to convert any cell to an eager cell, even if you don't have access to
the constructor of the cell.

The `isEven` cell from the previous example can also be defined with
the following:

```dart
final isEven = a.apply((a) => a.isEven)
    .store(changesOnly: true);
```

The `changesOnly` argument is also accepted by
[`MutableCell.computed`](https://pub.dev/documentation/live_cells/latest/live_cells/MutableCell/MutableCell.computed.html)
and
[`.mutableApply`](https://pub.dev/documentation/live_cells/latest/live_cells/ComputeExtension/mutableApply.html). This
also works if a `key` argument is provided to `mutableApply`, which if
you recall, creates a mutable stateless computed cell.

## When to use changesOnly?

`changesOnly: true` should be used either to prevent computation and
watch functions from being called unnecessarily or to convert a
computed cell from its default lazy semantics to eager semantics. This
is particularly useful in conjunction with `ValueCell.none`.

It should be noted that `changesOnly: true` (or an equivalent) is
already used in the following cells thus there is no need to add
`.store(changesOnly: true)` to them:

* Cell extensions for properties of [user defined
  types](http://localhost:3000/docs/basics/user-defined-types)
* Previous value cells
* Extension properties for cells holding lists, maps and sets.
