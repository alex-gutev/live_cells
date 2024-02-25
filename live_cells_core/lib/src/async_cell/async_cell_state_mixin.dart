import '../base/exceptions.dart';
import '../maybe_cell/maybe.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import 'async_cancellation_handler.dart';

/// Implements functionality for a [CellState] that updates its value when a [Future] completes.
mixin AsyncCellStateMixin<T, S extends StatefulCell> on ObserverCellState<S> {
  /// Argument cell holding a [Future].
  ValueCell<Future<T>> get argCell;

  /// Should only the last [Future] that was set be awaited?
  bool get lastOnly;

  /// Awaited [Future] value
  Maybe<T> awaitedValue = Maybe.error(UninitializedCellError());

  /// Cancellation handler for currently awaited future
  AsyncCancellationHandler? _handler;

  /// Value of completed [Future]
  T get value => awaitedValue.unwrap;

  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();

    argCell.addObserver(this);
    _updateValue(_getValue());
  }

  @override
  void dispose() {
    argCell.removeObserver(this);
    _handler?.cancel();

    super.dispose();
  }

  @override
  void postUpdate() {
    super.postUpdate();
    if (lastOnly) {
      _handler?.cancel();
    }

    _updateValue(_getValue());
  }

  /// Get a [Future] which resolves to the current value of [arg], wrapped in a [Maybe].
  Future<Maybe<T>> _getValue() {
    return Maybe.wrapAsync(() => argCell.value);
  }

  /// Await [future] and update this cell's value while notifying observers.
  Future<void> _updateValue(Future<Maybe<T>> future) async {
    final oldHandler = _handler;
    final newHandler = _handler = AsyncCancellationHandler();

    await oldHandler?.wait;

    await newHandler.waitFuture(future, (value) {
      notifyWillUpdate();

      stale = false;
      awaitedValue = value;

      notifyUpdate();
    });
  }
}