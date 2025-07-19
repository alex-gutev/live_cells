// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wait_cell_extension.dart';

// **************************************************************************
// RecordExtensionGenerator
// **************************************************************************

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension2<T$1, T$2> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2)> get wait {
    return WaitCell(
        arg: apply(($1, $2) => ($1, $2).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2)> get waitLast {
    return WaitCell(
        arg:
            apply(($1, $2) => ($1, $2).wait, key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2) => ($1, $2).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2)>> get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension3<T$1, T$2, T$3> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3)> get wait {
    return WaitCell(
        arg: apply(($1, $2, $3) => ($1, $2, $3).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3)> get waitLast {
    return WaitCell(
        arg: apply(($1, $2, $3) => ($1, $2, $3).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3) => ($1, $2, $3).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3)>> get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension4<T$1, T$2, T$3, T$4> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>,
  ValueCell<Future<T$4>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4)> get wait {
    return WaitCell(
        arg: apply(($1, $2, $3, $4) => ($1, $2, $3, $4).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4)> get waitLast {
    return WaitCell(
        arg: apply(($1, $2, $3, $4) => ($1, $2, $3, $4).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3, $4) => ($1, $2, $3, $4).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3, T$4)>> get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension5<T$1, T$2, T$3, T$4, T$5> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>,
  ValueCell<Future<T$4>>,
  ValueCell<Future<T$5>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5)> get wait {
    return WaitCell(
        arg: apply(($1, $2, $3, $4, $5) => ($1, $2, $3, $4, $5).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5)> get waitLast {
    return WaitCell(
        arg: apply(($1, $2, $3, $4, $5) => ($1, $2, $3, $4, $5).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3, $4, $5) => ($1, $2, $3, $4, $5).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3, T$4, T$5)>> get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension6<T$1, T$2, T$3, T$4, T$5, T$6> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>,
  ValueCell<Future<T$4>>,
  ValueCell<Future<T$5>>,
  ValueCell<Future<T$6>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6)> get wait {
    return WaitCell(
        arg: apply(($1, $2, $3, $4, $5, $6) => ($1, $2, $3, $4, $5, $6).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6)> get waitLast {
    return WaitCell(
        arg: apply(($1, $2, $3, $4, $5, $6) => ($1, $2, $3, $4, $5, $6).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3, $4, $5, $6) => ($1, $2, $3, $4, $5, $6).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3, T$4, T$5, T$6)>> get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension7<T$1, T$2, T$3, T$4, T$5, T$6, T$7> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>,
  ValueCell<Future<T$4>>,
  ValueCell<Future<T$5>>,
  ValueCell<Future<T$6>>,
  ValueCell<Future<T$7>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7)> get wait {
    return WaitCell(
        arg: apply(
            ($1, $2, $3, $4, $5, $6, $7) => ($1, $2, $3, $4, $5, $6, $7).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7)> get waitLast {
    return WaitCell(
        arg: apply(
            ($1, $2, $3, $4, $5, $6, $7) => ($1, $2, $3, $4, $5, $6, $7).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3, $4, $5, $6, $7) => ($1, $2, $3, $4, $5, $6, $7).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3, T$4, T$5, T$6, T$7)>> get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension8<T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>,
  ValueCell<Future<T$4>>,
  ValueCell<Future<T$5>>,
  ValueCell<Future<T$6>>,
  ValueCell<Future<T$7>>,
  ValueCell<Future<T$8>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8)> get wait {
    return WaitCell(
        arg: apply(
            ($1, $2, $3, $4, $5, $6, $7, $8) =>
                ($1, $2, $3, $4, $5, $6, $7, $8).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8)> get waitLast {
    return WaitCell(
        arg: apply(
            ($1, $2, $3, $4, $5, $6, $7, $8) =>
                ($1, $2, $3, $4, $5, $6, $7, $8).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3, $4, $5, $6, $7, $8) => ($1, $2, $3, $4, $5, $6, $7, $8).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8)>>
      get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension9<T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8, T$9> on (
  ValueCell<Future<T$1>>,
  ValueCell<Future<T$2>>,
  ValueCell<Future<T$3>>,
  ValueCell<Future<T$4>>,
  ValueCell<Future<T$5>>,
  ValueCell<Future<T$6>>,
  ValueCell<Future<T$7>>,
  ValueCell<Future<T$8>>,
  ValueCell<Future<T$9>>
) {
  /// Return a cell that awaits the [Future] held in the cells in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// awaits the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8, T$9)> get wait {
    return WaitCell(
        arg: apply(
            ($1, $2, $3, $4, $5, $6, $7, $8, $9) =>
                ($1, $2, $3, $4, $5, $6, $7, $8, $9).wait,
            key: _CombinedCellKey(this, false)));
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the values of
  /// the cells in [this] change, before the previous values have
  /// completed, the previous values are dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8, T$9)> get waitLast {
    return WaitCell(
        arg: apply(
            ($1, $2, $3, $4, $5, $6, $7, $8, $9) =>
                ($1, $2, $3, $4, $5, $6, $7, $8, $9).wait,
            key: _CombinedCellKey(this, true)),
        lastOnly: true);
  }

  /// A cell that awaits the [Future] held in the cells in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the values of the cells in [this] change, accessing the value of
  /// the returned cell before the new [Future]s have completed, will throw
  /// a [PendingAsyncValueError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8, T$9)> get awaited {
    return AwaitCell(
        arg: apply(
      ($1, $2, $3, $4, $5, $6, $7, $8, $9) =>
          ($1, $2, $3, $4, $5, $6, $7, $8, $9).wait,
      key: _CombinedAwaitCellKey(this),
    ));
  }

  /// A cell that is true when the [Future]s in the cells in this have completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<bool> get isCompleted {
    return awaited
        .apply((_) => true, key: _IsCompleteCellKey(this))
        .loadingValue(false.cell)
        .onError(true.cell);
  }

  /// A cell that evaluates to the [AsyncState] of the [Future] held in this cell.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<AsyncState<(T$1, T$2, T$3, T$4, T$5, T$6, T$7, T$8, T$9)>>
      get asyncState {
    return ValueCell.computed(
        () => AsyncState.makeState(
              current: awaited,
            ),
        key: _AsyncStateCellKey(this));
  }
}
