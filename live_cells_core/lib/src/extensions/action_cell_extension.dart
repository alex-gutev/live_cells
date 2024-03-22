import '../compute_cell/compute_cell.dart';
import '../compute_cell/store_cell.dart';
import '../mutable_cell/action_cell.dart';
import '../value_cell.dart';

/// Provides the [effect] method for creating an [EffectCell] triggered by an [ActionCell].
extension ActionCellEffectExtension on ValueCell<void> {
  /// Create a cell with a side effect that is run whenever this cell is triggered..
  ///
  /// The side effect [fn] is run only when this cell is triggered and only if
  /// the returned cell is observed. The value of the return cell is the value
  /// returned by the latest call to [fn].
  ///
  /// [key] identifies the cell containing the side effect.
  ValueCell<T> effect<T>(T Function() fn, {
    dynamic key
  }) => ComputeCell(
      compute: fn,
      arguments: {this},
      key: key
  ).effectCell;
}

/// Provides functionality for chaining action cells
extension ActionCellExtension on ActionCell {
  /// Create an action cell that is chained to this cell.
  ///
  /// An action cell is created that when triggered, [action] is called first.
  /// [action] can either call [trigger] on this cell thus allowing the action
  /// triggering the action represented by this cell, or it can prevent the
  /// action from being triggering by not calling [trigger].
  ///
  /// See [ActionCell.chain] for more details.
  ActionCell chain(void Function() action, {
    dynamic key
  }) => ActionCell.chain(
      this,
      action: action,
      key: key
  );
}

/// Provides the [combined] property for combining multiple action cells into one cell.
extension CombineActionCellExtension on List<ValueCell<void>> {
  /// Return an action cell that notifies its observers when any of the cells in this is triggered.
  ValueCell<void> get combined => ComputeCell(
    compute: () {},
    arguments: toSet()
  );
}