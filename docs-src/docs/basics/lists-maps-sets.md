---
title: Lists, Maps and Sets
description: Working with cells holding lists, maps and sets
sidebar_position: 9
---

# Lists, Maps and Sets

Live Cells provides extensions for cells holding `List`s, `Map`s and
`Set`s, which allow the properties of the `List`, `Map` and `Set`
interfaces to be accessed directly on cells.

## Indexing

For example the `[]` operator is overloaded for cells holding `Lists`,
which allows a list element to be retrieved.

```dart title="List cell operator[] example"
final list = MutableCell([1, 2, 3, 4]);
final index = MutableCell(0);

/// A cell which accesses the element at `index`
final element = list[index];
```

The `element` cell retrieves the value of the element at `index`
within `list`. You'll notice that the definition of the `element` cell
looks exactly like retrieving the value of an element from an ordinary
`List`. However, unlike an ordinarily `List` element access, `element`
is a cell and its value will be recomputed whenever the `list` and
`index`, which is also a cell, change:

```dart title="Reactive list element access"
print(element.value); // 1

element.value = 2;
print(element.value); // 3

list.value = [3, 9, 27];
print(element.value); // 27
```

The `element` cell is also a mutable cell which when set, updates the
value of the `list` element at `index`.

```dart title="Modifying list through an element access cell"
final list = MutableCell([1, 2, 3, 4]);
final index = MutableCell(0);

final element = list[index];

index.value = 1;
element.value = 100;

print(list); // 1, 100, 3, 4
```

:::note
The underlying `List` is not modified but a new `List` is created and
assigned to the `list` cell.
:::

You can also update the `list` element directly using `[]=`:

```dart
list[1] = 100;
```

:::note
Unlike the `[]` operator, the index provided to the `[]=` is a value
not a cell.
:::


