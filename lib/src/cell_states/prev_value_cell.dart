import '../base/cell_listeners.dart';
import '../base/managed_cell.dart';
import '../base/observer_cell.dart';
import '../restoration/restoration.dart';
import '../value_cell.dart';

/// Represents an attempt to access the value of a cell which does not yet have a value
class UninitializedCellError implements Exception {
  @override
  String toString() =>
      'The value of a cell was referenced before it was initialized.';
}

/// A cell which records the stores value of another cell at a given time.
class PrevValueCell<T> extends ManagedCell<T>
    with CellEquality<T>, CellListeners<T>, ObserverCell<T>
    implements RestorableCell<T> {

  /// Create a cell which records the previous value of [cell].
  ///
  /// When [value] is accessed it will always return the previous value
  /// of [cell].
  PrevValueCell(this.cell) : _currentValue = cell.value;

  /// Retrieve the previous value of [cell].
  ///
  /// **NOTE**: If [cell] has not changed its value since the initialization
  /// of this cell, an [UninitializedCellError] exception is thrown.
  @override
  T get value {
    if (_hasValue) {
      return _prevValue;
    }
    else {
      throw UninitializedCellError();
    }
  }

  @override
  bool get shouldNotifyAlways => false;

  // Private

  final ValueCell<T> cell;

  var _hasValue = false;
  late T _prevValue;
  T _currentValue;

  @override
  void init() {
    super.init();
    cell.addObserver(this);
  }

  @override
  void dispose() {
    cell.removeObserver(this);
    super.dispose();
  }

  @override
  void update(ValueCell cell) {
    if (updating) {
      _hasValue = true;
      _prevValue = _currentValue;
      _currentValue = cell.value;
    }

    super.update(cell);
  }

  @override
  Object? dumpState(CellValueCoder coder) => {
    'has_value': _hasValue,
    'current_value': coder.encode(_currentValue),

    if (_hasValue)
      'prev_value': coder.encode(_prevValue),
  };

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    assert(state is Map);

    final map = state as Map;

    _hasValue = map['has_value'];
    _currentValue = coder.decode(map['current_value']);

    if (_hasValue) {
      _prevValue = coder.decode(map['prev_value']);
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