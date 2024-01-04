import 'package:flutter/widgets.dart';
import 'package:live_cells/live_cells.dart';

part 'cell_widget.dart';

/// Cell creation function.
///
/// The cell is called with no arguments and should return a [ValueCell].
typedef CreateCell<T extends ValueCell> = T Function();

/// A cell which defers it's creation to a later point.
///
/// This cell serves as a proxy for another cell, which is created some point
/// after the [DeferredCell] instance is referenced in code.
///
/// The cell of which the creation is being deferred is defined by a cell creation
/// function. This function is called when the cell should be created and it
/// returns a new [ValueCell] instance.
///
/// **NOTE**: Calling any [ValueCell] method on this class, besides [eq], [neq]
/// and [toWidget] will trigger the creation of the cell.
class DeferredCell<T> implements MutableCell<T> {
  /// Function which returns a fresh instance of the cell being deferred.
  final CreateCell<ValueCell<T>> createCell;

  /// Create a proxy for a cell that has its creation deferred to a later point.
  ///
  /// When the cell is created, [createCell] is called to create the actual
  /// [ValueCell] instance.
  DeferredCell(this.createCell);

  @override
  T get value => _getCell().value;

  @override
  set value(T value) {
    final cell = _getCell() as MutableCell<T>;

    cell.value = value;
  }

  @override
  void addObserver(CellObserver observer) {
    _getCell().addObserver(observer);
  }

  @override
  ValueCell<bool> eq<U>(ValueCell<U> other) {
    return DeferredCell(() => _getCell().eq(other));
  }

  @override
  ValueCell<bool> neq<U>(ValueCell<U> other) {
    return DeferredCell(() => _getCell().neq(other));
  }

  @override
  void removeObserver(CellObserver observer) {
    return _getCell().removeObserver(observer);
  }

  Widget toWidget(ValueWidgetBuilder<T> builder, {
    Widget? child
  }) {
    return Builder(builder: (context) => _getCell().toWidget(
      builder,
      child: child
    ));
  }

  /// Private

  /// When true an exception is thrown if a [DeferredCell] is referenced before creation.
  static var _stopInit = false;

  /// The cell of which the creation is being deferred.
  late final ValueCell<T> _cell;

  /// Has the cell been initialized?
  var _initialized = false;

  /// Get the cell instance creating it if it has not been created yet.
  ValueCell<T> _getCell() {
    if (!_initialized) {
      if (_stopInit) {
        throw StateError('DeferredCell referenced before initialization.');
      }

      _initCell(createCell());
    }

    return _cell;
  }

  /// Initialize the [DeferredCell] with an existing instance
  void _initCell(ValueCell<T> cell) {
    _cell = cell;
    _initialized = true;
  }

  @override
  void notifyUpdate() {
    final cell = _getCell() as MutableCell<T>;
    cell.notifyUpdate();
  }

  @override
  void notifyWillUpdate() {
    final cell = _getCell() as MutableCell<T>;
    cell.notifyWillUpdate();
  }
}