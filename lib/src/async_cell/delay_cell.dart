import '../base/cell_observer.dart';
import '../base/notifier_cell.dart';
import '../value_cell.dart';

/// A cell which notifies its observers after a delay.
///
/// This cell class notifies its observers of changes in the value of
/// another [ValueCell] after a time period has elapsed since the
/// value change.
class DelayCell<T> extends NotifierCell<T> implements CellObserver {
  /// Create a DelayCell.
  ///
  /// The cell notifies its observers of changes to the value
  /// of [valueCell] after a time period of [delay].
  DelayCell(this.delay, this.valueCell) :
        super(valueCell.value);

  @override
  void init() {
    super.init();
    valueCell.addObserver(this);
    value = valueCell.value;
  }

  @override
  void dispose() {
    valueCell.removeObserver(this);
    super.dispose();
  }

  /// Private

  /// Time delay before notifying observers
  final Duration delay;

  /// Observed value cell
  final ValueCell<T> valueCell;

  @override
  void update(ValueCell cell) async {
    final newValue = valueCell.value;

    if (value != newValue) {
      await Future.delayed(delay);
      value = newValue;
    }
  }

  @override
  void willUpdate(ValueCell cell) {
  }

  @override
  bool get shouldNotifyAlways => false;
}