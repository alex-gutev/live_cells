import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
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
  }

  @override
  bool removeObserver(CellObserver observer) {
    return CellTable().removeObserver(key, observer);
  }

  @override
  T call() {
    try {
      var tracked = false;;

      final value = ComputeArgumentsTracker.computeWithTracker(_acquireCell().call, (_) {
        tracked = true;
      });

      if (tracked) {
        ComputeArgumentsTracker.trackArgument(this);
      }

      return value;
    }
    finally {
      _releaseCell();
    }
  }

  @override
  ValueCell<bool> eq<U>(ValueCell<U> other) =>
      ValueCell.unique(_ProxyEqCellKey(this, other), () => _acquireCell().eq(other));

  @override
  ValueCell<bool> neq<U>(ValueCell<U> other) =>
      ValueCell.unique(_ProxyNeqCellKey(this, other), () => _acquireCell().neq(other));

  /// Private

  final dynamic key;
  final CellCreator<T> create;

  /// Acquire the instance to the cell identified by [key].
  ///
  /// This tells [CellTable] to increment the reference count for the cell.
  ValueCell<T> _acquireCell() => CellTable().acquire(key, create);

  /// Release the instance of the cell
  ///
  /// This tells [CellTable] to decrement the reference count for the cell.
  void _releaseCell() => CellTable().release(key);
}

/// Key for indexing an equality comparison cell of ProxyCell
class _ProxyEqCellKey {
  final ValueCell a;
  final ValueCell b;

  _ProxyEqCellKey(this.a, this.b);

  @override
  bool operator==(other) => other is _ProxyEqCellKey &&
      a == other.a &&
      b == other.b;

  @override
  int get hashCode => Object.hash(runtimeType, a, b);
}


/// Key for indexing an inequality comparison cell of ProxyCell
class _ProxyNeqCellKey {
  final ValueCell a;
  final ValueCell b;

  _ProxyNeqCellKey(this.a, this.b);

  @override
  bool operator==(other) => other is _ProxyNeqCellKey &&
      a == other.a &&
      b == other.b;

  @override
  int get hashCode => Object.hash(runtimeType, a, b);
}