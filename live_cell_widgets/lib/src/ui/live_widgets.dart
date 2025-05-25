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

      documentation: '''A [Checkbox] widget with the [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the checkbox state is updated to reflect the
value of the cell. Similarly when the state of the checkbox is changed by the
user, the value of the cell is updated to reflect the state.
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

      documentation: '''A menu item with a [LiveCheckbox], akin to [CheckboxMenuButton].
  
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

      documentation: '''A [CheckedPopupMenuItem] widget with the [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the checkbox state is updated to reflect the
value of the cell. Similarly when the state of the widget is changed by the
user, the value of the cell is updated to reflect the state.
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

      documentation: '''A [CloseButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [CloseButton],
but as [ValueCell]'s. Instead of taking a callback function for [onPressed], the
constructor accepts an [ActionCell] that is triggered when the button is pressed.
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

      documentation: '''A [CupertinoSlider] with its [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction. 
When the value of the cell changes, the slider position is updated to reflect 
the value of the cell. Similarly when the slider is moved by the user, the 
value of the cell is updated to reflect the slider position.'''
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

      documentation: '''An [ElevatedButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of 
[ElevatedButton], but as [ValueCell]'s. Instead of taking a callback function 
for [onPressed], the constructor accepts an [ActionCell] that is triggered when 
the button is pressed.

[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange]. This allows
the hover and focus state of the widget to be observed by observing the [MetaCells]
passed to the constructor.
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

      documentation: '''A [FilledButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [FilledButton],
but as [ValueCell]'s.  Instead of taking a callback function 
for [onPressed], the constructor accepts an [ActionCell] that is triggered when 
the button is pressed.

[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange]. This allows
the hover and focus state of the widget to be observed by observing the [MetaCells]
passed to the constructor.
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

    excludeProperties: [#onHover],

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


    documentation: '''An [IconButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [IconButton].
Instead of taking a callback function for [onPressed], the constructor accepts 
an [ActionCell] that is triggered when the button is pressed.

A [bool] [MetaCell] is accepted for [onHover]. This allows
the hover state of the widget to be observed by observing the [MetaCells]
passed to the constructor.
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
the value of the [page] cell or trigger [nextPage]/[previousPage].'''
        )
      ],

      propertyValues: {
        #controller: '_controller',

        #onPageChanged: '''(index) => _withSuppressed(() {
        widget.page.value = index;
      })'''
      }
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

    documentation: '''A [Switch] widget with the [value] controlled by a [ValueCell].

The [value] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the checkbox state is updated to reflect the
value of the cell. Similarly when the state of the checkbox is changed by the
user, the value of the cell is updated to reflect the state.
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


    documentation: '''A [Radio] widget with the [groupValue] controlled by a [ValueCell].

The [groupValue] is controlled by a [MutableCell] which is passed on construction.
When the value of the cell changes, the state of the widget is updated to reflect the
value of the cell. Similarly when the state of the widget is changed by the
user, the value of the cell is updated to reflect the state.
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

      documentation: '''An [OutlinedButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [OutlinedButton],
but as [ValueCell]'s. Instead of taking a callback function 
for [onPressed], the constructor accepts an [ActionCell] that is triggered when 
the button is pressed.

[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange]. This allows
the hover and focus state of the widget to be observed by observing the [MetaCells]
passed to the constructor.
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

      documentation: '''A [TextButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [TextButton],
but as [ValueCell]'s. Instead of taking a callback function 
for [onPressed], the constructor accepts an [ActionCell] that is triggered when 
the button is pressed.

[bool] [MetaCell]s are accepted for [onHover] and [onFocusChange]. This allows
the hover and focus state of the widget to be observed by observing the [MetaCells]
passed to the constructor.
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

    documentation: '''A text field widget, similar to [TextField], with content controlled by a [ValueCell].

The content of the text field is controlled by a [MutableCell] which is passed on
construction. Whenever the value of the cell changes, the content of the text
field is updated to reflect the value of the cell. Similarly, whenever the content
of the text field changes, the value of the cell is updated to reflect the field
content.'''
  )
])
part 'live_widgets.g.dart';