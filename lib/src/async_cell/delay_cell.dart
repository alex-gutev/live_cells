import 'package:flutter/foundation.dart';

import '../base/notifier_cell.dart';

/// A cell which notifies its listeners after a delay.
///
/// This cell class notifies its listeners of changes in the value of
/// another [ValueListenable] after a time period has elapsed since the
/// value change.
class DelayCell<T> extends NotifierCell<T> {
  /// Create a DelayCell.
  ///
  /// The cell notifies its listeners of changes to the value
  /// of [valueCell] after a time period of [delay].
  DelayCell(this.delay, this.valueCell) :
        super(valueCell.value);

  @override
  void init() {
    super.init();
    valueCell.addListener(_onChangeValue);
    value = valueCell.value;
  }

  @override
  void dispose() {
    valueCell.removeListener(_onChangeValue);
    super.dispose();
  }

  /// Private

  /// Time delay before notifying listeners
  final Duration delay;

  /// Observed value cell
  final ValueListenable<T> valueCell;

  Future<void> _onChangeValue() async {
    final newValue = valueCell.value;

    if (value != newValue) {
      await Future.delayed(delay);
      value = newValue;
    }
  }
}