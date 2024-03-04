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

Remember we said `CellWidget` automatically generates a key for cells
defined within its build method. That's how the magic works, it's not
really magic now is it, and how the state of cells can be persisted
across builds. `CellWidget` automatically generates a key for each
cell defined in its build function/method that does not already have a
key.

Keys are not only useful in widgets, but also in computed cells:

```dart
final a = MutableCell(0);
final sum = ValueCell.computed(() => a() + a.previous());
```

Notice, we directly referenced the `previous` property (which
references the previous value of cell `a`), in the computed cell. We
are able to do this because `previous` returns a keyed cell. If it
weren't for keyed cells we would have to store `a.previous`
in a local variable first and reference that in the computed cell,
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

Don't give the same key to functionally different cells. **Don't do
this**

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

## Keys for mutable cells

If you assign a key to a mutable cell, created with `MutableCell` or
`MutableCell.computed`, you'll have to manually dispose the cell when
you're no longer using it, by calling its `.dispose()`. 

```dart
final a = MutableCell(0);
...
// When `a` will no longer be used
a.dispose();
```

This is because automatic disposal happens when the cell's last
observer is removed. However a mutable cell can reasonably be expected
to have its value assigned even when it doesn't have any observers. All
mutable cells with the same key, will have to share the same state and
hence the same value. This means the state has to be kept in the
global cell state table, even when it doesn't have any observers.

You don't have to manually dispose mutable cells without a key, since
their state is not shared with other cells and hence not kept in a
global state table.

:::important

`CellWidget` takes care of automatically disposing all `MutableCell`s
defined within it when the widget's element is unmounted, so you don't
have to call `dispose` manually.

:::

:::info

Stateless mutable computed cells do not require a `dispose` method to
be called, since they do not have any state to speak of. Most methods
and properties, provided by this library, that return keyed mutable
computed cells actually return stateless mutable computed cells. These
will be covered in the next section.

:::
