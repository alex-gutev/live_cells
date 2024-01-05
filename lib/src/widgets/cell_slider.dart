import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class CellSlider extends StatefulWidget {
  final MutableCell<double> value;
  final bool enabled;

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