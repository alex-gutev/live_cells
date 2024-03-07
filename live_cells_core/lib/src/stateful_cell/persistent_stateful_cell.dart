part of 'stateful_cell.dart';

/// Represents an attempt to read/write the value of an inactive persistent stateful cell.
class InactivePersistentStatefulCellError implements Exception {
  @override
  String toString() => 'The value of a stateful cell was read/written before '
      'its state has been created, i.e. before the first observer has been '
      'added';
}


/// A [StatefulCell] with a state that is created before the cell has observers.
///
/// This cell guarantees that a non-disposed state is returned whenever [state]
/// is accessed, even if the cell does not have any observers, as long as [key]
/// is null. If [key] is non-null an [InactivePersistentStatefulCellError]
/// exception is thrown if [state] is accessed when the cell is inactive.
abstract class PersistentStatefulCell<T> extends StatefulCell<T> {
  PersistentStatefulCell({super.key});

  @override
  @protected
  CellState get state {
    if (key == null) {
      return _ensureState();
    }

    final state = super.state;

    if (state == null) {
      throw InactivePersistentStatefulCellError();
    }

    return state;
  }
}