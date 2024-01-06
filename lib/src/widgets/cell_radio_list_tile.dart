import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// A [ListTile] with a [CellRadio], akin to [RadioListTile].
///
/// See [CellRadio] for a more detailed explanation.
class CellRadioListTile<T> extends StatelessWidget {
  /// Radio group value
  final MutableCell<T?> groupValue;

  /// Is the widget enabled for user input?
  final bool enabled;

  // Fields from [RadioListTile]

  final T value;

  final bool toggleable;
  final Color? activeColor;

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

  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool? enableFeedback;

  /// Create a CellRadioListTile
  ///
  /// The only required parameters are:
  ///
  /// * [value] -- the value associated with this button
  /// * [groupValue] -- [MutableCell] holding the radio group value
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [RadioListTile] constructor.
  const CellRadioListTile({
    super.key,
    required this.groupValue,
    required this.value,
    this.enabled = true,
    this.toggleable = false,
    this.activeColor,
    this.visualDensity,
    this.focusNode,
    this.autoFocus = false,
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
    return groupValue.toWidget((_, groupValue, __) => RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: enabled
          ? (T? value) => this.groupValue.value = value
          : null,

      activeColor: activeColor,
      toggleable: toggleable,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autoFocus,

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