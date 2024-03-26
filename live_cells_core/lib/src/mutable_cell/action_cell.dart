import '../stateful_cell/cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';
import 'mutable_cell.dart';

/// Interface for a cell without a value, which is used to trigger an action.
abstract class ActionCell implements ValueCell<void> {
  /// Create a cell that represents an action.
  ///
  /// The cell is identified by [key] if it is non-null.
  factory ActionCell({ key }) = _ActionCellImpl;

  /// Create an action cell chained to another [cell].
  ///
  /// This constructor creates an action cell that when triggered by [trigger],
  /// the function [action] is called. [action] has the option of either
  /// calling [trigger] on [cell]. If [action] calls [trigger] the observers
  /// of both [cell] and the returned cell are notified. If [action] does not
  /// call [trigger], neither the observers of [cell] nor the returned cell
  /// are notified, effectively preventing the action from taking place.
  ///
  /// When the observers of [cell] are notified, by calling [trigger] on [cell]
  /// directly, the observers of the returned cell are also notified.
  ///
  /// The cell is identified by [key] if it is non-null.
  factory ActionCell.chain(ValueCell<void> cell, {
    dynamic key,
    required void Function() action
  }) = _ChainedActionCell;

  /// Trigger the action represented by the cell.
  ///
  /// The observers of the cell are notified as though the value of the cell
  /// has changed.
  void trigger();
}

/// Implementation of the [ActionCell] interface
class _ActionCellImpl extends StatefulCell<void> implements ActionCell {
  /// Create a cell that represents an action.
  ///
  /// The cell is identified by [key] if it is non-null.
  _ActionCellImpl({super.key});

  @override
  void trigger() {
    (state as _ActionCellState?)?.trigger();
  }

  @override
  CellState<StatefulCell> createState() => _ActionCellState(
      cell: this,
      key: key
  );

  @override
  void get value {}
}

/// [_ActionCellImpl] state
class _ActionCellState extends MutableCellState<void, _ActionCellImpl> {
  _ActionCellState({
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

/// A stateless action cell that calls a user defined function when triggered.
class _ChainedActionCell extends DependentCell<void> implements ActionCell {
  /// Function to cal when triggered.
  final void Function() action;

  _ChainedActionCell(ValueCell<void> cell, {
    super.key,
    required this.action
  }) : super({cell});

  @override
  void get value {}
  
  @override
  void trigger() => action();
}