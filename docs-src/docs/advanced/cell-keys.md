---
title: Cell Keys
description: What cell keys are and what they are used for.
sidebar_position: 1
---

# Cell Keys

We stated a couple of times in the documentation that a certain
property returns a keyed cell. Now we'll explain what that actually
means.

## Keyed cells

A keyed cell is a cell with a key that identifies the cell. If two
distinct `ValueCell` instances have the same key, under `==`, then the
two cells compare `==`. In-effect, this allows them to function as
though they are the same cell despite being two separate objects.

Great, so how's that useful? Consider the following code which creates
a `CellWidget` that observes a cell `a`:

```dart
CellWidget.builder((_) {
    final a = ...;
    
    return Text(a());
});
```

`a` is created in the widget build function, and observed by the
`CellWidget`. When the `CellWidget` is rebuilt, the build function is
called again, a new `a` is created and the `CellWidget` is now
observing the new `a` alongside the previous `a`. With every rebuild
of the `CellWidget`, a new `a` is being observed. Besides leaking
memory, the state of `a` is lost and reset on every build.

Cell keys were created to avoid this problem. If the `CellWidget` is
rebuilt and a new `a` is created, BUT with the same key as the
previous `a`, the `CellWidget` sees it as the same cell and continues
observing the previous `a`. More importantly, the new `a` shares the
same state (and hence the same value) as the previous `a`. In-effect
is the same cell, just referenced by a different object.

Previously, we said cells should be created in a `CellWidget` with
`context.cell`. So why the need for keys? Keys, are especially useful
for extension properties which return cells. They allow you to write
the following:

```dart
CellWidget.builder((c) => {
    final l = c.cell(() => MutableCell([1, 2, 3]));
    final a = l.first;
    
    return Text('${a()}');
});
```

instead of:

```dart
CellWidget.builder((c) => {
    final l = c.cell(() => MutableCell([1, 2, 3]));
    final a = c.cell(() => l.first);
    
    return Text('${a()}');
});
```

Spot the difference? We didn't wrap `l.first` in `cell(...)` in the
first example. We don't have to because the `first` property returns a
keyed cell so in-effect it will always return the same cell, given
that the property getter is called on the same cell. The first code
snippet is much simpler, more intuitive and more readable than the
second snippet.

Keys are not only useful in cell widgets, but are useful wherever a
cell property, which itself returns a cell, is accessed. This is
allows you to freely reference cell extension properties such as
`.first`, as many times as you need to without having to store the
returned cell in a local variable first.

## Which cells have keys?

The cells returned by cell property getters are always keyed
cells. This includes (but is not limited to):

* List cell extension properties:
  * `.first`
  * `.last`
  * `.length`
  
* Map cell extension properties
* `previous` cells
* `peek` cells

* Cell property accessors generated for classes annotated with
  `@CellExtension`

Also the following cells are keyed:

* Constant cells
* Cells returned by the indexing operator on List and Map cells:
  * `list[1.cell]`
  * `map['key'.cell]`

* Equality comparison cells created with `eq` and `neq`

To be sure whether a specific method returns a keyed cell or not,
consult the [API
Reference](https://pub.dev/documentation/live_cells/latest/).

## Keys for your own cells

You can assign a key to your own computed cells, created with
`ValueCell.computed`, by providing the key in the `key` argument:

```dart title="Keyed computed cell"
final cell = ValueCell.computed(() => a() + b(),
    key: MyKey(a, b)
);
```

Any object which overloads `==` and `hashCode` can serve as a cell
key. For your own keys, you're generally encouraged to do the following:

* Use a class per key type. For example if you have a function which
  returns a cell, create a key class that is only used by that
  function.
* If your cell depends on other cells, include those cells in the key
  class and in its implementation of `==`.
  
An example implementation of `MyKey` from the example above:

```dart title="Example key implementation"
class MyKey {
    final ValueCell a;
    final ValueCell b;
    
    MyKey(this.a, this.b);
    
    @override
    bool operator ==(other) => other is MyKey &&
        a == other.a &&
        b == other.b;
        
    @override
    int get hashCode => Object.hash(runtimeType, a, b);     
}
```

:::info

Mutable cells, with the exception of lightweight mutable computed
cells, cannot be assigned a key.

:::
