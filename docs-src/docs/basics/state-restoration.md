---
title: State Restoration
description: How to save and restore the state of cells
sidebar_position: 7
---

# State Restoration

A mobile application may be terminated at any point when the user is
not interacting with it. When it is resumed, due to the user
navigating back to it, it should restore its state to the point where
it was when terminated.

## Restoration ID

For the most part all you need to do to restore the state of your
cells is to provide a `restorationId` when creating the `CellWidget`
or `StaticWidget`. The `restorationId` associates the saved state with
the widget, See
[`RestorationMixin.restorationId`](https://api.flutter.dev/flutter/widgets/RestorationMixin/restorationId.html),
for more information.

When a `restorationId` is given to `CellWidget.builder`, the state of
the cells created using `BuildContext.cell` will be saved and restored
automatically.

Here is a simple example:

```dart title="Cell state restoration using CellWidget"
Widget example() => CellWidget.builder((ctx) {
    final sliderValue = ctx.cell(() => MutableCell(0.0));
    final switchValue = ctx.cell(() => MutableCell(false));
    final checkboxValue = ctx.cell(() => MutableCell(true));

    final textValue = ctx.cell(() => MutableCell(''));

    return Column(
      children: [
        Text('A Slider'),
        Row(
          children: [
            CellWidget.builder((context) => Text(sliderValue().toStringAsFixed(2))),
            Expanded(
              child: CellSlider(
                 min: 0.0.cell,
                 max: 10.cell,
                 value: sliderValue
              ),
            )
          ],
        ),
        CellSwitchListTile(
          value: switchValue,
          title: Text('A Switch').cell,
        ),
        CellCheckboxListTile(
          value: checkboxValue,
          title: Text('A checkbox').cell,
        ),
        const Text('Enter some text:'),
        CellTextField(content: textValue),
        CellWidget.builder((context) => Text('You wrote: ${textValue()}')),
      ],
    );
  },
  
  restorationId: 'cell_restoration_example'
);
```

Notice the `restorationId` argument, provided after the widget builder
function.

:::tip
If you're subclassing `CellWidget`, provide the `restorationId` in the
call to the super class constructor.
:::

The `build` method defines four widgets, a slider, a switch, a
checkbox and a text field as well as four cells, creating using `cell`
for holding the state of the widgets. The code defining the cells is
exactly the same as it would be without state restoration, however
when the app is resumed the state of the cells, and likewise the
widgets which are dependent on the cells, is restored.

:::info
* `CellSlider`, `CellSwitchListTile` and `CellCheckboxListTile` are
  the live cell equivalents, provided by `live_cell_widgets`, of
  `Slider`, `SwitchListTile` and `CheckboxListTile` which allow their
  state to be controlled by a `ValueCell`.
* You can use any widgets not just those provided by
  `live_cell_widgets`. The state of the cells defined by
  `RestorableCellWidget.cell` will be restored regardless of the
  widgets you use.
:::


In order for cell state restoration to be successful, the following has to be taken into account:

* Only cells implementing the `RestorableCell` interface can have
  their state restored. All cells provided by **Live Cells** implement
  this interface except:
  + *Lightweight computed cells*, which do not have a state
  + `DelayCell`
* The values of the cells to be restored must be encodable by
  `StandardMessageCodec`. This means that only cells holding primitive
  values (`num`, `bool`, `null`, `String`, `List`, `Map`) can have
  their state saved and restored.
* To support state restoration of cells holding values not supported
  by `StandardMessageCodec`, a `CellValueCoder` has to be provided.

:::important
If a cell holds a non-restorable value pass `restorable: false` to
`.cell(...)`. This prevents the cell's state from being saved and restored.
:::

## User-Defined Types

`CellValueCoder` is an interface for encoding (and decoding) a value to a primitive value
representation that is supported by `StandardMessageCodec`. Two methods have to be implemented:

* `encode()` which takes a value and encodes it to a primitive value representation
* `decode()` which decodes a value from its primitive value representation

The following example demonstrates state restoration of a radio button
group using a `CellValueCoder` to encode the *group value* which is an
`enum`.

```dart title="CellValueCoder example"
enum RadioValue {
  value1,
  value2,
  value3
}

class RadioValueCoder implements CellValueCoder {
  @override
  RadioValue? decode(Object? primitive) {
    if (primitive != null) {
      final name = primitive as String;
      return RadioValue.values.byName(name);
    }

    return null;
  }

  @override
  Object? encode(covariant RadioValue? value) {
    return value?.name;
  }
}

Widget example() => CellWidget.builder((ctx) => {
    final radioValue = cell(
       () => MutableCell<RadioValue?>(RadioValue.value1),
       coder: RadioValueCoder.new
    );

    return Column(
      children: [
        const Text('Radio Buttons:',),
        CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),
        Column(
          children: [
            CellRadioListTile(
              groupValue: radioValue,
              value: RadioValue.value1.cell,
              title: Text('value1').cell,
            ),
            CellRadioListTile(
              groupValue: radioValue,
              value: RadioValue.value2.cell,
              title: Text('value2').cell,
            ),
            CellRadioListTile(
              groupValue: radioValue,
              value: RadioValue.value3.cell,
              title: Text('value3').cell,
            ),
          ],
        ),
      ],
    );
  },
  
  restorationId: 'cell_restoration_example'
);
```

`RadioValueCoder` is a `CellValueCoder` subclass which encodes the
`RadioValue` enum class to a string. In the definition of the
`radioValue` cell, the constructor of `RadioValueCoder`
(`RadioValueCoder.new`) is provided to `cell()` in the `coder`
argument.

## State Restoration in StaticWidget

Like with `CellWidget`, to achieve cell state restoration inside a
`StaticWidget` a `restorationId` has to be provided when creating the
widget. Unlike `CellWidget`, where cells are created using the `cell`
method, the `restore` method has to be called on all cells which need
to have their state restored.

The `CellRadio` example using `StaticWidget`:

```dart title="State Restoration using StaticWidget"
Widget example() => StaticWidget.builder((_) => {
    final radioValue = MutableCell<RadioValue?>(RadioValue.value1)
        .restore(coder: RadioValueCoder());

    return Column(
      children: [
        const Text('Radio Buttons:',),
        CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),
        Column(
          children: [
            CellRadioListTile(
              groupValue: radioValue,
              value: RadioValue.value1.cell,
              title: Text('value1').cell,
            ),
            CellRadioListTile(
              groupValue: radioValue,
              value: RadioValue.value2.cell,
              title: Text('value2').cell,
            ),
            CellRadioListTile(
              groupValue: radioValue,
              value: RadioValue.value3.cell,
              title: Text('value3').cell,
            ),
          ],
        ),
      ],
    );
  },
  
  restorationId: 'cell_restoration_example'
);
```

:::tip
If you're subclassing `StaticWidget`, provide the `restorationId` in the
call to the super class constructor.
:::

:::danger[Important]
The `restore()` method should only be called directly within a
`CellWidget` or `StaticWidget` with a non-null `restorationId`.
:::

## Recomputed Cell State

If a cell's value is not restored, its value is recomputed. As a
result, it is not necessary to save the value of a cell, if it can be
recomputed.

Example:

```dart title="Recomputed Cell State"
Widget example() => StaticWidget.builder((_) {
    final numValue = MutableCell<num>(1).restore();
    final numMaybe = numValue.maybe();
    final numError = numMaybe.error;

    final numStr = numMaybe.mutableString()
        .restore();

    return Column(
      children: [
        const Text('Text field for numeric input:'),
        CellTextField(
          content: numStr,
          decoration: ValueCell.computed(() => InputDecoration(
            errorText: numError() != null
               ? 'Not a valid number'
               : null
          )),
        ),
        const SizedBox(height: 10),
        CellWidget.builder((context) {
          final a1 = context.cell(() => numValue + 1.cell);
          return Text('${numValue()} + 1 = ${a1()}');
        }),
        ElevatedButton(
          child: const Text('Reset'),
          onPressed: () => numValue.value = 1
        )
      ],
    );
  },
  
  restorationId: 'cell_restoration_example'
);
```

The above is an example of a text field for numeric input with error
handling. The only cells in the above example which have their state
restored are `numValue`, the cell holding the numeric value that was
entered in the field, and `numMaybe.mutableString()` which is the
*content* cell for the text field. When the state of the app is
restored the values of the remaining cells are recomputed, which
in-effect restores their state without it actually being saved.

When you leave the app and return to it, you'll see the exact same
state, including erroneous input and the associated error message, as
when you left.

Some points to note from this example:

* The `restore` method is called only on those cells we want to have
  their state restored.

* Computed cells don't require their state to be saved, e.g. the state
  of the `a1` cell is not saved, however it is *restored* (the same
  state is recomputed on launch) nevertheless.

As a general rule of thumb only mutable cells which are either set
directly, such as `numValue` which has its value set in the "Reset"
button, or hold user input from widgets, such as the content cells of
text fields, are required to have their state saved.
