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
`Set`, etc., held in a cell, using:


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
likewise change whenever the value of `list` changes. So what's the
point? Unlike `list`, `cellList` only reacts to changes in the
`length` of the list, i.e. when the number of elements in the list
change, and not the values of the elements themselves.

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

This is particularly useful for constructing a `Column` or `Row`
widget using a list of child widgets held in a cell:

```dart
ValueCell<List<Widget>> children;

CellWidget.builder((_) => Column(
  children: children.cellList()
      .map((c) => c.widget())
      .toList()
);
```

:::info
The `ValueCell.widget()`, available on cells holding `Widget`s,
returns the `Widget` held in the cell. Unlike retrieving the `Widget`
directly with `.value`, the returned widget is rebuilt whenever the
value of the cell changes.
:::

Here's what's going on in the example above:

1. `children` is a cell holding the list of child `Widgets`
2. `cellList` is used to retrieve a cell that is only recomputed when
   the `length` of `children`.
3. As a result the `CellWidget`, holding the `Column`, is only
   rebuilt, when the size of `children` changes.
4. The list (`Iterable`) of cells held in `cellList` is converted to a
   list of `Widgets` by applying the `widget()` method on each cell in the
   list.

As a result modifying an element of the `children` list, will only
result in that child widget of the `Column` being rebuilt and not the
entire widget hierarchy rooted at the `Column`. 

You wont need `cellList` for this as Live Cells already provides a
`CellColumn` and a `CellRow`, which is implemented exactly as
described above, but its still useful to be aware of this pattern so
you can potentially apply it in other parts of your app which deal
with lists.

This makes surgical updates to a complex widget hierarchy simple and
intuitive. For example consider the following widget definition, using
`CellColumn`:

```dart title="CellColumn example"
final children = MutableCell(<Widget>[
    Text('Child 1'),
    Text('Child 2'),
    Text('Child 3')
]);

return CellColumn(
    children: children
);
```

Changing the second child widget is as simple as:

```dart
children[1] = Text('Updated Child 2');
```

With this only the second child widget of the `Column` is rebuilt.

If we have a common layout for the child widgets, we can do even
better. In the example above every widget is a `Text` widget
displaying a string. Instead of a list of `Widgets`, we could
represent our data as a list of `Strings`, and the map that list to a
list of `Widgets`.

Let's start off with our data:

```dart
final data = MutableCell([
    'Child 1',
    'Child 2',
    'Child 3'
]);
```

To map that data to a list of Widgets, we could do something like the
following:

```dart
final children = ValueCell.computed(() => data()
    .map((s) => Text(s))
    .toList()
)
```

However that will result in the entire `children` list being
recomputed, whenever a single element of `data` changes. We can avoid
that by mapping the `cellList` instead:

```dart
final children = ValueCell.computed(() => data.cellList()
    .map((c) => CellText(data: c))
    .toList()
)
```

The `cellList` is mapped to a list of `CellText` widgets, with each
cell in the list to the `data` property of the `CellText`.

With this definition for `children` we can now update a child widget
using the following:

```dart
children[1] = 'Updated Child 2';
```

What we've gained with this definition is that the presentation logic
is not only effectively separated from the data but is only specified
in one place.

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

Much like the with cells holding `List` values, these properties and
methods return cells which apply the property getter/method on the
`List` held in the cell.

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

Given that a `Set` is an `Iterable`, all the properties provided by
cells holding `Iterables` are also provided by cells holding `Sets`.
