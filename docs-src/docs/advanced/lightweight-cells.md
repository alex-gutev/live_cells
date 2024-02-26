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
[`ComputeCell`](https://pub.dev/documentation/live_cells/latest/live_cells/ComputeCell/ComputeCell.html)
constructor. The constructor takes the `compute` function, set of
argument cells (`arguments`) and an optional `key`:

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

## Stateless to Stateful

Occasionally you may want to convert a stateless (lightweight)
computed cell to a stateful cell that caches its value on only
recomputes it when the values of the arguments have changed. You can
do that with the `.store()` method.

The `.store()` method creates a cell that evaluates to the same value
as the cell, on which the method is called, but caches its value so
that it is only recomputed when the arguments have changed.

:::tip

`.store()` returns a keyed cell that is unique for the cell on which
the method is called.

:::

Consider the following definition of `sum` using a stateless computed
cell:

```dart
final a = MutableCell(0);
final b = MutableCell(1);

final sum = (a, b).apply((a, b) {
    print('Computing sum');
    return a + b;
});

final sumStore = sum.store();
```

`sumStore` is the `sum` cell converted to a stateful cell, using
`.store()`.

When the following is evaluated:

```dart
ValuCell(() {
    print('sum1: ${sum()}');
    print('sum2: ${sum()}');
});

a.value = 1;
```

The value computation function for `sum` is called twice, when its
value is referenced twice in the watch function. As a result
"Computing sum" is printed to the console twice.

However when the following is evaluated:

```dart
ValuCell(() {
    print('sum1: ${sumStore()}');
    print('sum2: ${sumStore()}');
});

a.value = 1;
```

The value computation function for `sum` is only called once, and
hence "Computing sum" is only printed to the console once.

:::warning[Important]

`.store()` only has an affect when the value of the cell is referenced
through the cell returned by `.store()`. Referencing the value of the
original cell will still result in its value being recomputed.

:::

`.store()` also takes an optional `changesOnly` argument. When
`changsOnly` is true, the returned cell only notifies its observers
when the new value of the cell is not equal (by `==`) to its previous
value. This is useful to prevent potentially expensive recomputations
(and side effects such as rebuilding a widget hierarchy) when the
actual value of the cell hasn't changed.

This can be demonstrated with the following example:

```dart
final a = MutableCell(2);

final c1 = a.apply((a) => a % 2).store();
final c2 = a.apply((a) => a % 2)
    .store(changesOnly: true);
    
ValueCell.watch(() => print('C1: ${c1()}');
ValueCell.watch(() => print('C2: ${c2()}');
```

When the following is evaluated:

```dart
a.value = 4;
a.value = 6;
```

The following is printed to the console:

```
C1: 0
C1: 0
```

Notice the second watch function, which observers `c2` which is
defined using `.store(changesOnly: true)` is not called. This is
because the computed value of the cell has not changed, even though
the value of its argument cell has.

When evaluating the following:

```dart
a.value = 7;
```

The following is printed:

```
C1: 1
C2: 1
```

Now both watch functions are called, because the computed value has
changed from `0` to `1`.

:::caution

Only one value can be provided for `changesOnly` for a given cell. For
example:

```dart
final store1 = a.store(changesOnly: true);
final store2 = a.store();
```

will only result in one of the values for changesOnly (`true` or
`false` which is the default) taking effect for both `store1` and
`store2`. Treat `changesOnly` as a performance optimization but don't
depend on the difference between `changesOnly: true` and `changesOnly:
false` for correctness.

:::

:::info

`changesOnly: true` changes the evaluation semantics of the cell on
which it is applied from lazy to eager. This will be explained in more
detail in the next section of the documentation.

:::

## Stateless Mutable Computed Cells

A stateless variant of a mutable computed cell can be defined using
`.mutableApply()`. Like `apply` this function can either be applied on
the cell, or a record of cells, and takes the value computation
function as an argument. `.mutableApply()` also takes a second
argument which is the reverse computation function, as in
`MutableCell.computed()`.

It is important to note that by default `mutableApply` does not create
a stateless cell, but a stateful mutable computed cell with a static
argument cell set. In order for a stateless cell to be created, a
non-null value for the `key` argument has to be given.

Example:

```dart
final a = MutableCell<num>(0);
final b = MutableCell<num>(1);

final sum = (a, b).mutableApply((a, b) => a + b, (sum) {
    final half = sum / 2;
    
    a.value = b.value = half;
}, key: MyKey(a, b));
```

In this example the `sum` cell from [Fun with Mutable Computed
Cells](/docs/basics/two-way-data-flow#fun-with-mutable-computed-cells)
has been implemented using a stateless mutable computed cell. The
behaviour of the cell is equivalent to the previous definition. It's
computed value is the sum of cells `a` and `b`, while setting its
value results in its value divided by 2 being assigned to both `a` and
`b` However, with this definition the `sum` cell is entirely
stateless. It doesn't keep track of its value, neither its computed
value nor that assigned to it. It's value is recomputed whenever
`sum.value` is accessed. The cell also does not keep track of which
cells are observing it. Adding an observer to `sum` results in the
observer being added directly to cells `a` and `b`.

A stateless mutable computed cell can also be defined with the
[`MutableCellView`](https://pub.dev/documentation/live_cells/latest/live_cells/MutableCellView/MutableCellView.html)
constructor. The constructor takes the set of argument cells, the
compute value function and the reverse computed functions as
arguments, with an optional `key` argument. Like `ComputeCell` the
compute value function is not called with any arguments, which allows
you to control when the values of the argument cells are referenced,
using `.value`.

The above definition using the `MutableCellView` constructor.

```dart
final sum = MutableCellView(
    arguments: {a, b}
    compute: () => a.value + b.value,
    reverse: (sum) {
        final half = sum / 2;
    
        a.value = b.value = half;
    },
    
    key: MyKey(a, b)
);
```

Stateless mutable computed cells differ in their semantics from their
stateful counterparts. Stateful mutable computed cells keep track of
the value assigned to them whereas the stateless variants do not. This
becomes apparent if the values assigned to the argument cells do not
result in the same value being computed as the value that was assigned
to the mutable computed cell.

For example consider the following cell:

```dart
final sum = MutableCell.computed(() => a() + b(), (sum) {
    a.value = sum;
    b.value = sum
});
```

The values assigned to the argument cells, in the reverse computation
function, will not result in the same value being computed as the
value that was assigned to sum. However the `sum` cell will remember
what value it was assigned:


```dart
sum.value = 10;

print(sum.value);         // 10
print(a.value + b.value); // 20
```

A stateless mutable computed cell on the other hand will not remember
what value it was assigned. Instead it will recompute its value which
is now different from the value it was assigned:


```dart
final sum = (a, b).mutableApply((a, b) => a + b, (sum) {
    a.value = sum;
    b.value = sum
});
```

```dart
sum.value = 10;

print(sum.value);         // 20
print(a.value + b.value); // 20
```

Therefore it's important to ensure that the values assigned to the
argument cells are such that when the value computation function is
run, an equivalent value will be produced as the value that was
assigned. If this condition cannot be met, then you should use a
normal stateful mutable computed cell.


## When to use Stateless Cells?

Stateless computed cells are useful for lightweight computations, such
as basic arithmetic and numeric comparisons, where recomputing the
cell's value every time it is accessed is likely to be faster than
caching it, due to the overhead of maintaining a state. For expensive
computations, it's preferable to cache the value and only recompute it
when necessary. If in doubt, you're better off sticking to
`ValueCell.computed` and `MutableCell.computed`.
