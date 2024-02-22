import 'compute_extension.dart';
import '../async_cell/wait_cell.dart';
import '../base/keys.dart';
import '../value_cell.dart';

/// A cell, which holds a [Future] value.
typedef FutureCell<T> = ValueCell<Future<T>>;

/// Provides the [wait] method on a cell holding a [Future].
extension WaitCellExtension1<T> on FutureCell<T> {
  /// Return a cell which awaits the [Future] held in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the value of [this] changes, the returned cell resolves the
  /// new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<T> get wait => WaitCell(arg: this);
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension2<T1, T2> on (FutureCell<T1>, FutureCell<T2>) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2)> get wait =>
      WaitCell(arg: ($1, $2).apply((p0, p1) => (p0, p1).wait,
          key: _CombinedCellKey(this)
      ));
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension3<T1, T2, T3> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3)> get wait =>
      WaitCell(arg: ($1, $2, $3).apply((p0, p1, p2) => (p0, p1, p2).wait,
          key: _CombinedCellKey(this)
      ));
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension4<T1, T2, T3, T4> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>,
  FutureCell<T4>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3, T4)> get wait => WaitCell(
      arg: ($1, $2, $3, $4).apply((p0, p1, p2, p3) => (p0, p1, p2, p3).wait,
          key: _CombinedCellKey(this)
      ));
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension5<T1, T2, T3, T4, T5> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>,
  FutureCell<T4>,
  FutureCell<T5>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3, T4, T5)> get wait => WaitCell(
      arg: ($1, $2, $3, $4, $5)
          .apply((p0, p1, p2, p3, p4) => (p0, p1, p2, p3, p4).wait,
          key: _CombinedCellKey(this)
      )
  );
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension6<T1, T2, T3, T4, T5, T6> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>,
  FutureCell<T4>,
  FutureCell<T5>,
  FutureCell<T6>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3, T4, T5, T6)> get wait => WaitCell(
      arg: ($1, $2, $3, $4, $5, $6)
          .apply((p0, p1, p2, p3, p4, p5) => (p0, p1, p2, p3, p4, p5).wait,
          key: _CombinedCellKey(this)
      )
  );
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension7<T1, T2, T3, T4, T5, T6, T7> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>,
  FutureCell<T4>,
  FutureCell<T5>,
  FutureCell<T6>,
  FutureCell<T7>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3, T4, T5, T6, T7)> get wait => WaitCell(
      arg: ($1, $2, $3, $4, $5, $6, $7)
          .apply((p0, p1, p2, p3, p4, p5, p6) => (p0, p1, p2, p3, p4, p5, p6).wait,
          key: _CombinedCellKey(this)
      )
  );
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension8<T1, T2, T3, T4, T5, T6, T7, T8> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>,
  FutureCell<T4>,
  FutureCell<T5>,
  FutureCell<T6>,
  FutureCell<T7>,
  FutureCell<T8>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3, T4, T5, T6, T7, T8)> get wait => WaitCell(
      arg: ($1, $2, $3, $4, $5, $6, $7, $8)
          .apply((p0, p1, p2, p3, p4, p5, p6, p7) => (p0, p1, p2, p3, p4, p5, p6, p7).wait,
          key: _CombinedCellKey(this)
      )
  );
}

/// Provides the [wait] method on a record of cells each holding a [Future]
extension WaitCellExtension9<T1, T2, T3, T4, T5, T6, T7, T8, T9> on (
  FutureCell<T1>,
  FutureCell<T2>,
  FutureCell<T3>,
  FutureCell<T4>,
  FutureCell<T5>,
  FutureCell<T6>,
  FutureCell<T7>,
  FutureCell<T8>,
  FutureCell<T9>
) {
  /// Return a cell which awaits the [Future] held in the cell's in [this].
  ///
  /// The value of the returned cell is the resolved value of the [Future].
  /// Whenever the values of the cells in [this] change, the returned cell
  /// resolves the new [Future] and updates its value accordingly.
  ///
  /// Until the [Future] completes, accessing the [value] of the returned cell
  /// will throw an [UninitializedCellError].
  ///
  /// **NOTE**: The returned cell must have at least one observer in order
  /// to function.
  ValueCell<(T1, T2, T3, T4, T5, T6, T7, T8, T9)> get wait => WaitCell(
      arg: ($1, $2, $3, $4, $5, $6, $7, $8, $9)
          .apply((p0, p1, p2, p3, p4, p5, p6, p7, p8) => (p0, p1, p2, p3, p4, p5, p6, p7, p8).wait,
          key: _CombinedCellKey(this)
      )
  );
}

/// A key which identifies a record of cells
class _CombinedCellKey<T> extends ValueKey1<T> {
  _CombinedCellKey(super.value);
}