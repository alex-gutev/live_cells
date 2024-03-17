import 'dart:collection';

import 'package:meta/meta.dart';

import '../base/keys.dart';
import '../maybe_cell/maybe.dart';
import '../stateful_cell/changes_only_cell_state.dart';
import '../stateful_cell/cell_state.dart';
import '../base/exceptions.dart';
import 'compute_cell_state.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import 'dynamic_compute_cell.dart';
import 'peek_cell.dart';

part 'effect_cell.dart';

/// Value cell which stores the computed value of another [ValueCell] in memory.
///
/// This class can be used to avoid expensive recomputations of cell values when
/// the values of the argument cells have not changed.
class StoreCell<T> extends StatefulCell<T> implements RestorableCell<T> {

  /// Create a [StoreCell] which observes and saves the value of [argCell]
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  /// The returned cell is identified by [key] if it is non-null. Otherwise if
  /// [key] is null, the returned cell has a key which uniquely identifies the
  /// [StoreCell] for a given [argCell].
  StoreCell(this.argCell, {
    this.changesOnly = false,
    dynamic key,
  }) : super(key: key ?? _StoreCellKey(argCell));

  @override
  T get value {
    final state = this.state;

    if (state == null) {
      try {
        return argCell.value;
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

  /// The observed cell
  final ValueCell<T> argCell;

  /// Should the observers only be notified if this cell's value has changed?
  final bool changesOnly;

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

    if (changesOnly) {
      return StoreCellChangesOnlyState<T>(
          cell: this,
          key: key
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
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  StoreCell<T> store({
    bool changesOnly = false
  }) => StoreCell(this,
      changesOnly: changesOnly
  );
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
  }

  @override
  void dispose() {
    cell.argCell.removeObserver(this);
    super.dispose();
  }
}

/// A [StoreCellState] that only notifies observers if the [cell]'s value has changed.
class StoreCellChangesOnlyState<T> extends StoreCellState<T> with ChangesOnlyCellState<StoreCell<T>> {
  StoreCellChangesOnlyState({
    required super.cell,
    required super.key
  });
}

class _StoreCellKey extends CellKey1<ValueCell> {
  _StoreCellKey(super.value);
}