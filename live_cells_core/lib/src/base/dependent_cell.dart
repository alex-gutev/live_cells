part of '../value_cell.dart';

/// A cell of which the value is dependent on the value of one or more argument cells.
/// 
/// The purpose of this class is to implement a cell of which the value is a
/// function of one or more argument cells, thus the value of this cell needs to
/// be recomputed whenever the values of the argument cells change.
///
/// This class does not provide storage for the cell's value, it is intended to
/// be computed on demand when accessed, whilst observers are added directly
/// on the argument cells.
abstract class DependentCell<T> extends ValueCell<T> {
  /// Key that uniquely identifies this cell.
  ///
  /// Since [DependentCell] is a stateless cell that always computes its value
  /// when referenced, this just ensures that [DependentCell]'s with the same
  /// key compare equal under [==].
  final dynamic key;

  /// Set of argument cells.
  @protected
  final Set<ValueCell> arguments;

  /// Create a cell, of which the value depends on a list of argument cells.
  ///
  /// [arguments] is the set of all the argument cells on which the value
  /// of this cell depends.
  ///
  /// If [key] is non-null, the returned [DependentCell] object will compare
  /// [==] to all [DependentCell] objects with the same [key] under [==].
  DependentCell(this.arguments, {
    key,
  }) : key = key ?? AutoKey.autoKey();

  @override
  bool operator ==(other) => other is DependentCell && key != null
      ? key == other.key
      : super == other;

  @override
  int get hashCode => key != null ? key.hashCode : super.hashCode;

  @override
  void addObserver(CellObserver observer) {
    for (final dependency in arguments) {
      dependency.addObserver(_CellObserverWrapper(this, observer));
    }
  }

  @override
  void removeObserver(CellObserver observer) {
    for (final dependency in arguments) {
      dependency.removeObserver(_CellObserverWrapper(this, observer));
    }
  }
}

/// A [CellObserver] wrapper which changes the cell passed to the interface methods.
class _CellObserverWrapper extends CellObserver {
  /// The cell to pass to the [update] and [willUpdate] methods.
  final ValueCell observedCell;

  /// The actual observe to call
  final CellObserver observer;

  _CellObserverWrapper(this.observedCell, this.observer);

  @override
  bool operator ==(Object other) =>
      other is _CellObserverWrapper && other.observer == observer;

  @override
  int get hashCode => observer.hashCode;

  @override
  void update(ValueCell cell, bool didChange) {
    observer.update(observedCell, didChange);
  }

  @override
  void willUpdate(ValueCell cell) {
    observer.willUpdate(observedCell);
  }

  @override
  bool get shouldNotifyAlways => observer.shouldNotifyAlways;
}