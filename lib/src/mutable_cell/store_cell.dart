import 'package:flutter/foundation.dart';

import '../common/notifier_cell.dart';

/// Value cell which stores the computed value of another listenable in memory.
///
/// The value of the listenable is stored in memory, and the listeners of the
/// [StoreCell] are only called if the value of the listenable has changed.
///
/// This class can be used to avoid expensive recomputations of cell values when
/// the values of the argument cells have not changed.
class StoreCell<T> extends NotifierCell<T> {
  /// Create a [StoreCell] which observes and saves the value of [valueCell]
  StoreCell(this.valueCell) : super(valueCell.value);

  @override
  void init() {
    super.init();
    valueCell.addListener(_onChangeValue);
  }

  @override
  void dispose() {
    valueCell.removeListener(_onChangeValue);
    super.dispose();
  }

  /// Private

  /// The observed cell
  final ValueListenable<T> valueCell;

  /// Value change listener for [valueCell]
  void _onChangeValue() {
    value = valueCell.value;
  }
}