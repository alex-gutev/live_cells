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
  WidgetSpec<AbsorbPointer>(
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Align>(
    includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedAlign>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedContainer>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedCrossFade>(
      propertyDefaultValues: {
        #layoutBuilder: 'AnimatedCrossFade.defaultLayoutBuilder'
      },
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedDefaultTextStyle>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedFractionallySizedBox>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedOpacity>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedPhysicalModel>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedPositioned>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedPositionedDirectional>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedRotation>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedScale>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedSize>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedSlide>(
      includeSuperProperties: [#curve, #duration, #onEnd],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnimatedSwitcher>(
      propertyTypes: {
        #layoutBuilder: 'AnimatedSwitcherLayoutBuilder'
      },
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AnnotatedRegion>(
      typeArguments: ['T extends Object'],
      includeSuperProperties: [#child],

      propertyTypes: {
        #value: 'T'
      },
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<AspectRatio>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<BackdropFilter>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Badge>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),
  WidgetSpec<Banner>(
    propertyDefaultValues: {
      #color: 'Color(0xA0B71C1C)',
      #textStyle: 'TextStyle(color: '
        'Color(0xFFFFFFFF),'
        'fontSize: 12.0 * 0.85,'
        'fontWeight: FontWeight.w900,'
        'height: 1.0)'
    },
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Baseline>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<BlockSemantics>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Card>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Center>(
    includeSuperProperties: [#widthFactor, #heightFactor, #child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CheckboxMenuButton>(
      mutableProperties: [#value],
      excludeProperties: [#onChanged, #onHover, #onFocusChange],
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

      documentation: '''A menu item with a [CellCheckbox], akin to [CheckboxMenuButton].
  
  See [CellCheckbox] for a more detailed explanation.''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CheckboxTheme>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CheckedPopupMenuItem>(
    typeArguments: ['T'],
    mutableProperties: [#value],
    excludeProperties: [#onTap],

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
      #onTap: 'tap != null ? () => _onTapCell(context).trigger() : null'
    },

    mixins: [#_OnTapCellMixin],
    baseClass: #_WrapperInterface,
    buildMethod: #_buildWrappedWidget,

    addProperties: [
      WidgetPropertySpec<void>(
        name: #tap,
        defaultValue: null,
        optional: true,
        meta: true,
        documentation: 'MetaCell for an action cell that is triggered when the '
            'item is tapped.'
      ),
    ],

    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  // TODO: Fix this
  WidgetSpec<Chip>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ChipTheme>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ChoiceChip>(
      mutableProperties: [#selected],
      excludeProperties: [#onSelected, #focusNode],
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ClipOval>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ClipPath>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ClipRect>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CloseButton>(
    includeSuperProperties: [
      #color,
      #style
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
          documentation: 'MetaCell for an ActionCell that is triggered when the '
              'button is pressed.'
      ),
    ],

    propertyValues: {
      #onPressed: 'enabled() && press != null ? _pressActionCell(context).trigger : null',
    },

    mixins: [#_onPressMixin],
    baseClass: #_WrapperInterface,
    buildMethod: #_buildWrappedWidget,

    deprecationNotice: 'Use widgets from live_cells_ui library.',

    documentation: '''A [CloseButton] widget with its properties controlled by [ValueCell]'s.

The constructor takes mostly same arguments as the unnamed constructor of [CloseButton],
but as [ValueCell]'s. This binds each property value to the [ValueCell] given
in the constructor. If the cell value is changed, the value of the corresponding
property to which it is bound is automatically updated to reflect the value of
the cell.

Instead of taking a callback function for [onPressed], the
constructor accepts a [MetaCell] that is set to an [ActionCell] which is
triggered when the button is pressed.
'''
  ),

  WidgetSpec<ColoredBox>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ColorFiltered>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ConstrainedBox>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ConstraintsTransformBox>(
    includeSuperProperties: [#child],
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Container>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CupertinoActivityIndicator>(
      propertyDefaultValues: {
        #radius: '10.0'
      },
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CupertinoListSection>(
      propertyDefaultValues: {
        #margin: 'EdgeInsets.only(bottom: 8.0)',
        #dividerMargin: '20.0',
        #topMargin: '22.0',
      },
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),
  
  WidgetSpec<CupertinoPageScaffold>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<CupertinoPopupSurface>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
value of the cell is updated to reflect the slider position.''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<DecoratedBox>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<DefaultTextStyle>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Divider>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ExcludeSemantics>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<FittedBox>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<FractionalTranslation>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<FractionallySizedBox>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Icon>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<IgnorePointer>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<IntrinsicHeight>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<IntrinsicWidth>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<LimitedBox>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<LinearProgressIndicator>(
      includeSuperProperties: [
        #value,
        #backgroundColor,
        #color,
        #semanticsLabel,
        #semanticsValue
      ],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<ListTile>(
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Text>(
    as: #CellText,
    deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<PageView>(
    baseClass: #_PageViewInterface,
    stateMixins: [#_CellPageViewMixin],

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
    },

    deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
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
''',

      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),

  WidgetSpec<Visibility>(
      includeSuperProperties: [#child],
      deprecationNotice: 'Use widgets from live_cells_ui library.'
  ),
])
part 'widgets.g.dart';

part 'wrapper_interface.dart';
part 'mixins.dart';
part 'cell_page_view_mixin.dart';