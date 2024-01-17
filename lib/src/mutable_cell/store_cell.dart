import '../base/observer_cell.dart';
import '../base/cell_observer.dart';
import '../base/notifier_cell.dart';
import '../restoration/restoration.dart';
import '../value_cell.dart';

/// Value cell which stores the computed value of another [ValueCell] in memory.
///
/// This class can be used to avoid expensive recomputations of cell values when
/// the values of the argument cells have not changed.
class StoreCell<T> extends NotifierCell<T> with ObserverCell<T>
    implements CellObserver, RestorableCell<T> {
  /// Create a [StoreCell] which observes and saves the value of [valueCell]
  StoreCell(this.valueCell) : super(valueCell.value);

  @override
  void init() {
    super.init();
    valueCell.addObserver(this);

    stale = true;
  }

  @override
  void dispose() {
    stale = true;
    valueCell.removeObserver(this);

    super.dispose();
  }

  @override
  T get value {
    if (stale) {
      setValue(valueCell.value);
      stale = !isInitialized;
    }

    return super.value;
  }

  /// Private

  /// The observed cell
  final ValueCell<T> valueCell;

  @override
  bool get shouldNotifyAlways => false;

  @override
  Object? dumpState(CellValueCoder coder) {
    return coder.encode(value);
  }

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    setValue(coder.decode(state));
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