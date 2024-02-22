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
it is the same cell, just referenced by a different object.

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

Keys are not only useful in cell widgets, but also in computed cells:

```dart
final a = MutableCell(0);
final sum = ValueCell.computed(() => a() + a.previous());
```

Notice, we directly referenced the `previous` property (which
references the previous value of cell `a`). in the computed cell. We
are able to do this because `previous` returns a keyed cell. If it
weren't for keyed cells we would have to write to store `a.previous`
in a local variable first and referenced that in the computed cell,
i.e. something similar to the following:

```dart
final a = MutableCell(0);
final prev = a.previous;

final sum = ValueCell.computed(() => a() + prev());
```

The second snippet is more verbose and would be inefficient, if
`previous` wasn't a keyed cell, because every `a.previous` would
create a new cell that tracks the previous value of `a`. With keyed
cells there is only a single `a.previous` cell that is tracking the
previous value of `a`.

### Why?

You may be asking why keyed cells instead of just caching the created
cells in private properties? There's three reasons for this:

* It keeps the core cell classes small. 
* All additional functionality `.previous`, `.wait`, `.delayed`,
  `.first`, `.last`, ..., can be kept in extensions on the relevant
  `ValueCell` classes rather than bloating the classes themselves.
* `live_cell_extension` (see [User Defined
  Types](/docs/basics/user-defined-types)) would not have been
  possible without cell keys.
* This allows users of the library to extend the cell classes with
  their own properties, e.g. `.foo`, which can be used just like a
  built in property.

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

An example implementation of `MyKey`:

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


:::danger

Don't give unrelated cells the same key. **Don't do this**

```dart
final a = ValueCell.computed(() => a() + b(),
    key: MyKey(a, b)
);

final b = ValueCell.computed(() => a() * b(),
    key: MyKey(a, b)
);
```

Not unless you want bad things to happen.

:::

:::info

Mutable cells, with the exception of lightweight mutable computed
cells, cannot be assigned a key.

:::
