import '../base/cell_observer.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/notifier_cell.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

/// A cell which notifies its observers after a delay.
///
/// This cell class notifies its observers of changes in the value of
/// another [ValueCell] after a time period has elapsed since the
/// value change.
class DelayCell<T> extends NotifierCell<T> {
  /// Create a DelayCell.
  ///
  /// The cell notifies its observers of changes to the value
  /// of [valueCell] after a time period of [delay].
  DelayCell(this.delay, this.valueCell) :
        super(valueCell.value);

  /// Private

  /// Time delay before notifying observers
  final Duration delay;

  /// Observed value cell
  final ValueCell<T> valueCell;

  @override
  CellState<StatefulCell> createState() => _DelayCellState(
      cell: this,
      key: key,
      arg: valueCell
  );

  void _initValue(T value) {
    setValue(value);
  }

  void _updateValue(T value) {
    this.value = value;
  }
}

class _DelayCellState<T> extends CellState<DelayCell> implements CellObserver {
  final ValueCell<T> arg;

  var _updating = false;

  _DelayCellState({
    required super.cell,
    required super.key,
    required this.arg
  });

  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();
    cell._initValue(arg.value);
    arg.addObserver(this);
  }

  @override
  void dispose() {
    arg.removeObserver(this);
    super.dispose();
  }

  @override
  void willUpdate(ValueCell cell) {
    _updating = true;
  }

  @override
  void update(ValueCell cell, bool didChange) {
    if (_updating) {
      _updateValue(cell.value);
      _updating = false;
    }
  }

  Future<void> _updateValue(T value) async {
    if (value != cell.value) {
      await Future.delayed(cell.delay);
      cell._updateValue(value);
    }
  }
}