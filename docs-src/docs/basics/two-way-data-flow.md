---
title: Two-way Data Flow
description: Introduction on bi-directional data flow
sidebar_position: 5
---

# Two-Way Data Flow

In all the examples we've seen till this point, data always flows in a
single direction. Now we'll introduce two-way data flow which allows
data to flow in both directions between a pair of cells.

## Mutable Computed Cells

A *Mutable computed cell* is a cell which ordinarily functions like a
normal computed cell, created with `ValueCell.computed`, but can also
have its value changed by setting its `value` property as though it is
a `MutableCell`. When the value of a mutable computed cell is set, it
*reverses* the computation by setting the argument cells to a value
such that when the mutable computed cell is recomputed, the same value
will be produced as the value that was set. Thus mutable computed
cells support two-way data flow, which is what sets **Live Cells**
apart from other reactive state management libraries.

Mutable computed cells are created using `MutableCell.computed`, which
takes the computation function and reverse computation function. The
computation function computes the cell's value as a function of
argument cells, like `ValueCell.computed`. The reverse computation
function *reverses* the computation by assigning a value to the
argument cells. It is given the value that was assigned to the `value`
property.

Example:

```dart title="Mutable computed cell example"
final a = MutableCell<num>(0);

final strA = MutableCell.computed(() => a().toString(), (value) {
  a.value = num.tryParse(value) ?? 0;
});
```

The mutable computed cell `strA` converts the value of its argument
cell `a` to a string. When the value of `strA` is set:

1. A `num` is parsed from the value.
2. The value of `a` is set to the parsed `num` value.

``` title="Mutable computed cell"
strA.value = '100';
print(a.value + 1); // Prints: 101
```

This definition will prove useful when implementing a text field for
numeric input. In-fact, this library already provides a definition for
this cell with the `mutableString` extension method on `MutableCell`'s
holding `int`, `double` and `num` values.

```dart title="Example of mutableString()"
final a = MutableCell<num>(0);
final strA = a.mutableString();
```

Implementing a text field for numeric input is as simple as binding
the `mutableString` cell to the *content* property of a
`CellTextField`:

```dart title="Text field for numeric input"
CellWidget.builder((_) {
  final a = MutableCell<num>(0);
  final square = a * a;
    
  return Column(
    children: [
      CellTextField(
        content: a.mutableString()  
        keyboardType: TextInputType.number.cell
      ),
      CellText(
        data: ValueCell.computed(
          () => '${a()}^2 = ${square()}'
        )
      )
    ]
  );
});
```

An integer is parsed from the `CellTextField`, it's square is computed
and displayed in a `CellText` below it.

:::info
An explicit generic type parameter is given to `MutableCell` to allow
it to store all numeric values, not just integers, which is the
deduced type of its initial value `0`.
:::

Here's a larger example containing two text fields for numeric input,
a widget which displays the sum of the two numbers entered and a
"Reset" button:

```dart title="Text field for numeric input"
CellWidget.builder((_) {
  final a = MutableCell<num>(0);
  final b = MutableCell<num>(0);
    
  final sum = a + b;
    
  return Column(
    children: [
      Row(
        children: [
          CellTextField(
            content: a.mutableString(),
            keyboardType: TextInputType.number.cell
          ),
          SizedBox(width: 5),
          Text('+'),
          SizedBox(width: 5),
          CellTextField(
            content: b.mutableString(),
            keyboardType: TextInputType.number.cell
          ),
        ],
      ),
      CellText(
        data: ValueCell.computed(
          () => '${a()} + ${b()} = ${sum()}'
        )
      ),
      ElevatedButton(
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

In this example two `CellTextField`s are defined with their content
cells bound to the `mutableString()` of cells `a` and `b`,
respectively. This allows us to handle the input provided in the
fields as numbers rather than strings.

The `sum` computed cell, defined by a cell expression, computes the
sum of `a` and `b`. The values of cells `a`, `b` and `sum` are
displayed in a `CellText` below the fields.

The "Reset" button resets both fields by setting the value of `a` and
`b` to `0`. Consequently, this also resets the sum and the value
displayed in the `CellText`.

:::info
`MutableCell.batch` was used when resetting the fields, in order to
reset both fields simultaneously.
:::

Without mutable computed cells and two-way data flow, this example
would require that an `onChanged` event callback is added on the
fields which does the parsing logic and then updates the values of the
cells. Once again with we were able to implement all our logic in a
declarative manner without a single `onChanged` callback.

The benefits of using `CellTextField` and mutable computed cells are:

* No need for a `TextEditingController` which you have to remember to `dispose`.
* No manual synchronization of state between the `TextEditingController` and the widget `State` / 
  `ChangeNotifier` object. Your state is instead stored in one place and in one representation.
* No need to use `StatefulWidget` or make ugly empty calls to `setState(() {})` to force the widget
  to update when the `text` property of the `TextEditingController` is updated.

## Fun with Mutable Computed Cells

Let's say we want the user to be able to enter the result of the addition and have the values for
`a` and `b` automatically computed and displayed in the corresponding fields:

We can do this with another mutable computed cell, this time with two arguments:

```dart title="Multi-argument mutable computed cell"
final sum = MutableCell.computed(() => a() + b(), (sum) {
  final half = sum / 2;

  a.value = half;
  b.value = half;
});
```

The reverse computation function assigns the sum divided by two to
both cells `a` and `b`.

All that we need to do add this functionality to the previous example,
is to add a `CellTextField` and bind its content to the `sum` cell.

Here's the full example with a `CellTextField` for the result of the addition:

```dart title="Multi-argument mutable computed cell"
CellWidget.builder((_) {
  final a = MutableCell<num>(0);
  final b = MutableCell<num>(0);
    
  final sum = MutableCell.computed(() => a() + b(), (sum) {
    final half = sum / 2;
    a.value = half;
    b.value = half;
  });
    
  return Column(
    children: [
      Row(
        children: [
          CellTextField(
            content: a.mutableString(),
            keyboardType: TextInputType.number.cell
          ),
          SizedBox(width: 5),
          Text('+'),
          SizedBox(width: 5),
          CellTextField(
            content: b.mutableString(),
            keyboardType: TextInputType.number.cell
          ),
          SizedBox(width: 5),
          Text('='),
          SizedBox(width: 5),
          CellTextField(
            content: sum.mutableString(),
            keyboardType: TextInputType.number.cell
          )
        ],
      )
    ]
  );
});
```
* Entering a value in the fields for `a` and `b` will result in the
  `sum` being recomputed and displayed in its field.
* Entering a value in the field for the `sum` results in the values for
  `a` and `b` being updated such that their sum equals the value entered.
