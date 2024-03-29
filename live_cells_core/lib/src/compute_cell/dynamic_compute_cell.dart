import 'dart:collection';

import 'package:meta/meta.dart';

import '../base/types.dart';
import '../maybe_cell/maybe.dart';
import '../stateful_cell/cell_state.dart';
import '../base/exceptions.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/changes_only_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import 'compute_cell_state.dart';

part 'self_cell.dart';

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
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  DynamicComputeCell(this._compute, {
    super.key,
    bool changesOnly = false
  }) : _changesOnly = changesOnly;

  @override
  T get value {
    final state = this.state;

    if (state == null) {
      try {
        return _untrackedCompute();
      }
      on StopComputeException catch (e) {
        if (e.defaultValue == null && null is! T) {
          throw UninitializedCellError();
        }

        return e.defaultValue;
      }
    }

    return state.value;
  }


  // Private

  @override
  @protected
  DynamicComputeCellState<T>? get state => super.state as DynamicComputeCellState<T>?;

  /// Value computation function
  final T Function() _compute;

  /// Should the cell check whether its value has actually changed before notifying observers?
  final bool _changesOnly;

  /// State restored by restoreState();
  CellState? _restoredState;

  @override
  CellState createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    if (_changesOnly) {
      return DynamicComputeChangesOnlyCellState<T>(
          cell: this,
          key: key
      );
    }

    return DynamicComputeCellState<T>(
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
    final restoredState = this.state ?? createState() as DynamicComputeCellState<T>;
    restoredState.restoreValue(coder.decode(state));

    _restoredState = restoredState;
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

class DynamicComputeCellState<T> extends ComputeCellState<T, DynamicComputeCell<T>> {
  DynamicComputeCellState({
    required super.cell,
    required super.key,
  }) : super(arguments: HashSet());

  void restoreValue(T value) {
    setValue(value);
  }

  @override
  T compute() => ComputeArgumentsTracker.computeWithTracker(cell._compute, (arg) {
    if (!arguments.contains(arg)) {
      arg.addObserver(this);
      arguments.add(arg);
    }
  });
}

/// A [DynamicComputeCellState] that only notifies observers if [cell]'s value has changed.
class DynamicComputeChangesOnlyCellState<T> extends DynamicComputeCellState<T>
    with ChangesOnlyCellState {
  DynamicComputeChangesOnlyCellState({
    required super.cell,
    required super.key
  });
}