import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_cell_annotations/live_cell_annotations.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';

import '../../live_cell_widgets_base.dart';

part 'mixins.dart';
part 'wrapper_interface.dart';
part 'button_interface.dart';
part 'cell_page_view_mixin.dart';
part 'cell_text_field_mixin.dart';
part 'ink_interface.dart';
part 'live_interactive_viewer_mixin.dart';

@GenerateCellWidgets([
  WidgetSpec<Checkbox>(
      as: #LiveCheckbox,
      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      cellProperties: [#value],
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

      documentation: '''A [Checkbox] widget with the [value] controlled by a [MutableCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the checkbox state is updated to reflect the
value of the cell. Similarly when the state of the checkbox is changed by the
user, the value of the cell is updated to reflect the state.

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<CheckboxListTile>(
      as: #LiveCheckboxListTile,
      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      cellProperties: [#value, #enabled],
      propertyValues: {
        #onChanged: 'enabled?.call() ?? true ? (v) => value.value = v : null',
      },

      documentation: '''A [ListTile] with a [LiveCheckbox], akin to [CheckboxListTile].

See [LiveCheckbox] for a more detailed explanation.
'''
  ),

  WidgetSpec<CheckboxMenuButton>(
      as: #LiveCheckboxMenuButton,
      mutableProperties: [#value],
      excludeProperties: [#onChanged, #onHover, #onFocusChange],
      cellProperties: [#value],
      propertyValues: {
        #onChanged: 'enabled() ? (v) => value.value = v : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      mixins: [#_HoverFocusChangeCellMixin],
      baseClass: #_WrapperInterface,
      buildMethod: #_buildWrappedWidget,

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the focus state of the button changes.'
        )
      ],

      documentation: '''A menu item with a [LiveCheckbox], akin to [CheckboxMenuButton].
  
[MetaCell]s can be provided for the [onHover] and [onFocusChange] properties.
The value of the [onHover] [MetaCell] is set to true, while hovering over the
widget and false otherwise. Similarly the value of the [onFocusChange] [MetaCell]
is set to true, while the widget is focussed.
  
See [LiveCheckbox] for a more detailed explanation.'''
  ),

  WidgetSpec<CheckedPopupMenuItem>(
      as: #LiveCheckedPopupMenuItem,
      typeArguments: ['T'],
      mutableProperties: [#value],
      excludeProperties: [#onTap],
      cellProperties: [#value],

      includeSuperProperties: [
        #value,
        #enabled,
        #padding,
        #height,
        #labelTextStyle,
        #mouseCursor,
        #child
      ],

      propertyTypes: {
        #value: 'T?'
      },

      propertyValues: {
        #onTap: 'tap?.trigger'
      },

      addProperties: [
        WidgetPropertySpec<void>(
            name: #tap,
            defaultValue: null,
            optional: true,
            mutable: true,
            documentation: '[ActionCell] to trigger when the item is tapped.'
        )
      ],

      documentation: '''A [CheckedPopupMenuItem] widget with the [value] controlled by a [MutableCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the checkbox state is updated to reflect the
value of the cell. Similarly when the state of the widget is changed by the
user, the value of the cell is updated to reflect the state.

The [ActionCell] provided in [tap], if not null, is triggered when the item
is tapped.
'''
  ),

  WidgetSpec<ChoiceChip>(
      as: #LiveChoiceChip,
      mutableProperties: [#selected],
      excludeProperties: [#onSelected, #focusNode],
      cellProperties: [#selected],

      propertyValues: {
        #onSelected: 'enabled() ? (v) => selected.value = v : null'
      },
      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            optional: false,
            defaultValue: 'true',

            documentation: 'Is the widget enabled for user input?'
        )
      ],

      documentation: '''A [ChoiceChip] widget with the value of [selected] controlled by a [ValueCell].

The [selected] state is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the widget is updated to reflect the
value of the cell. Similarly when the state of the widget is changed by the
user, the value of the cell is updated to reflect the state.

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<CloseButton>(
      as: #LiveCloseButton,

      includeSuperProperties: [
        #color,
        #style
      ],

      cellProperties: [],

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
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
        ),
      ],

      propertyValues: {
        #onPressed: 'enabled() ? press?.trigger : null',
      },

      documentation: '''A [CloseButton] that triggers an action cell when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).
'''
  ),

  WidgetSpec<CupertinoSlider>(
      as: #LiveCupertinoSlider,

      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      cellProperties: [#value],

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

      documentation: '''A [CupertinoSlider] with its [value] controlled by a [MutableCell].

The [value] is controlled by a [MutableCell] which is passed on construction. 
When the value of the cell changes, the slider position is updated to reflect 
the value of the cell. Similarly when the slider is moved by the user, the 
value of the cell is updated to reflect the slider position.

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<CupertinoSwitch>(
      as: #LiveCupertinoSwitch,

      mutableProperties: [#value],
      excludeProperties: [#onChanged],
      cellProperties: [#value],

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

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<ElevatedButton>(
      as: #LiveElevatedButton,

      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      cellProperties: [],

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
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() ? press?.trigger : null',
        #onLongPress: 'enabled() ? longPress?.trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      baseClass: #_FocusButtonInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''An [ElevatedButton] that triggers an action cell when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed. Similarly, when the button is long-pressed, the action cell
provided in [longPress] is triggered, if it is not null.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).

[MetaCell]s can be provided for the [onHover] and [onFocusChange] properties.
The value of the [onHover] [MetaCell] is set to true, while hovering over the
widget and false otherwise. Similarly the value of the [onFocusChange] [MetaCell]
is set to true, while the widget is focussed.
'''
  ),

  WidgetSpec<FilledButton>(
      as: #LiveFilledButton,

      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],
      cellProperties: [],

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
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() ? press?.trigger : null',
        #onLongPress: 'enabled() ? longPress?.trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      baseClass: #_FocusButtonInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''A [FilledButton] that triggers an action cell when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed. Similarly, when the button is long-pressed, the action cell
provided in [longPress] is triggered, if it is not null.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).

[MetaCell]s can be provided for the [onHover] and [onFocusChange] properties.
The value of the [onHover] [MetaCell] is set to true, while hovering over the
widget and false otherwise. Similarly the value of the [onFocusChange] [MetaCell]
is set to true, while the widget is focussed.
'''
  ),

  WidgetSpec<FloatingActionButton>(
      as: #LiveFloatingActionButton,

      cellProperties: [],

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
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
        ),
      ],

      excludeProperties: [
        #onPressed
      ],

      propertyDefaultValues: {
        #heroTag: 'null'
      },

      propertyValues: {
        #onPressed: 'enabled() ? press?.trigger : null',
      },

      baseClass: #_BaseButtonInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''A [FloatingActionButton] that triggers an [ActionCell] when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).
'''
  ),

  WidgetSpec<IconButton>(
    as: #LiveIconButton,

    excludeProperties: [
      #onHover,
      #onPressed,
      #onLongPress
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
          mutable: true,
          documentation: '[ActionCell] to trigger when the button is pressed.'
      ),
      WidgetPropertySpec<void>(
          name: #longPress,
          defaultValue: null,
          optional: true,
          mutable: true,
          documentation: '[ActionCell] to trigger when the button is long pressed.'
      ),
      WidgetPropertySpec<bool>(
          name: #onHover,
          defaultValue: null,
          optional: true,
          meta: true,
          documentation: 'MetaCell for a cell that is updated whenever the hover state of the button changes.'
      ),
    ],

    propertyValues: {
      #onPressed: 'enabled() ? press?.trigger : null',
      #onLongPress: 'enabled() ? longPress?.trigger : null',
      #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
    },

    baseClass: #_ButtonInterface,
    buildMethod: #_buildWrappedWidget,

    documentation: '''An [IconButton] that triggers an action cell when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed. Similarly, when the button is long-pressed, the action cell
provided in [longPress] is triggered, if it is not null.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).

A [MetaCell] can be provided for the [onHover] property. The value of the 
[MetaCell] is set to true, while hovering over the widget and false otherwise.
'''
  ),

  WidgetSpec<InkWell>(
    as: #LiveInkWell,

    includeSuperProperties: [
      #child,
      #mouseCursor,
      #focusColor,
      #hoverColor,
      #highlightColor,
      #overlayColor,
      #splashColor,
      #splashFactory,
      #radius,
      #borderRadius,
      #customBorder,
      #enableFeedback,
      #excludeFromSemantics,
      #focusNode,
      #canRequestFocus,
      #autofocus,
      #statesController
    ],

    cellProperties: [],

    addProperties: [
      WidgetPropertySpec<bool>(
          name: #enabled,
          defaultValue: 'true',
          optional: false,
          documentation: 'Is the widget enabled for user input?'
      ),
      WidgetPropertySpec<void>(
        name: #tap,
        defaultValue: null,
        optional: true,
        mutable: true
      ),
      WidgetPropertySpec<void>(
          name: #doubleTap,
          defaultValue: null,
          optional: true,
          mutable: true
      ),
      WidgetPropertySpec<void>(
          name: #longPress,
          defaultValue: null,
          optional: true,
          mutable: true
      ),
      WidgetPropertySpec<void>(
          name: #tapCancel,
          defaultValue: null,
          optional: true,
          mutable: true
      ),
      WidgetPropertySpec<TapDownDetails>(
        name: #tapDown,
        defaultValue: null,
        optional: true,
        meta: true
      ),
      WidgetPropertySpec<TapUpDetails>(
          name: #tapUp,
          defaultValue: null,
          optional: true,
          meta: true
      ),
      WidgetPropertySpec<void>(
          name: #secondaryTap,
          defaultValue: null,
          optional: true,
          mutable: true
      ),
      WidgetPropertySpec<void>(
          name: #secondaryTapCancel,
          defaultValue: null,
          optional: true,
          mutable: true
      ),
      WidgetPropertySpec<TapDownDetails>(
          name: #secondaryTapDown,
          defaultValue: null,
          optional: true,
          meta: true
      ),
      WidgetPropertySpec<TapUpDetails>(
          name: #secondaryTapUp,
          defaultValue: null,
          optional: true,
          meta: true
      ),
      WidgetPropertySpec<bool>(
        name: #highlighted,
        defaultValue: null,
        optional: true,
        meta: true
      ),
      WidgetPropertySpec<bool>(
          name: #hovered,
          defaultValue: null,
          optional: true,
          meta: true
      ),
      WidgetPropertySpec<bool>(
          name: #focussed,
          defaultValue: null,
          optional: true,
          meta: true
      ),
    ],

    propertyValues: {
      #onTap: 'enabled() ? tap?.trigger : null',
      #onDoubleTap: 'enabled() ? doubleTap?.trigger : null',
      #onLongPress: 'enabled() ? longPress?.trigger : null',
      #onTapDown: 'tapDown != null ? (v) => _tapDownCell(context).value = v : null',
      #onTapUp: 'tapUp != null ? (v) => _tapUpCell(context).value = v : null',
      #onTapCancel: 'enabled() ? tapCancel?.trigger : null',

      #onSecondaryTap: 'enabled() ? secondaryTap?.trigger : null',
      #onSecondaryTapDown: 'secondaryTapDown != null ? (v) => _secondaryTapDownCell(context).value = v : null',
      #onSecondaryTapUp: 'secondaryTapUp != null ? (v) => _secondaryTapUpCell(context).value = v : null',
      #onSecondaryTapCancel: 'enabled() ? secondaryTapCancel?.trigger : null',

      #onHighlight: 'highlighted != null ? (v) => _highlightedCell(context).value = v : null',
      #onHover: 'hovered != null ? (v) => _hoveredCell(context).value = v : null',
      #onFocusChange: 'focussed != null ? (v) => _focussedCell(context).value = v : null',
    },

    baseClass: #_InkInterface,
    buildMethod: #_buildWrappedWidget,

    documentation: '''An [InkWell] that triggers [ActionCell]s on gestures.
    
Rather than calling a callback function when a gesture is detected, an
[ActionCell] is triggered. The arguments [tap], [doubleTap], [longPress], 
[tapCancel], [secondaryTap], [secondaryTapCancel] correspond to the `onTap`, 
`onDoubleTap`, `onLongPress`, `onTapCancel`, `onSecondaryTap` and 
`onSecondaryTapCancel` arguments of the default constructor of [InkWell].

The arguments [tapUp], [tapDown], [secondaryTapUp], [secondaryTapDown] 
take [MetaCell]s that hold the details of the last tap up/tap down event. These
correspond to the `onTapUp`, `onTapDown`, `onSecondaryTapUp`,
`onSecondaryTapDown` arguments of the default constructor of [InkWell].

The [enabled] cell controls whether the widget can be tapped (true) or not 
(false).

[highlighted] is a [MetaCell] that holds the value true when the widget is
being highlighted and false otherwise. This corresponds to the [onHighlight]
argument of [InkWell]'s default constructor.

[hovered] is a [MetaCell] that holds the value true when the widget is
being hovered over and false otherwise. This corresponds to the [onHover]
argument of [InkWell]'s default constructor.

[focussed] is a [MetaCell] that holds the value true when the widget is
in focus and false otherwise. This corresponds to the [onFocus]
argument of [InkWell]'s default constructor.
'''
  ),

  WidgetSpec<InkResponse>(
      as: #LiveInkResponse,

      excludeProperties: [
        #onTap,
        #onTapDown,
        #onTapUp,
        #onTapCancel,
        #onDoubleTap,
        #onLongPress,
        #onSecondaryTap,
        #onSecondaryTapUp,
        #onSecondaryTapDown,
        #onSecondaryTapCancel,
        #onHighlightChanged,
        #onHover,
        #onFocusChange
      ],

      cellProperties: [],

      addProperties: [
        WidgetPropertySpec<bool>(
            name: #enabled,
            defaultValue: 'true',
            optional: false,
            documentation: 'Is the widget enabled for user input?'
        ),
        WidgetPropertySpec<void>(
            name: #tap,
            defaultValue: null,
            optional: true,
            mutable: true
        ),
        WidgetPropertySpec<void>(
            name: #doubleTap,
            defaultValue: null,
            optional: true,
            mutable: true
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            mutable: true
        ),
        WidgetPropertySpec<void>(
            name: #tapCancel,
            defaultValue: null,
            optional: true,
            mutable: true
        ),
        WidgetPropertySpec<TapDownDetails>(
            name: #tapDown,
            defaultValue: null,
            optional: true,
            meta: true
        ),
        WidgetPropertySpec<TapUpDetails>(
            name: #tapUp,
            defaultValue: null,
            optional: true,
            meta: true
        ),
        WidgetPropertySpec<void>(
            name: #secondaryTap,
            defaultValue: null,
            optional: true,
            mutable: true
        ),
        WidgetPropertySpec<void>(
            name: #secondaryTapCancel,
            defaultValue: null,
            optional: true,
            mutable: true
        ),
        WidgetPropertySpec<TapDownDetails>(
            name: #secondaryTapDown,
            defaultValue: null,
            optional: true,
            meta: true
        ),
        WidgetPropertySpec<TapUpDetails>(
            name: #secondaryTapUp,
            defaultValue: null,
            optional: true,
            meta: true
        ),
        WidgetPropertySpec<bool>(
            name: #highlighted,
            defaultValue: null,
            optional: true,
            meta: true
        ),
        WidgetPropertySpec<bool>(
            name: #hovered,
            defaultValue: null,
            optional: true,
            meta: true
        ),
        WidgetPropertySpec<bool>(
            name: #focussed,
            defaultValue: null,
            optional: true,
            meta: true
        ),
      ],

      propertyValues: {
        #onTap: 'enabled() ? tap?.trigger : null',
        #onDoubleTap: 'enabled() ? doubleTap?.trigger : null',
        #onLongPress: 'enabled() ? longPress?.trigger : null',
        #onTapDown: 'tapDown != null ? (v) => _tapDownCell(context).value = v : null',
        #onTapUp: 'tapUp != null ? (v) => _tapUpCell(context).value = v : null',
        #onTapCancel: 'enabled() ? tapCancel?.trigger : null',

        #onSecondaryTap: 'enabled() ? secondaryTap?.trigger : null',
        #onSecondaryTapDown: 'secondaryTapDown != null ? (v) => _secondaryTapDownCell(context).value = v : null',
        #onSecondaryTapUp: 'secondaryTapUp != null ? (v) => _secondaryTapUpCell(context).value = v : null',
        #onSecondaryTapCancel: 'enabled() ? secondaryTapCancel?.trigger : null',

        #onHighlight: 'highlighted != null ? (v) => _highlightedCell(context).value = v : null',
        #onHover: 'hovered != null ? (v) => _hoveredCell(context).value = v : null',
        #onFocusChange: 'focussed != null ? (v) => _focussedCell(context).value = v : null',
      },

      baseClass: #_InkInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''An [InkResponse] that triggers [ActionCell]s on gestures.
    
Rather than calling a callback function when a gesture is detected, an
[ActionCell] is triggered. The arguments [tap], [doubleTap], [longPress], 
[tapCancel], [secondaryTap], [secondaryTapCancel] correspond to the `onTap`, 
`onDoubleTap`, `onLongPress`, `onTapCancel`, `onSecondaryTap` and 
`onSecondaryTapCancel` arguments of the default constructor of [InkResponse].

The arguments [tapUp], [tapDown], [secondaryTapUp], [secondaryTapDown] 
take [MetaCell]s that hold the details of the last tap up/tap down event. These
correspond to the `onTapUp`, `onTapDown`, `onSecondaryTapUp`,
`onSecondaryTapDown` arguments of the default constructor of [InkResponse].

The [enabled] cell controls whether the widget can be tapped (true) or not 
(false).

[highlighted] is a [MetaCell] that holds the value true when the widget is
being highlighted and false otherwise. This corresponds to the [onHighlight]
argument of [InkResponse]'s default constructor.

[hovered] is a [MetaCell] that holds the value true when the widget is
being hovered over and false otherwise. This corresponds to the [onHover]
argument of [InkResponse]'s default constructor.

[focussed] is a [MetaCell] that holds the value true when the widget is
in focus and false otherwise. This corresponds to the [onFocus]
argument of [InkResponse]'s default constructor.
'''
  ),

  WidgetSpec<InteractiveViewer>(
    as: #LiveInteractiveViewer,

    baseClass: #_InteractiveViewerInterface,
    stateMixins: [#_LiveInteractiveViewerMixin],

    excludeProperties: [
      #transformationController
    ],

    cellProperties: [],

    addProperties: [
      WidgetPropertySpec<Matrix4>(
          name: #transformation,
          defaultValue: null,
          optional: true,
          mutable: true
      )
    ],

    propertyValues: {
      #transformationController: '_controller'
    },

    propertyDefaultValues: {
      // The value for the constant _kDrag was copied from
      // interactive_viewer.dart
      #interactionEndFrictionCoefficient: '0.0000135'
    },

    propertyTypes: {
      #builder: 'InteractiveViewerWidgetBuilder'
    },

    documentation: '''An [InteractiveViewer] where the [transformation] is exposed as a cell.

The value of the [transformation] cell is updated whenever the user
scrolls, pans or zooms the widget.

Setting the value of [transformation] results in the widget being scrolled,
zoomed and panned to the position represented by the transformation matrix.
'''
  ),

  WidgetSpec<PageView>(
      as: #LivePageView,

      baseClass: #_PageViewInterface,
      stateMixins: [#_CellPageViewMixin],
      cellProperties: [],

      excludeProperties: [
        #controller,
        #onPageChanged
      ],

      addProperties: [
        WidgetPropertySpec<int>(
            name: #page,
            defaultValue: null,
            optional: false,
            mutable: true,

            documentation: '''Cell holding the selected page index.

When the page is changed, the value of this cell is updated to reflect
the selected page index. Likewise, when the value of this cell is changed,
the current page is changed to the page corresponding to the value of
the cell.

The behaviour on page switching is affected by [animate], [duration] and
[curve].'''
        ),

        WidgetPropertySpec<bool>(
            name: #animate,
            defaultValue: null,
            optional: true,
            documentation: '''Should the transition between pages be animated?

If the value of this cell is true, page transitions are animated using
the animation duration and curve function given in [duration] and [curve].
[duration] and [curve] may not be null if the value of this cell is true.

If this property is null, the page transitions are not animated.'''
        ),

        WidgetPropertySpec<Duration>(
            name: #duration,
            defaultValue: null,
            optional: true,
            documentation: '''Duration of the page transition animation.'''
        ),

        WidgetPropertySpec<Curve>(
            name: #curve,
            defaultValue: null,
            optional: true,
            documentation: '''Curve function to use for page transition animations.'''
        ),

        WidgetPropertySpec<void>(
            name: #nextPage,
            defaultValue: null,
            optional: true,
            documentation: '''Action cell which triggers a transition to the next page.

When this cell is triggered, the view's page is changed to the next page. [duration]
and [curve] must be non-null, if this property is non-null.'''
        ),

        WidgetPropertySpec<void>(
            name: #previousPage,
            defaultValue: null,
            optional: true,
            documentation: '''Action cell which triggers a transition to the previous page.

When this cell is triggered, the view's page is changed to the previous page. 
[duration] and [curve] must be non-null, if this property is non-null.'''
        ),

        WidgetPropertySpec<bool>(
            name: #isAnimating,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: '''[MetaCell] injected with a cell that is true while a page transition is in progress.
        
NOTE: This cell is only updated if the page change is triggered either by changing
the value of the [page] cell or triggering [nextPage]/[previousPage].'''
        )
      ],

      propertyValues: {
        #controller: '_controller',

        #onPageChanged: '''(index) => _withSuppressed(() {
        widget.page.value = index;
      })'''
      },

      documentation: '''A [PageView] with the page controlled by a [MutableCell].

The [page] cell holds the page that is currently shown. When the value of the
[page] cell is set, the page is changed. When the current page is changed by
some other means, such as swiping to the left or right, [page] is updated to
reflect the actual page of the [PageView].

An [ActionCell] can be provided for [nextPage]. When it is triggered, the
current page is advanced to next page. Similarly, when the cell provided
for [previousPage] is triggered, the page is changed to the previous page.

[animate] controls whether page changes via [nextPage] and [previousPage]
are animated (true) or not (false). 

**NOTE**: If [nextPage] or [previousPage] are triggered, while [animated] is
true, a [curve] and [duration] must also be provided.

A [MetaCell] can be provided for [isAnimating]. The value of this cell is
set to true while an animated page transition is in progress.
**NOTE**: The value of this cell is only updated if the page change
is triggered by [page], [nextPage] or [prevPage]. 
'''
  ),

  WidgetSpec<Slider>(
    as: #LiveSlider,
    mutableProperties: [#value],
    excludeProperties: [#onChanged],
    cellProperties: [#value],

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

    documentation: '''A [Slider] with its [value] controlled by a [MutableCell].

The [value] is controlled by a [MutableCell] which is passed on construction. 
When the value of the cell changes, the slider position is updated to reflect 
the value of the cell. Similarly when the slider is moved by the user, the 
value of the cell is updated to reflect the slider position.

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<Switch>(
    as: #LiveSwitch,
    mutableProperties: [#value],
    cellProperties: [#value],
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

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<SwitchListTile>(
    as: #LiveSwitchListTile,
    mutableProperties: [#value],
    cellProperties: [#value],
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

      documentation: '''A [ListTile] with a [LiveSwitch], akin to [SwitchListTile].

See [LiveSwitch] for a more detailed explanation.
'''
  ),

  WidgetSpec<Radio>(
    as: #LiveRadio,
    typeArguments: ['T'],
    mutableProperties: [#groupValue],
    excludeProperties: [#onChanged],
    cellProperties: [#groupValue],

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

    documentation: '''A [Radio] widget with the [groupValue] controlled by a [MutableCell].

The [groupValue] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the state of the widget is updated to reflect the
value of the cell. Similarly when the state of the widget is changed by the
user, the value of the cell is updated to reflect the state.

The cell provided for [enabled] controls whether the widget is enabled for user
interaction, when the value of the cell is true, or disabled, when the value
of the cell is false.
'''
  ),

  WidgetSpec<RadioListTile>(
    as: #LiveRadioListTile,
    typeArguments: ['T'],
    mutableProperties: [#groupValue],
    cellProperties: [#groupValue],
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


    documentation: '''A [ListTile] with a [LiveRadio], akin to [RadioListTile].

See [LiveRadio] for a more detailed explanation.
'''
  ),

  WidgetSpec<OutlinedButton>(
      as: #LiveOutlinedButton,
      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      cellProperties: [],

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
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is long pressed.'
        ),
        WidgetPropertySpec<bool>(
            name: #onHover,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the hover state of the button changes.'
        ),
        WidgetPropertySpec<bool>(
            name: #onFocusChange,
            defaultValue: null,
            optional: true,
            meta: true,
            documentation: 'MetaCell for a cell that is updated whenever the focus state of the button changes.'
        )
      ],

      propertyValues: {
        #onPressed: 'enabled() ? press?.trigger : null',
        #onLongPress: 'enabled() ? longPress?.trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      baseClass: #_FocusButtonInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''An [OutlinedButton] that triggers an action cell when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed. Similarly, when the button is long-pressed, the action cell
provided in [longPress] is triggered, if it is not null.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).

[MetaCell]s can be provided for the [onHover] and [onFocusChange] properties.
The value of the [onHover] [MetaCell] is set to true, while hovering over the
widget and false otherwise. Similarly the value of the [onFocusChange] [MetaCell]
is set to true, while the widget is focussed.
'''
  ),

  WidgetSpec<TextButton>(
      as: #LiveTextButton,
      includeSuperProperties: [
        #child,
        #style,
        #autofocus,
        #clipBehavior,
      ],

      cellProperties: [],

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
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
        ),
        WidgetPropertySpec<void>(
            name: #longPress,
            defaultValue: null,
            optional: true,
            mutable: true,
            documentation: '[ActionCell] to trigger when the button is pressed.'
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
        #onPressed: 'enabled() ? press?.trigger : null',
        #onLongPress: 'enabled() ? longPress?.trigger : null',
        #onHover: 'onHover != null ? (v) => _onHoverCell(context).value = v : null',
        #onFocusChange: 'onFocusChange != null ? (v) => _onFocusChangeCell(context).value = v : null',
      },

      baseClass: #_FocusButtonInterface,
      buildMethod: #_buildWrappedWidget,

      documentation: '''A [TextButton] that triggers an action cell when pressed.

Rather than taking an `onPressed` callback function, the constructors take an
action cell in the [press] argument, which is triggered when the button is
pressed. Similarly, when the button is long-pressed, the action cell
provided in [longPress] is triggered, if it is not null.

The [enabled] cell controls whether the button can be tapped (true) or not 
(false).

[MetaCell]s can be provided for the [onHover] and [onFocusChange] properties.
The value of the [onHover] [MetaCell] is set to true, while hovering over the
widget and false otherwise. Similarly the value of the [onFocusChange] [MetaCell]
is set to true, while the widget is focussed.
'''
  ),
  
  WidgetSpec<TextFormField>(
    as: #LiveTextFormField,
    
    baseClass: #_TextFieldInterface,
    stateMixins: [#_CellTextFieldMixin],
    
    cellProperties: [#enabled],

    includeSuperProperties: [
      #forceErrorText,
      #onSaved,
      #validator,
      #errorBuilder,
      #restorationId,
    ],
    
    excludeProperties: [
      #controller,
      #toolbarOptions,
      #contextMenuBuilder,
    ],
    
    addProperties: [
      WidgetPropertySpec<String>(
        name: #content,
        defaultValue: null,
        optional: false,
        mutable: true,

        documentation: 'Cell holding the content of the field'
      ),
      
      WidgetPropertySpec<TextSelection>(
        name: #selection,
        defaultValue: null,
        optional: true,
        mutable: true,

        documentation: 'Cell holding the text selection in the field'
      ),
    ],

    propertyValues: {
      #controller: '_controller',
    },
    
    documentation: '''A [TextFormField] widget with Live Cells integration.
    
The [content] cell controls the text content of the field.
The [selection] cell controls the text selection in the field.

All standard [TextFormField] callbacks are supported and will be called in addition to
updating the corresponding cells.
'''
  ),
  
  WidgetSpec<TextField>(
    as: #LiveTextField,

    baseClass: #_TextFieldInterface,
    stateMixins: [#_CellTextFieldMixin],

    cellProperties: [#enabled],

    excludeProperties: [
      #controller, #contextMenuBuilder
    ],

    addProperties: [
      WidgetPropertySpec<String>(
          name: #content,
          defaultValue: null,
          optional: false,
          mutable: true,

          documentation: 'Cell holding the content of the field'
      ),

      WidgetPropertySpec<TextSelection>(
          name: #selection,
          defaultValue: null,
          optional: true,
          mutable: true,

          documentation: 'Cell holding the text selection'
      )
    ],

    propertyValues: {
      #controller: '_controller',
    },

    documentation: '''A text field widget, similar to [TextField], with content controlled by a [MutableCell].

The content of the text field is controlled by a [MutableCell] which is passed on
construction. Whenever the value of the cell changes, the content of the text
field is updated to reflect the value of the cell. Similarly, whenever the content
of the text field changes, the value of the cell is updated to reflect the field
content.

Similar to the [content] cell, the cell provided for [selection] is synchronized 
with the text selection of the field.

'''
  )
])
part 'live_widgets.g.dart';