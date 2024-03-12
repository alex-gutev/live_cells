---
title: Live Cell Widgets
description: Live cell widgets library
sidebar_position: 4
---

# Live Cell Widgets

Besides the core cell functionality, this library also comes with a
collection of widgets that extend the stock Flutter widgets with
functionality which allows their properties to be accessed and
controlled by cells.

Quite a mouthful. Let's start with the simple `Text` widget for
displaying text. Live cells provides a `CellText` widget with a
constructor that takes the same parameters as the constructor of
`Text` but allows `ValueCell`s to be given instead of the raw values.

:::tip
The name of a Live Cells equivalent of a Flutter widget is `Cell`
followed by the name of the widget class.
:::

When a cell is given as a parameter for a widget property, the
property is said to be bound to the cell. This means that when the
value of the cell changes, the value of the property is automatically
updated to reflect the value of the cell.

```dart title="CellText example"
CellWidget.builder((c) {
    final content = MutableCell('');
    
    return Column(
        children: [
            CellText(data: content),
            ElevatedButton(
                child: Text('Say Hi'),
                onPressed: () => content.value = 'Hi!'
            )
        ]
    );
});
```

In the example above a `CellText` is created with its data property bound to the
cell `content`, which initially holds the empty string. The button
below sets the value of `content` to the string "Hi!". This value is
then displayed in the `CellText` widget.

Every widget provided by live cells also provides a `bind`
method. This method creates a copy of the widget with the properties
bound to different cells.

```dart title="bind method"
final text = CellText()
    .bind(data: content) // Copy CellText with `data` bound to `content`
    .bind(style: style); // Copy CellText with a new binding for `style`
```

## User input

Cells can be used for more than just setting and automatically
updating the values of widget properties. They can also be used to
retrieve and observe the values of widget properties.

Widgets which are used for retrieving input from the user, take
mutable cells for the properties which represent the user input. For
example `CellSwitch`, the Live Cells equivalent of Flutter's `Switch`
takes a mutable cell for its `value` property, which represents the
state of the switch. Setting the value of the cell updates the state
of the switch, similarly when the user changes the state of
the switch, the value of the cell is changed to reflect the state.

```dart title="CellSwitch example"
CellWidget.builder((c) {
    final state = MutableCell(false);
    
    return Column(
        children: [
            CellText(
                data: state.select(
                    'The switch is on'.cell,
                    'The switch is off'.cell
                )
            ),
            CellSwitch(value: state),
        ]
    );
});
```

In this example:

* The state (`value`) of the switch is bound to cell `state`. 
* The content (`data`) of the `CellText` widget is bound to a cell
  that selects between two strings describing the state of the switch
  based on the value of the `state` cell.

Toggling the switch automatically changes the value of the `state`
cell and hence changes the text that is displayed in the `CellText`
widget.

Notice how user input was handled in a declarative manner entirely
using cells. There was no need for `onChanged` callbacks, in-fact
`CellSwitch` doesn't even take an `onChanged` argument.

`CellTextField` is another widget which uses cells to handle user
input. Unlike `TextField` which takes a `TextEditingController`,
`CelltextField` takes a `content` cell which is bound to the content
of the field. It also takes an optional `selection` cell which is
bound to the selection.

The `content` cell can be used both to observe and set the content of
the field. Here's a simple example that echoes whatever is written in
the field to a `CellText` widget.

```dart title="CellTextField example"
CellWidget.builder((c) {
    final content = MutableCell('');
    
    return Column(
        children: [
            CellText(data: content),
            CellTextField(content: content),
            ElevatedButton(
                child: Text('Clear'),
                onPressed: () => content.value = ''
            )
        ]
    );
});
```

Like the `CellSwitch` example, we didn't need an `onChanged` callback
nor did we need to add a listener to a `TextEditingController`
object. This example also adds a "Clear" button which clears the
content of the text field by setting the value of the `content` cell
to the empty string.

:::tip
The approach used to clear the content of the `CellTextField` in this
example, setting the value of the content cell, can also be used to
reset the state of a `CellSwitch` and any other widget property which
is bound to a mutable cell.
:::

:::caution
If you provide a cell for the `selection` property of `CellTextField`,
it has to be reset as well as the content cell when clearing the text field.
:::
