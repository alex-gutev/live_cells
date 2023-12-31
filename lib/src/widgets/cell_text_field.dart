import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base/cell_listenable.dart';
import '../mutable_cell/mutable_cell.dart';

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

  // Fields from [TextField]

  final FocusNode? node;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? showCursor;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autoCorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final VoidCallback? onEdittingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final GestureTapCallback? onTap;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;
  final bool canRequestFocus;

  /// Create a CellTextField.
  ///
  /// The only required parameter is [content] which is a [MutableCell] to which
  /// the content of the text field is bound. Whenever the cell's value changes
  /// the content is updated to reflect the cell value, and similarly when
  /// the cell's value changes, the content of the text field is updated to
  /// reflect the value of the cell.
  ///
  /// The remaining parameters are the same as in the constructor of [TextField].
  const CellTextField({
    super.key,
    required this.content,
    this.node,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style, this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autoCorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onEdittingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const [],
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.canRequestFocus = true,
  });

  @override
  State<CellTextField> createState() => _CellTextFieldState();
}

class _CellTextFieldState extends State<CellTextField> {
  final _controller = TextEditingController();
  var _suppressUpdate = false;

  @override
  void initState() {
    super.initState();

    _onChangeCellContent();
    widget.content.listenable.addListener(_onChangeCellContent);

    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.content.listenable.removeListener(_onChangeCellContent);
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CellTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content != oldWidget.content) {
      oldWidget.content.listenable.removeListener(_onChangeCellContent);

      _onChangeCellContent();
      widget.content.listenable.addListener(_onChangeCellContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.node,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autoCorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onEditingComplete: widget.onEdittingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      scribbleEnabled: widget.scribbleEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    );
  }

  void _onTextChange() {
    try {
      _suppressUpdate = true;
      widget.content.value = _controller.text;
    }
    finally {
      _suppressUpdate = false;
    }
  }

  void _onChangeCellContent() {
    if (!_suppressUpdate) {
      _controller.text = widget.content.value;
    }
  }
}