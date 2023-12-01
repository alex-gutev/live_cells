import 'package:flutter/foundation.dart';

import '../equality/cell_equality.dart';
import '../value_cell.dart';

/// A [ValueCell] that stores its value in a [ValueNotifier]
class NotifierCell<T> extends ValueCell<T> with CellEquality<T> {
  /// Creates a [NotifierCell] with an initial value of [value]
  NotifierCell(T value) :
      notifier = ValueNotifier(value);

  @override
  T get value => notifier.value;

  @override
  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  /// Private

  /// The [ValueNotifier] which stores the cell's value.
  @protected
  final ValueNotifier<T> notifier;
}