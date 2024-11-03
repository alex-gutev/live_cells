---
title: Why Live Cells?
---

# Why Live Cells?

There are plenty of similar libraries out there. So why should you use
Live Cells in particular?

## Why not StatefulWidget?

`StatefulWidget` and `setState` are excellent tools for managing state
that is local to a single widget, and passing that state down the
widget hierarchy. However `StatefulWidget` is not a great tool for
managing global application state, nor is it capable of passing data
up the widget hierarchy. To pass data from a child widget to its
parent, you have to pass callback functions.

For example to implement a "counter" widget that provides a button for
incrementing a counter value, which is stored in the parent of the
"counter" widget, you have to do something similar to the following:

```dart
class Counter extends StatelessWidget {
    final int count;
    
    final void Function(int) onChanged;
    
    Counter({
        required this.count,
        required this.onChanged
    });
    
    @override
    Widget build(BuildContext context) {
        return ElevatedButton(
            child: Text(count.toString()),
            onPressed: () => onChanged(count + 1) 
        );
    }
}
```

To use this widget, you would do something similar to the following :

```dart
class Parent extends StatefulWidget {
    @override
    State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
    var _count = 0;
    
    @override
    Widget build(BuildContext context) => Column(
      children: [
        Text('Count is $_count'),
        Counter(
            count: _count,
            onChanged: (count) => setState(() {
                _count = count;
            })
        )
      ]
    );
}
```

Now let's compare this with an implementation using Live Cells:

```dart
class Counter extends CellWidget {
    final MutableCell<int> count;
    
    Counter(this.count);
    
    @override
    Widget build(BuildContext context) {
        return ElevatedButton(
            child: Text(count().toString()),
            onPressed: () => count.value++
        );
    }
}
```

```dart
class Parent extends CellWidget {
    @override
    Widget build(BuildContext context) {
        final count = MutableCell(0);
        
        return Column(
          children: [
            Text('Count is ${count()}'),
            Counter(count)
          ]
        );
    }
}
```

Notice the version using Live Cells version does not require an
`onChanged` callback in the `Counter` widget. Only the cell holding
the counter value is passed. The `Counter` widget increments the
value held in the cell directly, and the parent widget is
automatically rebuilt with the new counter value.

So what's the big deal with callbacks? 

1. You're duplicating the state synchronization code wherever you use
   the `Counter` widget.
2. If you have multiple counters with different values, there's more
   room for mistakes by setting the wrong counter value, e.g. doing
   `_count1 = count` instead of `_count2 = count`.
3. If the counter is stored in a widget that is even higher up the
   hierarchy, you have to prop-drill callbacks all the way down to the
   `Counter` widget. With cells you just pass the cell holding the
   counter.

## Why not ValueNotifier?

Doesn't `ValueNotifier` already perform the function of cells,
described above? Yes it does, but a cell can also be defined as a
function of other cells. For example imagine you have two counters,
you can define a cell that evaluates to the sum of the counters,
using:

```dart
final sum = ValueCell.computed(() => count1() + count2());
```

The `sum` cell defined above is automatically recomputed when either
one of `count1` or `count2` change. This cell can then be observed
just like any other cell.

```dart
class Parent extends CellWidget {
    @override
    Widget build(BuildContext context) {
        final count1 = MutableCell(0);
        final count2 = MutableCell(0);
        
        final sum = ValueCell.computed(() => count1() + count2());
        
        return Column(
          children: [
              Text('${count1()} + ${count2()} = ${sum()}'),
              Counter(count1),
              Counter(count2)
          ]
        );
    }
}
```

This cannot be done easily with `ValueNotifier`, you either have to
subclass it or implement your own `ValueListenable`, or manually add
and remove listeners to both `ValueNotifier`s in the widget.


```dart
class _ParentState extends State<Parent> {
    final count1 = ValueNotifier(0);
    final count2 = ValueNotifier(0);
    
    final sum = 0;
    
    void _updateSum() {
        setState(() {
            sum = count1.value + count2.value;
        });
    }
    
    @override
    void initState() {
        super.initState();
        
        count1.addListener(_updateSum);
        count2.addListener(_updateSum);
    }
    
    @override
    void dispose() {
        count1.dispose();
        count2.dispose();
        
        super.dispose();
    }
    
    @override
    Widget build(BuildContext context) {
        return Column(
          children: [
              Text('${count1.value} + ${count2.value} = $sum'),
              Counter(count1),
              Counter(count2)
          ]
        );
    }
}
```

Besides being more verbose, this is also more error prone. You could
easily forget to add a listener, or forget to dispose a
`ValueNotifier`. Live Cells takes care of all of that for you so you
can focus only on your application logic.

## Why not ChangeNotifier?

Why not just put both counters in a single `ChangeNotifier` instead of
two `ValueNotifier`s? Something similar to the following:


```dart
class SumNotifier extends ChangeNotifier {
    final _count1 = 0;
    final _count2 = 0;
    
    int get count1 => _count1;
    
    set count1(int value) {
        _count1 = value;
        notifyListeners();
    }
    
    int get count2 => _count2;
    
    set count2(int value) {
        _count2 = value;
        notifyListeners();
    }
    
    int get sum => _count1 + _count2;
}
```

What do you do if one of the counter values is stored in the `Parent`
widget, but the other needs to be stored even higher up the widget
hierarchy, which means you cannot store both counters in a single
`ChangeNotifier`? You'll just run into the same problem.

With Live Cells this is as simple as:

```dart
class Parent extends CellWidget {
    final MutableCell<int> count1;
    
    Parent(this.count1);
    
    @override
    Widget build(BuildContext context) {
        final count2 = MutableCell(0);
        
        final sum = ValueCell.computed(() => count1() + count2());
        
        return Column(
          children: [
              Text('${count1()} + ${count2()} = ${sum()}'),
              Counter(count1),
              Counter(count2)
          ]
        );  
    }
}
```

## Why not other libraries?

Other libraries also provide equivalent functionality to
`ValueCell.computed`, some of them even with the same syntax. So why
should you use Live Cells?

### Two-way data flow

There are plenty of libraries which provide equivalent functionality
to `ValueCell.computed`. However `ValueCell.computed` has a
fundamental limitation in that it only defines a unidirectional flow of
data.

For example in the following:

```dart
final n = MutableCell(0);
final strN = ValueCell.computed(() => n().toString());
```

Data can flow from `n` to `strN`, which converts the integer held in
`n` to a string, but data can never flow from `strN` to `n`.

Live Cells also provides `MutableCell.computed`, which allows you to
define the data flow in both directions:

```dart
final n = MutableCell(0);
final strN = MutableCell.computed(() => n().toString(), (str) {
    n.value = int.tryParse(str) ?? 0;
});
```

In this example when an integer value is assigned to `n`, `strN` is
automatically updated to the string representation of the value that
was assigned:

```dart
n.value = 0;
print(strN.value); // 0

n.value = 5;
print(strN.value); // 5
```

A string value can also be assigned to `strN`. In this case, an
integer is parsed from the value that was assigned, and is assigned to
`n`.

```dart
strN.value = '10';
print(n.value + 1); // 11

strN.value = '15';
print(n.value + 1); // 16
```

This is very useful for implementing data conversions while exchanging
data between a child and parent widget. In-fact this pattern is so
common that Live Cells packages this definition of `strN` in a
`.mutableString()` method. So `strN` can be defined using:

```dart
final strN = n.mutableString();
```

Now let's put this to practical use. Imagine that instead of a button,
the `Counter` widget should provide a text field for entering the
counter value directly.

With Live Cells this can be done easily using two-way data flow:

```dart
class Counter extends CellWidget {
    final MutableCell<int> count;
    
    Counter(this.count);
    
    @override
    Widget build(BuildContext context) {
        return LiveTextField(
            content: count.mutableString()
        );
    }
}
```

:::info

`LiveTextField` is a widget provided by the **Live Cell Widgets** library
that binds the content of a `TextField` to the cell provided
in the `content` parameter of the constructor. 

When the value of the cell changes, the content of the field is
updated, and similarly when the content changes, the value of the cell
is updated.

:::

That's it, we were able to achieve that without callback functions or
manually adding listeners.

No other library (to the best of my knowledge) provides anything
equivalent to `MutableCell.computed`, and hence cannot implement the
example above as succinctly as Live Cells.

If we were to rely only on `ValueCell.computed` (An equivalent of
which is provided by most other libraries), we would have to do
something similar to the following:


```dart
final Counter extends StatefulWidget {
    final MutableCell<int> count;
    
    Counter(this.count);
    
    @override
    State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
    final _controller = TextEditingController();
    
    @override
    void initState() {
        super.initState();
        _controller.text = widget.count.value.toString();
    }
    
    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }
    
    @override
    Widget build(BuildContext context) {
        return TextField(
            controller: _controller,
            onChanged: (str) {
                count.value = int.tryParse(str) ?? 0;
            }
        );
    }
}
```

Besides being verbose and error prone (this is becoming a common
theme), a bug could easily be introduced if your forget to initialize
the `text` property of the `TextEditingController` or you forget to
dispose it, this definition is not even equivalent to the previous definition
using `mutableString()`.

In the previous definition if the value of the `count` cell is
changed, regardless of where it is changed from, the global state, a
widget higher up the hierarchy, or within the `Counter` widget itself,
the content of the text field is updated to reflect the new counter
value. With this implementation, the content of the text field is no
longer updated when the value of the counter is changed. We've lost
reactivity and now the state of our widgets is no longer in sync with
our application state.

To fix this implementation we'd have to add a listener on the
`count` cell, which we can do with `ValueCell.watch` and manually
synchronize the state of the `TextField` with our cell. Something
similar to the following:


```dart
late final CellWatcher _watcher;

var _suppressChanges = false;

@override
void initState() {
    ...
    _watcher = ValueCell.watch(() {
        if (!_suppressChanges) {
            _controller.text = count().toString();
        }
    });
}

@override
void dispose() {
    ...
    _watcher.stop();
}

@overidde
Widget build(BuildContext context) {
    return TextField(
        controller: _controller,
        onChanged: (str) {
            _suppressChanges = true;
            count.value = int.tryParse(str) ?? 0;
            _suppressChanges = false;
        }
    );
}
```

Wow, that's a lot of boilerplate and that's not even all of it. We had
to add a listener on the `count` cell in `initState` to keep the
content of the text field (the `text` property of the
`TextEditingController`) in sync with the value of the cell. We also
had to add a guard `_suppressChanges` to prevent changes to the value
of the `count` cell, that are triggered by the `onChanged` callback,
from causing unnecessary updates to the `TextEditingController`. 

You can tell that the code is becoming unwieldy. In-fact, it's uglier
than a simpler implementation that forgoes cells, `ValueNotifier`s, or
another library's primitive in favour of `setState`, callbacks and
`didUpdateWidget`, and that's what many developers do. However, then
you end up with the issues outlined in [Why not
StatefulWidget](#why-not-statefulwidget). Without two-way data flow,
reactive programming is essentially useless in situations such as these.

Whilst we used the primitives of Live Cells (`ValueCell.computed` and
`ValueCell.watch`), since similar primitives are provided by other
libraries, every library that does not offer an equivalent to
`MutableCell.computed`, which hardly any if any at all do, will suffer
from the same limitations.

### Flexibility

Cells can be used both to manage global and widget state. Whilst this
is not exclusive to Live Cells, I know of no other library where you
can define the widget state directly in the build method using exactly
the same definitions as you would for global state.

For example this is widget local state (we've already seen this):

```dart
class Counter extends CellWidget {
    @override
    Widget build(BuildContext context) {
        final count = MutableCell(0);
        
        return ElevatedButton(
            child: Text('${count()}'),
            onPressed: () => count.value++
        );
    }
}
```

Let's say for some reason we want a global counter shared by all
`Counter` widgets throughout our app. All we have to do is move the
definition of `count` outside the widget:


```dart
final count = MutableCell(0);

class Counter extends CellWidget {
    @override
    Widget build(BuildContext context) {
        return ElevatedButton(
            child: Text('${count()}'),
            onPressed: () => count.value++
        );
    }
}
```

The code defining the `count` cell is exactly the same in both case,
the only difference is where its placed.

### Unobtrusive

Cells are designed to be indistinguishable from the values they hold
as much as possible. For example you can define cells directly as an
expression of other cells:

```dart
final sum = a + b;
```

This defines a cell (`sum`) that computes the sum of the values of
cells `a` and `b`.

```dart
final elem = list[index];
```

This defines a cell (`elem`) that retrieves the element at the index
held in cell `index` of the list held in cell `list`.

With
[live_cell_extension](https://pub.dev/packages/live_cell_extension),
_which you can read more about
[here](/docs/basics/user-defined-types)_, you can access properties of
your own types using almost the same syntax as you would use if you
were dealing with the values directly:

For example consider the following `Person` class:

```dart
class Person {
    final String name;
    final int age;
    
    const Person({
        this.name,
        this.age
    });
}
```

With `live_cell_extension` you can create a cell that access a
property of a `Person` held in another cell using the following:

```dart
final person = MutableCell(
    Person(
        name: 'John Smith',
        age: 25
    )
);

// Create a cell that accesses the `name` property
final name = person.name;

// Create a cell that accesses the `age` property
final age = person.age
```

The code used is exactly the same as if you were accessing the
properties directly on a `Person` value. Most other libraries require
you to define *selectors* using something similar to the following:

```dart
final name = person.select((p) => p.name);
```

Notice you didn't have to define custom subclasses, providers, or
selectors, which a lot of other libraries require even for simple
examples such as these. Live Cells tries to make working with cells as
close as possible to working with raw values.

### Widgets library

Live Cells also comes with a widgets library, _which you can read more
about [here](/docs/basics/live-cell-widgets)_, that allows you to bind
cells directly to widget properties. We've already seen one such
example `LiveTextField`:

```dart
final contentCell = MutableCell('');

LiveTextField(
    content: contentCell
)
```

`LiveTextField` is a the Live Cells equivalent of Flutter's
`TextField`, which allows you to bind its properties directly to
cells. In the example above, the content of the field is bound to
`contentCell`. This means whenever the content of the field changes,
the value of `contentCell` is updated. Likewise whenever the value of
`contentCell` changes, the content of the field is updated.

Besides `LiveTextField`, this library also provides `LiveSwitch`,
`LiveCheckbox`, `LiveRadio` and many other widgets.

:::info

These are not reimplementations of Flutter's widgets but wrappers over
them.

:::

No other library, to the best of my knowledge, offers anything
remotely similar to this.
