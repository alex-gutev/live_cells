import '../base/cell_observer.dart';

import '../base/notifier_cell.dart';
import '../value_cell.dart';

/// Value cell which stores the computed value of another [ValueCell] in memory.
///
/// The value of the cell is stored in memory, and the observers of the
/// [StoreCell] are only called if the value of the observed call has changed.
///
/// This class can be used to avoid expensive recomputations of cell values when
/// the values of the argument cells have not changed.
class StoreCell<T> extends NotifierCell<T> implements CellObserver {
  /// Create a [StoreCell] which observes and saves the value of [valueCell]
  StoreCell(this.valueCell) : super(valueCell.value);

  @override
  void init() {
    super.init();
    valueCell.addObserver(this);

    _stale = false;
    setValue(valueCell.value);
  }

  @override
  void dispose() {
    valueCell.removeObserver(this);
    super.dispose();
  }

  @override
  T get value => _stale ? valueCell.value : super.value;

  /// Private

  /// The observed cell
  final ValueCell<T> valueCell;

  /// Is the saved value outdated?
  var _stale = false;
  
  @override
  void willUpdate() {
    _stale = true;
    notifyWillUpdate();
  }

  @override
  void update() {
    _stale = false;
    final newValue = valueCell.value;
    
    if (newValue != value) {
      setValue(newValue);
      notifyUpdate();
    }
    else {
      notifyWillNotUpdate();
    }
  }
  
  @override
  void willNotUpdate() {
    _stale = false;
    notifyWillNotUpdate();
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