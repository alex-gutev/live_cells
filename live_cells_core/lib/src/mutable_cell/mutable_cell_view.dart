import '../compute_cell/compute_cell.dart';
import '../value_cell.dart';
import 'mutable_cell.dart';

/// A lightweight mutable computed cell that doesn't store its only value.
///
/// **NOTE**: This cell is restricted to a single argument only
class MutableCellView<T> extends ComputeCell<T> implements MutableCell<T> {
  /// Create a lightweight mutable computed cell.
  ///
  /// The created cell has computation function [compute] of the argument cell
  /// [argument] and reverse computation function [reverse].
  ///
  /// [argument] does not have to be a [MutableCell] but in general it should
  /// either be the same cell that is set in [reverse] or an immediate
  /// successor of it.
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
  MutableCellView({
    required this.argument,
    required this.reverse,
    required super.compute,
    super.key,
    super.willChange
  }) : super(arguments: [argument]);

  @override
  set value(T value) {
    reverse(value);
  }

  // Private

  /// Argument cell
  final ValueCell argument;

  /// Reverse computation function
  final void Function(T) reverse;
}