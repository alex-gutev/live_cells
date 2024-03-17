import 'package:flutter/cupertino.dart';
import 'package:live_cell_widgets/live_cell_widgets_base.dart';
import 'package:live_cells_core/live_cells_core.dart';

/// A widget is rebuilt in response to changes in the value of a cell.
class CellListenerWidget<T> extends StatefulWidget {
  final ValueCell<T> cell;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  /// Create a widget that is rebuilt in response to changes in the value of [cell].
  ///
  /// [builder] is called when the value of [cell] changes. The value of [cell]
  /// is passed to builder along with the [child] widget.
  ///
  /// **NOTE**: If an exception is thrown while referencing the value of [cell],
  /// after the initial build, the exception is handled and the widget is not
  /// rebuilt. If an exception is thrown when referencing the value of [cell],
  /// for the first time, the exception is not handled.
  const CellListenerWidget({
    super.key,
    required this.cell,
    required this.builder,
    this.child
  });

  @override
  State<CellListenerWidget<T>> createState() => _CellListenerWidgetState<T>();
}

class _CellListenerWidgetState<T> extends State<CellListenerWidget<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    widget.cell.listenable.addListener(_updateValue);

    _value = widget.cell.value;
  }

  @override
  void didUpdateWidget(covariant CellListenerWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.cell != oldWidget.cell) {
      widget.cell.listenable.addListener(_updateValue);
      oldWidget.cell.listenable.removeListener(_updateValue);

      _value = widget.cell.value;
    }
  }

  @override
  void dispose() {
    widget.cell.listenable.removeListener(_updateValue);
    super.dispose();
  }

  void _updateValue() {
    setState(() {
      try {
        _value = widget.cell.value;
      }
      catch (e) {
        // Rebuild with previous value.
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _value, widget.child);
}