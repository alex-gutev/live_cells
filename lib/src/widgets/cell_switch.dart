import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// A [Switch] widget with the switch state controlled by a [ValueCell].
///
/// The switch state is controlled by a [MutableCell] which is passed on
/// construction. When the value of the cell changes, the switch state is
/// updated to reflect the value of the cell. Similarly when the switch is
/// toggled by the user, the value of the state cell is updated to reflect
/// the switch state.
class CellSwitch extends StatefulWidget {
  /// Switch state cell
  final MutableCell<bool> value;

  /// Is the widget enabled for user input?
  final bool enabled;

  // Fields from [Switch]

  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final ImageProvider<Object>? activeThumbImage;
  final ImageErrorListener? onActiveThumbImageError;
  final ImageProvider<Object>? inactiveThumbImage;
  final ImageErrorListener? onInactiveThumbImageError;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Create a CellSwitch
  ///
  /// The only required parameter is [value] which is a [MutableCell] holding
  /// the switch state.
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [Switch] constructor.
  const CellSwitch({
    super.key,
    required this.value,
    required this.enabled,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false
  });

  @override
  State<CellSwitch> createState() => _CellSwitchState();
}

class _CellSwitchState extends State<CellSwitch> {
  var _suppress = false;
  
  @override
  Widget build(BuildContext context) {
    return widget.value.toWidget((context, value, child) => Switch(
      value: value,
      onChanged: widget.enabled ? _onChanged : null,
      activeColor: widget.activeColor,
      activeTrackColor: widget.activeTrackColor,
      inactiveThumbColor: widget.inactiveThumbColor,
      inactiveTrackColor: widget.inactiveTrackColor,
      activeThumbImage: widget.activeThumbImage,
      onActiveThumbImageError: widget.onActiveThumbImageError,
      inactiveThumbImage: widget.inactiveThumbImage,
      onInactiveThumbImageError: widget.onActiveThumbImageError,
      thumbColor: widget.thumbColor,
      trackColor: widget.trackColor,
      materialTapTargetSize: widget.materialTapTargetSize,
      dragStartBehavior: widget.dragStartBehavior,
      mouseCursor: widget.mouseCursor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      focusNode: widget.focusNode,
      overlayColor: widget.overlayColor,
      splashRadius: widget.splashRadius,
      autofocus: widget.autofocus,
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