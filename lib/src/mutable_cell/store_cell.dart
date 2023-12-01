import 'notifier_cell.dart';
import '../value_cell.dart';

/// Value cell which stores the computed value of another cell in memory.
///
/// The value of the observed cell is stored in memory, and the listeners of the
/// [StoreCell] are only called if the value of the observed cell has changed.
///
/// This class can be used to avoid expensive recomputations of cell values when
/// the values of the argument cells have not changed.
class StoreCell<T> extends NotifierCell<T> {
  /// Create a [StoreCell] which observes and saves the value of [valueCell]
  StoreCell(this.valueCell) : super(valueCell.value) {
    valueCell.addListener(_onChangeValue);
  }

  @override
  void dispose() {
    valueCell.removeListener(_onChangeValue);
    super.dispose();
  }

  /// Private

  /// The observed cell
  final ValueCell<T> valueCell;

  /// Value change listener for [valueCell]
  void _onChangeValue() {
    notifier.value = valueCell.value;
  }
}