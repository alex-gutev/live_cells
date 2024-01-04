part of 'deferred_cell.dart';

/// Base class for widget which manages one or more [ValueCell] instances.
///
/// This usage of this class is similar to [StatelessWidget] however subclasses
/// should override the [buildChild] method instead of [build].
///
/// Within [buildChild] the [cell] method can be used to obtain an instance of
/// a [ValueCell] that is persisted between builds of the widget.
///
/// In the first call to [buildChild] every call to [cell] will create a new
/// [ValueCell] instance using the corresponding cell creation function passed
/// as an argument.
///
/// In subsequent calls to [buildChild], calls to [cell] return the existing
/// [ValueCell] instance created using the corresponding cell creation function
/// during a previous call to [buildChild]
///
/// Example:
///
/// ````dart
/// class Example extends CellWidget {
///   @override
///   Widget buildChild(BuildContext context) {
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
///    thosed used with [Builder] or [ValueListenableBuilder].
/// 3. The cell returned by [cell] may only be referenced within a cell creation
///    function, used with [cell]. The only exception is converting the cell to
///    a widget using [ValueCell.toWidget].
abstract class CellWidget extends StatelessWidget {
  CellWidget({super.key});

  /// Build the user interface represented by this widget.
  Widget buildChild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    try {
      DeferredCell._stopInit = true;
      final child = buildChild(context);

      return _DeferredCellBuilder(
          deferredCells: _deferredCells,
          child: child
      );
    }
    finally {
      DeferredCell._stopInit = false;
    }
  }

  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// This function is intended to be used with [buildChild] to create and
  /// retrieve an instance of a [ValueCell], so that the same instance will be
  /// returned across calls to [buildChild].
  ///
  /// In the first call to [buildChild]: every call to [cell] will result in a
  /// new [ValueCell] instance being created by calling the corresponding [create]
  /// function.
  ///
  /// In subsequent calls to [buildChild], [cell] returns the existing [ValueCell]
  /// instance previously created using the corresponding [create] function.
  ///
  /// The returned [DeferredCell] will function as though its the cell returned
  /// by [create]. However, the [DeferredCell] may only be referenced within
  /// a cell creation function of [cell]. Outside of a cell creation function it
  /// may only be used to call the [ValueCell.toWidget] method.
  DeferredCell<T> cell<T>(CreateCell<ValueCell<T>> create) {
    final cell = DeferredCell(create);
    _deferredCells.add(cell);

    return cell;
  }

  /// Private

  final List<DeferredCell> _deferredCells = [];
}

/// Keeps track of deferred [ValueCell] instances between builds.
class _DeferredCellBuilder extends StatefulWidget {
  /// List of deferred cell proxy objects
  final List<DeferredCell> deferredCells;

  final Widget child;

  /// Create a new deferred cell builder with a list of [DeferredCell]'s.
  ///
  /// On the first build the deferred cells in [deferredCells] are created
  /// using their respective cell creation functions. In subsequent builds, the
  /// [deferredCells] are assigned the corresponding [ValueCell] instances from
  /// the previous build.
  ///
  /// It is an error to pass a [deferredCells] list that is of a different
  /// length than what was previously passed.
  const _DeferredCellBuilder({
    super.key,
    required this.deferredCells,
    required this.child
  });

  @override
  State<_DeferredCellBuilder> createState() => _DeferredCellBuilderState();
}

class _DeferredCellBuilderState extends State<_DeferredCellBuilder> {
  late final List<ValueCell> _cells;

  @override
  void initState() {
    super.initState();

    _cells = widget.deferredCells.map((e) => e._getCell()).toList();
  }

  @override
  void didUpdateWidget(covariant _DeferredCellBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    assert(_cells.length == widget.deferredCells.length);

    for (var i = 0; i < widget.deferredCells.length; i++) {
      widget.deferredCells[i]._initCell(_cells[i]);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}