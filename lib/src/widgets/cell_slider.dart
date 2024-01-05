import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// A slider widget, similar to [Slider], of which the value is controlled by a [ValueCell].
///
/// The slider value is controlled by a [MutableCell] which is passed on
/// construction. When the value of the cell changes, the slider position is
/// updated to reflect the value of the cell. Similarly when the slider is moved
/// by the user, the value of the cell is updated to reflect the slider position.
class CellSlider extends StatefulWidget {
  /// Slider value cell
  final MutableCell<double> value;

  /// Is the widget enabled for user input?
  final bool enabled;

  /// Fields from [Slider]

  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  final double min;
  final double max;
  final int? divisions;

  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;

  final MouseCursor? mouseCursor;

  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Create a CellSlider
  ///
  /// The only required parameter is [value], which is a [MutableCell] to which
  /// the slider value is bound. When the cell's value changes the slider position
  /// is updated to reflect the value of the cell, and similarly when the slider
  /// is moved by the user, the cell's value is updated to reflect the slider
  /// position.
  ///
  /// The [enabled] parameter controls whether the widget is enabled for user
  /// input (true) or disabled (false).
  ///
  /// The remaining parameters are the same is in the [Slider] constructor.
  const CellSlider({
    super.key,
    required this.value,
    this.enabled = true,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false
  });

  @override
  State<CellSlider> createState() => _CellSliderState();
}

class _CellSliderState extends State<CellSlider> {
  var _suppressUpdate = false;

  @override
  Widget build(BuildContext context) {
    return widget.value.toWidget((context, value, _) => Slider(
      value: value,
      onChanged: widget.enabled ? _onChanged : null,

      onChangeStart: widget.onChangeStart,
      onChangeEnd: widget.onChangeEnd,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      label: widget.label,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      thumbColor: widget.thumbColor,
      mouseCursor: widget.mouseCursor,
      semanticFormatterCallback: widget.semanticFormatterCallback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    ));
  }

  void _onChanged(double value) {
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