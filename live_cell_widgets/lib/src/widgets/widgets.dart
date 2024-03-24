import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:live_cell_widgets/src/extensions/widget_extension.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cell_annotations/live_cell_annotations.dart';
import 'package:live_cells_core/live_cells_internals.dart';

import '../cell_widget/cell_widget.dart';

@GenerateCellWidgets([
  WidgetSpec<AbsorbPointer>(),

  WidgetSpec<Align>(
    includeSuperProperties: [#child],
  ),

  WidgetSpec<AnimatedAlign>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedContainer>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedCrossFade>(
      propertyDefaultValues: {
        #layoutBuilder: 'AnimatedCrossFade.defaultLayoutBuilder'
      },
  ),

  WidgetSpec<AnimatedDefaultTextStyle>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedFractionallySizedBox>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedOpacity>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedPhysicalModel>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedPositioned>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedPositionedDirectional>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedRotation>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedScale>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedSize>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedSlide>(
      includeSuperProperties: [#curve, #duration, #onEnd],
  ),

  WidgetSpec<AnimatedSwitcher>(
      propertyTypes: {
        #layoutBuilder: 'AnimatedSwitcherLayoutBuilder'
      },
  ),

  WidgetSpec<AnnotatedRegion>(
      typeArguments: ['T extends Object'],
      includeSuperProperties: [#child],

      propertyTypes: {
        #value: 'T'
      },
  ),

  WidgetSpec<AspectRatio>(
    includeSuperProperties: [#child],
  ),

  WidgetSpec<BackdropFilter>(
    includeSuperProperties: [#child],
  ),

  WidgetSpec<Badge>(),

  WidgetSpec<Baseline>(
    includeSuperProperties: [#child],
  ),

  WidgetSpec<Card>(
  ),

  WidgetSpec<Center>(
    includeSuperProperties: [#widthFactor, #heightFactor, #child],
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

  WidgetSpec<Chip>(),

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
  ),

  WidgetSpec<ClipOval>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<ClipPath>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<ClipRect>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<Column>(
      includeSuperProperties: [
        #mainAxisAlignment,
        #mainAxisSize,
        #crossAxisAlignment,
        #textDirection,
        #verticalDirection,
        #textBaseline,
        #children
      ],

      propertyValues: {
        #children: 'children.cellList().map((e) => e.widget()).toList()'
      },
  ),

  WidgetSpec<ConstrainedBox>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<Container>(),

  WidgetSpec<CupertinoActivityIndicator>(
      propertyDefaultValues: {
        #radius: '10.0'
      },
  ),

  WidgetSpec<CupertinoListSection>(
      propertyDefaultValues: {
        #margin: 'EdgeInsets.only(bottom: 8.0)',
        #dividerMargin: '20.0',
        #topMargin: '22.0',
      },
  ),
  
  WidgetSpec<CupertinoPageScaffold>(),

  WidgetSpec<CupertinoPopupSurface>(),

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
  ),

  WidgetSpec<DefaultTextStyle>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<Divider>(),

  WidgetSpec<ElevatedButton>(
      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            defaultValue: 'true',
            optional: false,
            documentation: 'Is the widget enabled for user input?'
        ),
        WidgetPropertySpec<void>(
            name: #press,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() && press != null ? _pressActionCell(context).trigger : null',
        #onLongPress: 'enabled() && longPress != null ? _longPressActionCell(context).trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      mixins: [#_MaterialButtonMixin],
      baseClass: #_WrapperInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''An [ElevatedButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [ElevatedButton],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.

Instead of taking callback functions for [onPressed] and [onLongPress], the
constructor accepts [MetaCell]'s that are set to [ActionCell]s which are
triggered when the button is pressed and long pressed respectively. Similarly,
[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange].
'''
  ),

  WidgetSpec<ExcludeSemantics>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<FilledButton>(
      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            defaultValue: 'true',
            optional: false,
            documentation: 'Is the widget enabled for user input?'
        ),
        WidgetPropertySpec<void>(
            name: #press,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() && press != null ? _pressActionCell(context).trigger : null',
        #onLongPress: 'enabled() && longPress != null ? _longPressActionCell(context).trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      mixins: [#_MaterialButtonMixin],
      baseClass: #_WrapperInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''A [FilledButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [FilledButton],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.

Instead of taking callback functions for [onPressed] and [onLongPress], the
constructor accepts [MetaCell]'s that are set to [ActionCell]s which are
triggered when the button is pressed and long pressed respectively. Similarly,
[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange].
'''
  ),

  WidgetSpec<FittedBox>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<FractionalTranslation>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<FractionallySizedBox>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<Icon>(),

  WidgetSpec<IgnorePointer>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<IntrinsicHeight>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<IntrinsicWidth>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<LimitedBox>(
      includeSuperProperties: [#child],
  ),

  WidgetSpec<LinearProgressIndicator>(
      includeSuperProperties: [
        #value,
        #backgroundColor,
        #color,
        #semanticsLabel,
        #semanticsValue
      ],
  ),

  WidgetSpec<ListTile>(),

  WidgetSpec<Text>(
    as: #CellText,
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
  ),

  WidgetSpec<Row>(
      includeSuperProperties: [
        #mainAxisAlignment,
        #mainAxisSize,
        #crossAxisAlignment,
        #textDirection,
        #verticalDirection,
        #textBaseline,
        #children
      ],

      propertyValues: {
        #children: 'children.cellList().map((e) => e.widget()).toList()'
      },
  ),

  WidgetSpec<OutlinedButton>(
      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            defaultValue: 'true',
            optional: false,
            documentation: 'Is the widget enabled for user input?'
        ),
        WidgetPropertySpec<void>(
            name: #press,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() && press != null ? _pressActionCell(context).trigger : null',
        #onLongPress: 'enabled() && longPress != null ? _longPressActionCell(context).trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      mixins: [#_MaterialButtonMixin],
      baseClass: #_WrapperInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''An [OutlinedButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [OutlinedButton],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.

Instead of taking callback functions for [onPressed] and [onLongPress], the
constructor accepts [MetaCell]'s that are set to [ActionCell]s which are
triggered when the button is pressed and long pressed respectively. Similarly,
[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange].
'''
  ),

  WidgetSpec<TextButton>(
      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            defaultValue: 'true',
            optional: false,
            documentation: 'Is the widget enabled for user input?'
        ),
        WidgetPropertySpec<void>(
            name: #press,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an ActionCell that is triggered when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for an cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() && press != null ? _pressActionCell(context).trigger : null',
        #onLongPress: 'enabled() && longPress != null ? _longPressActionCell(context).trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      mixins: [#_MaterialButtonMixin],
      baseClass: #_WrapperInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''A [TextButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [TextButton],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.

Instead of taking callback functions for [onPressed] and [onLongPress], the
constructor accepts [MetaCell]'s that are set to [ActionCell]s which are
triggered when the button is pressed and long pressed respectively. Similarly,
[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange].
'''
  ),

  WidgetSpec<Visibility>(
      includeSuperProperties: [#child],
  ),
])
part 'widgets.g.dart';

part 'wrapper_interface.dart';
part 'mixins.dart';
