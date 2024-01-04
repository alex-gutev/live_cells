part of 'deferred_cell.dart';

/// Base class for widget which manages one or more [ValueCell] instances.
///
/// This usage of this class is similar to [StatelessWidget] however subclasses
/// should override the [buildChild] method instead of [build].
///
/// Within [buildChild] the [defer] and [mutableDefer] functions can be used to
/// obtain instances to [ValueCell]'s and [MutableCell]'s which are kept between
/// builds of the widget.
///
/// In the first call to [buildChild] every call to [defer] and [mutableDefer]
/// will create a new [ValueCell] instance using the corresponding cell creation
/// function passed as an argument.
///
/// In subsequent calls to [buildChild], calls to [defer] and [mutableDefer]
/// return the existing [ValueCell] instance created using the corresponding
/// cell creation function during a previous call to [buildChild]
///
/// Example:
///
/// ````dart
/// class Example extends CellWidget {
///   @override
///   Widget buildChild(BuildContext context) {
///     final a = mutableDefer(() => MutableCell(0));
///     final b = mutableDefer(() => MutableCell(1));
///
///     final sum = defer(() => a + b);
///     final product = defer(() => a * b);
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
/// In the example above, when [buildChild] is called for the first time, two
/// mutable cells are created and assigned to `a` and `b`, and two computational
/// cells `a + b`, `a * b` are assigned to `sum` and `product`, respectively.
/// In subsequent calls to [buildChild], the two calls to [mutableDefer]
/// return the same [MutableCell] instances created during the 1st call and
/// `defer(() => a + b)` returns the existing instance of the cell `a + b`, while
/// `defer(() => a * b)` returns the existing instance of the cell `a * b`.
///
/// With this class cell definitions can be kept directly within the build function
/// without having to use a [StatefulWidget].
///
/// **NOTE**:
///
/// Uses of [defer] and [mutableDefer] have to obey the following rules:
///
/// 1. Calls to [defer] and [mutableDefer] must not appear within conditionals or
///    loops.
/// 2. Calls to [defer] and [mutableDefer] must not appear within widget builder
///    functions, such as when using [Builder] or [ValueListenableBuilder].
/// 3. The cells returned by [defer] and [mutableDefer] may only be referenced
///    within a cell creation function, used with [defer] and [mutableDefer].
///    If they are referenced outside a cell creation function, only the method
///    [ValueCell.toWidget] may be called.
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
  /// In the first call to [buildChild]: every call to [defer] will result in a
  /// new [ValueCell] instance being created by calling the corresponding [create]
  /// function.
  ///
  /// In subsequent calls to [buildChild], [defer] returns the existing [ValueCell]
  /// instance previously created using the corresponding [create] function.
  ///
  /// The returned [DeferredCell] will function as though its the cell returned
  /// by [create]. However, the [DeferredCell] may only be referenced within
  /// the cell creation functions of [defer] and [mutableDefer]. Outside of a
  /// cell creation function it may only be used to call the [ValueCell.toWidget]
  /// method.
  DeferredCell<T> defer<T>(CreateCell<ValueCell<T>> create) {
    final cell = DeferredCell(create);
    _deferredCells.add(cell);

    return cell;
  }

  /// Same as [defer] however returns a [MutableCell].
  ///
  /// **NOTE**: The [DeferredCell] returned by this method can also have its
  /// [value] property assigned. This can only be done after the widget has been
  /// built, that is [buildChild] has been called, at least once.
  MutableDeferredCell<T> mutableDefer<T>(CreateCell<MutableCell<T>> create) {
    final cell = MutableDeferredCell(create);
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