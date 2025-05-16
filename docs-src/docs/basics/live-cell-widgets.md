---
title: Live Cell Widgets
description: Live cell widgets library
sidebar_position: 4
---

# Live Cell Widgets

Besides the core cell functionality, this package comes with a
`live_cells_ui` library which provides a collection of widgets that
extend the stock Flutter widgets with functionality which allows their
properties to be observed and controlled by cells.

:::tip
The name of a Live Cells equivalent of a Flutter widget is `Live`
followed by the name of the widget class.
:::

When a cell is given as a parameter for a widget property, the
property is said to be bound to the cell. This means that when the
value of the cell changes, the value of the property is automatically
updated to reflect the value of the cell. Similarly, when the value of
the property changes due to user interaction, the value of the cell is
updated to reflect the state of the widget.

For example the `LiveSwitch` widget is a `Switch` which takes a cell
for its `value` property.

```dart title="LiveSwitch example"
CellWidget.builder((c) {
    final state = MutableCell(false);
    
    return Column(
        children: [
            Text(state() ? 'On' : 'Off'),
            LiveSwitch(
                value: state
            ),
            FilledButton(
                child: Text('Reset'),
                onPressed: () => state.value = false
            )
        ]
    );
});
```

In this example:

1. A `LiveSwitch` is created with its `value` property bound to the
   cell `state`.
   
2. The initial value of the `state` cell is `false` hence the switch
   is initially in the *off* position.
   
3. The state of the switch, initially "Off" is displayed in a `Text`
   widget above the switch.
   
4. When the switch is turned to on by the user, the value of the
   `state` cell is updated to `true` and "On" is displayed in the
   `Text` widget.
   
5. Likewise, when the switch is turned off the value of the `state`
   cell is updated to `false` and "Off" is displayed in the `Text`
   widget.

The "Reset" button below the switch sets the value of the `state` cell
to `false`, which results in the switch widget resetting to the *off*
position and "Off" being displayed.

Notice that user input was handled entirely in a declarative
manner. There was no need to provide an `onChanged` callback, nor any
need to call `setState`.

## Text Fields

`LiveTextField` is another widget provided by this library that allows
user input to be observed and handled using cells. Unlike `TextField`
which takes a `TextEditingController`, `LiveTextField` takes a
`content` cell which is bound to the content of the field. It also
takes an optional `selection` cell which is bound to the selection.

The `content` cell can be used both to observe and set the content of
the field. Here's a simple example that echoes whatever is written in
the field to a `Text` widget.

```dart title="LiveTextField example"
CellWidget.builder((c) {
    final content = MutableCell('');
    
    return Column(
        children: [
            Text(content()),
            LiveTextField(
                content: content
            ),
            FilledButton(
                child: Text('Clear'),
                onPressed: () => content.value = ''
            )
        ]
    );
});
```

Like the `LiveSwitch` example, we didn't need an `onChanged` callback
nor did we need to add a listener to a `TextEditingController`
object. The "Clear" button clears the content of the text field by
setting the value of the `content` cell to the empty string.

:::caution
If you provide a cell for the `selection` property of `LiveTextField`,
it has to be reset as well as the content cell when clearing the text field.
:::
