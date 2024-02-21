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
    final content = c.cell(() => MutableCell(''));
    
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
    .data(content) // Copy CellText with `data` bound to `content`
    .style(style); // Copy CellText with a new binding for `style`
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
    final state = c.cell(() => MutableCell(false));
    final text = c.cell(() => state.select(
        'The switch is on'.cell,
        'The switch is off'.cell
    ));
    
    return Column(
        children: [
            CellText(data: text),
            CellSwitch(value: state),
        ]
    );
});
```

In this example:

* The state (`value`) of the switch is bound to cell `state`. 
* The `state` cell is used by cell `text` to select between two
  strings describing the state of the switch.
* The content (`data`) of the `CellText` widget is bound to cell `text`.

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
    final content = c.cell(() => MutableCell(''));
    
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

## Static Widgets

What has probably become an annoyance throughout these examples is
having to use the `cell` method to create the cells which are bound to
widget properties. In these examples we don't need to observe the
values of cells directly in the `CellWidget`, nor does the structure
of the widget change between builds. This is where `StaticWidget`
comes in handy.

`StaticWidget.builder` creates a widget with a build function that is
only called when the widget is inserted in the tree for the first
time. When the `StaticWidget` is rebuilt, the same widget that was
returned by the build function during the first build is
returned. This allows us to define our cells directly in the build
function without having to use the `cell` method.

With `StaticWidget` the `CellSwitch` example becomes:

```dart title="StaticWidget example"
StaticWidget.builder((c) {
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

And the `CellTextField` example becomes:

```dart title="CellText example with StaticWidget"
StaticWidget.builder((c) {
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

:::tip
Subclassing `StaticWidget` and overriding the `build`
method is equivalent to using `StaticWidget.builder`.
:::

If you know that your widget is only going to be used inside a
`StaticWidget`, you can define your widget entirely as a function:

```dart title="CellText example as a function"
Widget example() {
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
}
```

:::danger

Do not conditionally select a `build` function that is passed to
`StaticWidget.builder`. If the condition changes the widget will not
be rebuilt with the new build function (in-fact it is not rebuilt at
all).

**Don't do this:**

```dart
StaticWidget.builder(cond ? (c) { ... } : (c) { ... })
```

**Don't do this either:**

```dart
cond ? StaticWidget.builder(...) : StaticWidget.builder(...)
```

:::
