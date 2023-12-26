import 'package:flutter/foundation.dart';
import '../value_cell.dart';
import 'cell_observer.dart';

/// Creates a [ValueListenable] from a [ValueCell]
///
/// The listeners of the listenable are called whenever the value of the
/// cell changes.
///
/// **NOTE**: [dispose] should be called on an instance this class when it will
/// no longer be used.
class CellListenable<T> extends ChangeNotifier implements ValueListenable<T>, CellObserver {
  /// The cell of which to observe the value.
  final ValueCell<T> cell;

  /// The cell's value
  @override
  T get value => cell.value;

  /// Create a [ValueListenable] which listens to changes in [cell]
  ///
  /// Whenever the value of [cell] changes the listeners of [this] are called.
  CellListenable(this.cell) {
    cell.addObserver(this);
  }

  @override
  void dispose() {
    cell.removeObserver(this);
    super.dispose();
  }

  @override
  void update() {
    notifyListeners();
  }

  @override
  void willNotUpdate() {
  }

  @override
  void willUpdate() {
  }
}

/// Provides a method for creating a [ValueListenable] from a cell
extension CellListenableExtension<T> on ValueCell<T> {
  /// Create a [ValueListenable] of which the listeners are calledd whenever the value of [this] changes.
  ///
  /// The returned [ValueListenable] has a [value] property which is equal to the
  /// cell's value.
  ///
  /// **NOTE**: [dispose] should be called on the returned instance when it will
  /// no longer be used.
  CellListenable<T> toListenable() => CellListenable(this);
}