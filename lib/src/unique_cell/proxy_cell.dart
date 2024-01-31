import '../base/cell_observer.dart';
import '../value_cell.dart';
import 'cell_table.dart';

/// A cell which is proxy for another cell identifier by [key].
class ProxyCell<T> implements ValueCell<T> {
  /// Create a cell which is a proxy for the cell identified by [key].
  ///
  /// When the [ProxyCell] is used the it forwards all method calls/property
  /// accesses to the cell identified by [key]. If there is no cell identified
  /// by [key] it is created the first time this instance is used.
  ProxyCell({required this.key, required this.create});

  @override
  bool operator==(other) {
    if (other is ProxyCell) {
      return key == other.key;
    }

    return super == other;
  }

  @override
  int get hashCode => key.hashCode;

  @override
  T get value {
    try {
      return _acquireCell().value;
    }
    finally {
      _releaseCell();
    }
  }

  @override
  void addObserver(CellObserver observer) {
    _acquireCell().addObserver(observer);
    CellTable().acquire(key, create).addObserver(observer);
  }

  @override
  void removeObserver(CellObserver observer) {
    if (_cell != null) {
      _cell!.removeObserver(observer);
      _releaseCell();
    }
  }

  @override
  T call() {
    try {
      return _acquireCell().call();
    }
    finally {
      _releaseCell();
    }
  }

  @override
  ValueCell<bool> eq<U>(ValueCell<U> other) => EqCell(this, other);

  @override
  ValueCell<bool> neq<U>(ValueCell<U> other) => NeqCell(this, other);

  /// Private

  final dynamic key;
  final CellCreator<T> create;

  /// The proxied cell
  ValueCell<T>? _cell;

  /// Acquire the instance to the cell identified by [key].
  ///
  /// This tells [CellTable] to increment the reference count for the cell.
  ValueCell<T> _acquireCell() {
    _cell = CellTable().acquire(key, create);
    return _cell!;
  }

  /// Release the instance of the cell
  ///
  /// This tells [CellTable] to decrement the reference count for the cell.
  void _releaseCell() {
    if (CellTable().release(key)) {
      _cell = null;
    }
  }
}