import '../maybe_cell/maybe.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

/// A cell which notifies its observers after a delay.
///
/// This cell class notifies its observers of changes in the value of
/// another [ValueCell] after a time period has elapsed since the
/// value change.
class DelayCell<T> extends StatefulCell<T> {
  /// Create a DelayCell.
  ///
  /// The cell notifies its observers of changes to the value
  /// of [arg] after a time period of [delay].
  DelayCell(this.delay, this.arg) {
    _initState();
  }

  @override
  T get value => _state.value;

  /// Private

  /// Time delay before notifying observers
  final Duration delay;

  /// Observed value cell
  final ValueCell<T> arg;

  /// Delay cell state
  late _DelayCellState<T> _state;

  @override
  CellState<StatefulCell> createState() {
    if (_state.isDisposed) {
      _initState();
    }

    return _state;
  }

  void _initState() {
    _state = _DelayCellState(
      cell: this,
      key: key,
    );
  }
}

class _DelayCellState<T> extends CellState<DelayCell<T>>
    with ObserverCellState<DelayCell<T>> {
  /// The wrapped cell value
  Maybe<T> _value;

  _DelayCellState({
    required super.cell,
    required super.key,
  }) : _value = Maybe.wrap(() => cell.arg.value);

  T get value => _value.unwrap;

  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();

    cell.arg.addObserver(this);
    _value = _getValue();
  }

  @override
  void dispose() {
    cell.arg.removeObserver(this);
    super.dispose();
  }

  @override
  void postUpdate() {
    super.postUpdate();
    _updateValue(_getValue());
  }

  @override
  void onWillUpdate() {
    // Prevent observers from being notified before delay
  }

  @override
  void onUpdate(bool didChange) {
    // Prevent observers from being notified before delay
  }

  /// Get the argument cell value and wrap it in a [Maybe]
  Maybe<T> _getValue() => Maybe.wrap(() => cell.arg.value);

  /// Update the [DelayCell]'s value to [value] after the delay has elapsed.
  Future<void> _updateValue(Maybe<T> value) async {
    await Future.delayed(cell.delay);

    notifyWillUpdate();
    _value = value;
    notifyUpdate();
  }
}