---
title: Cell Expressions
description: Creating cells using expressions
sidebar_position: 3
---

# Cell Expressions

This library provides a number of tools for building expressions of
cells without requiring a computed cell to be created explicitly using
`ValueCell.computed`.

## Arithmetic

The arithmetic and relational (`<`, `<=`, `>`, `>=`) operators, when
applied to cells holding numeric values, return cells which compute the
result of the expression.

This allows a computed cell to be defined directly as an expression of
cells. For example the following cell computes the sum of two cells:

```dart title="Arithmetic Expressions"
final a = MutableCell(1);
final b = MutableCell(2);

final sum = a + b;
```

:::info 

This definition of the sum cell is not only simpler than the
definition using `ValueCell.computed` but is also more efficient since
the argument cells are determined at compile-time. In-fact it is
equivalent to the definition seen in [Lightweight Computed
Cells](./cells#lightweight-computed-cells):

```dart
final sum = (a, b).apply((a, b) => a + b);
```

:::

The `sum` cell is a cell like any other, and can be observed by a
watch function, observed by a widget (using `CellWidget`) and can
appear as an argument in a computed cell.

```dart title="Observing expression cells"
final watcher = ValueCell.watch(() => print('${sum()}'));

a.value = 5; // Prints: 7
b.value = 4; // Prints: 9
```

Expressions of cells can be arbitrarily complex:

```dart title="Complex Cell Expressions"
final x = a * b + c / d;
final y = x < e;
```

:::tip
To include a constant in a cell expression, use the `.cell` property
on the constant if available or wrap it in a cell using
`ValueCell.value`.
:::

## Equality

Every cell provides the `eq` and `neq` methods which compare whether the cell
is equal or not equal to another cell, respectively. Like the arithmetic operators, these
methods return cells which perform the comparison.

```dart title="Equality Comparison"
final eq = a.eq(b);   // eq() == true when a() == b()
final neq = a.neq(b); // neq() == true when a() != b()
```

## Logic and selection

Cells holding `bool` values are extended with the following methods:

<dl>
<dt>`and`</dt>
<dd>Creates a cell with a value that is the *logical and* of two cells</dd>
<dt>`or`</dt>
<dd>Creates a cell with a value that is the *logical or* of two cells</dd>
<dt>`not`</dt>
<dd>Creates a cell with a value which is the *logical not* of a cell</dd>
<dt>`select`</dt>
<dd>Creates a cell which selects between the values of two cells based on a condition</dd>
</dl>

```dart title="Logic and selection expressions"
final a = MutableCell(true);
final b = MutableCell(true);

final c = MutableCell(1);
final d = MutableCell(2);

final cond = a.or(b);           // cond() is true when a() || b() is true
final cell = cond.select(c, d); // when cond() is true, cell() == c() else cell() == d()

ValueCell.watch(() => print('${cell()}'));

a.value = true;  // Prints: 1
a.value = false; // Prints: 2
```

The second argument of `select` can be omitted, in which case the
cell's value will not be updated if the condition is false:

```dart title="Single argument select"
final cond = MutableCell(false);
final a = MutableCell(1);

final cell = cond.select(a);

ValueCell.watch(() => print('${cell()}'));

cond.value = true;  // Prints: 1
a.value = 2;        // Prints: 2

cond.value = false; // Prints: 2
a.value = 4;        // Prints: 2
```

## Aborting a computation

The computation of a computed cell's value can be aborted using
`ValueCell.none()`. When `ValueCell.none` is called inside a computed
cell, the value computation function is exited and the cell's current
value is preserved. This can be used to prevent a cell's value from
being recomputed when a condition is not met:

```dart title="Example of ValueCell.none()"
final a = MutableCell(4);
final b = ValueCell.computed(() => a() < 10 ? a() : ValueCell.none());

ValueCell.watch(() => print(b()));

a.value = 6;  // Prints 6
a.value = 15; // Prints 6
a.value = 8;  // Prints 8
```

If `ValueCell.none()` is called during the computation of the cell's
first value, the cell's value is assigned to `null` by default. If a
different default value is desired, `ValueCell.none` takes an optional
argument which is the default value to assign to the cell in this
case. For example `ValueCell.none(3)` will assign the value `3` by
default.

:::caution
The value of a computed cell is only computed if it is actually
referenced. `ValueCell.none` only preserves the current value of the
cell, but this might not be the latest value of the cell if the cell's
value is only referenced conditionally. A good rule of thumb is to use
`ValueCell.none` only for preventing a cell from holding an invalid
value.
:::

## Exception Handling

If an exception is thrown during the computation of a cell's value, it
is rethrown when the cell's value is referenced. This allows
exceptions to be handled using `try` and `catch` inside computed
cells:

```dart title="Exception handling in computed cells"
final str = MutableCell('0');
final n = ValueCell.computed(() => int.parse(str()));

final isValid = ValueCell.computed(() {
  try {
    return n() > 0;
  }
  catch (e) {
    return false;
  }
});

print(isValid.value); // Prints false

str.value = '5';
print(isValid.value); // Prints true

str.value = 'not a number';
print(isValid.value); // Prints false
```

This library provides two utility methods, `onError` and `error`, for
handling exceptions thrown in computed cells.

The `onError` method creates a cell that selects the value of another
cell when an exception is thrown. The `error` method creates a cell
which holds the exception thrown or `null` if no exception is thrown.

```dart title="Example of onError"
final str = MutableCell('0');
final m = MutableCell(2);
final n = ValueCell.computed(() => int.parse(str()));

final result = n.onError(m); // Equal to n(). If n() throws, equal to m();

str.value = '3';
print(result.value); // Prints 3

str.value = 'not a number';
print(result.value); // Prints 2
```

`onError` is a generic method with a type argument which when given, only exceptions of the given
type are handled.

```dart title="Handling specific exceptions with onError"
final result = n.onError<FormatException>(m); // Only handles FormatException
```

The above validation logic can be implemented more succinctly using:

```dart title="Putting it all together"
final str = MutableCell('0');
final n = ValueCell.computed(() => int.parse(str()));
final isValid = (n > 0.cell).onError(false.cell);
```

:::note
We used `0.cell` and `false.cell` to create constant cells that hold
the values `0` and `false`, respectively.
:::

## Previous Values

The `previous` property can be used to retrieve the previous values of cells:

```dart title="Retrieving previous cell values"
final a = MutableCell(1);
final prev = a.previous;

final sum = ValueCell.computed(() => a() + prev());

ValueCell.watch(() {
    final prev_value = prev();
    
    print('\nA = ${a()}');
    print('Prev = ${prev_value()}');
    print('Sum = ${sum()}');
});

a.value = 2;
a.value = 5;
```

This results in the following being printed to the console:

```
A = 2
Prev = 1
Sum = 3
 
A = 5
Prev = 2
Sum = 7
```

:::info
The `previous` property returns a cell, which can be used like any
other cell. This is also a keyed cell. Keyed cells share a common
state identified by a key. This allows you to call the `previous`
property multiple times and even though a new cell instance is
returned every time it is called, every instance created by `previous`
on the same cell, shares the same state.
:::

:::caution
* On creation `prev` does not hold a value. Accessing it will throw an `UninitializedCellError`.
* For `prev` to actually keep track of the previous value of `a`, `prev` must be observed, either
  by another cell, a `CellWidget` or a *watch function*.
:::

## Peeking Cells

What if you want to use the value of a cell in a computed cell but
don't want changes to that cell's value triggering a
recomputation. The peek property allows you to do exactly that.

```dart title="Example of .peek"
final a = MutableCell(0);
final b = MutableCell(1);

final c = ValueCell.computed(() => a() + b.peek());

final watch = ValueCell.watch(() => print('${c()}'));

a.value = 3; // Prints: 4
b.value = 5; // Doesn't print anything
a.value = 7; // Prints: 13
```

In the example above, cell `c` is a computed cell that references the value
of `a` and *peeks* the value of `b`. Changing the value of `a`
triggers a recomputation of `c`, and hence triggers the watch function
which prints to the console. However, changing the value of `b` doesn't
trigger a recomputation of `c`, and hence the watch function is not called.

:::note
`peek` returns a cell.
:::

You may be asking why do we need `peek` here instead of just accessing
the value of `b` directly `b.value`. Something we've glossed over till
this point is the lifecycle of cells. Cells are only active while they
are actually observed, and are activated when the first observer is
added. While active, cells react to changes in their argument
cells. When the last observer is removed, cells are deactivated and
stop observing their argument cells. When a new observer is added,
they are reactivated again. Essentially, this means that the value of
a cell may no longer be current if it doesn't have at least one
observer. For a computed cell this is not a problem, since when it is
inactive it computes its value on demand, but it may cause issues with
other cells, such as `previous` cells. The `peek` property takes
care of adding an observer to the peeked cell, so that it remains
active, but at the same time prevents the observers, added through
`peek`, from being notified of the changes in its value.
