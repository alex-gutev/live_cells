import 'dart:collection';

import '../base/cell_state.dart';
import '../base/exceptions.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import 'compute_cell_state.dart';

/// A computational cell which determines its dependencies at runtime
/// 
/// Usage:
/// 
/// Create a [DynamicComputeCell] by passing the value computation function
/// to the default constructor:
/// 
/// ```dart
/// final sum = DyanmicComputeCell(() => a() + b());
/// ```
class DynamicComputeCell<T> extends StatefulCell<T> implements RestorableCell<T> {
  /// Create a cell which computes its value using [compute].
  DynamicComputeCell(this._compute);

  @override
  T get value {
    final state = _state;

    if (state == null) {
      try {
        return _untrackedCompute();
      }
      on StopComputeException catch (e) {
        return e.defaultValue;
      }
    }

    return state.value;
  }


  // Private

  _DynamicComputeCellState<T>? get _state => currentState<_DynamicComputeCellState<T>>();

  /// Value computation function
  final T Function() _compute;

  /// State restored by restoreState();
  late CellState? _restoredState;

  @override
  CellState createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    return _DynamicComputeCellState(
      cell: this,
      key: key,
    );
  }

  @override
  Object? dumpState(CellValueCoder coder) {
    return coder.encode(value);
  }

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    final restoredState = _state ?? createState() as _DynamicComputeCellState<T>;
    restoredState.restoreValue(coder.decode(state));
  }

  /// Call [_compute] without tracking referenced argument cells.
  ///
  /// This is to ensure that the referenced cells do not leak up to other
  /// cells referencing this cells [value].
  T _untrackedCompute() =>
      ComputeArgumentsTracker.computeWithTracker(_compute, (_) { });
}

/// Provides static methods for tracking computational cell arguments at runtime.
extension ComputeArgumentsTracker<T> on ValueCell<T> {
  /// Inform the current argument cell listener that the value of [cell] was referenced. 
  static void trackArgument(ValueCell cell) {
    _onUseArgument?.call(cell);
  }

  /// Compute a cell value using [fn] while tracking argument cells using [tracker].
  /// 
  /// When the value of an cell is referenced in [fn], [tracker] is called with
  /// the referenced cell passed as an argument.
  /// 
  /// Returns the value computed by [fn].
  static T computeWithTracker<T>(T Function() fn, void Function(ValueCell) tracker) {
    final prevTracker = _onUseArgument;
    
    try {
      _onUseArgument = tracker;
      return fn();
    }
    finally {
      _onUseArgument = prevTracker;
    }
  }

  /// Private

  /// Callback function to call whenever a the value of a cell is referenced.
  static void Function(ValueCell dep)? _onUseArgument;
}

class _DynamicComputeCellState<T> extends ComputeCellState<T, DynamicComputeCell<T>> {
  _DynamicComputeCellState({
    required super.cell,
    required super.key,
  }) : super(arguments: HashSet());

  void restoreValue(T value) {
    setValue(value);
  }

  @override
  T compute() => ComputeArgumentsTracker.computeWithTracker(cell._compute, (arg) {
    arg.addObserver(this);
    arguments.add(arg);
  });
}