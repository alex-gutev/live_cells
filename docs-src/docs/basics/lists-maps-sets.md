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

The `[]` operator is overloaded for cells holding `Lists`, which
allows a list element to be retrieved.

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

You can also update the `list` element directly using the `[]=`
operator:

```dart
list[1] = 100;
```

:::note
Unlike the `[]` operator, the index provided to the `[]=` operator is
a value not a cell.
:::

## Iterable Properties

Cells holding `Iterable` values provide the following properties and
methods:

* `first`
* `last`
* `isEmpty`
* `isNotEmpty`
* `length`
* `single`
* `toList()`
* `toSet()`

Each property/method returns a cell which applies the property
getter/method on the `Iterable` held in the cell. This allows you, for
example, to retrieve the first value in an `Iterable`, be it a `List`,
`Set`, etc., that is held in a cell, using:


```dart
ValueCell<Iterable> seq;
...
final first = seq.first
```

This is roughly equivalent to:

```dart
final first = ValueCell.computed(() => seq().first);
```

## cellList Property

The `cellList` property, of cells holding `Lists`, returns a cell
which evaluates to an `Iterable` of cells, with each cell accessing
the value of an element in the original `List`:


For example, consider the following cell:

```dart
// A list with four elements
final list = MutableCell([1, 2, 3, 4]);
```

`list.cellList` returns a cell which holds the following list of cells:

```dart
final cellList = list.cellList;

// cellList.value is equivalent to the following:
[list[0], list[1], list[2], list[3]]
```

`cellList` is reactive, like any other cell, and its value will
likewise change whenever the value of `list` changes. However,
`cellList` only reacts to changes in the `length` of the `list`,
i.e. when the number of elements in the list change, and not the
values of the elements themselves.

You can test this out using `ValueCell.watch`:

```dart
ValueCell.watch(() {
    print('${cellList().length} elements');
});
```

The following will not cause `cellList` to be recomputed:

```dart
// Doesn't print anything since the 
// number of elements hasn't changed
list.value = [5, 6, 7, 8];

list[0] = 100;
list[2] = -1;
```

However the following will cause `cellList` to be recomputed:

```dart
// Prints: 3 elements
list.value = [1, 2, 3]

// Prints: 0 elements
list.value = [];

// Prints: 7 elements
list.value = [1, 2, 3, 4, 5, 6, 7];
```

## Map and Set Properties

The following properties and methods are provided by cells holding
`Map` values:

* `entries`
* `keys`
* `values`
* `isEmpty`
* `isNotEmpty`
* `length`
* `containsKey()`
* `containsValue()`

Like with cells holding `List` values, these properties and methods
return cells which apply the property getter/method on the `List` held
in the cell.

The indexing operator `[]` is also provided, which takes a cell for the key:

```dart
final map = MutableCell({
    'k1': 1,
    'k2': 2,
    'k3': 3
});

final key = MutableCell('k1');
final element = map[key];

print(element.value); // 1

element.value = 100;
print(map.value['k1']); // 100

key.value = 'k3';
print(element.value); // 3

key.value = 'not in map';
print(element.value); // null
```

Setting the value of a cell created by `[]`, updates the value of the
entry in the `Map` cell. Like with cells holding `List`s, the actual
`Map` instance is not modified, but a new `Map`, with the updated
entry, is created and assigned to the `Map` cell.

The following methods are provided by cells holding `Set` values:

* `contains`
* `containsAll`

Both `contains` and `containsAll` return mutable cells, if the `Set`
cell on which they are called is mutable. This allows elements to be
added and removed from the set with the following:

```dart
final set = MutableCell({1, 2, 3});
final item = MutableCell(4);

final contains = set.contains(item);

// Add `4` to the set
contains.value = true;

// Remove `4` from the set
contains.value = false;
```

Given that a `Set` is an `Iterable`, all the properties provided by
cells holding `Iterables` are also provided by cells holding `Sets`.
