import 'package:flutter/widgets.dart';

import '../base/cell_listenable.dart';
import '../value_cell.dart';

/// Provides functionality for creating [Widgets[ from ValueCells
extension WidgetExtension<T> on ValueCell<T> {
  /// Create a [Widget] which depends on the cell's value.
  ///
  /// The [builder] function, see [ValueListenable.builder] for details
  /// of the arguments, is called with the cells value to build the widget.
  /// Whenever the value of the cell changes, the [builder] function is called
  /// to rebuild the widget.
  ///
  /// If [child] is non-null it is passed as the third argument to the
  /// [builder] function. This is a Widget which is inserted in the
  /// Widget tree returned by the builder function but does not depend
  /// on the value of the cell and hence should not be rebuilt if the cell
  /// value changes.
  Widget toWidget(ValueWidgetBuilder<T> builder, {
    Widget? child
  }) {
    return ValueListenableBuilder(
        key: ObjectKey(this),
        valueListenable: listenable,
        builder: builder,
        child: child
    );
  }
}