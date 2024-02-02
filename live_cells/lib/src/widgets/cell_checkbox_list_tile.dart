import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// A [ListTile] with a [CellCheckbox], akin to [CheckboxListTile].
///
/// See [CellCheckbox] for a more detailed explanation.
class CellCheckboxListTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return value.toWidget((_, state, __) => CheckboxListTile(
      value: state,
      onChanged: enabled
          ? (state) => value.value = state
          : null,

      tristate: tristate,
      activeColor: activeColor,
      checkColor: checkColor,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autoFocus,
      checkboxShape: checkboxShape,
      side: side,

      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      dense: dense,
      secondary: secondary,
      selected: selected,
      controlAffinity: controlAffinity,
      contentPadding: contentPadding,
      shape: shape,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
    ));
  }
}