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
mixin CellHooks on CellWidget {
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
  ///
  /// **NOTE**: This method may only be called within the [build] method.
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    assert(_activeCellElement != null);
    return _activeCellElement!.getCell(create);
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
  ///
  /// **NOTE**: This method may only be called within the [build] method.
  void watch(VoidCallback watch) {
    assert(_activeCellElement != null);
    _activeCellElement!.getWatcher(watch);
  }

  @override
  StatelessElement createElement() => restorationId != null
      ? _RestorableCellStorageElement(this, restorationId!)
      : _CellStorageElement(this);

  // Private

  /// The element of the [CellWidget] currently being built.
  static _CellStorageElement? _activeCellElement;
}

/// Interface providing methods for defining cells and watch functions that are persisted between builds of a widget.
abstract class CellHookContext extends BuildContext {
  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// The functionality of this method is the same as [CellHooks.cell].
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create);

  /// Register a callback function to be called whenever the values of cells change.
  ///
  /// The functionality of this method is the same as [CellHooks.watch].
  void watch(VoidCallback watch);

  /// Prevent construction
  CellHookContext._internal();
}

/// Widget element for [CellWidget]
/// 
/// Keeps track of the cell instances that were created during the lifetime of
/// the widget.
class _CellStorageElement extends _CellWidgetElement implements CellHookContext {
  _CellStorageElement(super.widget);

  /// List of created cells
  final List<ValueCell> _cells = [];

  /// List of registered cell watchers
  final List<CellWatcher> _watchers = [];

  /// Is this the first build of the widget
  var _isFirstBuild = true;

  /// Index of cell to retrieve/create when calling [getCell]
  var _curCell = 0;

  /// Index of watcher to retrieve/create when calling [getWatcher]
  var _curWatcher = 0;

  /// Retrieve/create the current cell.
  ///
  /// During the first build of the widget, [create] is called to create a new
  /// instance at the current cell index.
  ///
  /// In subsequent builds, [getCell] returns the existing cell instance at the
  /// current cell index.
  ///
  /// The cell index is advanced when calling this method.
  V getCell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    if (_isFirstBuild) {
      late final V cell;

      AutoKey.withAutoKeys((_) => null, () {
        cell = create();
      });

      _cells.add(cell);
      _curCell++;

      return cell;
    }

    assert(
      _curCell < _cells.length,
      'CellWidget.cell() was called more times in this build of the '
        'widget than in the previous build. This usually happens when a call to '
        'cell() is placed inside a conditional or loop.'
    );

    return _cells[_curCell++] as V;
  }

  /// Retrieve/create the current *cell watcher*.
  ///
  /// During the first build of the widget, a new cell watcher is created with
  /// watch function [watch], at the current watcher index.
  ///
  /// In subsequent builds, [getWatcher] returns the existing [CellWatcher]
  /// instance at the current watcher index.
  ///
  /// The watcher index is advanced when calling this method.
  CellWatcher getWatcher(VoidCallback watch) {
    if (_isFirstBuild) {
      final watcher = CellWatcher(watch);
      _watchers.add(watcher);
      _curWatcher++;

      return watcher;
    }

    assert(
      _curWatcher < _watchers.length,
      'CellWidget.watch() was called more times in this build of the '
        'widget than in the previous build. This usually happens when a call to '
        'watch() is placed inside a conditional or loop.'
    );

    return _watchers[_curWatcher++];
  }

  @override
  Widget build() {
    final previousActiveElement = CellHooks._activeCellElement;

    try {
      _curCell = 0;
      _curWatcher = 0;

      CellHooks._activeCellElement = this;
      return super.build();
    }
    finally {
      _isFirstBuild = false;
      CellHooks._activeCellElement = previousActiveElement;
    }
  }

  @override
  void unmount() {
    for (final watcher in _watchers) {
      watcher.stop();
    }

    super.unmount();
  }

  @override
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create) => getCell(create);

  @override
  void watch(VoidCallback watch) => getWatcher(watch);
}

/// A [_CellStorageElement] which restores the state of the cells created within it.
class _RestorableCellStorageElement extends _CellStorageElement {
  final String _restorationId;

  _RestorableCellStorageElement(super.widget, this._restorationId);

  @override
  Widget build() => CellRestorationManager(
      builder: super.build,
      restorationId: _restorationId
    );
}