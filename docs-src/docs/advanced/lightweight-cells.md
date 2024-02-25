---
title: Lightweight Computed Cells
description: What are lightweight computed cells and how to create them?
sidebar_position: 2
---

# Lightweight Computed Cells

To understand what a lightweight computed cell is, we first have to go
over the difference between **stateful cells** and **stateless
cells**.

## Stateful and Stateless Cells

Till this point, we've mostly been using stateful cells. A stateful
cell maintains a state in memory, which consists of the cell's value
and the set of observers that are observing the cell. `MutableCell`
and `ValueCell.computed(...)` both create stateful cells.

Stateless cells do not maintain a state. This means they do not store
a value, nor do they maintain a set of observers. An example of
stateless cells that we've used frequently throughout this
documentation is the constant cell, e.g. `1.cell`,
`'hello'.cell`. These cells are stateless because they do not actually
store a value but merely return a "hardcoded" constant. 

## Stateless Computed Cells

A lightweight computed cell is a stateless cell that rather than
returning a constant, computes a value as a function of the values of
other cells.

Unlike a stateful cell created with `ValueCell.computed`, a stateless
computed cell does not cache its value. Instead it is computed on
demand whenever the value property is accessed. Stateless computed
cells do not keep track of their own observers. Instead, all observers
added to a stateless computed cell, are added directly to the argument
cells.

Stateless computed cells can be created using the `apply` method
provided by all cells. `apply` takes a compute function, that is
applied on the value of the cell, and returns a new stateless computed
cell. The compute function is called whenever the value of the cell is
accessed.

```dart title="Creating a stateless computed cell with .apply()"
final inc = n.apply((n) => n + 1);
final dec = n.apply((n) => n - 1);
```

This example shows two definitions of stateless computed cells,
derived from cell `n`:

* `inc`, which evaluates to `n + 1`
* `dec`, which evaluates to `n - 1`

A stateless computed cell with multiple argument cells, can be created
using the `apply` method on a record of the argument cells. The
compute function is applied with the value of each argument cell
passed as an argument.

```dart title="Multi-argument stateless computed cells"
final sum = (a, b).apply((a, b) => a + b);
```

In this example a stateless computed cell `sum` is defined, which
evaluates to the sum of cells `a` and `b`.

`apply` also takes an optional key argument, by which the returned
cell is identified:

```dart title="apply() with key argument"
final sum = (a, b).apply((a, b) => a + b,
    key: SumKey(a, b)
);
```

The purpose of the key in stateless computed cells, is to prevent the
same observer from being added to multiple but functionally equivalent
cell objects. _See [Cell Keys](cell-keys) for more information._

If you want to control when the value properties of each argument are
referenced, you can define a lightweight computed cell using the
`ComputeCell` constructor. The constructor takes the `compute`
function, set of argument cells (`arguments`) and an optional `key`:

```dart title="ComputeCell constructor"
final logand = ComputeCell(
    arguments: {a, b},
    compute: () => a.value && b.value
);
```

Notice the argument set has to be specified manually, and the compute
function does not take any arguments. Instead, the values of the
argument cells have to be referenced manually using the `value`
property. Because they are referenced manually, we can control when
each value property is accessed, which is not possible with
`apply(...)`. In this case `b.value` is only referenced if `a.value`
is true, which would not be the case if the cell was defined with `apply`.

:::important

When defining a stateless compute cell, the values of the argument
cells are referenced directly using the `value` property rather than
the function call syntax used with `ValueCell.computed`. The
difference between the two is that `value` simply accesses the value
of the cell, whereas calling the cell registers it as a
dependency. Stateless computed cells don't track dependencies,
therefore there is no need to "call" the cell, and its value can be
accessed directly.

:::

## When to use Stateless Cells?

Stateless computed cells are useful for lightweight computations, such
as basic arithmetic and numeric comparisons, where recomputing the
cell's value every time it is accessed is likely to be faster than
caching it, due to the overhead of maintaining a state. For expensive
computations, it's preferable to cache the value and only recompute it
when necessary. If in doubt, you're
better off sticking to `ValueCell.computed`.
