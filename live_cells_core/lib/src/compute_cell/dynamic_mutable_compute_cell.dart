import '../base/types.dart';
import '../value_cell.dart';
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
    super.shouldNotify
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
  }) {
    if (shouldNotify != null) {
      return _DynamicMutableComputedCellStateNotifierCheck(
          cell: this,
          key: key,
          shouldNotify: shouldNotify!
      );
    }

    return _DynamicMutableComputeCellState(
        cell: this,
        key: key,
        oldState: oldState
    );
  }
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

/// A [_DynamicMutableComputeCellState] with [shouldNotify] defined by a callback function.
class _DynamicMutableComputedCellStateNotifierCheck<T>
    extends _DynamicMutableComputeCellState<T> {

  final ShouldNotifyCallback _shouldNotify;

  _DynamicMutableComputedCellStateNotifierCheck({
    required super.cell,
    required super.key,
    required ShouldNotifyCallback shouldNotify
  }) : _shouldNotify = shouldNotify;

  @override
  bool shouldNotify(ValueCell cell, newValue) => _shouldNotify(cell, newValue);
}