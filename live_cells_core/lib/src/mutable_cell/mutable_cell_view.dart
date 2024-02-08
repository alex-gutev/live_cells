import '../compute_cell/compute_cell.dart';
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
  final MutableCell argument;

  /// Reverse computation function
  final void Function(T) reverse;
}