import 'package:flutter/widgets.dart';

import '../base/cell_observer.dart';
import '../value_cell.dart';

/// Widget which is rebuilt whenever the value of a [ValueCell] changes.
///
/// The building of the widget is delegated to a [builder] function
class CellListenableBuilder<T> extends StatefulWidget {
  /// The cell to track.
  final ValueCell<T> cell;

  /// Widget builder function.
  final ValueWidgetBuilder<T> builder;

  /// Optional child widget to pass to third argument of [builder]
  final Widget? child;

  /// Creates a widget which is rebuilt whenever the value of [cell] changes.
  ///
  /// The building of the widget is delegated to the function [builder], which
  /// is called with three arguments: the [BuildContext], the value of the cell,
  /// and an optional [child] widget.
  const CellListenableBuilder({super.key, required this.cell, required this.builder, this.child});

  @override
  State<CellListenableBuilder<T>> createState() => _CellListenableBuilderState<T>();
}

class _CellListenableBuilderState<T> extends State<CellListenableBuilder<T>> implements CellObserver {
  /// Cell value
  late T _value;

  @override
  void initState() {
    super.initState();

    widget.cell.addObserver(this);
    _value = widget.cell.value;
  }

  @override
  void dispose() {
    widget.cell.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value, widget.child);
  }

  @override
  void update() {
    final value = widget.cell.value;

    setState(() {
      _value = value;
    });
  }

  @override
  void willNotUpdate() {}

  @override
  void willUpdate() {}
}