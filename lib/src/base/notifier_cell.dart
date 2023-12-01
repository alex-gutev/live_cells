import 'package:flutter/foundation.dart';

import '../equality/cell_equality.dart';
import '../value_cell.dart';
import 'cell_change_notifier.dart';

/// A [ValueCell] that stores its own value and manages its own listeners
///
/// This class should be subclassed when a cell is required to store its value
/// rather than computing it on demand.
///
/// This class also provides [init] and [dispose] methods for managing resources.
abstract class NotifierCell<T> extends ValueCell<T> with CellEquality<T> {
  /// Creates a [NotifierCell] with an initial value
  NotifierCell(this._value);

  /// Initialize the cell object.
  ///
  /// If the cell needs to set up any listeners, on other [ValueCell]'s or
  /// [Listenables], or acquire resources it should be done in this method.
  ///
  /// **NOTE:** This method may be called after the [value] property is accessed
  @protected
  void init() {}

  /// Teardown the cell object.
  ///
  /// If the cell has set up any listeners, on other [ValueCell]'s or
  /// [Listenables], or acquired resources this method should be overridden
  /// to include any teardown or cleanup logic.
  @protected
  void dispose() {}

  @override
  T get value => _value;

  @override
  void addListener(VoidCallback listener) {
    if (_isDisposed) {
      _notifier = CellChangeNotifier();
    }

    if (!_notifier.isActive) {
      init();
    }

    _notifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _notifier.removeListener(listener);

    if (!_notifier.isActive) {
      _notifier.dispose();
      _isDisposed = true;

      dispose();
    }
  }

  /// Private

  /// The cell's value
  T _value;

  /// Has dispose been called on [_notifier]?
  var _isDisposed = false;

  /// The [ChangeNotifier] responsible for managing the listeners.
  var _notifier = CellChangeNotifier();

  @protected
  set value(T value) {
    _value = value;

    if (!_isDisposed) {
      _notifier.notifyListeners();
    }
  }
}