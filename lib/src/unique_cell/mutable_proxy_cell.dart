part of 'proxy_cell.dart';

/// A [ProxyCell] for [MutableCell]'s.
class MutableProxyCell<T> extends ProxyCell<T> implements MutableCell<T> {
  MutableProxyCell({required super.key, required super.create});

  @override
  void notifyUpdate([bool isEqual = false]) {
    CellTable().withCell(key, (cell) {
      final mutCell = cell as MutableCell<T>;
      mutCell.notifyUpdate(isEqual);
    });
  }

  @override
  void notifyWillUpdate([bool isEqual = false]) {
    CellTable().withCell(key, (cell) {
      final mutCell = cell as MutableCell<T>;
      mutCell.notifyUpdate(isEqual);
    });
  }

  @override
  set value(T value) {
    _useCell((cell) {
      final mutCell = cell as MutableCell<T>;
      mutCell.value = value;
    });
  }
}