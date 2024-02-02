import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../maybe_cell/maybe.dart';
import '../restoration/restoration.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

/// Represents an attempt to access the value of a cell which does not yet have a value
class UninitializedCellError implements Exception {
  @override
  String toString() =>
      'The value of a cell was referenced before it was initialized.';
}

/// A cell which records the stores previous value of another cell at a given time.
class PrevValueCell<T> extends StatefulCell<T> implements RestorableCell<T> {

  /// Create a cell which records the previous value of [cell].
  ///
  /// When [value] is accessed it will always return the previous value
  /// of [cell].
  PrevValueCell(this.cell) : super(key: _PrevValueCellKey(cell));

  /// Retrieve the previous value of [cell].
  ///
  /// **NOTE**: If [cell] has not changed its value since the initialization
  /// of this cell, an [UninitializedCellError] exception is thrown.
  @override
  T get value {
    final state = _state;

    if (state == null) {
      throw UninitializedCellError();
    }

    return state.value;
  }

  // Private

  final ValueCell<T> cell;

  _PrevValueState<T>? get _state => currentState<_PrevValueState<T>>();

  CellState? _restoredState;

  @override
  CellState createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    return _PrevValueState(
        cell: this,
        key: key,
        arg: cell
    );
  }

  @override
  Object? dumpState(CellValueCoder coder) => _state?.dumpState(coder);

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    if (state != null) {
      final restoredState = _state ?? createState() as _PrevValueState;
      restoredState.restoreState(state, coder);

      _restoredState = restoredState;
    }
  }
}

/// Provides the [previous] property for retrieving a cell which holds the previous value of this cell.
extension PrevValueCellExtension<T> on ValueCell<T> {
  /// Return a cell which holds the previous value of [this] cell.
  ///
  /// **NOTE**: The cell will only keep track of the previous value after the
  /// value of [this] is changed at least once AFTER the first observer is
  /// added to the returned cell.
  ValueCell<T> get previous => PrevValueCell<T>(this);
}

class _PrevValueState<T> extends CellState with ObserverCellState {
  final ValueCell<T> arg;

  var _hasValue = false;
  late Maybe<T> _prevValue;
  Maybe<T> _currentValue;

  _PrevValueState({
    required super.cell,
    required super.key,
    required this.arg
  }) : _currentValue = Maybe.wrap(() => arg.value) {
    stale = false;
  }

  Object? dumpState(CellValueCoder coder) {
    final maybeCoder = MaybeValueCoder<T>(
        valueCoder: coder,
        errorCoder: coder
    );

    return {
      'has_value': _hasValue,
      'current_value': maybeCoder.encode(_currentValue),

      if (_hasValue)
        'prev_value': maybeCoder.encode(_prevValue),
    };
  }

  void restoreState(Object? state, CellValueCoder coder) {
    assert(state is Map);

    final map = state as Map;

    final maybeCoder = MaybeValueCoder<T>(
        valueCoder: coder,
        errorCoder: coder
    );

    _hasValue = map['has_value'];
    _currentValue = maybeCoder.decode(map['current_value']);

    if (_hasValue) {
      _prevValue = maybeCoder.decode(map['prev_value']);
    }
  }

  T get value {
    if (stale) {
      _updateCurrentValue();
    }

    if (_hasValue) {
      return _prevValue.unwrap;
    }
    else {
      throw UninitializedCellError();
    }
  }

  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();
    arg.addObserver(this);
  }

  @override
  void dispose() {
    arg.removeObserver(this);
    super.dispose();
  }

  @override
  void update(ValueCell cell) {
    if (stale) {
      _updateCurrentValue();
    }

    super.update(cell);
  }

  /// Get the current value of the cell and set [_prevValue] to the previous [_currentValue].
  void _updateCurrentValue() {
    _hasValue = true;
    _prevValue = _currentValue;
    _currentValue = Maybe.wrap(() => arg.value);

    stale = false;
  }
}

class _PrevValueCellKey {
  final ValueCell cell;

  _PrevValueCellKey(this.cell);

  @override
  bool operator ==(Object other) =>
      other is _PrevValueCellKey && cell == other.cell;

  @override
  int get hashCode => Object.hash(runtimeType, cell);
}