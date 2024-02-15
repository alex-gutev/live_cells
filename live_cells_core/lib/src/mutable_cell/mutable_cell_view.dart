import '../compute_cell/compute_cell.dart';
import 'mutable_cell.dart';

/// A lightweight mutable computed cell that doesn't store its own value.
class MutableCellView<T> extends ComputeCell<T> implements MutableCell<T> {
  /// Create a lightweight mutable computed cell.
  ///
  /// The created cell has computation function [compute] of the argument cells
  /// [arguments] and reverse computation function [reverse].
  ///
  /// The cells in [arguments] do not have to be [MutableCell]s but in general
  /// they should either be the same cells that are set in [reverse] or immediate
  /// successors of them.
  ///
  /// A [key] can also be supplied that uniquely identifies this cell
  ///
  /// If [willChange] is non-null, it is called to determine whether the cell's
  /// value will change for a change in the value of an argument cell. It is
  /// called with the argument cell and its new value passed as arguments. The
  /// function should return true if the cell's value may change, and false if
  /// it can be determined with certainty that it wont. **NOTE**: this function
  /// is only called if the new value of the argument cell is known, see
  /// [CellObserver.willChange] for more information.
  ///
  /// **CAUTION**: This cell has slightly different semantics from
  /// [MutableComputeCell]. Its value is always recomputed from the argument
  /// cells, even after it is set explicitly. Thus, it is even more important
  /// that [reverse] assigns values to the argument cells that will result in
  /// the same value being computed as the value that was assigned.
  MutableCellView({
    required super.arguments,
    required super.compute,
    required this.reverse,
    super.key,
    super.willChange
  });

  @override
  set value(T value) {
    MutableCell.batch(() {
      reverse(value);
    });
  }

  // Private

  /// Reverse computation function
  final void Function(T) reverse;
}