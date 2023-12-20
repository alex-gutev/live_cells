<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This package aims to replace `ChangeNotifier`, `ValueListenable`, `ValueNotifier`,
`Consumer`, `Selector`, etc. from the `provider` package with a unified `ValueCell`
interface that is simpler to use and more flexible.

## Features

The `ValueCell` interface offers the following benefits over `ChangeNotifier`/`ValueNotifier`:

## Usage

### Basics

The basis of this package is the `ValueCell` interface, which is an extension of the `ValueListenable` interface.

Every `ValueCell` has a value which can be accessed by the `value` property:

```dart
final cell = ValueCell.value(1);

print(cell.value); // Prints 1
```

Generally you wouldn't want to access the value of a cell directly but you would create a widget
which depends on the cell's value. This is done using the `toWidget` method:

```dart
final cell = ValueCell.value(1);

return cell.toWidget((context, value, _) => Text("Cell value: $value"));
```

The benefit of using `toWidget` as opposed to accessing `value` directly is that the returned
Widget is rebuilt whenever the value of the cell changes.

### Mutable Cells

So far the value of a cell cannot be changed after it is created. A `MutableCell` is a `ValueCell`
of which the `value` property can be set as well as read. When the value of the cell is set, all widgets
that depend on the value of the cell, created using `toWidget`, are rebuilt with the new value.

```dart
import 'package:live_cells/live_cells.dart';

class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final counter = MutableCell(0);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        counter.toWidget((context, count, _) => 
            Text('You clicked the button $count times')
        ),
        ElevatedButton(
          child: Text('Increment Counter'),
          onPressed: () {
              counter.value += 1;
          },
        )
      ],
    );
  }
}
```

When the button is clicked, the value of the cell `counter` is incremented by one and the widget
that displays the number of times the button was clicked is rebuilt.

**Notice** there are no `dispose` calls on `counter`, unlike if you were to use `ValueNotifier`.
This is intentional. More on this later. 

### Computational Cells

The code you've seen till this point isn't very different from what you'd see if you were using `ValueNotifier`
from the `provider` package, so why use `live_cells` at all? In this section you'll see where live cells
excels.

A computational cell is a cell that depends on the value of one or more argument cells. Whenever the values
of the argument cells change the value of the computational cell is recomputed and any widgets which
depend on its value are rebuilt.

The simplest way to create a computational cell is using the `ValueCell.apply` method, which
creates a new cell by applying a function on the value of the cell.

```dart
final cell = MutableCell(1);
final square = cell.apply((value) => value * value);
```

In this example the value of `square` is the square of the value of `cell`. Whenever the value
of `cell` changes, the value of `square` is recomputed with the new value of `cell`.

Here's a fully fledged example:

```dart
class ApplyMethodExample extends StatefulWidget {
  @override
  State<ApplyMethodExample> createState() => _ApplyMethodExampleState();
}

class _ApplyMethodExampleState extends State<ApplyMethodExample> {
  final name = MutableCell('');
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Enter your name:'),
        TextField(
          onChanged: (value) {
            name.value = value;
          },
        ),
        name.apply((value) => 'Hello ${value}')
            .toWidget((context, greeting, _) => Text(greeting))
      ],
    );
  }
}
```

Cells can also depend on multiple argument cells, for example every `ValueCell` implements the methods
`eq` and `neq` which create a new cell which compares whether the value of the cell is equal or not
equal to another value. Example:

```dart
final cell = MutableCell(2);

return cell.eq(1).toWidget((context, value, _) => {
  if (value) {
    return Text('Is equal to one');
  }
  else {
    return Text('Not equal to one');
  }
});
```

A computational cell which depends on multiple argument cells can be created with the `ComputeCell`
constructor:

```dart
final a = MutableCell(1);
final b = MutableCell(2);

final sum = ComputeCell(
    compute: () => a.value + b.value,
    arguments: [a,b]
);
```

The value of `sum` is the sum of the values of cells `a` and `b`. Note the `compute` function does
not take any arguments, unlike when using `apply`. Instead you have to access the values of the cells
directly using  the `value` property inside the `compute` function. Additionally you have to include
every argument cell in the `arguments` list so that the cell knows when its value should be 
recomputed.

**Note**:

Computational cells, whether created by the `apply` method or with the `ComputeCell` constructor
do not store their values. Instead the value of a computational cell is computed on demand whenever its
`value` property is accessed. If the property is accessed multiple times, the value of the cell is 
computed multiple times.

For those cases where this is undesirable, such as when the computation is expensive, the `store`
method can be used to create a cell which stores the value of the computational cell.

Example:

```dart
final a = MutableCell(10);

final factorial = a.apply((n) {
  var result = 1;

  for (var i = 2; i <= n; i++) {
    result *= i;
  }
  
  return result;
}).store();
```

The value of the `factorial` cell, which computes the factorial of cell `a`, is only computed once
when the value of `a` changes and the result is stored so that when the `value` property is accessed
later the stored value is retrieved rather than recomputing the value.

## Widgets Library

Besides the `ValueCell` interface, containined in the `live_cells` library, this package also 
provides a second library `live_cell_widgets` which address another shortcoming in Flutter which is
the requirement for "controller" objects.

Quite a few widgets in Flutter require a "controller" for some or all of their functionality, the
most notable being `TextField` which requires a `TextEditingController`. Controller objects are
problematic because they step out of the reactive paradigm adopted by Flutter making them
difficult or clunky to use.

The `live_cell_widgets` library provides wrappers around commonly used widgets which replace
controller objects with cell objects.

The `CellTextField` widget is a wrapper around `TextField` which takes a "content cell" parameter,
instead of a controller. When the user enters text in the text field, the value of the content
cell is changed. Similarly when the value of the content cell is set, the value inside the text
field is changed to reflect the value of the cell. 

Here's a simple example:

```dart
class CellTextFieldExample extends StatefulWidget {
  @override
  State<CellTextFieldExample> createState() => _CellTextFieldExampleState();
}

class _CellTextFieldExampleState extends State<CellTextFieldExample> {
  final name = MutableCell('');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Enter your name:'),
        CellTextField(content: name),
        name.toWidget((context, name, child) => Text('Hello $name')),
        ElevatedButton(
            onPressed: () => name.value = '',
            child: Text('Clear')
        )
      ],
    );
  }
}
```

Notice the `CellTextField` widget takes a `content` parameter, which is the content cell. This
must be a `MutableCell` in order for its value to be set by the widget.

A widget which depends on the content cell is created using `toWidget` in order to display
the value entered in the text field in a `Text` widget.

The "Clear" button clears the text field when pressed by setting the value of the content cell to 
the empty string.

Currently only a wrapper for `TextField` is provided. The aim for future release is to provide a 
cell-based interface to all widgets which take a controller object.

## Advanced

### Writing your own cells

Occasionally you may need to write your own `ValueCell` subclasses. A common situation is if you
have a specific computation that you want to apply to different cells throughout your code.

The `ValueCell` interface is an extension of the `ValueListenable` interface, which provides the
equality comparison methods `eq` and `neq` for comparing whether two cells are equal and not equal
respectively. These methods both return a `ValueCell` of which the value is the result of the
comparison. The `CellEquality` mixin implements these methods using the `==` and `!=` operators 
for a given type.

To implement a cell which performs a computation which is dependent on the values of one or more
argument cells, you should extend `DependentCell`. This class already implements `addListener` and 
`removeListener`, and provides a constructor which takes a list of the argument cells on which the
value of the cell depends. You're only required to implement the `value` property accessor in which 
the value of the cell is computed.

Example:

```dart
class ClampCell<T extends num> extends DependentCell<T> with CellEquality<T> {
  final ValueListenable<T> argValue;
  final ValueListenable<T> argMin;
  final ValueListenable<T> argMax;
  
  ClampCell(this.argValue, this.argMin, this.argMax) :
    super([argValue, argMin, argMax]);

  @override
  T get value => min(argMax.value, max(argMin.value, argValue.value));
}
```

The above `ValueCell` subclass implements a cell of which the value is the value of an argument cell
clamped between a minimum and maximum which are also passed in argument cells.

**NOTE**: The argument cell containing the value to be clamped as well as the cells containing the
minimum and maximum are all passed to the constructor of `DependentCell` so that the listeners
of the `ClampCell` are called whenever the value of one of the argument cells changes.

Also note the argument cells do not have to be instances of `ValueCell` but a `ValueListenable`,
or just a bare `Listenable` can be used instead.

If your cell needs to store its value rather than computing it on demand, as in the `ClampCell`
example, you will need to subclass `NotifierCell`. This class provides implementations of
`addListener`, `removeListener` and the `get value` property accessor. This class also provides a
protected `set value` property accessor for setting and storing the cell's value. When the value of
the cell is set via `set value` the listeners of the cell are called if the new value is not equal
to the previous value.

Example:

```dart
class CountCell extends NotifierCell<int> {
  final int end;
  final Duration interval;

  CountCell(this.end, {
    this.interval = const Duration(seconds: 1)
  }) : super(0) {
    unawaited(_startCounter());
  }

  Future<void> _startCounter() async {
    while (value < end) {
      await Future.delayed(interval);
      value++;
    }
  }
}
```

The above example is an implementation of a cell of which the value starts at `0` and is incremented
by one every second. If the value in this cell is displayed in a widget using `toWidget` you'd see
the widget display a new value every second.

**NOTE***: The constructor of `NotifierCell` must be called to give the cell an initial value.
In this case the cell is given an initial value of `0` using `super(0)`.

### Resource Management

In Flutter resources are typically acquired in a constructor or *init* method and are released by
calling a *dispose* method. You'll notice that there are no calls to *dispose* anywhere
in any of these examples. This package takes a slightly different approach. The cells which require
manual resource management implement the `ManagedCell` interface, which is `NotifierCell` extends.

`ManagedCell` provides an `init` method where resources should be acquired and a `dispose` method
where resources should be released. The `init` method is called when the first listener is added 
to the cell and `dispose` is called when the last listener is removed. The `init` method may be
called again after `dispose` if a new listener is added after the last one is removed. Therefore
implementations of `ManagedCell` should be written in such a way that the cell can be reused after
`dispose` is called.

You will have noticed that the implementation of `CountCell` in the previous example has a serious
flaw. It starts counting immediately when it is created and continues counting even when there are
no listeners. If the value of this cell is displayed in a widget, the counter might appear to start
from a value greater than `0` or the counting could be complete before the widget has even rendered,
depending on where the cell is constructed.

Here's a better example using `init` and `dispose` to start the counter after the first listener
is added and "pause" the counter when there are no more listeners.

```dart
class CountCell extends NotifierCell<int> {
  final int end;
  final Duration interval;

  var _counting = false;
  
  CountCell(this.end, {
    this.interval = const Duration(seconds: 1)
  }) : super(0) {
    unawaited(_startCounter());
  }

  @override
  void init() {
    super.init();

    _counting = true;
    unawaited(_startCounter());
  }

  @override
  void dispose() {
    _counting = false;
    super.dispose();
  }
  
  Future<void> _startCounter() async {
    while (value < end) {
      await Future.delayed(interval);
      
      if (!_counting) {
        break;
      }
      
      value++;
    }
  }
}
```

**NOTE**: In this case the `_counting` variable, and the accompanying implementation of `dispose`,
is unnecessary since `isInitialized` can be used  to check if the cell has been initialized, that 
is whether it has at least one listener, however it's included in this example to demonstrate
the usage of `init` and `dispose`.

If your implementing a subclass of `NotifierCell` which depends on the value of another cell, you
will add a listener to the cell in the `init` method and remove the listener in the `dispose`
method.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
