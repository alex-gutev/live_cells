import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// A [ListTile] with a [CellCheckbox], akin to [CheckboxListTile].
///
/// See [CellCheckbox] for a more detailed explanation.
class CellCheckboxListTile extends StatefulWidget {
  /// Checkbox state
  final MutableCell<bool?> value;

  /// Is the widget enabled for user input?
  final bool enabled;

  // Fields from [CheckboxListTile]

  final bool tristate;
  final Color? activeColor;
  final Color? checkColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autoFocus;
  final OutlinedBorder? checkboxShape;
  final BorderSide? side;

  final Widget? title;
  final Widget? subtitle;
  final bool isThreeLine;
  final bool? dense;
  final Widget? secondary;
  final bool selected;
  final ListTileControlAffinity controlAffinity;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool? enableFeedback;

  /// Create a CellCheckBoxListTile
  ///
  /// The only required parameter is [value] which is a [MutableCell] holding
  /// the checkbox state.
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [CheckboxListTile] constructor.
  const CellCheckboxListTile({
    super.key,
    required this.value,
    this.enabled = true,
    this.tristate = false,
    this.activeColor,
    this.checkColor,
    this.visualDensity,
    this.focusNode,
    this.autoFocus = false,
    this.checkboxShape,
    this.side,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback
  });

  @override
  State<CellCheckboxListTile> createState() => _CellCheckboxListTileState();
}

class _CellCheckboxListTileState extends State<CellCheckboxListTile> {
  var _suppressUpdate = false;

  @override
  Widget build(BuildContext context) {
    return widget.value.toWidget((_, value, __) => CheckboxListTile(
      value: value,
      onChanged: widget.enabled ? _onChanged : null,
      tristate: widget.tristate,
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      visualDensity: widget.visualDensity,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocus,
      checkboxShape: widget.checkboxShape,
      side: widget.side,

      title: widget.title,
      subtitle: widget.subtitle,
      isThreeLine: widget.isThreeLine,
      dense: widget.dense,
      secondary: widget.secondary,
      selected: widget.selected,
      controlAffinity: widget.controlAffinity,
      contentPadding: widget.contentPadding,
      shape: widget.shape,
      tileColor: widget.tileColor,
      selectedTileColor: widget.selectedTileColor,
      enableFeedback: widget.enableFeedback,
    ));
  }

  void _onChanged(bool? value) {
    if (!_suppressUpdate) {
      try {
        _suppressUpdate = true;
        widget.value.value = value;
      }
      finally {
        _suppressUpdate = false;
      }
    }
  }
}