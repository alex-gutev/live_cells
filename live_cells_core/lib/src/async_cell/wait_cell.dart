import 'dart:async';

import '../base/keys.dart';
import '../maybe_cell/maybe.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import '../previous_values/prev_value_cell.dart';

/// A cell which waits for a [Future] held in another cell to complete.
///
/// Until the [Future] completes, accessing the [value] of the cell will throw
/// an [UninitializedCellError].
class WaitCell<T> extends StatefulCell<T> {
  /// Create a cell which waits for the [Future] held in [arg] to complete
  WaitCell({
    required this.arg
  }) : super(key: _WaitCellKey(arg));

  @override
  T get value {
    final state = this.state as _WaitCellState<T>?;

    if (state != null) {
      return state.value;
    }

    throw UninitializedCellError();
  }

  // Private

  /// Argument cell holding [Future]
  final ValueCell<Future<T>> arg;

  @override
  CellState<StatefulCell> createState() => _WaitCellState<T>(
      cell: this,
      key: key
  );
}

/// State for [WaitCell]
class _WaitCellState<T> extends CellState<WaitCell<T>>
    with ObserverCellState<WaitCell<T>> {
  /// Awaited [Future] value
  Maybe<T> _value = Maybe.error(UninitializedCellError());

  Completer<void>? _wait;
  //StreamController<Future<Maybe<T>>>? _queue;
  //StreamSubscription<Future<Maybe<T>>>? _subQueue;

  _WaitCellState({
    required super.cell,
    required super.key
  });

  T get value => _value.unwrap;

  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();

    cell.arg.addObserver(this);
    //_queue = StreamController();

    _updateValue(_getValue());
  }

  @override
  void dispose() {
    cell.arg.removeObserver(this);
    super.dispose();
  }

  @override
  void onWillUpdate() {
    // Prevent observers from being notified before delay
  }

  @override
  void onUpdate(bool didChange) {
    // Prevent observers from being notified before delay
  }

  @override
  void postUpdate() {
    super.postUpdate();
    _updateValue(_getValue());
  }

  /// Get the a [Future] which resolves to the current value of [arg], wrapped in a [Maybe].
  Future<Maybe<T>> _getValue() {
    return Maybe.wrapAsync(() => cell.arg.value);
  }

  /// Await [future] and update this cell's value while notifying observers.
  Future<void> _updateValue(Future<Maybe<T>> future) async {
    final wait = _wait;
    final newWait = _wait = Completer();

    await wait?.future;
    final value = await future;

    newWait.complete();

    notifyWillUpdate();
    _value = value;
    notifyUpdate();
  }
}

/// Key identifying a [WaitCell].
class _WaitCellKey<T> extends ValueKey1<ValueCell<T>> {
  /// Create a key for identifying a [WaitCell].
  ///
  /// The key identifies a [WaitCell] which waits for the value held in argument
  /// cell [value].
  _WaitCellKey(super.value);
}