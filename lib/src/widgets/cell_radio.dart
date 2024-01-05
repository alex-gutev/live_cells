import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// A [Radio] widget with the group value controlled by a [ValueCell].
///
/// The radio group value is controlled by a [MutableCell] which is passed on
/// construction. When the value of the cell changes, the radio button state is
/// updated to reflect the value of the cell. Similarly when the radio button is
/// selected by the user, the value of the group value cell is set to
/// the [value] associated with the widget.
class CellRadio<T> extends StatefulWidget {
  /// Radio group value
  final MutableCell<T?> groupValue;

  /// Is the widget enabled for user input?
  final bool enabled;

  // Fields from [Radio]

  final T value;

  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autoFocus;

  /// Create a CellRadio
  ///
  /// The only required parameters are:
  ///
  /// * [value] -- the value associated with this button
  /// * [groupValue] -- [MutableCell] holding the radio group value
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [Radio] constructor.
  const CellRadio({
    super.key,
    required this.groupValue,
    required this.value,
    this.enabled = true,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autoFocus = false
  });

  @override
  State<CellRadio<T>> createState() => _CellRadioState<T>();
}

class _CellRadioState<T> extends State<CellRadio<T>> {
  var _suppressUpdate = false;

  @override
  Widget build(BuildContext context) {
    return widget.groupValue.toWidget((_, groupValue, __) => Radio(
      value: widget.value,
      groupValue: groupValue,
      onChanged: widget.enabled ? _onChanged : null,

      mouseCursor: widget.mouseCursor,
      toggleable: widget.toggleable,
      activeColor: widget.activeColor,
      fillColor: widget.fillColor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      overlayColor: widget.overlayColor,
      splashRadius: widget.splashRadius,
      materialTapTargetSize: widget.materialTapTargetSize,
      visualDensity: widget.visualDensity,
      focusNode: widget.focusNode,
      autofocus: widget.autoFocus,
    ));
  }

  void _onChanged(T? value) {
    if (!_suppressUpdate) {
      try {
        _suppressUpdate = true;
        widget.groupValue.value = value;
      }
      finally {
        _suppressUpdate = false;
      }
    }
  }
}