import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// A [ListTile] with a [CellSwitch], akin to [SwitchListTile].
///
/// See [CellSwitch] for a more detailed explanation.
class CellSwitchListTile extends StatefulWidget {
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
    required this.enabled,
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
  State<CellSwitchListTile> createState() => _CellSwitchListTileState();
}

class _CellSwitchListTileState extends State<CellSwitchListTile> {
  var _suppress = false;

  @override
  Widget build(BuildContext context) {
    return widget.value.toWidget((context, value, child) => SwitchListTile(
      value: value,
      onChanged: widget.enabled ? _onChanged : null,
      activeColor: widget.activeColor,
      activeTrackColor: widget.activeTrackColor,
      inactiveThumbColor: widget.inactiveThumbColor,
      inactiveTrackColor: widget.inactiveTrackColor,
      activeThumbImage: widget.activeThumbImage,
      inactiveThumbImage: widget.inactiveThumbImage,
      hoverColor: widget.hoverColor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,

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

  void _onChanged(bool value) {
    if (!_suppress) {
      try {
        _suppress = true;
        widget.value.value = value;
      }
      finally {
        _suppress = false;
      }
    }
  }
}