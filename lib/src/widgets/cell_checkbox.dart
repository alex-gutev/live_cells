import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// A [Checkbox] widget with the checkbox state controlled by a [ValueCell].
///
/// The checkbox state is controlled by a [MutableCell] which is passed on
/// construction. When the value of the cell changes, the checkbox state is
/// updated to reflect the value of the cell. Similarly when the state of the
/// checkbox state is changed by the user, the value of the cell is updated to
/// reflect the state.
class CellCheckbox extends StatelessWidget {
  /// Checkbox state
  final MutableCell<bool?> value;

  /// Is the widget enabled for user input?
  final bool enabled;

  // Fields from [Checkbox]

  final bool tristate;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autoFocus;
  final OutlinedBorder? shape;
  final BorderSide? side;

  /// Create a CellCheckbox
  ///
  /// The only required parameter is [value] which is a [MutableCell] holding
  /// the checkbox state.
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [Checkbox] constructor.
  const CellCheckbox({
    super.key,
    required this.value,
    this.enabled = true,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autoFocus = false,
    this.shape,
    this.side,
  });

  @override
  Widget build(BuildContext context) {
    return value.toWidget((_, state, __) => Checkbox(
      value: state,
      onChanged: enabled 
          ? (state) => value.value = state
          : null,

      tristate: tristate,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autoFocus,
      shape: shape,
      side: side
    ));
  }
}