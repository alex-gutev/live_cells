part of 'cell_widget.dart';

/// Cell creation function.
///
/// The function is called with no arguments and should return a [ValueCell].
typedef CreateCell<T extends ValueCell> = T Function();

/// Provides the [cell] method for creating and retrieving instances of [ValueCell]'s.
///
/// The [cell] method can be used within [build] to obtain an instance of
/// a [ValueCell] that is persisted between builds of the widget.
///
/// During the first build every call to [cell] will create a new [ValueCell]
/// instance using the provided cell creation function. In subsequent builds
/// calls to [cell] return the existing instance that was created during the
/// first build using the corresponding cell creation function.
///
/// Example:
///
/// ````dart
/// class Example extends CellWidget {
///   @override
///   Widget build(BuildContext context) {
///     final a = cell(() => MutableCell(0));
///     final b = cell(() => MutableCell(1));
///
///     final sum = cell(() => a + b);
///     final product = cell(() => a * b);
///
///     return Column(
///       children: [
///          Text('a + b = ${sum()}'),
///          Text('a * b = ${product()}')
///          ...
///       ]
///     );
///   }
/// }
/// ````
///
/// In the example above, when the widget is built for the first time, two
/// mutable cells are created and assigned to `a` and `b`, and two computed
/// cells `a + b`, `a * b` are assigned to `sum` and `product`, respectively.
/// In subsequent builds, the first two calls to [cell] return the same
/// [MutableCell] instances created during the first build and
/// `cell(() => a + b)` returns the existing instance of the cell `a + b`, while
/// `cell(() => a * b)` returns the existing instance of the cell `a * b`.
///
/// With this class cell definitions can be kept directly within the build function
/// without having to use a [StatefulWidget].
///
/// **NOTE**:
///
/// Uses of [cell] have to obey the following rules:
///
/// 1. Calls to [cell] must not appear within conditionals or loops.
/// 2. Calls to [cell] must not appear within widget builder functions, such as
///    those used with [Builder] or [ValueListenableBuilder].
mixin CellInitializer on CellWidget {
  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// This function is intended to be used within [build] to create and
  /// retrieve an instance of a [ValueCell], so that the same instance will be
  /// returned across calls to [build].
  ///
  /// During the first build of the widget every call to [cell] will result in a
  /// new [ValueCell] instance being created by calling the provided [create]
  /// function. In subsequent builds, [cell] returns the existing
  /// [ValueCell] instance that was created during the first build using
  /// [create].
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    assert(_activeCellElement != null);

    final cell = _activeCellElement!.getCell(create);
    _activeCellElement!.nextCell();

    return cell;
  }

  /// Register a callback to be called whenever the values of cells change.
  ///
  /// The function [watch] is called whenever the values of the cells referenced
  /// within it using [ValueCell.call] change. [watch] is called once after it
  /// is registered.
  ///
  /// [watch] is not called after the widget is removed from the tree.
  ///
  /// **NOTE**: The callback is only registered once during the first build,
  /// and will not be registered again on subsequent builds.
  void watch(VoidCallback watch) {
    assert(_activeCellElement != null);

    _activeCellElement!.getWatcher(watch);
    _activeCellElement!.nextWatcher();
  }

  @override
  StatelessElement createElement() => _CellStorageElement(this);

  /// Private

  /// The element of the [CellWidget] currently being built.
  static _CellStorageElement? _activeCellElement;
}

/// Provides the [cell] method for creating and retrieving instances of [ValueCell]'s.
extension CellWidgetContextExtension on BuildContext {
  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// The functionality of this method is the same as [CellInitializer.cell].
  ///
  /// **NOTE**: This method may only be called if [this] is the [BuildContext]
  /// of a [CellWidget] with the [CellInitializer] mixin.
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    final element = this as _CellStorageElement;
    final cell = element.getCell(create);

    element.nextCell();
    return cell;
  }

  /// Register a callback function to be called whenever the values of cells change.
  ///
  /// The functionality of this method is the same as [CellInitializer.watch].
  ///
  /// **NOTE**: This method may only be called if [this] is the [BuildContext]
  /// of a [CellWidget] with the [CellInitializer] mixin.
  CellWatcher watch(VoidCallback watch) {
    final element = this as _CellStorageElement;
    final watcher = element.getWatcher(watch);

    element.nextWatcher();
    return watcher;
  }
}

/// Widget element for [CellWidget]
/// 
/// Keeps track of the cell instances that were created during the lifetime of
/// the widget.
class _CellStorageElement extends _CellWidgetElement {
  _CellStorageElement(super.widget);

  /// List of created cells
  final List<ValueCell> _cells = [];

  /// List of registered cell watchers
  final List<CellWatcher> _watchers = [];

  /// Index of cell to retrieve/create when calling [getCell]
  var _curCell = 0;

  /// Index of watcher to retrieve/create when calling [getWatcher]
  var _curWatcher = 0;

  /// Retrieve/create the current cell.
  /// 
  /// If there is no cell instance at the current cell index, [create] is called
  /// to create a new instance. Calling [getCell] again at the current cell index
  /// returns the existing cell instance.
  /// 
  /// The cell index can be advanced using [nextCell].
  V getCell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    if (_curCell < _cells.length) {
      return _cells[_curCell] as V;
    }

    final cell = create();
    _cells.add(cell);

    return cell;
  }

  /// Advance the cell index by 1.
  ///
  /// Calling [getCell] after [nextCell] will retrieve the cell at the next
  /// cell index.
  void nextCell() {
    _curCell++;
  }

  /// Retrieve/create the current *cell watcher*
  ///
  /// If there is no [CellWatcher] instance at the current watcher index a new one
  /// is created with watch function [watch]. Calling [getWatcher] again at the
  /// current watcher index returns the existing [CellWatcher] instance.
  ///
  /// The [CellWatcher] is automatically stopped when the element is unmounted.
  ///
  /// The watcher index can be advanced using [nextWatcher].
  CellWatcher getWatcher(VoidCallback watch) {
    if (_curWatcher < _watchers.length) {
      return _watchers[_curWatcher];
    }

    final watcher = CellWatcher(watch);
    _watchers.add(watcher);

    return watcher;
  }

  /// Advance the watcher index by 1.
  ///
  /// Calling [getWatcher] after [nextWatcher] will retrieve the *cell watcher*
  /// at the next watcher index.
  void nextWatcher() {
    _curWatcher++;
  }

  @override
  Widget build() {
    final previousActiveElement = CellInitializer._activeCellElement;
    try {
      _curCell = 0;
      _curWatcher = 0;

      CellInitializer._activeCellElement = this;
      return super.build();
    }
    finally {
      CellInitializer._activeCellElement = previousActiveElement;
    }
  }

  @override
  void unmount() {
    for (final watcher in _watchers) {
      watcher.stop();
    }

    super.unmount();
  }
}