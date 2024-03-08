import '../stateful_cell/cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import 'mutable_cell.dart';

/// A cell without a value, which is used to trigger an action
class ActionCell extends StatefulCell<void> {
  /// Create a cell that represents an action.
  ///
  /// The cell is identified by [key] if it is non-null.
  ActionCell({super.key});

  /// Trigger the action represented by the cell.
  ///
  /// The observers of the cell are notified as though the value of the cell
  /// has changed.
  void trigger() {
    (state as ActionCellState?)?.trigger();
  }

  @override
  CellState<StatefulCell> createState() => ActionCellState(
      cell: this,
      key: key
  );

  @override
  void get value {}
}

/// [ActionCell] state
class ActionCellState extends MutableCellState<void, ActionCell> {
  ActionCellState({
    required super.cell,
    required super.key
  });

  /// Notify the observers of the cell.
  void trigger() {
    notifyWillUpdate();

    if (isBatchUpdate) {
      addToBatch(false);
    }
    else {
      notifyUpdate();
    }
  }
}