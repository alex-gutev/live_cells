import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../base/types.dart';
import '../stateful_cell/cell_state.dart';
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
  ///
  /// If [shouldNotify] is non-null, it is called to determine whether the
  /// observers of the cell should be notified for a given value change. If
  /// true, the observers are notified, otherwise they are not notified.
  DynamicComputeCell(this._compute, {
    super.key,
    this.shouldNotify
  });

  @override
  T get value {
    final state = this.state;

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

  @override
  @protected
  DynamicComputeCellState<T>? get state => super.state as DynamicComputeCellState<T>?;

  /// Value computation function
  final T Function() _compute;

  /// Callback function called to determine whether observers should be notified
  final ShouldNotifyCallback? shouldNotify;

  /// State restored by restoreState();
  CellState? _restoredState;

  @override
  CellState createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    if (shouldNotify != null) {
      return DynamicComputeCellStateNotifierCheck<T>(
          cell: this,
          key: key,
          shouldNotify: shouldNotify!
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

  @override
  void init() {
    super.init();

    try {
      setValue(value);
    }
    catch (e) {
      // Prevent exception from being propagated to caller
    }
  }
}

/// A [DynamicComputeCellState] with [shouldNotify] defined by a callback function.
class DynamicComputeCellStateNotifierCheck<T> extends DynamicComputeCellState<T> {
  final ShouldNotifyCallback _shouldNotify;

  DynamicComputeCellStateNotifierCheck({
    required super.cell,
    required super.key,
    required ShouldNotifyCallback shouldNotify
  }) : _shouldNotify = shouldNotify;

  @override
  bool shouldNotify(ValueCell cell, newValue) => _shouldNotify(cell, newValue);
}