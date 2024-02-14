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
  MutableCellView({
    required this.argument,
    required this.reverse,
    required super.compute,
    super.key
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