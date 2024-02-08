import 'dynamic_compute_cell.dart';
import '../mutable_cell/mutable_dependent_cell.dart';
import 'mutable_computed_cell_state.dart';

/// A mutable computational cell which determines is dependencies at runtime
///
/// Usage:
///
/// Create a [DynamicMutableComputeCell] by passing the value computation function,
/// and reverse computation function to the default constructor:
///
/// ```dart
/// final sum = DynamicMutableComputeCell(() => a() + b(), (sum) {
///   final half = sum / 2;
///   a.value = half;
///   b.value = half;
/// });
/// ```
class DynamicMutableComputeCell<T> extends MutableDependentCell<T> {
  DynamicMutableComputeCell({
    required T Function() compute,
    required void Function(T) reverseCompute,
  }) : _compute = compute, _reverseCompute = reverseCompute, super({});

  @override
  T compute() => ComputeArgumentsTracker.computeWithTracker(_compute, (_) {});

  @override
  void reverseCompute(T value) {
    _reverseCompute(value);
  }

  /// Private

  final T Function() _compute;
  final void Function(T) _reverseCompute;

  @override
  MutableComputedCellState<T, DynamicMutableComputeCell<T>> createMutableState({
    covariant MutableComputedCellState<T, DynamicMutableComputeCell<T>>? oldState
  }) => _DynamicMutableComputeCellState(
      cell: this,
      key: key,
      oldState: oldState
  );
}

class _DynamicMutableComputeCellState<T>
    extends MutableComputedCellState<T, DynamicMutableComputeCell<T>> {
  _DynamicMutableComputeCellState({
    required super.cell,
    required super.key,
    super.oldState
  }) : super(arguments: {});

  @override
  T compute() => ComputeArgumentsTracker.computeWithTracker(cell._compute, (arg) {
    if (!arguments.contains(arg)) {
      arg.addObserver(this);
      arguments.add(arg);
    }
  });
}