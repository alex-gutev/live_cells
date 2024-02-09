import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cell_annotations/live_cell_annotations.dart';

import '../cell_widget/cell_widget.dart';

@GenerateCellWidgets([
  WidgetSpec<Align>(
    includeSuperProperties: [#child],

    documentation: '''An [Align] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Align],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedAlign>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedAlign] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedAlign],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedContainer>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedContainer] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedContainer],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedDefaultTextStyle>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedDefaultTextStyle] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedDefaultTextStyle],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedOpacity>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedOpacity] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedOpacity],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedPhysicalModel>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedPhysicalModel] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedPhysicalModel],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedPositioned>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedPositioned] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedPositioned],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AnimatedSize>(
      includeSuperProperties: [#curve, #duration, #onEnd],

      documentation: '''An [AnimatedSize] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AnimatedSize],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<AspectRatio>(
    includeSuperProperties: [#child],
    documentation: '''An [AspectRatio] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [AspectRatio],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<BackdropFilter>(
    includeSuperProperties: [#child],

    documentation: '''A [BackdropFilter] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [BackdropFilter],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Badge>(
    documentation: '''A [Badge] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Badge],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Baseline>(
    includeSuperProperties: [#child],
    documentation: '''A [Baseline] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Baseline],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Card>(
    documentation: '''A [Card] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Card],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Center>(
    includeSuperProperties: [#widthFactor, #heightFactor, #child],

    documentation: '''A [Center] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Center],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
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

  WidgetSpec<Chip>(
    documentation: '''A [Chip] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Chip],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<CircularProgressIndicator>(
      includeSuperProperties: [
        #value,
        #backgroundColor,
        #color,
        #valueColor,
        #semanticsLabel,
        #semanticsValue
      ],

      propertyDefaultValues: {
        #strokeAlign: '0.0'
      },

      documentation: '''A [CircularProgressIndicator] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [CircularProgressIndicator],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<ClipOval>(
      includeSuperProperties: [#child],

      documentation: '''A [ClipOval] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [ClipOval],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<ClipPath>(
      includeSuperProperties: [#child],

      documentation: '''A [ClipPath] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [ClipPath],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<ClipRect>(
      includeSuperProperties: [#child],

      documentation: '''A [ClipRect] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [ClipRect],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<ConstrainedBox>(
      includeSuperProperties: [#child],

      documentation: '''A [ConstrainedBox] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [ConstrainedBox],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Container>(
      documentation: '''A [Container] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Container],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<CupertinoActivityIndicator>(
      propertyDefaultValues: {
        #radius: '10.0'
      },

      documentation: '''A [CupertinoActivityIndicator] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [CupertinoActivityIndicator],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<CupertinoListSection>(
      propertyDefaultValues: {
        #margin: 'EdgeInsets.only(bottom: 8.0)',
        #dividerMargin: '20.0',
        #topMargin: '22.0',
      },

      documentation: '''A [CupertinoListSection] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [CupertinoListSection],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),
  
  WidgetSpec<CupertinoPageScaffold>(
      documentation: '''A [CupertinoPageScaffold] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [CupertinoPageScaffold],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<CupertinoPopupSurface>(
      documentation: '''A [CupertinoPopupSurface] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [CupertinoPopupSurface],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<CupertinoSlider>(
      mutableProperties: [#value],
      excludeProperties: [#onChanged],

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],

      propertyValues: {
        #onChanged: 'enabled() ? (v) => value.value = v : null'
      },

      documentation: '''A [CupertinoSlider] with its [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction. 
When the value of the cell changes, the slider position is updated to reflect 
the value of the cell. Similarly when the slider is moved by the user, the 
value of the cell is updated to reflect the slider position.'''
  ),

  WidgetSpec<CupertinoSwitch>(
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

      documentation: '''A [CupertinoSwitch] widget with its [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the switch state is updated to reflect the
value of the cell. Similarly when the state of the switch is changed by the
user, the value of the cell is updated to reflect the state.
'''

  ),

  WidgetSpec<DecoratedBox>(
      includeSuperProperties: [#child],

      documentation: '''A [DecoratedBox] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [DecoratedBox],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<DefaultTextStyle>(
      includeSuperProperties: [#child],

      documentation: '''A [DefaultTextStyle] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [DefaultTextStyle],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Divider>(
      documentation: '''A [Divider] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Divider],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<ExcludeSemantics>(
      includeSuperProperties: [#child],

      documentation: '''An [ExcludeSemantics] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [ExcludeSemantics],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<FittedBox>(
      includeSuperProperties: [#child],

      documentation: '''A [FittedBox] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [FittedBox],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<FractionalTranslation>(
      includeSuperProperties: [#child],

      documentation: '''A [FractionalTranslation] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [FractionalTranslation],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<FractionallySizedBox>(
      includeSuperProperties: [#child],

      documentation: '''A [FractionallySizedBox] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [FractionallySizedBox],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<Icon>(
      documentation: '''An [Icon] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [Icon],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<IgnorePointer>(
      includeSuperProperties: [#child],
      documentation: '''An [IgnorePointer] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [IgnorePointer],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<IntrinsicHeight>(
      includeSuperProperties: [#child],
      documentation: '''An [IntrinsicHeight] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [IntrinsicHeight],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<IntrinsicWidth>(
      includeSuperProperties: [#child],
      documentation: '''An [IntrinsicWidth] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [IntrinsicWidth],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<LimitedBox>(
      includeSuperProperties: [#child],
      documentation: '''A [LimitedBox] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [LimitedBox],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<LinearProgressIndicator>(
      includeSuperProperties: [
        #value,
        #backgroundColor,
        #color,
        #semanticsLabel,
        #semanticsValue
      ],

      documentation: '''A [LinearProgressIndicator] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [LinearProgressIndicator],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

  WidgetSpec<ListTile>(
      documentation: '''A [ListTile] widget with its properties controlled by [ValueCell]'s.

The constructor takes the same arguments as the unnamed constructor of [ListTile],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.'''
  ),

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