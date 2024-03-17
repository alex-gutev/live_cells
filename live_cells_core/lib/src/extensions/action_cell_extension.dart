import '../compute_cell/compute_cell.dart';
import '../compute_cell/store_cell.dart';
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

/// Provides the [combined] property for combining multiple action cells into one cell.
extension CombineActionCellExtension on List<ValueCell<void>> {
  /// Return an action cell that notifies its observers when any of the cells in this is triggered.
  ValueCell<void> get combined => ComputeCell(
    compute: () {},
    arguments: toSet()
  );
}