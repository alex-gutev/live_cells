import '../base/cell_observer.dart';
import '../mutable_cell/mutable_cell.dart';
import '../value_cell.dart';

/// A cell object which serves as a proxy for another cell.
///
/// The purpose of this class is to provide a [MutableCell] wrapper when it is
/// not known at compile-time whether the underlying cell is a [MutableCell].
class ProxyCell<T> implements MutableCell<T> {
  /// Create a proxy for [_cell]
  ProxyCell(this._cell);

  @override
  T get value => _cell.value;

  @override
  set value(T value) {
    _mutableCell.value = value;
  }

  @override
  T call() => _cell();

  @override
  void addObserver(CellObserver observer) {
    _cell.addObserver(observer);
  }

  @override
  ValueCell<bool> eq<U>(ValueCell<U> other) => _cell.eq(other);

  @override
  ValueCell<bool> neq<U>(ValueCell<U> other) => _cell.neq(other);

  @override
  void notifyUpdate() {
    _mutableCell.notifyUpdate();
  }

  @override
  void notifyWillUpdate() {
    _mutableCell.notifyWillUpdate();
  }

  @override
  void removeObserver(CellObserver observer) {
    _cell.removeObserver(observer);
  }

  /// The underlying cell
  final ValueCell<T> _cell;

  /// The underlying cell as a [MutableCell]
  MutableCell<T> get _mutableCell => _cell as MutableCell<T>;
}