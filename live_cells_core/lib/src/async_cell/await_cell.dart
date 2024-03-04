import '../base/exceptions.dart';
import '../base/keys.dart';
import '../maybe_cell/maybe.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import 'async_cell_state_mixin.dart';

/// A cell which `await`s a [Future] held in another cell
///
/// While the cell is waiting for the [Future] to complete, accessing its value
/// will throw an [UninitializedCellError].
class AwaitCell<T> extends StatefulCell<T> {
  /// Create a cell that awaits the [Future] held in [arg]
  AwaitCell({
    required this.arg
  }) : super(key: _AwaitCellKey(arg));

  @override
  T get value {
    final state = this.state as _AwaitCellState<T>?;

    if (state != null) {
      return state.value;
    }

    throw UninitializedCellError();
  }

  // Private

  /// Argument cell holding [Future]
  final ValueCell<Future<T>> arg;

  @override
  CellState<StatefulCell> createState() => _AwaitCellState<T>(
      cell: this,
      key: key
  );
}

/// State for [AwaitCell]
class _AwaitCellState<T> extends CellState<AwaitCell<T>>
    with ObserverCellState<AwaitCell<T>>, AsyncCellStateMixin<T, AwaitCell<T>> {
  _AwaitCellState({
    required super.cell,
    required super.key
  });

  @override
  ValueCell<Future<T>> get argCell => cell.arg;

  @override
  bool get lastOnly => true;

  @override
  T get value {
    if (stale) {
      awaitedValue = Maybe.error(UninitializedCellError());
      stale = false;
    }

    return awaitedValue.unwrap;
  }
}

/// Key identifying an [AwaitCell].
class _AwaitCellKey<T> extends CellKey1<ValueCell<T>> {
  /// Create a key for identifying a [WaitCell].
  ///
  /// The key identifies a [AwaitCell] which waits for the value held in argument
  /// cell [value].
  _AwaitCellKey(super.value);
}