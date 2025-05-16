---
title: Cells
description: Introduction to the cell -- the basic building block of Live Cells.
sidebar_position: 1
---

# Cells

A cell, denoted by the base type `ValueCell`, is an object with a
value and a set of observers that react to changes in its value.

The simplest cell is the constant cell which holds a constant
value. These are created with the `.cell` property, added to all
objects, or the `ValueCell.value` constructor.

```dart title="Constant cells"
final a = 1.cell;
final b = 'hello world'.cell;
final c = ValueCell.value(someValue);
```

The value of a cell is accessed using the `value` property.

```dart title="Accessing cell values"
print(a.value); // Prints: 1
print(b.value); // Prints: 'hello world'
print(c.value); // Prints the value of `someValue`
```

## Mutable Cells

Mutable cells, created with the `MutableCell` constructor, hold a
value that can be set directly, by assigning a value to the `value`
property.

```dart title="Creating mutable cells"
final a = MutableCell(0);

print(a.value); // Prints: 0

a.value = 3;
print(a.value); // Prints: 3
```

## Observing Cells

When the value of a cell changes, its observers are notified of the
change. The simplest way to demonstrate this is to set up a *watch
function* using [`ValueCell.watch`](https://pub.dev/documentation/live_cells/latest/live_cells/ValueCell/watch.html):

```dart title="Observing cells"
final a = MutableCell(0);
final b = MutableCell(1);

// Set up a watch function observing cells `a` and `b`
final watcher = ValueCell.watch(() {
    print('${a()} + ${b()} = ${a() + b()}');
});

a.value = 5;  // Prints: 5 + 1 = 6
b.value = 10; // Prints: 5 + 10 = 15
```


In the example above, a watch function that prints the values of cells
`a` and `b` to the console, along with their sum, is defined. This
function is called automatically when the value of either `a` or `b`
changes. 

:::important

Within watch functions, the value of a cell is referenced using the
function call operator rather than accessing the value property
directly.

:::

There are a couple of important points to keep in mind when using
`ValueCell.watch`:

* The watch function is called once immediately when `ValueCell.watch`
  is called, to determine which cells are referenced within it.
  
* `ValueCell.watch` automatically tracks which cells are referenced
  within the watch function, and registers it to be called when the
  values of the referenced cells change. This works even when the
  cells are referenced conditionally.

* Within the watch function, the values of cells have to be referenced
  with the function call operator rather than the `value`
  property. The difference between the two is that `.value` only
  references the value, whereas the function call operator also tracks
  the cell as a referenced cell.

Every call to `ValueCell.watch` adds a new watch function, for
example:

```dart title="Multiple watch functions"
final watcher2 = ValueCell.watch(() => print('A = ${a()}'));

// Prints: 20 + 10 = 30
// Also prints: A = 20
a.value = 20;

// Prints: 20 + 1 = 21
b.value = 1;
```

The watch function defined above, `watcher2`, observes the value of
`a` only. Changing the value of `a` results in both watch functions
being called. Changing the value of `b` only results in the first
watch function being called, since the second watch function is not
observing `b`.

:::tip

When you no longer need the watch function to be called, call
[`stop`](https://pub.dev/documentation/live_cells/latest/live_cells/CellWatcher/stop.html)
on the `CellWatcher` object returned by `ValueCell.watch`.

:::

The
[`Watch`](https://pub.dev/documentation/live_cells/latest/live_cells/Watch/Watch.html)
constructor allows you to define a watch function which has access to
its own handle. This allows you to define a watch function that can be
stopped from within the function itself:

```dart
final a = MutableCell(0);

Watch((handle) {
    print('A = ${a()}')
    
    if (a() > 10) {
        handle.stop();
    }
});
```

In this example a watch function is defined that prints the value of
cell `a` to the console. When the value of `a` exceeds 10 the watch
function is stopped, by calling `stop()` on the handle provided to the
watch function.

```dart
a.value = 1;  // Prints: A = 1
a.value = 5;  // Prints: A = 5
a.value = 11; // Prints: A = 11

// The watch function is stopped at this point

a.value = 7; // Doesn't print anything
```

The *handle* also provides an
[`afterInit()`](https://pub.dev/documentation/live_cells/latest/live_cells/CellWatcher/afterInit.html)
method, which exits the watch function when it is called during the
first call to the watch function. This is useful when you don't want
the side effects defined in the watch function to run on the initial
"setup" call.

```dart
Watch((handle) {
    final value = a();
    
    handle.afterInit();
    
    print('A = ${a()}');
});
```

In this example the value of `a` is only printed when it changes
**after** the watch function is defined with `Watch`. It is not
printed when the watch function is called for the first time to
determine its dependencies.

:::important

The watch function must observe at least one cell, using the function
call operator, before the `afterInit()` call. Otherwise, the watch
function will not be observing any cells and will never be called.

:::

## Computed Cells

A *computed cell*, defined using `ValueCell.computed`, is a cell
with a value that is defined as a function of the values of one or
more argument cells. Whenever the value of an argument cell changes,
the value of the computed cell is recomputed.

```dart title="Computed cells"
final a = MutableCell(1);
final b = MutableCell(2);
final sum = ValueCell.computed(() => a() + b());
```

In the above example, `sum` is a computed cell with its value defined
as the sum of cells `a` and `b`. The value of `sum` is recomputed
whenever the value of either `a` or `b` changes. This is demonstrated
below:

```dart title="Computed cells"
final watcher = ValueCell.watch(() {
    print('The sum is ${sum()}');
});

a.value = 3; // Prints: The sum is 5
b.value = 4; // Prints: The sum is 7
```

In this example:

1. A watch function observing the `sum` cell is defined.
2. The value of `a` is set to `3`, which:
   1. Causes the value of `sum` to be recomputed
   2. Calls the watch function defined in 1.
3. The value of `b` is set to `4`, which likewise also results in the
   sum being recomputed and the watch function being called.

By default, computed cells notify their observers whenever their value
is recomputed, which happens when the value of at least one of the
referenced argument cells changes. This means that even if the new
value of the computed cell is equal to its previous value, the
observers of the cell are still notified that the cell's value has
changed.

By providing `changesOnly: true` to `ValueCell.computed`, the computed
cell will not notify its observers if its new value is equal, by `==`,
to its previous value.

This is demonstrated with the following example:

```dart
final a = MutableCell(0);
final b = ValueCell.computed(() => a() % 2, changeOnly: true);

ValueCell.watch(() => print('${b()}'));

a.value = 1;
a.value = 3;
a.value = 5;
a.value = 6;
a.value = 8;
```

This results in the following being printed to the console:

```
0
1
0
```

Notice only three lines are printed to the console even though the
value of the computed cell argument `a` was changed five times.

If `changesOnly: true` is omitted from the definition of `b`, the
following is printed to the console:

```
0
1
1
1
0
0
```

Notice that a new line is printed to the console whenever the value of
`a`, which is an argument of `b`, is changed. This is because `b`
notifies its observers whenever the value of its argument `a` has
changed even when `b`'s new value is equal to its previous value.

:::important

By default computed cells are evaluated lazily. This means the
computation function of a computed cell is not run unless its value is
actually referenced. However, providing `changesOnly: true` to
`ValueCell.computed` makes the cell eager, which means the
computation function is run regardless of whether the cell's value is
referenced or not.

:::

## Lightweight Computed Cells

Another way to create computed cells is with the
[`apply`](https://pub.dev/documentation/live_cells/latest/live_cells/ComputeExtension/apply.html)
extension method on a record containing the arguments of the cell. The
computation function, provided to `apply`, is passed the values of the
argument cells that are listed in the record on which `apply` is
called.

The `sum` cell from the previous example can also be defined as:

```dart
final a = MutableCell(0);
final b = MutableCell(1);

final sum = (a, b).apply((a, b) => a + b);
```

This definition is functionally equivalent to the previous
definition. It computes the same value, which is recomputed whenever
the value of either `a` or `b` changes. However this definition is
different in that:

* The argument cells `a` and `b` are specified explicitly in the
  record on which `apply` is called.
  
* The argument cells are known at compile-time rather than determined
  at run-time. Thus this definition has less run time overhead.
  
* The value of the `sum` cell is not cached. Instead it is recomputed
  whenever the value of the cell is accessed.

:::tip

To create a lightweight computed cell taking a single argument, call
`apply` on the argument cell:

```dart
final b = a.apply((a) => a + 1);
```

:::

This definition is more lightweight than the previous definition of
`sum`, since it doesn't have the overhead of determining the cell
arguments at run time or the overhead of caching the cell
value. However it is less convenient since the argument cells have to
be listed beforehand, whereas with the previous definition, the
arguments cells are determined automatically.

For cells consisting of a simple computation, such as the `sum` cell,
there is no need to cache the value since the overhead of the caching
logic will likely increase the computational time. However, for more
expensive value computation functions it may be beneficial to only run
the computation function once and cache the result until the values of
the argument cells change. The
[`store()`](https://pub.dev/documentation/live_cells/latest/live_cells/StoreCellExtension/store.html)
method of `ValueCell` creates a cell that adds caching to another
cell.

Caching can be added to the `sum` cell as follows:

```dart
final sum = (a, b).apply((a, b) => a + b);
final cached_sum = sum.store();
```

The cell `cached_sum` evaluates to the same value as the `sum` cell
but caches it until the values of the argument cells `a` and `b`
change. The best way to demonstrate the difference is to change the
definition of sum to the following:

```dart
final sum = (a, b).apply((a, b) {
    print('Computing sum');
    return a + b;
});
```

The following watch function:

```dart
ValueCell.watch(() {
    print('a + b = ${sum()}');
    print('The sum is ${sum()}');
});
```

Results in the following being printed to the console:

```
Computing sum
a + b = 1
Computing sum
The sum is 1
```

Notice that the computation function of `sum` is called whenever the
value of the cell is referenced.

The following watch function references the value of `cached_sum`,
which caches the value of `sum` using `.store()`:

```dart
ValueCell.watch(() {
    print('a + b = ${cached_sum()}');
    print('The sum is ${cached_sum()}');
});
```

This results in the following being printed to the console:

```
Computing sum
a + b = 1
The sum is 1
```

Notice that the computation function of `sum` is now called only the
first time the value of `cached_sum` is referenced.

`.store()` also accepts a `changesOnly` argument like
`ValueCell.computed`. When given `changesOnly: true`, the cell
returned by `.store()` only notifies its observers when the new value
of the argument cell is not equal to its previous value.

Example:

```dart
final cached_sum = sum.store(changesOnly: true);
```

## Batch Updates

The `MutableCell.batch` function allows the values of multiple mutable
cells to be set simultaneously. The effect of this is that while the
values of the cells are changed as soon as their `value` properties
are set, the observers of the cells are only notified after all the
cell values have been set.

```dart title="Batch updates"
final a = MutableCell(0);
final b = MutableCell(1);

final watcher = ValueCell.watch(() {
    print('a = ${a()}, b = ${b()}');
});

// This only prints: a = 15, b = 3
MutableCell.batch(() {
    a.value = 15;
    b.value = 3;
});
```

In the example above, the values of `a` and `b` are set to `15` and
`3` respectively, within `MutableCell.batch`. The watch function,
which observes both `a` and `b`, is only called once after the values
of both `a` and `b` are set.

As a result the following is printed to the console:

```
a = 0, b = 1
a = 15, b = 3
```

1. `a = 0, b = 1` is printed when the watch function is first defined.  
2. `a = 15, b = 3` is printed when `MutableCell.batch` returns.

:::info
A watch function is always called once immediately after it is set
up. This is necessary to determine, which cells the watch function is
observing.
:::
