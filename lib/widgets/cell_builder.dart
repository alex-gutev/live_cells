import 'package:flutter/widgets.dart';

import '../base/value_cell.dart';

/// Cell creation function.
///
/// The cell is called with no arguments and should return a [ValueCell].
typedef CreateCell<T extends ValueCell> = T Function();

/// Builder function for [CellBuilder].
///
/// This function is called to build the widget with [cell] being the instance
/// of the cell and [child] being an optional child widget supplied to
/// [CellBuilder].
typedef BuildCellWidget<T extends ValueCell> =
  Widget Function(BuildContext context, T cell, Widget? child);

/// Manages the creation of a cell, and exposes it to child widgets.
///
/// The purpose of this class is to avoid unnecessary uses of StatefulWidget
/// just to create a cell which is only used by child widgets in the tree.
class CellBuilder<T extends ValueCell> extends StatefulWidget {
  /// Function which is called to create the cell
  final CreateCell<T> create;

  /// Function which is called to build the widget
  final BuildCellWidget<T> builder;

  /// Child widget passed in [child] argument to [builder]
  final Widget? child;

  /// Create a CellBuilder to manage the creation of a cell.
  ///
  /// The cell is created when the widget is first initialized by calling [create].
  /// The [builder] function is called to build the widget passing in the cell
  /// returned by [create] and the optional [child] widget.
  ///
  /// **NOTE**: This widget is not rebuilt when the cell's value changes, use
  /// [toWidget] to listen for changes. This class is merely a helper for
  /// creating [ValueCell]'s which are only used by a select few widgets.
  const CellBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.child
  });

  @override
  State<CellBuilder<T>> createState() => _CellBuilderState<T>();
}

class _CellBuilderState<T extends ValueCell> extends State<CellBuilder<T>> {
  late final T cell;

  @override
  void initState() {
    super.initState();
    cell = widget.create();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, cell, widget.child);
  }
}