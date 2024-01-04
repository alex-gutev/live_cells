import 'package:flutter/cupertino.dart';

import 'deferred_cell.dart';

/// A [CellWidget] of which the [buildChild] method can be specified by a [builder] function.
///
/// This allows you to define and keep references to [ValueCell]'s between builds,
/// using [CellWidget.cell] without having to subclass [CellWidget].
class CellWidgetBuilder extends CellWidget {
  /// Widget build function.
  ///
  /// The [cellWidget] parameter provides access to the [CellWidget], on which
  /// the [CellWidget.cell] method can be called.
  ///
  /// See [CellWidget] for more information and an example.
  final Widget Function(BuildContext context, CellWidget cellWidget) builder;

  /// Create a [CellWidget] with [buildChild] defined by a [builder] function.
  CellWidgetBuilder({
    super.key,
    required this.builder
  });

  @override
  Widget buildChild(BuildContext context) {
    return builder(context, this);
  }
}