import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cell_annotations/live_cell_annotations.dart';

@GenerateCellWidgets([
  WidgetSpec<Text>(
    as: #CellText,
    documentation: '''A [Text] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Text],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.
'''
  ),

  WidgetSpec<Checkbox>(
    as: #CellCheckbox,
    mutableProperties: [#value],
    excludeProperties: [#onChanged],
    propertyValues: {
      #onChanged: 'enabled() ? (v) => value.value = v : null',
    },
    addProperties: [
      WidgetPropertySpec<bool>(
          name: #enabled,
          optional: false,
          defaultValue: 'true',

          documentation: 'Is the widget enabled for user input?'
      )
    ],

    documentation: '''A [Checkbox] widget with the [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the checkbox state is updated to reflect the
value of the cell. Similarly when the state of the checkbox is changed by the
user, the value of the cell is updated to reflect the state.
'''
  ),

  WidgetSpec<CheckboxListTile>(
      as: #CellCheckboxListTile,
      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      propertyValues: {
        #onChanged: 'enabled?.call() ?? true ? (v) => value.value = v : null',
      },

      documentation: '''A [ListTile] with a [CellCheckbox], akin to [CheckboxListTile].

See [CellCheckbox] for a more detailed explanation.
'''
  ),

  WidgetSpec<Slider>(
      as: #CellSlider,
      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      propertyValues: {
        #onChanged: 'enabled() ? (v) => value.value = v : null',
      },
      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],

      documentation: '''A [Slider] with its [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction. 
When the value of the cell changes, the slider position is updated to reflect 
the value of the cell. Similarly when the slider is moved by the user, the 
value of the cell is updated to reflect the slider position.
'''
  ),

  WidgetSpec<Switch>(
      as: #CellSwitch,
      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      propertyValues: {
        #onChanged: 'enabled() ? (v) => value.value = v : null',
      },
      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],

      documentation: '''A [Switch] widget with its [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the switch state is updated to reflect the
value of the cell. Similarly when the state of the switch is changed by the
user, the value of the cell is updated to reflect the state.
'''
  ),

  WidgetSpec<SwitchListTile>(
      as: #CellSwitchListTile,
      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      propertyValues: {
        #onChanged: 'enabled() ? (v) => value.value = v : null',
      },

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],


      documentation: '''A [ListTile] with a [CellSwitch], akin to [SwitchListTile].

See [CellSwitch] for a more detailed explanation.
'''
  ),

  WidgetSpec<Radio>(
      as: #CellRadio,
      typeArguments: ['T'],
      mutableProperties: [#groupValue],
      excludeProperties: [#onChanged],

      propertyTypes: {
        #value: 'T',
        #groupValue: 'T?'
      },
      propertyValues: {
        #onChanged: 'enabled() ? (v) => groupValue.value = v : null',
      },

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],

      documentation: '''A [Radio] widget with its [groupValue] controlled by a [ValueCell].

The [groupValue] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the radio button state is updated to reflect the
value of the cell. Similarly when the selected radio button is changed by the
user, the value of the [groupValue[ cell is updated to reflect the [value] of
the selected button.
'''
  ),

  WidgetSpec<RadioListTile>(
      as: #CellRadioListTile,
      typeArguments: ['T'],
      mutableProperties: [#groupValue],
      excludeProperties: [#onChanged],

      propertyTypes: {
        #value: 'T',
        #groupValue: 'T?'
      },
      propertyValues: {
        #onChanged: 'enabled() ? (v) => groupValue.value = v : null',
      },

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],


      documentation: '''A [ListTile] with a [CellRadio], akin to [RadioListTile].

See [CellRadio] for a more detailed explanation.
'''
  ),
])
part 'widgets.g.dart';