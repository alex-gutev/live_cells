part of 'dynamic_compute_cell.dart';

/// A computed cell which can access its current value in the compute function.
///
/// This cell is identical to a computed cell created with [ValueCell.computed],
/// but the compute function is called with a `self` argument. The `self`
/// argument is a function that when called returns the last computed value of
/// the [SelfCell]. If there is no last computed value [UninitializedCellError]
/// is thrown when calling the `self` function.
///
/// Example:
///
/// ```dart
/// final count = SelfCell((self) => self() + delta(),
///   initialValue: 0
/// )
/// ```
class SelfCell<T> extends DynamicComputeCell<T> {
  /// Create a computed cell which can access its own value.
  ///
  /// The [compute] function is called to compute the value of the cell, with
  /// a `self` argument. The `self` argument returns the last computed value of
  /// the cell. `self()` returns [initialValue] when it is called while
  /// computing the first value of the cell. If [initialValue] is null and [T]
  /// is not nullable, an [UninitializedCellError] is thrown when calling `self()`
  /// while computing the first value of the cell.
  ///
  /// The cell is identified by [key] if it is not null.
  factory SelfCell(SelfCompute<T> compute, {
    T? initialValue,
    key
  }) {
    late final SelfCell<T> self;

    self = SelfCell._internal(() => compute(self._selfValue),
        key: key,
        initialValue: initialValue
    );

    return self;
  }

  // Private

  /// The initial value to return when calling `self()`
  final T? _initialValue;

  SelfCell._internal(super._compute, {
    T? initialValue,
    super.key
  }) : _initialValue = initialValue, super(changesOnly: true);

  /// Get the last computed value of the cell.
  T _selfValue() {
    final state = this.state;

    if (state == null) {
      if (_initialValue == null && null is! T) {
        throw UninitializedCellError();
      }

      return _initialValue as T;
    }

    return state.selfValue;
  }

  @override
  @protected
  _SelfCellState<T>? get state => super.state as _SelfCellState<T>?;

  @override
  CellState<StatefulCell> createState() {
    if (_restoredState != null) {
      final state = _restoredState;
      _restoredState = null;

      return state!;
    }

    return _SelfCellState<T>(
      cell: this,
      key: key,
    );
  }
}

/// State for a [SelfCell].
class _SelfCellState<T> extends DynamicComputeChangesOnlyCellState<T> {
  _SelfCellState({
    required super.cell,
    required super.key
  });

  /// The last computed value of the cell
  late Maybe<T> _selfValue = Maybe.wrap(() {
    final cell = this.cell as SelfCell<T>;

    if (cell._initialValue == null && null is! T) {
      throw UninitializedCellError();
    }

    return cell._initialValue as T;
  });

  /// The last computed value of the cell.
  T get selfValue => _selfValue.unwrap;

  @override
  void preUpdate() {
    super.preUpdate();

    _selfValue = Maybe.wrap(() => cell.value);
  }
}