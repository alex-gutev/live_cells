import 'package:flutter/widgets.dart';
import 'package:live_cells_core/live_cells_core.dart';

/// Provides functionality for creating [Widget]'s from [ValueCell]'s
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
        valueListenable: listenable,
        builder: builder,
        child: child
    );
  }
}

/// Provides the [widget] method for directly creating a [Widget] from a [ValueCell] which holds a [Widget].
extension WidgetCellExtension on ValueCell<Widget> {
  /// Create a [Widget] out of the cell's value.
  ///
  /// The returned widget is automatically rebuilt whenever the cell's value
  /// changes.
  Widget widget() => toWidget((_, value, __) => value);
}

/// Extends [List] with a method for creating a [Widget] which is dependent on one or more [ValueCell]'s.
extension ComputeWidgetExtension on List {
  /// Create a [Widget] which is dependent on the [ValueCell]'s in [this].
  ///
  /// The widget is defined by the function [builder], which is called to build
  /// the widget whenever the value of one of the cells in [this] is changed.
  ///
  /// Example:
  ///
  /// ````dart
  /// final a = MutableCell(0);
  /// final b = MutableCell(1);
  /// final sum = a + b;
  ///
  /// ...
  ///
  /// final widget =
  ///    [a, b, sum].computeWidget(() => Text('${a.value} + ${b.value} = ${sum.value}'))
  /// ````
  Widget computeWidget(Widget Function() builder) => computeCell(builder).widget();
}