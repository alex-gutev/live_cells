import 'package:flutter/foundation.dart';
import '../value_cell.dart';
import 'cell_observer.dart';

/// Provides a method for creating a [ValueListenable] from a cell
extension CellListenableExtension<T> on ValueCell<T> {
  /// Adapter object for the [ValueCell] which implements the [ValueListenable] interface.
  ///
  /// The returned [ValueListenable] has a [value] property which is equal to the
  /// cell's value. Listeners added to the [ValueListenable] are called whenever
  /// the value of the cell changes.
  ValueListenable<T> get listenable => _CellListenable(this);
}

/// Adapter for [ValueCell] which implements the [ValueListenable] interface.
///
/// The listeners added to this listenable are called whenever the value of the
/// cell changes.
class _CellListenable<T> extends ValueListenable<T> {
  /// The cell of which to observe the value.
  final ValueCell<T> cell;

  /// The cell's value
  @override
  T get value => cell.value;

  /// Create a [ValueListenable] which listens to changes in the value of [cell].
  _CellListenable(this.cell);

  @override
  void addListener(VoidCallback listener) {
    cell.addObserver(_ListenerCellObserverAdapter(listener));
  }

  @override
  void removeListener(VoidCallback listener) {
    cell.removeObserver(_ListenerCellObserverAdapter(listener));
  }
}

/// [VoidCallback] to [CellObserver] adapter.
///
/// This class is an adapter which allows a [VoidCallback] (the listener type
/// of the [Listenable] interface) to be used where a [CellObserver] is
/// expected.
///
/// The [listener] function is called when the [CellObserver.update] method is
/// called.
///
/// This class overrides the [==] operator and [hashCode] so that different
/// [_ListenerCellObserverAdapter] objects holding the same [listener] compare
/// equal.
class _ListenerCellObserverAdapter extends CellObserver {
  /// The listener function
  final VoidCallback listener;

  _ListenerCellObserverAdapter(this.listener);

  bool operator ==(other) {
    return other is _ListenerCellObserverAdapter && listener == other.listener;
  }
  
  @override
  int get hashCode => listener.hashCode;
  
  @override
  void update() {
    listener();
  }

  @override
  void willNotUpdate() {
  }

  @override
  void willUpdate() {
  }
}