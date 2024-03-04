part of 'stateful_cell.dart';

/// A [StatefulCell] with a state that is created before the cell has observers.
///
/// This cell guarantees that a non-disposed state is returned whenever [state]
/// is accessed, even if the cell does not have any observers. This means the
/// state of the cell will have to be disposed manually, when it is no longer
/// used.
abstract class PersistentStatefulCell<T> extends StatefulCell<T> {
  PersistentStatefulCell({super.key});

  @override
  @protected
  CellState get state => _ensureState();
}