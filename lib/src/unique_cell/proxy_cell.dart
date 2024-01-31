import '../base/cell_equality_factory.dart';
import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
import '../mutable_cell/mutable_cell.dart';
import '../value_cell.dart';
import 'cell_table.dart';

part 'mutable_proxy_cell.dart';

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
  T get value => _useCell((cell) => cell.value);

  @override
  void addObserver(CellObserver observer) {
    CellTable().addObserver(key, create, observer);
  }

  @override
  bool removeObserver(CellObserver observer) {
    return CellTable().removeObserver(key, observer);
  }

  @override
  T call() {
    return _useCell((cell) {
      var tracked = false;

      final value = ComputeArgumentsTracker.computeWithTracker(cell.call, (_) {
        tracked = true;
      });

      if (tracked) {
        ComputeArgumentsTracker.trackArgument(this);
      }

      return value;
    });
  }


  @override
  ValueCell<bool> eq<U>(ValueCell<U> other) => ValueCell.unique(
      _ProxyEqCellKey(this, other),
      () => equalityCellFactory.makeEq(this, other)
  );

  @override
  ValueCell<bool> neq<U>(ValueCell<U> other) => ValueCell.unique(
      _ProxyNeqCellKey(this, other),
      () => equalityCellFactory.makeNeq(this, other)
  );

  @override
  EqualityCellFactory get equalityCellFactory =>
      _useCell((cell) => cell.equalityCellFactory);

  /// Private

  final dynamic key;
  final CellCreator<T> create;

  R _useCell<R>(R Function(ValueCell<T> cell) fn) =>
      CellTable().useCell(key, create, fn);
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