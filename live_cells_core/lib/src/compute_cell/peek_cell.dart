import '../base/cell_observer.dart';
import '../value_cell.dart';

/// Provides the [peek] property for using the value of a cell without reacting to changes.
extension PeekCellExtension<T> on ValueCell<T> {
  /// Use the value of [this] without reacting to changes.
  ///
  /// This property returns a cell, which has the same value as [this] but does
  /// not inform its observers when the value of [this] changes.
  ///
  /// This should be used rather than accessing [value] directly or omitting
  /// [this] as a dependency to ensure that [this] cell is kept active.
  ValueCell<T> get peek => PeekCell(this);
}

/// A cell which has the same value as another cell but does not notify its observers.
class PeekCell<T> extends ValueCell<T> {
  /// The cell providing this cell's value
  final ValueCell<T> cell;

  PeekCell(this.cell) : super();

  @override
  bool operator ==(Object other) => other is PeekCell && other.cell == cell;

  @override
  int get hashCode => Object.hash(runtimeType, cell);

  @override
  void addObserver(CellObserver observer) {
    cell.addObserver(_PeekCellObserver(observer));
  }

  @override
  void removeObserver(CellObserver observer) {
    cell.removeObserver(_PeekCellObserver(observer));
  }

  @override
  T get value => cell.value;

}

/// Wraps an observer of a [PeekCell] to prevent [update] and [willUpdate] from being called.
class _PeekCellObserver extends CellObserver {
  /// The original observer, used only for comparison with other [_PeekCellObserver]'s.
  final CellObserver observer;

  _PeekCellObserver(this.observer);

  @override
  bool operator ==(Object other) => other is _PeekCellObserver &&
          other.observer == observer;

  @override
  int get hashCode => observer.hashCode;

  @override
  void update(ValueCell cell) {
    // Do nothing
  }

  @override
  void willUpdate(ValueCell cell) {
    // Do nothing
  }
}