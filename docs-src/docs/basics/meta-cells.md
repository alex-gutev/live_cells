---
title: Meta Cells
description: Dependency inversion using meta cells
sidebar_position: 12
---

# Meta Cells

A *meta cell* is a cell that points to another cell. Accessing the
`value` of a meta cell, accesses the value of the cell it
points to. Similarly, observers of the meta cell are notified when the
value of the cell it points to changes.

Meta cells are created with the `MetaCell` constructor, and initially
do not point to any cell.

```dart title="Creating a meta cell"
final m = MetaCell<int>();
```

:::note

`MetaCell` is a generic class with a single type parameter, which is
the cell value type, `int` in the example above. This has to be
specified manually when creating the `MetaCell`, since the constructor
does not take any arguments, from which it can be deduced.

:::

Observers can be added and removed before the meta cell is pointing to
another cell, but accessing its value will result in an
[`EmptyMetaCellError`](https://pub.dev/documentation/live_cells/latest/live_cells/EmptyMetaCellError-class.html)
exception being thrown.

```dart
// This is OK
m.addObserver(...)

// This will throw EmptyMetaCellError
print(m.value)
```

The cell to which a meta cell points to is set with the
[`inject`](https://pub.dev/documentation/live_cells/latest/live_cells/MetaCell/inject.html)
method, which takes the cell as an argument. Once a cell has been
*injected* in a meta cell, accessing the meta cell's value returns the
value of the injected cell.

The `inject` method can be called multiple times. If the meta cell,
already points to a cell when `inject` is called, the meta cell now
points to the new cell. The value of the meta cell is the value of the
newly *injected cell*, and similarly the observers of the meta cell
are notified whenever the observers of the injected cell are notified.

```dart .inject() method
final a = MutableCell(0);
final b = MutableCell(1);

final m = MetaCell<int>();

m.inject(a);

// Called when `m` notifies its observers
ValueCell.watch(() => print(m.value));

a.value = 2; // Prints 2
a.value = 3; // Prints 3

m.inject(b);

// Doesn't print anything since `m` no
// longer points to `a`
a.value = 4;

// Prints 15
b.value = 15;
```

:::important

A meta cell **does not** notify its observers when the cell it points
to is changed with `.inject`.

:::

Meta cells allow for a rudimentary form of *dependency
inversion*. They are useful when you need to observe a cell without
controlling how the cell is created.

## Differences from Mutable Cells

Meta cells are different from mutable cells, in that a meta cell does
not actually implement the functionality of a cell but delegates its
implementation to the cell it points to, whereas a mutable cell is an
actual implementation of a cell that can have its value set. Meta
cells do not allow their value to be set, but only allow changing the
cell to which the meta cell points to.

:::note

In the current version of Live Cells, setting the value of a cell via
a meta cell is not supported.

:::
