import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// A [ListTile] with a [CellSwitch], akin to [SwitchListTile].
///
/// See [CellSwitch] for a more detailed explanation.
class CellSwitchListTile extends StatelessWidget {
  /// Switch state cell
  final MutableCell<bool> value;

  /// Is the widget enabled for user input?
  final bool enabled;

  // Fields from [SwitchListTile]

  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider<Object>? activeThumbImage;
  final ImageProvider<Object>? inactiveThumbImage;
  final Color? hoverColor;
  final FocusNode? focusNode;
  final bool autofocus;

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

  /// Create a CellSwitchListTile
  ///
  /// The only required parameter is [value] which is a [MutableCell] holding
  /// the switch state.
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [SwitchListTile] constructor.
  const CellSwitchListTile({
    super.key,
    required this.value,
    this.enabled = true,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
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
    return value.toWidget((context, state, child) => SwitchListTile(
      value: state,
      onChanged: enabled
          ? (state) => value.value = state
          : null,

      activeColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      activeThumbImage: activeThumbImage,
      inactiveThumbImage: inactiveThumbImage,
      hoverColor: hoverColor,
      focusNode: focusNode,
      autofocus: autofocus,

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