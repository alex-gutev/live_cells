import 'notifier_cell.dart';

/// A [ValueCell] of which the [value] property can be set explicity.
class MutableCell<T> extends NotifierCell<T> {
  MutableCell(super.value);

  set value(T value) {
    notifier.value = value;
  }
}