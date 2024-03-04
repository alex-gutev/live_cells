import 'package:meta/meta.dart';

import '../base/exceptions.dart';
import '../base/types.dart';
import '../stateful_cell/changes_only_cell_state.dart';
import '../mutable_cell/mutable_cell.dart';
import '../mutable_cell/mutable_dependent_cell.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../value_cell.dart';

/// Cell state for a mutable computed cell.
///
/// This provides a public [value] setter which sets the value of the
/// cell directly.
class MutableComputedCellState<T, S extends MutableDependentCell<T>>
    extends MutableCellState<T, S> with ObserverCellState<S> {
  /// Computed cell arguments
  @protected
  final Set<ValueCell> arguments;

  MutableComputedCellState({
    required super.cell,
    required super.key,
    required this.arguments,
    MutableComputedCellState<T,S>? oldState
  }) {
    if (!(oldState?._computed ?? true)) {
      _computed = false;
      setValue(oldState!.value);
    }
  }

  Object dumpState(CellValueCoder coder) {
    final currentValue = value;

    return {
      'computed': _computed,
      'value': coder.encode(currentValue)
    };
  }

  void restoreState(Object? state, CellValueCoder coder) {
    final map = state as Map;

    if (map['computed']) {
      _computed = true;
      setValue(coder.decode(map['value']));
    }
    else {
      value = coder.decode(map['value']);
    }
  }

  T compute() => cell.compute();

  @override
  T get value {
    if (stale) {
      _computed = true;

      try {
        setValue(compute());
      }
      on StopComputeException catch (e) {
        if (!_hasValue) {
          setValue(e.defaultValue);
        }
      }

      stale = false;
      _hasValue = true;
    }

    return super.value;
  }

  @override
  set value(T value) {
    final isEqual = _hasValue && super.value == value;

    _reverse = true;
    notifyWillUpdate(isEqual: isEqual);

    updating = false;
    stale = false;
    _computed = false;

    setValue(value);

    MutableCell.batch(() {
      try {
        cell.reverseCompute(value);
      }
      catch (e, st) {
        debugPrint('Unhandled exception in MutableDependentCell reverse computation function: $e\n$st');
      }
    });

    if (isBatchUpdate) {
      addToBatch(isEqual);
    }
    else {
      notifyUpdate(isEqual: isEqual);
    }

    _reverse = false;
  }

  // Private

  /// Is a reverse computation being performed?
  var _reverse = false;

  /// Is the current value computed or assigned using the [value] property.
  var _computed = true;

  /// Has the value of the cell been initialized
  var _hasValue = false;

  /// Was the value (before the current update cycle) a computed value?
  var _wasComputed = true;

  @override
  bool get shouldNotifyAlways => true;

  @override
  void willUpdate(ValueCell cell) {
    if (!_reverse) {
      if (!updating) {
        _wasComputed = _computed;
      }

      super.willUpdate(cell);
    }
    else {
      _wasComputed = false;
      waitingForChange = false;
    }
  }

  @override
  void update(ValueCell cell, bool didChange) {
    super.update(cell, !_wasComputed || didChange);
  }

  @override
  void init() {
    super.init();

    try {
      stale = true;
      setValue(value);
    }
    catch (e) {
      // Prevent exception from being propagated to callers
    }

    for (final arg in arguments) {
      arg.addObserver(this);
    }
  }

  @override
  void dispose() {
    for (final arg in arguments) {
      arg.removeObserver(this);
    }

    super.dispose();
  }
}

/// A [MutableComputedCellState] that notifies observers only if [cell]'s value has changed.
class MutableComptedChangesOnlyCellState<T, S extends MutableDependentCell<T>>
    extends MutableComputedCellState<T,S> with ChangesOnlyCellState<S> {
  MutableComptedChangesOnlyCellState({
    required super.cell,
    required super.key,
    required super.arguments,
    super.oldState
  });
}