import 'package:record_extender_annotations/record_extender_annotations.dart';

import 'compute_extension.dart';
import 'conversion_extensions.dart';
import 'error_handling_extension.dart';
import '../async_cell/await_cell.dart';
import '../async_cell/wait_cell.dart';
import '../base/keys.dart';
import '../value_cell.dart';

part 'wait_cell_extension.g.dart';

/// A cell, which holds a [Future] value.
typedef FutureCell<T> = ValueCell<Future<T>>;

/// Provides methods for creating cells that notify their observers after a delay.
extension DelayCellExtension<T> on ValueCell<T> {
  /// Create a cell which notifies its observers, for value changes in [this], after a delay.
  ///
  /// The returned cell takes on the same value as [this], but instead of
  /// updating its value immediately when the value of [this] changes, it updates
  /// its value, and hence notifies its observers, after a [delay].
  ///
  /// The cell returned is a keyed cell, which is unique for a given [this] and
  /// [delay].
  FutureCell<T> delayed(Duration delay) =>
      apply((value) => Future.delayed(delay, () => value),
        key: _DelayCellKey(this, delay)
      );
}

/// Provides the [wait] method on a cell holding a [Future].
@RecordExtension(
  size: 9,
  documentation: 'Provides the [wait] method on a record of cells each holding a [Future]'
)
extension WaitCellExtension1<T> on FutureCell<T> {
  /// Return a cell that awaits the [Future] held in [this].
  ///
  /// The value of the returned cell is the completed value of the [Future].
  /// Whenever the value of [this] changes, the returned cell awaits the
  /// new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  @RecordExtensionElement(
    type: 'ValueCell<({type-params})>',
    implementation: '''return WaitCell(arg: apply(({elements}) => ({elements}).wait,
    key: _CombinedCellKey(this, false)
    ));''',

    documentation: '''Return a cell that awaits the [Future] held in the cells in [this].

The value of the returned cell is the completed value of the [Future].
Whenever the values of the cells in [this] change, the returned cell
awaits the new [Future] and updates its value accordingly.

Until the [Future] completes, accessing the [value] of the returned cell
will throw an [UninitializedCellError].

**NOTE**: The returned cell must have at least one observer in order
to function.'''
  )
  ValueCell<T> get wait => WaitCell(arg: this);

  /// A cell that awaits the [Future] held in [this].
  ///
  /// The returned cell is like [wait] with the difference that if the value of
  /// [this] changes to a new [Future], before its previous value has
  /// completed, the previous value is dropped.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  @RecordExtensionElement(
    type: 'ValueCell<({type-params})>',
    implementation: '''return WaitCell(arg: apply(({elements}) => ({elements}).wait,
    key: _CombinedCellKey(this, true)),
    lastOnly: true
    );''',

    documentation: '''A cell that awaits the [Future] held in the cells in [this].

The returned cell is like [wait] with the difference that if the values of
the cells in [this] change, before the previous values have
completed, the previous values are dropped.

Until the [Future] completes, accessing the [value] of the returned cell
will throw an [UninitializedCellError].

**NOTE**: The returned cell must have at least one observer in order
to function.'''
  )
  ValueCell<T> get waitLast => WaitCell(
      arg: this,
      lastOnly: true
  );

  /// A cell that awaits the [Future] held in [this].
  ///
  /// The returned cell is like [waitLast] with the difference that whenever
  /// the value of [this] is changed to a new [Future], accessing the value of
  /// the returned cell before the new [Future] has completed, will throw
  /// an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  @RecordExtensionElement(
    type: 'ValueCell<({type-params})>',
    implementation: '''return AwaitCell(arg: apply(({elements}) => ({elements}).wait,
      key: _CombinedAwaitCellKey(this),
      ));''',

    documentation: '''A cell that awaits the [Future] held in the cells in [this].

The returned cell is like [waitLast] with the difference that whenever
the values of the cells in [this] change, accessing the value of
the returned cell before the new [Future]s have completed, will throw
an [UninitializedCellError].

**NOTE**: The returned cell must have at least one observer in order
to function.'''
  )
  ValueCell<T> get awaited => AwaitCell(arg: this);

  /// A cell that is true when the [Future] in this has completed, false otherwise.
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  @RecordExtensionElement(
    type: 'ValueCell<bool>',
    implementation: '''return awaited.apply((_) => true, key: _IsCompleteCellKey(this))
      .initialValue(false.cell);''',

  documentation: '''A cell that is true when the [Future]s in the cells in this have completed, false otherwise.

**NOTE**: The returned cell must have at least one observer in order
to function.'''
)
  ValueCell<bool> get isCompleted => awaited
      .apply((_) => true, key: _IsCompleteCellKey(this))
      .initialValue(false.cell);
}

/// A key which identifies a record of cells
class _CombinedCellKey<T> extends ValueKey2<T, bool> {
  _CombinedCellKey(super.value1, super.value2);
}

/// A key which identifies a record of cells used with `.awaited`
class _CombinedAwaitCellKey<T> extends ValueKey1<T> {
  _CombinedAwaitCellKey(super.value);
}

/// Key identifying a delayed cell.
class _DelayCellKey<T> extends ValueKey2<ValueCell<T>, Duration> {
  _DelayCellKey(super.value1, super.value2);
}

/// Identifies a cell created with `.isCompleted`
class _IsCompleteCellKey<T> extends ValueKey1<T> {
  _IsCompleteCellKey(super.value);
}