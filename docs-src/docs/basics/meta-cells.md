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

// Called when `m` notifies its observers
ValueCell.watch(() => print(m()));

m.inject(a);

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

:::caution

A meta cell has to be observed before `.inject` can be called. If
`.inject` is called before the cell is observed
`InactiveMetaCelLError` is thrown. You will have noticed the cell
watch function is defined before `.inject` is called.

:::


Meta cells allow for a rudimentary form of *dependency
inversion*. They are useful when you need to observe a cell without
controlling how the cell is created.

You may have noticed that an unhandled `EmptyMetaCellError` exception
notice is being printed to the console. This is because the watch
function is called initially when it is defined. At that point the
meta cell does not point to any cell when its value is accessed, which
results in the `EmptyMetaCellError` exception being thrown.

You can silence these notices with the `.whenReady`:

```dart
final m = MetaCell<int>();

// Called when `m` notifies its observers
ValueCell.watch(() => print(m.whenReady()));
```

When `.whenReady` is used within a watch function it aborts the watch
function, if the meta cell does not point to any cell, without
printing a notice to the console.

## Mutable and Action Meta Cells

`MutableMetaCell` and `ActionMetaCell` are variants of `MetaCell`s
which allow you to set the value of a mutable cell and trigger an
action cell, respectively, from a `MetaCell`. A `MutableMetaCell` and
`ActionMetaCell` can be created with `MetaCell.mutable` and
`MetaCell.action` respectively.

```dart title="Mutable/Action meta cells"
final m = MetaCell.mutable<int>();
final a = MetaCell.action();

...

// Set the value of the MutableCell pointed to by `m`
m.value = 2;

// Trigger the ActionCell pointed to by `a`
a.trigger();
```

## Differences from Mutable Cells

Meta cells are different from mutable cells, in that a meta cell does
not actually implement the functionality of a cell but delegates its
implementation to the cell it points to, whereas a mutable cell is an
actual implementation of a cell that can have its value set.
