import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_cell_widgets/live_cell_widgets_base.dart';
import 'package:live_cells_core/live_cells_core.dart';

/// A text field widget, similar to [TextField], with content controlled by a [ValueCell].
///
/// The content of the text field is controlled by a [MutableCell] which is passed on
/// construction. Whenever the value of the cell changes, the content of the text
/// field is updated to reflect the value of the cell. Similarly, whenever the content
/// of the text field changes, the value of the cell is updated to reflect the field
/// content.
class CellTextField extends StatefulWidget {
  /// Content cell
  final MutableCell<String> content;

  /// Cell holding the text selection
  final MutableCell<TextSelection>? selection;

  // Fields from [TextField]

  final ValueCell<FocusNode?>? focusNode;
  final ValueCell<InputDecoration?> decoration;
  final ValueCell<TextInputType?>? keyboardType;
  final ValueCell<TextInputAction?>? textInputAction;
  final ValueCell<TextCapitalization> textCapitalization;
  final ValueCell<TextStyle?>? style;
  final ValueCell<StrutStyle?>? strutStyle;
  final ValueCell<TextAlign> textAlign;
  final ValueCell<TextAlignVertical?>? textAlignVertical;
  final ValueCell<TextDirection?>? textDirection;
  final ValueCell<bool> readOnly;
  final ValueCell<ToolbarOptions?>? toolbarOptions;
  final ValueCell<bool?>? showCursor;
  final ValueCell<bool> autofocus;
  final ValueCell<String> obscuringCharacter;
  final ValueCell<bool> obscureText;
  final ValueCell<bool> autocorrect;
  final ValueCell<SmartDashesType?>? smartDashesType;
  final ValueCell<SmartQuotesType?>? smartQuotesType;
  final ValueCell<bool> enableSuggestions;
  final ValueCell<int?> maxLines;
  final ValueCell<int?>? minLines;
  final ValueCell<bool> expands;
  final ValueCell<int?>? maxLength;
  final ValueCell<MaxLengthEnforcement?>? maxLengthEnforcement;
  final ValueCell<void Function()?>? onEditingComplete;
  final ValueCell<void Function(String)?>? onSubmitted;
  final ValueCell<void Function(String, Map<String, dynamic>)?>? onAppPrivateCommand;
  final ValueCell<List<TextInputFormatter>?>? inputFormatters;
  final ValueCell<bool?>? enabled;
  final ValueCell<double> cursorWidth;
  final ValueCell<double?>? cursorHeight;
  final ValueCell<Radius?>? cursorRadius;
  final ValueCell<bool?>? cursorOpacityAnimates;
  final ValueCell<Color?>? cursorColor;
  final ValueCell<BoxHeightStyle> selectionHeightStyle;
  final ValueCell<BoxWidthStyle> selectionWidthStyle;
  final ValueCell<Brightness?>? keyboardAppearance;
  final ValueCell<EdgeInsets> scrollPadding;
  final ValueCell<DragStartBehavior> dragStartBehavior;
  final ValueCell<bool?>? enableInteractiveSelection;
  final ValueCell<TextSelectionControls?>? selectionControls;
  final ValueCell<void Function()?>? onTap;
  final ValueCell<void Function(PointerDownEvent)?>? onTapOutside;
  final ValueCell<MouseCursor?>? mouseCursor;
  final ValueCell<InputCounterWidgetBuilder?>? buildCounter;
  final ValueCell<ScrollPhysics?>? scrollPhysics;
  final ValueCell<Iterable<String>?> autofillHints;
  final ValueCell<ContentInsertionConfiguration?>? contentInsertionConfiguration;
  final ValueCell<Clip> clipBehavior;
  final ValueCell<String?>? restorationId;
  final ValueCell<bool> scribbleEnabled;
  final ValueCell<bool> enableIMEPersonalizedLearning;
  final ValueCell<bool> canRequestFocus;
  final ValueCell<SpellCheckConfiguration?>? spellCheckConfiguration;
  final ValueCell<TextMagnifierConfiguration?>? magnifierConfiguration;

  /// Create a CellTextField.
  ///
  /// The only required parameter is [content] which is a [MutableCell] to which
  /// the content of the text field is bound. Whenever the cell's value changes
  /// the content is updated to reflect the cell value, and similarly when
  /// the content of the text field is changed, the cell's value is updated to
  /// reflect content.
  ///
  /// The text selection is bound to the cell [selection] if it is given. This
  /// means when the selection is changed by the user, the value of [selection]
  /// is updated to reflect the selection. When the value of [selection] is
  /// changed, the selection in the text field is updated to reflect the value
  /// of [selection].
  ///
  /// The remaining parameters are the same as in the constructor of [TextField].
  const CellTextField({
    super.key,
    required this.content,
    this.selection,
    this.focusNode,
    this.decoration = const ValueCell.value(const InputDecoration()),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = const ValueCell.value(TextCapitalization.none),
    this.style,
    this.strutStyle,
    this.textAlign = const ValueCell.value(TextAlign.start),
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = const ValueCell.value(false),
    this.toolbarOptions,
    this.showCursor,
    this.autofocus = const ValueCell.value(false),
    this.obscuringCharacter = const ValueCell.value('•'),
    this.obscureText = const ValueCell.value(false),
    this.autocorrect = const ValueCell.value(true),
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = const ValueCell.value(true),
    this.maxLines = const ValueCell.value(1),
    this.minLines,
    this.expands = const ValueCell.value(false),
    this.maxLength,
    this.maxLengthEnforcement,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = const ValueCell.value(2.0),
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.selectionHeightStyle = const ValueCell.value(BoxHeightStyle.tight),
    this.selectionWidthStyle = const ValueCell.value(BoxWidthStyle.tight),
    this.keyboardAppearance,
    this.scrollPadding = const ValueCell.value(const EdgeInsets.all(20.0)),
    this.dragStartBehavior = const ValueCell.value(DragStartBehavior.start),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints = const ValueCell.value(const <String>[]),
    this.contentInsertionConfiguration,
    this.clipBehavior = const ValueCell.value(Clip.hardEdge),
    this.restorationId,
    this.scribbleEnabled = const ValueCell.value(true),
    this.enableIMEPersonalizedLearning = const ValueCell.value(true),
    this.canRequestFocus = const ValueCell.value(true),
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });

  CellTextField bind({
    MutableCell<String>? content,
    MutableCell<TextSelection>? selection,
    ValueCell<FocusNode?>? focusNode,
    ValueCell<InputDecoration?>? decoration,
    ValueCell<TextInputType?>? keyboardType,
    ValueCell<TextInputAction?>? textInputAction,
    ValueCell<TextCapitalization>? textCapitalization,
    ValueCell<TextStyle?>? style,
    ValueCell<StrutStyle?>? strutStyle,
    ValueCell<TextAlign>? textAlign,
    ValueCell<TextAlignVertical?>? textAlignVertical,
    ValueCell<TextDirection?>? textDirection,
    ValueCell<bool>? readOnly,
    ValueCell<ToolbarOptions?>? toolbarOptions,
    ValueCell<bool?>? showCursor,
    ValueCell<bool>? autofocus,
    ValueCell<String>? obscuringCharacter,
    ValueCell<bool>? obscureText,
    ValueCell<bool>? autocorrect,
    ValueCell<SmartDashesType?>? smartDashesType,
    ValueCell<SmartQuotesType?>? smartQuotesType,
    ValueCell<bool>? enableSuggestions,
    ValueCell<int?>? maxLines,
    ValueCell<int?>? minLines,
    ValueCell<bool>? expands,
    ValueCell<int?>? maxLength,
    ValueCell<MaxLengthEnforcement?>? maxLengthEnforcement,
    ValueCell<void Function()?>? onEditingComplete,
    ValueCell<void Function(String)?>? onSubmitted,
    ValueCell<void Function(String, Map<String, dynamic>)?>?
    onAppPrivateCommand,
    ValueCell<List<TextInputFormatter>?>? inputFormatters,
    ValueCell<bool?>? enabled,
    ValueCell<double>? cursorWidth,
    ValueCell<double?>? cursorHeight,
    ValueCell<Radius?>? cursorRadius,
    ValueCell<bool?>? cursorOpacityAnimates,
    ValueCell<Color?>? cursorColor,
    ValueCell<BoxHeightStyle>? selectionHeightStyle,
    ValueCell<BoxWidthStyle>? selectionWidthStyle,
    ValueCell<Brightness?>? keyboardAppearance,
    ValueCell<EdgeInsets>? scrollPadding,
    ValueCell<DragStartBehavior>? dragStartBehavior,
    ValueCell<bool?>? enableInteractiveSelection,
    ValueCell<TextSelectionControls?>? selectionControls,
    ValueCell<void Function()?>? onTap,
    ValueCell<void Function(PointerDownEvent)?>? onTapOutside,
    ValueCell<MouseCursor?>? mouseCursor,
    ValueCell<InputCounterWidgetBuilder?>? buildCounter,
    ValueCell<ScrollPhysics?>? scrollPhysics,
    ValueCell<Iterable<String>?>? autofillHints,
    ValueCell<ContentInsertionConfiguration?>? contentInsertionConfiguration,
    ValueCell<Clip>? clipBehavior,
    ValueCell<String?>? restorationId,
    ValueCell<bool>? scribbleEnabled,
    ValueCell<bool>? enableIMEPersonalizedLearning,
    ValueCell<bool>? canRequestFocus,
    ValueCell<SpellCheckConfiguration?>? spellCheckConfiguration,
    ValueCell<TextMagnifierConfiguration?>? magnifierConfiguration,
  }) =>
      CellTextField(
        content: content ?? this.content,
        selection: selection ?? this.selection,
        focusNode: focusNode ?? this.focusNode,
        decoration: decoration ?? this.decoration,
        keyboardType: keyboardType ?? this.keyboardType,
        textInputAction: textInputAction ?? this.textInputAction,
        textCapitalization: textCapitalization ?? this.textCapitalization,
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        textAlignVertical: textAlignVertical ?? this.textAlignVertical,
        textDirection: textDirection ?? this.textDirection,
        readOnly: readOnly ?? this.readOnly,
        toolbarOptions: toolbarOptions ?? this.toolbarOptions,
        showCursor: showCursor ?? this.showCursor,
        autofocus: autofocus ?? this.autofocus,
        obscuringCharacter: obscuringCharacter ?? this.obscuringCharacter,
        obscureText: obscureText ?? this.obscureText,
        autocorrect: autocorrect ?? this.autocorrect,
        smartDashesType: smartDashesType ?? this.smartDashesType,
        smartQuotesType: smartQuotesType ?? this.smartQuotesType,
        enableSuggestions: enableSuggestions ?? this.enableSuggestions,
        maxLines: maxLines ?? this.maxLines,
        minLines: minLines ?? this.minLines,
        expands: expands ?? this.expands,
        maxLength: maxLength ?? this.maxLength,
        maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
        onEditingComplete: onEditingComplete ?? this.onEditingComplete,
        onSubmitted: onSubmitted ?? this.onSubmitted,
        onAppPrivateCommand: onAppPrivateCommand ?? this.onAppPrivateCommand,
        inputFormatters: inputFormatters ?? this.inputFormatters,
        enabled: enabled ?? this.enabled,
        cursorWidth: cursorWidth ?? this.cursorWidth,
        cursorHeight: cursorHeight ?? this.cursorHeight,
        cursorRadius: cursorRadius ?? this.cursorRadius,
        cursorOpacityAnimates:
        cursorOpacityAnimates ?? this.cursorOpacityAnimates,
        cursorColor: cursorColor ?? this.cursorColor,
        selectionHeightStyle: selectionHeightStyle ?? this.selectionHeightStyle,
        selectionWidthStyle: selectionWidthStyle ?? this.selectionWidthStyle,
        keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
        scrollPadding: scrollPadding ?? this.scrollPadding,
        dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
        enableInteractiveSelection:
        enableInteractiveSelection ?? this.enableInteractiveSelection,
        selectionControls: selectionControls ?? this.selectionControls,
        onTap: onTap ?? this.onTap,
        onTapOutside: onTapOutside ?? this.onTapOutside,
        mouseCursor: mouseCursor ?? this.mouseCursor,
        buildCounter: buildCounter ?? this.buildCounter,
        scrollPhysics: scrollPhysics ?? this.scrollPhysics,
        autofillHints: autofillHints ?? this.autofillHints,
        contentInsertionConfiguration:
        contentInsertionConfiguration ?? this.contentInsertionConfiguration,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        restorationId: restorationId ?? this.restorationId,
        scribbleEnabled: scribbleEnabled ?? this.scribbleEnabled,
        enableIMEPersonalizedLearning:
        enableIMEPersonalizedLearning ?? this.enableIMEPersonalizedLearning,
        canRequestFocus: canRequestFocus ?? this.canRequestFocus,
        spellCheckConfiguration:
        spellCheckConfiguration ?? this.spellCheckConfiguration,
        magnifierConfiguration:
        magnifierConfiguration ?? this.magnifierConfiguration,
      );

  @override
  State<CellTextField> createState() => _CellTextFieldState();
}

class _CellTextFieldState extends State<CellTextField> {
  final _controller = TextEditingController();
  var _suppressUpdate = false;

  /// Watches the content and selection cells for changes
  late CellWatcher _watcher;

  @override
  void initState() {
    super.initState();

    _watcher = ValueCell.watch(_onChangeCellContent);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _watcher.stop();
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CellTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content != oldWidget.content) {
      _watcher.stop();
      _watcher = ValueCell.watch(_onChangeCellContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CellWidget.builder((context) => TextField(
      controller: _controller,
      focusNode: widget.focusNode?.call(),
      decoration: widget.decoration(),
      keyboardType: widget.keyboardType?.call(),
      textInputAction: widget.textInputAction?.call(),
      textCapitalization: widget.textCapitalization(),
      style: widget.style?.call(),
      strutStyle: widget.strutStyle?.call(),
      textAlign: widget.textAlign(),
      textAlignVertical: widget.textAlignVertical?.call(),
      textDirection: widget.textDirection?.call(),
      readOnly: widget.readOnly(),
      toolbarOptions: widget.toolbarOptions?.call(),
      showCursor: widget.showCursor?.call(),
      autofocus: widget.autofocus(),
      obscuringCharacter: widget.obscuringCharacter(),
      obscureText: widget.obscureText(),
      autocorrect: widget.autocorrect(),
      smartDashesType: widget.smartDashesType?.call(),
      smartQuotesType: widget.smartQuotesType?.call(),
      enableSuggestions: widget.enableSuggestions(),
      maxLines: widget.maxLines(),
      minLines: widget.minLines?.call(),
      expands: widget.expands(),
      maxLength: widget.maxLength?.call(),
      maxLengthEnforcement: widget.maxLengthEnforcement?.call(),
      onEditingComplete: widget.onEditingComplete?.call(),
      onSubmitted: widget.onSubmitted?.call(),
      onAppPrivateCommand: widget.onAppPrivateCommand?.call(),
      inputFormatters: widget.inputFormatters?.call(),
      enabled: widget.enabled?.call(),
      cursorWidth: widget.cursorWidth(),
      cursorHeight: widget.cursorHeight?.call(),
      cursorRadius: widget.cursorRadius?.call(),
      cursorOpacityAnimates: widget.cursorOpacityAnimates?.call(),
      cursorColor: widget.cursorColor?.call(),
      selectionHeightStyle: widget.selectionHeightStyle(),
      selectionWidthStyle: widget.selectionWidthStyle(),
      keyboardAppearance: widget.keyboardAppearance?.call(),
      scrollPadding: widget.scrollPadding(),
      dragStartBehavior: widget.dragStartBehavior(),
      enableInteractiveSelection: widget.enableInteractiveSelection?.call(),
      selectionControls: widget.selectionControls?.call(),
      onTap: widget.onTap?.call(),
      onTapOutside: widget.onTapOutside?.call(),
      mouseCursor: widget.mouseCursor?.call(),
      buildCounter: widget.buildCounter?.call(),
      scrollPhysics: widget.scrollPhysics?.call(),
      autofillHints: widget.autofillHints(),
      contentInsertionConfiguration: widget.contentInsertionConfiguration?.call(),
      clipBehavior: widget.clipBehavior(),
      restorationId: widget.restorationId?.call(),
      scribbleEnabled: widget.scribbleEnabled(),
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning(),
      canRequestFocus: widget.canRequestFocus(),
      spellCheckConfiguration: widget.spellCheckConfiguration?.call(),
      magnifierConfiguration: widget.magnifierConfiguration?.call(),
    ));
  }

  void _onTextChange() {
    _withSuppressUpdates(() {
      MutableCell.batch(() {
        widget.content.value = _controller.text;
        widget.selection?.value = _controller.selection;
      });
    });
  }

  void _onChangeCellContent() {
    final text = widget.content();
    final selection = widget.selection?.call();

    _withSuppressUpdates(() {
      if (selection != null) {
        _controller.value = _controller.value.copyWith(
          text: text,
          selection: selection
        );
      }
      else {
        _controller.text = widget.content.value;
      }
    });
  }

  /// Suppress events triggered by [fn].
  ///
  /// If [fn] updates [_controller.text] do not reflect the change in
  /// [widget.content]. Similarly, if [fn] updates [widget.content] do not
  /// reflect the change in [_controller.text].
  void _withSuppressUpdates(VoidCallback fn) {
    if (!_suppressUpdate) {
      try {
        _suppressUpdate = true;
        fn();
      }
      finally {
        _suppressUpdate = false;
      }
    }
  }
}