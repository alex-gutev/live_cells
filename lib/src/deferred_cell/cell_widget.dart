import 'package:flutter/widgets.dart';

import '../mutable_cell/mutable_cell.dart';
import '../value_cell.dart';
import 'proxy_cell.dart';

/// Cell creation function.
///
/// The cell is called with no arguments and should return a [ValueCell].
typedef CreateCell<T extends ValueCell> = T Function();

/// Base class for a widget which manages one or more [ValueCell] instances.
///
/// The [cell] method can be used within [build] to obtain an instance of
/// a [ValueCell] that is persisted between builds of the widget.
///
/// During the first build every call to [cell] will create a new [ValueCell] 
/// instance using the provided cell creation function. In subsequent builds
/// calls to [cell] return the existing instance that was created during the
/// first build using the corresponding cell creation function.
///
/// Example:
///
/// ````dart
/// class Example extends CellWidget {
///   @override
///   Widget build(BuildContext context) {
///     final a = cell(() => MutableCell(0));
///     final b = cell(() => MutableCell(1));
///
///     final sum = cell(() => a + b);
///     final product = cell(() => a * b);
///
///     return Column(
///       children: [
///          sum.toWidget((c, sum, _) => Text('a + b = $sum')),
///          product.toWidget((c, product, _) => Text('a * b = $product')),
///          ...
///       ]
///     );
///   }
/// }
/// ````
///
/// In the example above, when the widget is built for the first time, two
/// mutable cells are created and assigned to `a` and `b`, and two computational
/// cells `a + b`, `a * b` are assigned to `sum` and `product`, respectively.
/// In subsequent builds, the first two calls to [cell] return the same
/// [MutableCell] instances created during the first build and
/// `cell(() => a + b)` returns the existing instance of the cell `a + b`, while
/// `cell(() => a * b)` returns the existing instance of the cell `a * b`.
///
/// With this class cell definitions can be kept directly within the build function
/// without having to use a [StatefulWidget].
///
/// **NOTE**:
///
/// Uses of [cell] have to obey the following rules:
///
/// 1. Calls to [cell] must not appear within conditionals or loops.
/// 2. Calls to [cell] must not appear within widget builder functions, such as
///    those used with [Builder] or [ValueListenableBuilder].
abstract class CellWidget extends StatelessWidget {
  const CellWidget({super.key});

  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// This function is intended to be used within [build] to create and
  /// retrieve an instance of a [ValueCell], so that the same instance will be
  /// returned across calls to [build].
  ///
  /// During the first build of the widget every call to [cell] will result in a
  /// new [ValueCell] instance being created by calling the provided [create]
  /// function. In subsequent calls to builds, [cell] returns the existing
  /// [ValueCell] instance that was created during the first build using the 
  /// corresponding [create] function.
  MutableCell<T> cell<T>(CreateCell<ValueCell<T>> create) {
    final cell = _activeCellElement!.getCell(create);
    _activeCellElement!.nextCell();

    return cell;
  }

  @override
  StatelessElement createElement() => _CellWidgetElement(this);

  /// Private
  
  /// The element of the [CellWidget] currently being built.
  static _CellWidgetElement? _activeCellElement;
}

/// Widget element for [CellWidget]
/// 
/// Keeps track of the cell instances that were created during the lifetime of
/// the widget.
class _CellWidgetElement extends StatelessElement {
  _CellWidgetElement(super.widget);
  
  /// List of created cells
  final List<ProxyCell> _cells = [];
  
  /// Index of cell to retrieve/create when calling [getCell]
  var _curCell = 0;

  /// Retrieve/create the current cell.
  /// 
  /// If there is no cell instance at the current cell index, [create] is called
  /// to create a new instance. Calling [getCell] again at the current cell index
  /// returns the existing cell instance.
  /// 
  /// The cell index can be advanced using [nextCell].
  ProxyCell<T> getCell<T>(CreateCell<ValueCell<T>> create) {
    if (_curCell < _cells.length) {
      return _cells[_curCell] as ProxyCell<T>;
    }

    final cell = ProxyCell(create());
    _cells.add(cell);

    return cell;
  }

  /// Advance the cell index by 1.
  ///
  /// Calling [getCell] after [nextCell] will retrieve the cell at the next
  /// cell index.
  void nextCell() {
    _curCell++;
  }

  @override
  Widget build() {
    try {
      _curCell = 0;
      CellWidget._activeCellElement = this;
      return super.build();
    }
    finally {
      CellWidget._activeCellElement = null;
    }
  }
}