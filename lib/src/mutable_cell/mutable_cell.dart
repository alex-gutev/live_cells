import '../base/notifier_cell.dart';

/// A [ValueCell] of which the [value] property can be set explicitly.
class MutableCell<T> extends NotifierCell<T> {
  MutableCell(super.value);

  @override
  set value(T value) {
    super.value = value;
  }
}