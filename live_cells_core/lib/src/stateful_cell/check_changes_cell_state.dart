import 'observer_cell_state.dart';
import 'stateful_cell.dart';

/// Implements [didChange] by checking whether the new cell value is [==] to the previous value.
mixin CheckChangesCellState<S extends StatefulCell> on ObserverCellState<S> {
  /// Has a previous value been recorded?
  var _hasValue = false;

  /// The previous cell value if any
  Object? _oldValue;

  @override
  bool didChange() {
    try {
      return !_hasValue || cell.value != _oldValue;
    }
    catch (e) {
      return true;
    }
  }

  @override
  void preUpdate() {
    super.preUpdate();

    try {
      _hasValue = true;
      _oldValue = cell.value;
    }
    catch (e) {
      _hasValue = false;
    }
  }

  @override
  void postUpdate() {
    super.postUpdate();

    _hasValue = false;
    _oldValue = null;
  }
}