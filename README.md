This package provides a replacement (`ValueCell`) for `ChangeNotifier` and `ValueNotifier` 
that is simpler to use and more flexible, as well as a library of widgets which expose their properties
via `ValueCell`'s replacing the need for controller objects and event handlers.

## Features

This package provides a `ValueCell` interface which offers the following benefits 
over `ChangeNotifier` / `ValueNotifier`:

+ Implementing a `ValueCell` which is an expression of other `ValueCell`'s, e.g. `a + b`,
  can be done in a functional manner without manually adding and removing listeners using
  `addListener`, `removeListener`.
+ Simpler resource management, no need to call `dispose`.
+ (Still in early stages) A library of widgets which replaces "controller" objects with 
  `ValueCell`'s. This allows for a style of programming which fits in with the reactive
  paradigm of flutter.
  
This package also has the following advantages over other state management libraries:

+ Tightly integrated with a widget library replacing the need for event listeners and controller objects.
  Other libraries ignore this part and leave it up to the user to integrate the state management library
  with widgets.
+ Supports two-way data flow, whereas most other libraries, if not all, only support
  one-way data flow.

## Usage

### Basics

The basis of this package is the `ValueCell` which provides the cell interface. Every cell has a 
`value` and a set of observers which react to changes in the value.

A `MutableCell` is a cell which can have its `value` property set directly:

```dart
final cell = MutableCell(0);
...
cell.value = 1;
```

When the `value` property is set the observers of the cell react to the change.

A cell which is a function of other cells can be created using the `ValueCell.computed` constructor,
which takes the function that computes the cell's value.

```dart
final a = MutableCell(0);
final b = MutableCell(1);

final sum = ValueCell.computed(() => a() + b());
```

In the above example, cell `sum` computes the sum of the values of cells `a` and `b`. Whenever the
value of either `a` or `b` changes the value of `sum` is recomputed using the new values.

**NOTE**: The values of `a` and `b` are accessed using the function call syntax rather than by
accessing the `value` property. This is so that the computed cell can observe changes to the values
of those cells and automatically recompute its own value.

Putting it all together let's implement the most trivial of examples, a simple counter:

```dart
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class CounterDemo extends StatefulWidget {
  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  final counter = MutableCell(0);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CellWidget.builder((context) =>
            Text('You clicked the button ${counter()} times')
        ),
        ElevatedButton(
          child: const Text('Increment Counter'),
          onPressed: () => counter.value += 1,
        )
      ],
    );
  }
}
```

`CellWidget.builder` is used to create a widget which is rebuilt whenever the value of `counter`
changes. Like `ValueCell.computed`, the widget is rebuilt when the value of a cell, that is 
referenced within the widget builder function, changes.

**NOTE**: `ValueCell`'s do not require manually calling a `dispose` method once they're no longer
used. Disposal is taken care of automatically.

This example can be condensed further by moving the `counter` cell initialization directly within
the `build` method:

```dart
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class CounterExample extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final counter = cell(() => MutableCell(0));

    return Column(
      children: [
        CellWidget.builder((context) =>
            Text('You clicked the button ${counter()} times')
        ),
        ElevatedButton(
          child: const Text('Increment Counter'),
          onPressed: () => counter.value += 1,
        )
      ],
    );
  }
}
```

The `counter` cell is created directly within the `build` method using the `cell` method, provided by
the `CellInitializer` mixin, which creates an instance of a `ValueCell`, using the provided function,
on the first build of the widget, and retrieves the existing instance in subsequent builds.

The following example demonstrates computed cells:

```dart
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class ComputedExample extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell(0));
    final b = cell(() => MutableCell(0));

    final sum = cell(() => ValueCell.computed(() => a() + b()));

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  a.value = int.tryParse(value) ?? 0;
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
              ),
            ),
            const SizedBox(width: 5),
            const Text('+'),
            const SizedBox(width: 5),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  b.value = int.tryParse(value) ?? 0;
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CellWidget.builder((_) => Text(
            '${a()} + ${b()} = ${sum()}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
        ))
      ],
    );
  }
}
```

The above example demonstrates how the value of a computed cell, created using `ValueCell.computed`,
is recomputed whenever the values of the referenced argument cells change.

The definition of the `sum` cell above can be simplified further to the following:

```dart
final sum = cell(() => a + b);
```

The arithmetic and relational operators are overloaded for `ValueCell`'s holding `num` values, so that
a computed cell can be defined as an expression of `ValueCell`'s. This is not only simpler
but more efficient since the argument cells are determined at compile time.

### User Input

So far we've used the `onChanged` callback with the stock `TextField` provided by Flutter. This has
two disadvantages:

* The content of the `TextField` cannot be set externally without a `TextEditingController`.
* You have to manually synchronize the state of the cells with the state of the text field, in an
  event handler.

Live cells provides a `CellTextField` widget which allows its content to be accessed and controlled
by a `ValueCell`.

Example:

```dart
import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellTextFieldDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final input = cell(() => MutableCell(''));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        CellTextField(content: input),
        const SizedBox(height: 10),
        const Text(
            'You wrote:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
        ),
        const SizedBox(height: 10),
        CellWidget.builder((_) => Text(input())),
        ElevatedButton(
          child: const Text('Clear'),
          onPressed: () {
            input.value = '';
          },
        )
      ],
    );
  }
}
```

The `CellTextField` constructor takes a `content` cell parameter, in this example the cell `input` 
is provided. The value of the provided content cell, which must be a `MutableCell`, is updated to 
reflect the content of the text field whenever it is changed by the user. Whatever the user writes 
in the field is reflected in the widget below.

The 'Clear' button clears the text field by setting the `input` cell to the empty string. The benefits
of this approach are:

* No need for a `TextEditingController`
* No need for event handlers allowing for a declarative style of programming
* The content of the text field is a cell and can referenced by a computed cell

### Two-way data flow

Whilst the above is an improvement over what is offered by the stock Flutter `TextField`, it is still
quite limited in that the *content cell* has to be a string cell. You'll run into difficulties,
if instead of string input you require numeric input, as in the *sum* example.

*Mutable computed cells* are `MutableCell`'s which ordinarily function like normal computed cells,
created with `ValueCell.computed`, in that they compute a value out of one or more argument cells.
However, a mutable computed cell can also have its value changed by setting its `value` property
as though it is a `MutableCell`. When the value of a mutable computed cell is set, it *reverses*
the computation by setting the argument cells to a value such that when the mutable computed
cell is recomputed, the same value will be produced as the value that was set. Thus mutable
computed cells support two-way data flow, which is what sets *Live Cells* apart from other reactive
state management libraries.

Mutable computed cells can be created using the `MutableCell.computed` constructor, which takes the
computation function and reverse computation function. The computation function computes the cell's
value as a function of argument cells, like `ValueCell.computed`. The reverse computation
function *reverses* the computation by assigning a value to the argument cells. It is given the
value that was assigned to the `value` property.

Here's a simple example:

```dart
final a = MutableCell<num>(0);
final strA = MutableCell.computed(() => a().toString(), (value) {
  a.value = num.tryParse(value) ?? 0;
});
```

The above mutable computation cell converts the value of its argument cell `a`, which is a `num`
in this case, to a string. The reverse computation function parses a `num` from the string which was
assigned to the cell. Assigning a string value to `strA` will result in the `num` parsed from the
string being assigned to cell `a`.

```dart
strA.value = '100';
print(a.value + 1); // Prints 101
```

The above definition will prove useful when implementing a text field for numeric input. In-fact, this
library already provides a definition for this cell with the `mutableString` extension
method on `MutableCell`'s holding `int`, `double` and `num` values.

```dart
final a = MutableCell<num>(0);
final strA = a.mutableString();
```

We can now reimplement the *sum* example from earlier using `CellTextField` and `mutableString`:

```dart
import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class ComputedExample extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    final strA = cell(() => a.mutableString());
    final strB = cell(() => b.mutableString());

    final sum = cell(() => a + b);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                child: CellTextField(
                  content: strA,
                  keyboardType: TextInputType.number,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
              ),
            ),
            const SizedBox(width: 5),
            const Text('+'),
            const SizedBox(width: 5),
            Expanded(
              child: CellTextField(
                content: strB,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        CellWidget.builder((_) => Text(
            '${a()} + ${b()} = ${sum()}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
        )),
        ElevatedButton(
          child: const Text('Reset'),
          onPressed: () {
            a.value = 0;
            b.value = 0;
          },
        )
      ],
    );
  }
}
```

In the above example two mutable computed cells `strA` and `strB` are created using `mutableString`,
which are used as the content cells for the text fields for `a` and `b` respectively. There is also
a "Reset" button which resets the values of cells `a` and `b` to 0 when pressed. When the values of
`a` and `b` are set, the value of `sum` is automatically recomputed and the content of the text
fields is updated to reflect the new values of `a` and `b`.

The benefits of using `CellTextField` and mutable computed cells are:

* No need for a `TextEditingController` which you have to remember to `dispose`.
* No manual synchronization of state between the `TextEditingController` and the widget `State` / 
  `ChangeNotifier` object. Your state is instead stored in one place and in one representation.
* No need to use `StatefulWidget` or make ugly empty calls to `setState(() {})` to force the widget
  to update when the `text` property of the `TextEditingController` is updated.

**NOTE**:

The reverse computation functions of mutable computed cells are called in a batch update, which
means that all cell value updates performed within the function will be reflected, in the observers
of the cells, only after the function returns.

A batch update can be done outside of a reverse computation function using `Mutable.batch`. In-fact
the proper implementation of the "Reset" button is:

```dart
ElevatedButton( 
  child: const Text('Reset'),
  onPressed: () {
    MutableCell.batch(() {
      a.value = 0;
      b.value = 0;
    });
  },
)
```

With the above implementation cells `a` and `b` are both set to `0` simultaneously after the batch
update function returns. With this implementation the `sum` cell, which is an observer of both `a`
and `b` will only be recomputed once after both `a` and `b` are set to `0`.

#### Fun with mutable computed cells

Let's say we want the user to be able to enter the result of the addition and have the values for
`a` and `b` automatically computed and displayed in the corresponding fields:

We can do this with another mutable computed cell, this time with two arguments:

```dart
final sum = MutableCell.computed(() => a() + b(), (sum) {
  final half = sum / 2;

  a.value = half;
  b.value = half;
});
```

The reverse computation cell assigns the sum divided by two to both cells `a` and `b`.

Here's the full example with a `CellTextField` for the result of the addition:

```dart
import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class ComputedExample extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    final sum = cell(() => MutableCell.computed(() => a() + b(), (sum) {
      final half = sum / 2;

      a.value = half;
      b.value = half;
    }));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CellTextField(
                content: cell(() => a.mutableString()),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 5),
            const Text('+'),
            const SizedBox(width: 5),
            Expanded(
              child: CellTextField(
                content: cell(() => b.mutableString()),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 5),
            const Text('='),
            const SizedBox(width: 5),
            Expanded(
              child: CellTextField(
                content: cell(() => sum.mutableString()),
                keyboardType: TextInputType.number,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        CellWidget.builder((_) => Text(
           '${a()} + ${b()} = ${sum()}', 
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
            )
        )),
        ElevatedButton(
          child: const Text('Reset'),
          onPressed: () {
            MutableCell.batch(() {
              a.value = 0;
              b.value = 0;
            });
          },
        )
      ],
    );
  }
}
```

For brevity the definitions of the string conversion cells are placed directly in the `CellTextField`
constructor. When a value for `a` and `b` is entered, the result of the addition is displayed in the
result text field. When a value for the result is entered in the result text field, the values of `a`
and `b` and reflected in their corresponding text fields. This example also demonstrates how
mutable computed cells can be chained.

### Other Widgets

We've already covered `CellTextField`. The `live_cell_widgets` library also provides the following
widgets which expose their properties via `ValueCell`'s:

* `CellCheckbox` - A `Checkbox` with the `value` property controlled by a cell
* `CellCheckboxListTile` - A `CheckboxListTile` with the `value` property controlled by a cell
* `CellRadio` - A `Radio` with the `groupValue` property controlled by a cell
* `CellRadioListTile` - A `RadioListTile` with the `groupValue` property controlled by a cell`
* `CellSlider` - A `Slider` with the `value` property controlled by a cell
* `CellSwitch` - A `Switch` with the `value` property controlled by a cell
* `CellSwitchListTile` - A `SwitchListTile` with the `value` property controlled by a cell

## Advanced

### Writing your own cells

Occasionally you may need to write your own `ValueCell` subclasses. A common situation is if you
have a specific computation that you want to apply to different cells throughout your code.

To subclass `ValueCell`, the following methods have to be implemented:

* The `get value` property accessor to return the cell's value.
* The `addObserver` and `removeObserver` methods to add and remove observers, respectively.
* The equality comparison methods `eq` and `neq`.

The `CellEquality` mixin provides implementations of the equality comparison methods using the
`==` and `!=` operators for a given type.

To implement a cell that performs a computation which is dependent on the values of one or more
argument cells, you should extend `DependentCell`. This class already implements `addObserver` and 
`removeObserver`, and provides a constructor which takes a list of the argument cells on which the
value of the cell depends. You're only required to implement the `value` property accessor in which 
the value of the cell is computed.

Example:

```dart
class ClampCell<T extends num> extends DependentCell<T> with CellEquality<T> {
  final ValueCell<T> argValue;
  final ValueCell<T> argMin;
  final ValueCell<T> argMax;
  
  ClampCell(this.argValue, this.argMin, this.argMax) :
    super([argValue, argMin, argMax]);

  @override
  T get value => min(argMax.value, max(argMin.value, argValue.value));
}
```

The above `ValueCell` subclass implements a cell of which the value is the value of an argument cell
clamped between a minimum and maximum which are also supplied in argument cells.

**NOTE**: The argument cell containing the value to be clamped as well as the cells containing the
minimum and maximum are all passed to the constructor of `DependentCell` so that the observers
of the `ClampCell` are called whenever the value of one of the argument cells changes.

If your cell needs to store its value rather than computing it on demand or initiate value changes 
you will need to subclass `NotifierCell`. This class provides implementations of `addObserver`,
`removeObserver` and the `get value` property accessor. This class also provides a protected
`set value` property accessor for setting the cell's value. When the value of the cell is set via 
`set value` the observers of the cell are notified, if the new value is not equal to the previous value.

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

**NOTE**: The constructor of `NotifierCell` must be called to give the cell an initial value.
In this case the cell is given an initial value of `0` using `super(0)`.

### Resource Management

In Flutter resources are typically acquired in a constructor or *init* method and are released by
calling a *dispose* method. You'll notice that there are no calls to *dispose* anywhere
in any of these examples. This package takes a slightly different approach. The cells which require
manual resource management implement the `ManagedCell` interface, which `NotifierCell` extends.

`ManagedCell` provides an `init` method where resources should be acquired and a `dispose` method
where resources should be released. The `init` method is called before the first observer is added 
to the cell and `dispose` is called after the last observer is removed. The `init` method may be
called again after `dispose` if a new observer is added after the last one is removed. Therefore
implementations of `ManagedCell` should be written in such a way that the cell can be reused after
`dispose` is called.

You will have noticed that the implementation of `CountCell` in the previous example has a serious
flaw. It starts counting immediately when it is created and continues counting even when there are
no observers. If the value of this cell is displayed in a widget, the counter might appear to start
from a value greater than `0` or the counting could be complete before the widget has even rendered,
depending on where the cell is constructed.

Here's a better example that uses `init` and `dispose` to start and stop a timer, for incrementing
the value:

```dart
import 'dart:async';

import 'package:live_cells/live_cells.dart';

class CountCell extends NotifierCell<int> {
  final int end;
  final Duration interval;

  Timer? _timer;

  CountCell(this.end, {
    this.interval = const Duration(seconds: 1)
  }) : super(0);

  @override
  void init() {
    super.init();

    _timer = Timer.periodic(interval, _timerTick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    super.dispose();
  }
  
  void _timerTick(Timer timer) {
    if (value >= end) {
      timer.cancel();
    }
    
    value++;
  }
}
```

If you're implementing a subclass of `NotifierCell` which depends on the value of another cell, you
should add an observer to the cell in the `init` method and remove the observer in the `dispose`
method.

### ValueListenable Interface

The `ValueCell` class provides a `listenable` property which provides an object that exposes the cell's
value via the `ValueListenable` interface. Listeners added to the `ValueListenable` will be called
whenever the value of the cell changes. This allows you to use a `ValueCell` where a `ValueListenable`
is expected.

## Additional information

If you discover any issues or have any feature requests, please open an issue on the package's Github
repository.

Take a look at the `example` directory for more complete examples of how to use this library.