part of 'mutable_cell.dart';

/// Base class implementing the [MutableCell] interface, for values of type [T].
///
/// **NOTE**: Unlike [StatefulCell], this cell always has a [CellState] object
/// associated with it, even when it is not active.
///
/// **NOTE**: Subclasses should override [createMutableState] instead of
/// [createState].
abstract class MutableCellBase<T> extends PersistentStatefulCell<T> implements MutableCell<T> {
  /// Mutable cell base constructor.
  ///
  /// If [key] is non-null it is used to identify the cell. **NOTE**, if [key]
  /// is non null [dispose] has to be called, when the cell is no longer used.
  MutableCellBase({super.key});

  @override
  T get value => state.value;

  @override
  set value(T value) {
    state.value = value;
  }

  @override
  @protected
  MutableCellState<T, MutableCellBase<T>> get state =>
      super.state as MutableCellState<T,MutableCellBase<T>>;

  @override
  MutableCellState<T, MutableCellBase<T>> createState() {
    if (_mutableState?.isDisposed ?? true) {
      _mutableState = createMutableState(
          oldState: key == null ? _mutableState : null
      );
    }

    return _mutableState!;
  }

  /// Create the state for the MutableCell.
  ///
  /// [oldState] is the previous state of the cell, or [null] if the cell
  /// doesn't have a state yet. Implementations of this method, should use
  /// [oldState] to return a new state that produces the same value as would
  /// be produced with [oldState].
  @protected
  MutableCellState<T, MutableCellBase<T>> createMutableState({
    MutableCellState<T, MutableCellBase<T>>? oldState
  }) => MutableCellState(
      cell: this,
      key: key,
  );

  // Private

  MutableCellState<T, MutableCellBase<T>>? _mutableState;
}

class MutableCellState<T, S extends StatefulCell<T>> extends CellState<S> {
  MutableCellState({
    required super.cell,
    required super.key,
  });

  /// Is a batch update of cells currently in progress, *see [MutableCell.batch]*.
  ///
  /// If this is true, then only [CellObserver.willUpdate] should be called on
  /// the cell's observers when changing the value.
  bool get isBatchUpdate => MutableCell._batched;

  /// Add this cell state to the batch update list.
  ///
  /// This method should be called when [value] is being set while
  /// [isBatchUpdate] is true. The observers are notified, by [notifyUpdate]
  /// after the batch update is complete.
  ///
  /// If [isEqual] is true it indicates that the new value is equal to the
  /// previous value.
  void addToBatch(bool isEqual) {
    MutableCell._addToBatch(this, isEqual);
  }

  /// Retrieve the cell's value
  T get value => _value;

  /// Set the cell's value and notify the observers
  set value(T value) {
    if (isDisposed) {
      _value = value;
      return;
    }

    final isEqual = value == _value;

    if (MutableCell._batched) {
      notifyWillUpdate(isEqual: isEqual);
      _value = value;

      MutableCell._addToBatch(this, isEqual);
    }
    else {
      notifyWillUpdate(isEqual: isEqual);
      _value = value;
      notifyUpdate(isEqual: isEqual);
    }
  }

  /// Set the value to [value] without notifying the observers
  void setValue(T value) {
    _value = value;
  }

  // Private

  /// The cell's value.
  late T _value;
}