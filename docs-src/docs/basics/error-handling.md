---
title: Error Handling
description: How to handle errors using two-way data flow
sidebar_position: 6
---

# Error Handling

In the previous section we introduced how to handle numeric input
using mutable computed cells. However, we glossed over what happens if
the user enters invalid input.

When a cell created by `mutableString()` is assigned a string which
does not represent a valid number, a default value of `0` is
assigned. This default value can be changed using the `errorValue`
argument:

```dart title="Example of mutableString(errorValue: ...)"
final a = MutableCell<num>(0);

final strA = a.mutableString(
  errorValue: -1.cell
);

strA.value = 'not a valid number';

print(a.value); // Prints -1
```

In this example, cell `a` is assigned a value of `-1` if `strA` is
assigned a string which does not represent a valid number.

:::tip
The `errorValue` is a cell, which allows the default value to be
changed dynamically.
:::

## Maybe Values

This error handling strategy might be sufficient for some cases but
usually, we want to detect and handle the error rather than assigning
a default value. This can be done with
[`Maybe`](https://pub.dev/documentation/live_cells/latest/live_cells/Maybe-class.html)
values.

[`Maybe`](https://pub.dev/documentation/live_cells/latest/live_cells/Maybe-class.html)
is a container that either contains a value, or an exception that was
thrown during the computation of a value. This can be used to catch
exceptions thrown inside the reverse computation function of a mutable
computed cell.

The
[`Maybe.wrap`](https://pub.dev/documentation/live_cells/latest/live_cells/Maybe/Maybe.wrap.html)
constructor calls the function passed to it and wraps the return
value, or the exception that was thrown, in a `Maybe` value.

```dart
// Creates a Maybe holding the integer value 1
final maybeInt = Maybe.wrap(() => int.parse('1'));

// Creates a Maybe holding a FormatException
final maybeError = Maybe.wrap(() => int.parse('junk'));
```

:::tip

`Maybe` is a sealed union of the classes
[`MaybeValue`](https://pub.dev/documentation/live_cells/latest/live_cells/MaybeValue-class.html)
and
[`MaybeError`](https://pub.dev/documentation/live_cells/latest/live_cells/MaybeError-class.html). This
allows you to handle errors using `switch` and pattern matching:

```dart
switch (maybe) {
  case MaybeValue(:final value):
    /// Do something with `value`
        
  case MaybeError(:final error):
    /// Handle the `error`
}
```

:::

The
[`unwrap`](https://pub.dev/documentation/live_cells/latest/live_cells/Maybe/unwrap.html)
property returns the value held in the `Maybe`. If the `Maybe` holds
an exception, it is rethrown.

```dart
// Creates a Maybe holding the integer value 1
final maybeInt = Maybe.wrap(() => int.parse('1'));

// Prints 1
print(maybeInt.unwrap);

// Creates a Maybe holding a FormatException
final maybeError = Maybe.wrap(() => int.parse('junk'));

// Throws the FormatException held in the Maybe
print(maybeError.unwrap);
```

## Maybe Cells

The
[`maybe()`](https://pub.dev/documentation/live_cells/latest/live_cells/CellMaybeExtension/maybe.html)
extension method creates a cell that wraps the value of its argument
cell in a `Maybe`. The resulting `Maybe` cell is a mutable computed
cell with the following behaviour:

* Its computed value is the value of the argument cell wrapped in a
  `Maybe`.
* When the cell's value is set, it sets the value of the argument cell
  to the value wrapped in the `Maybe` if it is holding a value.
* When the cell's value is set to a `Maybe` holding an exception, the
  argument cell's value is not changed.

The following cell definition:

```dart
final a = MutableCell<num>(0);
final maybeA = a.maybe();
```

is equivalent to:

```dart
final maybeA = MutableCell.computed(
  () => Maybe.wrap(() => a()), 
  (maybe) => a.value = maybe.unwrap
);
```

`Maybe` cells provide an
[`error`](https://pub.dev/documentation/live_cells/latest/live_cells/MaybeCellExtension/error.html)
property which retrieves a `ValueCell` that evaluates to the exception
held in the `Maybe` or `null` if the `Maybe` is holding a value.

This can be used to determine whether an error occurred while
assigning a value to a mutable computed cell.

```dart title="Mutable computed cell with error handling"
final a = MutableCell<num>(0);
final maybeA = a.maybe();

final strA = MutableCell.computed(() => a().toString(), (value) {
  maybeA.value = Maybe.wrap(() => num.parse(value));
}

print(strA.value); // Prints 0

strA.value = '12';
print(a.value);            // Prints 12
print(maybeA.error.value); // Prints null

strA.value = 'junk';
print(a.value);            // Prints 12
print(maybeA.error.value); // Prints FormatException
```

In this example `strA` is a mutable computed cell that:

1. Converts the value it is assigned to a `num`
2. Wraps it in a `Maybe` value
3. Assigns the `Maybe` value to `maybeA`, which in turns sets the
   value of `a` to the wrapped value.

When `strA` is assigned a value that is not a valid `num`, `maybeA` is
assigned a maybe that holds an exception which can be retrieved using
`maybeA.error`. The value of `a` is not changed in this case.

A cell with this behaviour can be created using the
[`mutableString`](https://pub.dev/documentation/live_cells/latest/live_cells/ParseMaybeNumExtension/mutableString.html)
method provided on `Maybe` cells that hold `num`, `int` or `double`
values.

Putting it all together a text field for numeric input that displays
an error message when an invalid value is entered can be implemented
with the following:

```dart title="Numeric text field with error handling"
class NumberField extends CellWidget {
  final MutableCell<num> n;
  
  const NumberField(this.n, {
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
    final maybe = n.maybe();
    final error = maybe.error;
    
    return LiveTextField(
      content: maybe.mutableString(),
      decoration: InputDecoration(
          errorText: error() != null 
              ? 'Please enter a valid number' 
              : null
      )
    );
  }
}
```

:::note

We've packaged the input field in a `CellWidget` subclass which
takes the cell to which to bind the content of the field as an
argument. This allows us to reuse this error handling logic wherever a
numeric input text field is required.

:::

Here we're testing whether `error` is non-null, that is whether an
error occurred while parsing a number from the text field, and if so
providing an error message in the `errorText` of the
`InputDecoration`.

The error message can be made more descriptive by also checking
whether the field is empty, or not:

```dart title="Numeric text field with error handling"
class NumberField extends CellWidget {
  final MutableCell<num> n;
  
  const NumberField(this.n);
  
  @override
  Widget build(BuildContext context) {
    final maybe = n.maybe();
    final content = maybe.mutableString();
    final error = maybe.error;
    
    return LiveTextField(
      content: content,
      decoration: InputDecoration(
          errorText: content().isEmpty 
              ? 'Cannot be empty' 
              : error() != null 
              ? 'Please enter a valid number' 
              : null
      )
    );
  }
}
```

Now that we have a reusable numeric input field with error handling,
let's use it to reimplement the sum example from earlier.

```dart title="Sum example using NumberField"
CellWidget.builder((_) {
  final a = MutableCell<num>(0);
  final b = MutableCell<num>(0);
    
  final sum = a + b;
    
  return Column(
    children: [
      Row(
        children: [
          NumberField(a),
          SizedBox(width: 5),
          Text('+'),
          SizedBox(width: 5),
          NumberField(b),
        ],
      ),
      Text('${a()} + ${b()} = ${sum()}'),
      FilledButton(
        child: Text('Reset'),
        onPressed: () => MutableCell.batch(() {
          a.value = 0;
          b.value = 0;
        })
      )
    ]
  );
});
```

Notice how we were able to package our text field with error handling
entirely in a separate class, that can be reused, all without writing
or passing a single `onChanged` callback and at the same time being
able to reset the content of the fields simply by changing the values
of the cells holding our data.

:::caution

The same cell should be provided to `NumberField` between
builds. Don't conditionally select between multiple cells. **Don't do
this**:

```dart
NumberField(cond ? n1 : n2)
```

**Don't do this either**:

```dart
cond ? NumberField(n1) : NumberField(n2)
```

If you need to do this consider provided a `key` to `NumberField` that
is changed whenever a different cell is selected.

:::
