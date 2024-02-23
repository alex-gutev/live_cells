Live Cells is a reactive programming library for Dart, intended to be used with Flutter. 
Specifically Live Cells provides a replacement (the cell) for `ChangeNotifier` and `ValueNotifier` 
that is simpler to use and more flexible.

## Features

Cells offers the following benefits over `ChangeNotifier` / `ValueNotifier`:

+ Implementing a cell which is an expression of other cells, e.g. `a + b`,
  can be done in a functional manner without manually adding and removing listeners.
+ Simpler resource management, no need to call `dispose`.
+ Integrated with a library of widgets which allow their properties to
  be controlled and observed by cells. This allows for a style of
  programming which fits in with the reactive paradigm of Flutter.

This library also has the following advantages over other similar libraries:

+ Supports two-way data flow, whereas most other libraries, if not all, only support
  one-way data flow.
+ Cells are designed to be unobtrusive and indistinguishable, as much
  as is possible, from the values they hold.
+ Live Cells is unopinionated. You're not forced to change the way you
  write your apps. Use as much of its functionality as you need.
+ Integrated with a library of widgets which allow for effortless data
  binding between UI elements and cells.

## Getting Started

If you haven't used Live Cells before, please head to the full
[documentation](https://alex-gutev.github.io/live_cells/docs/intro).

The remainder of this README shows brief examples that demonstrate the main features of this library.

## Usage

### Defining Cells

Constant cells can be defined either using `.cell` or `ValueCell.value`:

```dart
final a = 1.cell;
final b = 'hello'.cell;
final c = ValueCell.value(someValue);
```

Mutable cells are defined using `MutableCell`:

```dart
final a = MutableCell(0);
final b = MutableCell(1);
```

### Computed Cells

Basic computed cells can be defined directly as an expression of cells:

```dart
final sum = a + b;
```

More complex computed cells are defined using `ValueCell.computed`:

```dart
final computed = ValueCell.computed(() => sqrt(a() * a() + b() * b()));
```

The values of computed cells are recomputed whenever the values of their argument cells
change:

```dart
print(sum.value); // 1
a.value = 6;
print(sum.value); // 7
```

### Observing Cells

Cells can be observed using `ValueCell.watch`. The watch function is called whenever the values of
the cells it references change:

```dart
ValueCell.watch(() {
  print('${a()} + ${b()} = ${sum()}');
});

a.value = 8; // Prints: 8 + 1 = 9
```

### Batch Updates

The values of multiple mutable cells can be set simultaneously using `MutableCell.batch`:

```dart
MutableCell.batch(() {
  a.value = 1;
  b.value = 3;
});
```

### Cells in Widgets

`CellWidget.builder` creates a widget that is rebuilt whenever the values of the cells referenced by
it change:

```dart
// Rebuilt when a, b, or sum change
CellWidget.builder(() => Text('${a()} + ${b()} = ${sum()}'));
```

### Exception Handling

Exceptions thrown during the computation of a cell's value are propagated to all points where the
value is referenced. 

This allows exceptions to be handled using try catch:

```dart
final str = MutableCell('0');
final n = ValueCell.computed(() => int.parse(str()));

final isValid = ValueCell.computed(() {
  try {
    return n() > 0;
  }
  catch (e) {
    return false;
  }
});

print(isValid.value); // Prints false

str.value = '5';
print(isValid.value); // Prints true

str.value = 'not a number';
print(isValid.value); // Prints false
```

Or more succinctly using `onError`:

```dart
final str = MutableCell('0');
final n = ValueCell.computed(() => int.parse(str()));
final isValid = (n > 0.cell).onError(false.cell);
```

### Previous Values

The previous value of a cell can be accessed using `.previous`, which is itself a cell:

```dart
final a = MutableCell(0);
final prev = a.previous;
final sum = a + prev;

a.value = 1;
print(a.value);    // Prints 1
print(prev.value); // Prints 0
print(sum.value);  // Prints 1

a.value = 5;
print(a.value);    // Prints 5
print(prev.value); // Prints 1
print(sum.value);  // Prints 6
```

### Binding Cells to Widget Properties

This package also provides a collection of widgets, which allow their properties to be controlled
and observed by cells:

For example `CellSwitch` is this library's equivalent of `Switch`:

```dart
final state = MutableCell(false);

return Column(
  children: [
    // This binds the value of the switch to `state`
    CellSwitch(
      value: state
    );
    // This widget is rebuilt whenever the switch is toggled
    CellWidget.builder(() => Text(state() ? 'On' : 'Off'));
  ]
);
```

Resetting the switch is as simple as setting the value of `state`:

```dart
state.value = false;
```

### Two-Way Data Flow

Two-way data flow allows for complex logic to be implemented entirely using concise declarative 
code:

```dart
final n = MutableCell<num>(0);

// CellTextField is a Live Cells TextField
//
// This binds the content of the field to `n`
return CellTextField(
  // Example of two-way data flow:
  //
  // When the value of `n` is set, `mutableString()` converts it to
  // a string and forwards it to the field's content.
  //
  // When the content of the field changes, `mutableString()` converts
  // the string content to a number and forwards it to `n`
  content: n.mutableString();
)
```

### Property Accessors for your own types:

With [live_cell_extension](https://pub.dev/packages/live_cell_extension) you can generate cell
accessors for your own classes:

```dart
@CellExtension(mutable: true)
class Person {
  final String firstName;
  final String lastName;
  
  Person({
    required this.firstName,
    required this.lastName
  });
}
```

You can now access `firstName` and `lastName` directly on cell's holding a `Person`:

```dart
final person = MutableCell(Person(...));

ValueCell.watch(() {
  print('${person.firstName()} ${person.LastName()}');
});

// This triggers the watch function defined above:
person.firstName.value = 'John';
```

### Asynchronous Cells

Cells can hold and manipulate a `Future` like any other value:

```dart
ValueCell<Future<int>> cell1;
ValueCell<Future<int>> cell2;
...
final sum = ValueCell.computed(() async {
  final (a, b) = await (cell1(), cell2()).wait;
  return a + b;
});
```

Cells can `await` a `Future` held in another cell:

```dart
ValueCell<Future<int>> cell1;
ValueCell<Future<int>> cell2;
...
// The value of `sum` is only computed once the futures
// in both `cell1` and `cell2` have completed
final sum = ValueCell.computed(() {
  final (a, b) = (cell1, cell2).wait();
  return a + b;
});
```

## Additional information

If you discover any issues or have any feature requests, please open an issue on the package's Github
repository.

Please visit the full [documentation](https://alex-gutev.github.io/live_cells/docs/intro) for a full
introduction to the library's features. Also take a look at the `example` directory for more
complete examples of how to use this library.
