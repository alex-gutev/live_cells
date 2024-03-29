import 'package:meta/meta.dart';

import '../compute_cell/mutable_computed_cell_state.dart';
import '../restoration/restoration.dart';
import '../value_cell.dart';
import 'mutable_cell.dart';

/// Base class for a computational cell which can have its value set.
///
/// The use of this class is similar to [DependentCell] however the [compute]
/// method, rather than the [value] property setter, has to be overriden with
/// the implementation of the cell computation function.
///
/// Constructors of this class must call the [MutableDependentCell] constructor
/// with the list of argument cells which are referenced in the [compute]
/// function. The value of the cell will be recomputed whenever the value of
/// one of the argument cells changes.
///
/// Additionally, subclasses must also implement the [reverseCompute] method,
/// which is called whenever the value of the cell is set. This method should
/// update the values of the argument cells.
abstract class MutableDependentCell<T> extends MutableCellBase<T>
    implements RestorableCell<T> {

  /// List of argument cells.
  @protected
  final Set<ValueCell> arguments;

  /// Should the cell notify its observers only when its value has changed?
  @protected
  final bool changesOnly;

  /// Construct a [MutableDependentCell] which depends on the cells in [arguments]
  ///
  /// Every cell of which the value is referenced in [compute] must be
  /// included in [arguments].
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  /// If [key] is non-null it is used to identify the cell. **NOTE**, if [key]
  /// is non null [dispose] has to be called, when the cell is no longer used.
  MutableDependentCell(this.arguments, {
    this.changesOnly = false,
    super.key
  });

  /// Compute the value of the cell.
  ///
  /// Implementations of this method may reference the values of cells included
  /// in [arguments].
  ///
  /// The new cell value should be returned.
  T compute();

  /// Set the value of the argument cells in response to the value of the cell being set.
  ///
  /// Implementations of this method should be update the values of the cells in
  /// [arguments] based on [value], which is the new value of the cell.
  ///
  /// This method is executed in a [MutableCell.batch] call.
  void reverseCompute(T value);

  // Private

  @override
  MutableComputedCellState<T, MutableDependentCell<T>> createMutableState({
    covariant MutableComputedCellState<T, MutableDependentCell<T>>? oldState
  }) {
    if (changesOnly) {
      return MutableComptedChangesOnlyCellState(
          cell: this,
          key: key,
          arguments: arguments,
          oldState: oldState
      );
    }
    return MutableComputedCellState(
        cell: this,
        key: key,
        arguments: arguments,
        oldState: oldState
    );
  }

  @override
  MutableComputedCellState<T, MutableDependentCell<T>> get state =>
      super.state as MutableComputedCellState<T, MutableDependentCell<T>>;

  @override
  Object? dumpState(CellValueCoder coder) => state.dumpState(coder);

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    if (state != null) {
      this.state.restoreState(state, coder);
    }
  }
}
