---
title: ValueCell Subclass 1
description: Part one of how to write your own ValueCell subclass
sidebar_position: 3
---

# ValueCell Subclass 1

[`ValueCell`](https://pub.dev/documentation/live_cells/latest/live_cells/ValueCell-class.html)
is the base class implemented by all cells. This class defines the
cell interface which consists of the following methods:

* [`addObserver`](https://pub.dev/documentation/live_cells/latest/live_cells/ValueCell/addObserver.html)

  Adds an observer that is notified when the value of the cell changes.

* [`removeObserver`](https://pub.dev/documentation/live_cells/latest/live_cells/ValueCell/removeObserver.html)

  Removes an observer, previously added with `addObserver`, so that it
  is no longer notified when the value of the cell changes.

and the following property:

* [`value`](https://pub.dev/documentation/live_cells/latest/live_cells/ValueCell/value.html)

  The value of the cell, which can either be retrieved from memory or
  computed on demand.
  
To implement your own `ValueCell` subclass, you have to implement
these methods and properties. For example to implement a cell that
computes a random value, whenever its value is accessed, the `value`
property has to be overridden:

```dart title="Custom cell that returns a random value"
class RandomCell extends ValueCell<int> {
  final int max;
  
  const RandomCell([this.max = 10]);

  @override
  int get value => Random().nextInt(max);

  @override
  void addObserver(CellObserver observer) {}

  @override
  void removeObserver(CellObserver observer) {}
}
```

The `value` property is overridden with a property that returns a
random integer. Note, a new random integer is returned whenever the
value of the cell is accessed.

The `addObserver` and `removeObserver` methods are overridden, since
these methods are not defined by the base `ValueCell` class. These
methods are left empty since the cell never notifies its observers
that its value has changed and thus there is no need to keep track of
observers.

## Custom Cells with Arguments

To define a `ValueCell` subclass with a value that is dependent on
other cells, extend the
[`DependentCell`](https://pub.dev/documentation/live_cells_core/latest/live_cells_internals/DependentCell-class.html)
class. This class provides a constructor which accepts the set of
argument cells on which the value of the cell depends. Whenever the
value of at least one of the cells in this set changes, the observers
of the `DependentCell` are notified. Only the `value` property has to
be overridden by subclasses, since `DependentCell` provides
implementations of `addObserver` and `removeObserver`.

Here's an example of the previous `RandomCell` however with the
*maximum* now provided in an argument cell rather than a value.

```dart
class RandomCell extends DependentCell<int> {
  final ValueCell<int> max;
  
  const RandomCell(this.max) : super({max});
  
  @override 
  int get value => Random().nextInt(max.value);
}
```

Some points to note from this example:

* `max` is now a `ValueCell` which is included in the argument cell
  set provided to the `super` constructor.
* The `value` property is accessed directly since `DependentCell` does
  not determine argument cells dynamically.

:::important

`DependentCell` is a stateless cell that does not cache its
value. Instead it's value is recomputed whenever it is accessed.

:::
