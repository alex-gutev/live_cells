import 'package:flutter/cupertino.dart';

import '../base/types.dart';
import '../stateful_cell/cell_state.dart';
import '../base/exceptions.dart';
import 'compute_cell_state.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

/// Value cell which stores the computed value of another [ValueCell] in memory.
///
/// This class can be used to avoid expensive recomputations of cell values when
/// the values of the argument cells have not changed.
class StoreCell<T> extends StatefulCell<T> implements RestorableCell<T> {

  /// Create a [StoreCell] which observes and saves the value of [argCell]
  ///
  /// If [willChange] is non-null, it is called to determine whether the cell's
  /// value will change for a change in the value of an argument cell. It is
  /// called with the argument cell and its new value passed as arguments. The
  /// function should return true if the cell's value may change, and false if
  /// it can be determined with certainty that it wont. **NOTE**: this function
  /// is only called if the new value of the argument cell is known, see
  /// [CellObserver.shouldNotify] for more information.
  StoreCell(this.argCell, {
    this.willChange
  }) : super(key: _StoreCellKey(argCell));

  @override
  T get value {
    final state = this.state;

    if (state == null) {
      try {
        return argCell.value;
      }
      on StopComputeException catch (e) {
        return e.defaultValue;
      }
    }

    return state.value;
  }

  // Private

  /// The observed cell
  final ValueCell<T> argCell;

  /// Callback function called to determine whether the cell's value will change.
  final WillChangeCallback? willChange;
  
  /// State restored by restoreState();
  CellState? _restoredState;

  @override
  @protected
  StoreCellState<T>? get state => super.state as StoreCellState<T>?;

  @override
  CellState<StatefulCell> createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    if (willChange != null) {
      return StoreCellStateNotifyCheck<T>(
          cell: this,
          key: key,
          willChange: willChange!
      );
    }

    return StoreCellState<T>(
        cell: this,
        key: key
    );
  }
  
  @override
  Object? dumpState(CellValueCoder coder) {
    return coder.encode(value);
  }

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    final restoredState = this.state ?? createState() as StoreCellState<T>;
    restoredState.restoreValue(coder.decode(state));

    _restoredState = restoredState;
  }
}

extension StoreCellExtension<T> on ValueCell<T> {
  /// Return a [ValueCell] which stores the value of this cell in memory.
  ///
  /// This is useful for cells which compute their value on demand but do not
  /// store it.
  ///
  /// The returned [StoreCell] stores the value of this cell in memory whenever it
  /// changes. Further references to the returned cell's value retrieve the
  /// stored value rather than running the computation function again.
  ///
  /// If [willChange] is non-null, it is called to determine whether the cell's
  /// value will change for a change in the value of an argument cell. It is
  /// called with the argument cell and its new value passed as arguments. The
  /// function should return true if the cell's value may change, and false if
  /// it can be determined with certainty that it wont. **NOTE**: this function
  /// is only called if the new value of the argument cell is known, see
  /// [CellObserver.shouldNotify] for more information.
  StoreCell<T> store({
    WillChangeCallback? willChange
  }) => StoreCell(this, willChange: willChange);
}

class StoreCellState<T> extends ComputeCellState<T, StoreCell<T>> {
  StoreCellState({
    required super.cell,
    required super.key,
  }) : super(arguments: {cell.argCell});

  void restoreValue(T value) {
    setValue(value);
  }

  @override
  T compute() => cell.argCell.value;

  @override
  void init() {
    super.init();
    cell.argCell.addObserver(this);

    try {
      setValue(value);
    }
    catch (e) {
      // Prevent exception from being propagated to caller
    }
  }

  @override
  void dispose() {
    cell.argCell.removeObserver(this);
    super.dispose();
  }
}

/// A [StoreCellState] with [shouldNotify] defined by a callback function
class StoreCellStateNotifyCheck<T> extends StoreCellState<T> {
  final WillChangeCallback _willChange;

  StoreCellStateNotifyCheck({
    required super.cell,
    required super.key,
    required WillChangeCallback willChange
  }) : _willChange = willChange;

  @override
  bool shouldNotify(ValueCell cell, newValue) => _willChange(cell, newValue);
}

class _StoreCellKey {
  final ValueCell cell;

  _StoreCellKey(this.cell);

  @override
  bool operator ==(Object other) =>
      other is _StoreCellKey && cell == other.cell;

  @override
  int get hashCode => Object.hash(runtimeType, cell);
}