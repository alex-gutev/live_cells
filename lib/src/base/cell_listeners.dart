import 'package:flutter/foundation.dart';

import 'cell_change_notifier.dart';
import 'managed_cell.dart';

/// Provides functionality for adding, removing and notifying listeners of a cell
///
/// This mixin provides implementations of the [addListener] and [removeListener]
/// methods of the [ValueListenable] interface.
///
/// The [init] and [dispose] methods of [ManagedCell] are called respectively
/// when the first listener is added, and the last listener is removed.
mixin CellListeners<T> on ManagedCell<T> {
  /// Has the cell been initialized
  @protected
  bool get isInitialized => _isInitialized;

  @override
  void addListener(VoidCallback listener) {
    if (!_isInitialized) {
      _notifier = CellChangeNotifier();
      _isInitialized = true;

      init();
    }

    _notifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _notifier.removeListener(listener);

    if (!_notifier.isActive) {
      dispose();

      _notifier.dispose();
      _isInitialized = false;
    }
  }

  /// Notify the listeners of the cell that the value has changed.
  @protected
  void notifyListeners() {
    if (_isInitialized) {
      _notifier.notifyListeners();
    }
  }

  /// Private

  /// Has [_notifier] been initialized?
  var _isInitialized = false;

  /// The [ChangeNotifier] responsible for managing the listeners.
  late CellChangeNotifier _notifier;
}