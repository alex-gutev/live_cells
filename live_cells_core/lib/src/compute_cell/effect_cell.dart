part of 'store_cell.dart';

/// A cell used for running side effects and observing the result.
///
/// This cell evaluates to the value of its argument cell [argCell] while making
/// the following guarantees:
///
/// 1. The value of [argCell] is only referenced when it notifies this cell that
///    its value has changed.
///
/// 2. The value of [argCell] is referenced at most once per value change
///    notification.
///
/// This allows a side effect to be placed in the value computation function
/// of the argument cell, since it is guaranteed that the side effect will only
/// be run when triggered by the dependency cells, and will not be run more
/// than necessary.
///
/// The result of the side effect can be observed by observing this cell.
///
/// **NOTE**: Accessing the [value] results in an [UninitializeCellError] being
/// thrown until the first value change notification. This exception is also
/// thrown when [value] is accessed while this cell is inactive.
///
/// **IMPORTANT**: These guarantees hold if the argument cell only
/// calls its computation function when its value is referenced. If the
/// argument cell calls its computation function even when its value is not
/// referenced, then these guarantees no longer hold.
///
/// It should also be noted that these guarantees hold only when interacting
/// with this cell via the cell returned by this method.
class EffectCell<T> extends StoreCell<T> {
  /// Create a "side effect" cell for a given argument cell.
  EffectCell(super.argCell) :
        super(key: _EffectCellKey(argCell));

  @override
  T get value {
    final state = this.state;

    if (state == null) {
      throw UninitializedCellError();
    }

    return state.value;
  }

  @override
  CellState<StatefulCell> createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    return EffectCellState(
        cell: this,
        key: key
    );
  }
}

/// State of an [EffectCell]
class EffectCellState<T> extends StoreCellState<T> {
  EffectCellState({
    required super.cell,
    required super.key
  });

  @override
  void restoreValue(T value) {
    _value = Maybe(value);
  }

  @override
  T compute() {
    if (_shouldCompute) {
      _value = Maybe.wrap(() => cell.argCell.value);
      _shouldCompute = false;
    }

    return _value.unwrap;
  }

  // Private

  /// Should the value of the argument cell be referenced?
  var _shouldCompute = false;

  /// The cached value wrapped in a [Maybe].
  Maybe<T> _value = Maybe.error(UninitializedCellError());
}

/// Provides the [effect] method for creating a cell for observing side effects.
extension EffectCellExtension<T> on ValueCell<T> {
  /// Create a cell for observing side effects defined in [this] cell.
  ///
  /// The returned cell evaluates to the value of this cell while making
  /// the following guarantees:
  ///
  /// 1. The value of [this] cell is only referenced when it notifies its
  ///    observers.
  ///
  /// 2. The value of [this] cell is referenced at most once per value change
  ///    notification.
  ///
  /// This allows a side effect to be placed in the value computation function
  /// of this cell, since it is guaranteed that the side effect will only
  /// be run when triggered by the dependency cells, and will not be run more
  /// than necessary.
  ///
  /// The result of the side effect can be observed by observing this cell.
  ///
  /// **NOTE**: Accessing the [value] results in an [UninitializeCellError] being
  /// thrown until the first value change notification. This exception is also
  /// thrown when [value] is accessed while this cell is inactive.
  ///
  /// **IMPORTANT**: These guarantees hold if this cell only
  /// calls its computation function when its value is referenced. If this cell
  /// calls its computation function even when its value is not
  /// referenced, then these guarantees no longer hold.
  ///
  /// It should also be noted that these guarantees hold only when interacting
  /// with this cell via the cell returned by this method.
  ValueCell<T> effect() => EffectCell(this);
}

/// Key identifying an [EffectCell]
class _EffectCellKey extends CellKey1<ValueCell> {
  _EffectCellKey(super.value);
}