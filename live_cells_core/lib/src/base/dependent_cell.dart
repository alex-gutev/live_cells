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

  /// List of argument cells.
  @protected
  final List<ValueCell> arguments;

  /// Callback function called to determine whether the cell's value will change.
  @protected
  final WillChangeCallback? willChange;
  
  /// Create a cell, of which the value depends on a list of argument cells.
  ///
  /// [arguments] is the list of all the argument cells on which the value
  /// of this cell depends.
  ///
  /// If [key] is non-null, the returned [DependentCell] object will compare
  /// [==] to all [DependentCell] objects with the same [key] under [==].
  ///
  /// If [willChange] is non-null, it is called to determine whether the cell's
  /// value will change for a change in the value of an argument cell. It is
  /// called with the argument cell and its new value passed as arguments. The
  /// function should return true if the cell's value may change, and false if
  /// it can be determined with certainty that it wont. **NOTE**: this function
  /// is only called if the new value of the argument cell is known, see
  /// [CellObserver.shouldNotify] for more information.
  DependentCell(this.arguments, {
    this.key,
    this.willChange
  });

  @override
  bool operator ==(other) => other is DependentCell && key != null
      ? key == other.key
      : super == other;

  @override
  int get hashCode => key != null ? key.hashCode : super.hashCode;

  @override
  void addObserver(CellObserver observer) {
    for (final dependency in arguments) {
      dependency.addObserver(willChange == null
          ? _CellObserverWrapper(this, observer)
          : _CellObserverCheckNotifyWrapper(this, observer, willChange!)
      );
    }
  }

  @override
  void removeObserver(CellObserver observer) {
    for (final dependency in arguments) {
      dependency.removeObserver(willChange == null
          ? _CellObserverWrapper(this, observer)
          : _CellObserverCheckNotifyWrapper(this, observer, willChange!)
      );
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
  void update(ValueCell cell) {
    observer.update(observedCell);
  }

  @override
  void willUpdate(ValueCell cell) {
    observer.willUpdate(observedCell);
  }

  @override
  bool get shouldNotifyAlways => observer.shouldNotifyAlways;
}

class _CellObserverCheckNotifyWrapper extends _CellObserverWrapper {
  final WillChangeCallback _shouldNotify;

  _CellObserverCheckNotifyWrapper(super.observedCell, super.observer, this._shouldNotify);

  @override
  bool shouldNotify(ValueCell cell, newValue) => _shouldNotify(cell, newValue);
}