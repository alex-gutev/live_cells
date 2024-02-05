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
  StoreCell(this.argCell) : super(key: _StoreCellKey(argCell));

  @override
  T get value {
    final state = currentState<_StoreCellState<T>>();

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

  /// State restored by restoreState();
  CellState? _restoredState;

  _StoreCellState<T>? get _state =>
      currentState<_StoreCellState<T>>();

  @override
  CellState<StatefulCell> createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    return _StoreCellState<T>(
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
    final restoredState = _state ?? createState() as _StoreCellState<T>;
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
  StoreCell<T> store() => StoreCell(this);
}

class _StoreCellState<T> extends ComputeCellState<T, StoreCell<T>> {
  _StoreCellState({
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
    setValue(cell.value);
  }

  @override
  void dispose() {
    cell.argCell.removeObserver(this);
    super.dispose();
  }
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