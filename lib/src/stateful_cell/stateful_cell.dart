import 'package:flutter/foundation.dart';

import '../base/cell_observer.dart';
import '../base/cell_state.dart';
import '../value_cell.dart';

/// A cell with the state managed by a [CellState] object.
///
/// This class should be subclassed if you need to create a cell type that
/// manages its own observers or stores its own value. The state of the cell,
/// the observers and its value, should be stored in the [CellState] object
/// rather than the [StatefulCell]. This is to allow multiple [ValueCell]
/// objects with the same [key] to reference the same [CellState], and hence
/// share the same state.
///
/// **NOTE**:
///
/// The [CellState] only exists while it has at least one observer.
/// If the [CellState] has no observers then effectively this cell has no state,
/// it is *inactive*. Inactive cells should handle accesses to their values as
/// gracefully as possible. For example an computed cell will simply recompute
/// its value whenever it is accessed while it is inactive.
abstract class StatefulCell<T> extends ValueCell<T> {
  /// Key which uniquely identifies the cell
  ///
  /// All [ValueCell] objects which share the same [key], that is equal under
  /// [Object.==], reference the same shared [CellState] object, thus effectively
  /// they reference a single cell. **NOTE**: This only applies while the
  /// [CellState] has at least one observer.
  ///
  /// If this is [null] then this [ValueCell] is unique from all other [ValueCell]
  /// objects including those with a [key] equal to [null].
  late final dynamic key;

  /// Create a cell identified by [key].
  StatefulCell({this.key});

  @override
  bool operator ==(Object other) => other is StatefulCell && key != null
      ? key == other.key
      : super == other;

  @override
  int get hashCode => key != null ? key.hashCode : super.hashCode;

  /// Get the current state of the cell.
  ///
  /// Returns null if the cell is inactive.
  @protected
  S? currentState<S>() => _getState() as S;

  /// Create the [CellState] for this cell.
  ///
  /// This method should be overridden by subclasses.
  @protected
  CellState createState();

  @override
  void addObserver(CellObserver observer) {
    _ensureState().addObserver(observer);
  }

  @override
  void removeObserver(CellObserver observer) {
    _ensureState().removeObserver(observer);
  }


  /// Notify the observers of the cell that the cell's value will change.
  ///
  /// This should be called before the value of the cell has actually changed.
  ///
  /// If [isEqual] is true then only the observers, for which
  /// [CellObserver.shouldNotifyAlways] is true, are notified.
  @protected
  void notifyWillUpdate([bool isEqual = false]) {
    _getState()?.notifyWillUpdate(isEqual);
  }

  /// Notify the observers of the cell that the cell's value has changed.
  ///
  /// This should be called after the value of the cell has changed to a new
  /// value following a [notifyWillChange] call.
  ///
  /// If [isEqual] is true then only the observers, for which
  /// [CellObserver.shouldNotifyAlways] is true, are notified.
  @protected
  void notifyUpdate([bool isEqual = false]) {
    _getState()?.notifyUpdate(isEqual);
  }

  /// Private

  /// Current cell state or [null] if the cell is inactive.
  ///
  /// **NOTE**: The cell may be inactive even if this property is non-null,
  /// for example when the previous state has been disposed.
  CellState? _currentState;

  /// Return the current state, creating a new state if the cell is inactive.
  CellState _ensureState() {
    if (_getState() == null) {
      _currentState = CellState.getState(key, createState);
    }

    return _currentState!;
  }

  /// Returns the current state or null if the cell is inactive.
  CellState? _getState() {
    return _currentState?.isDisposed ?? true ? null : _currentState;
  }
}