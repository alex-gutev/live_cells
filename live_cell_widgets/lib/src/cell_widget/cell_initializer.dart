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
  ///
  /// If this CellWidget has a non-null [restorationId] the state of the cell is
  /// also saved and restored when restoring the widget state.
  ///
  /// For state restoration to happen the following conditions need to be met:
  ///
  /// 1. The widget must be within a route which is restorable, see
  ///    [Navigator.restorablePush].
  /// 2. The cell returned by [create] must be a [RestorableCell].
  ///
  /// If [restorable] is false, the state of the returned cell is not restored.
  /// If [restorable] is true, an assertion is violated if the cell returned
  /// by [create] is not a [RestorableCell]. Otherwise if [restorable] is null
  /// (the default) the state of the cell is only restored if the cell
  /// is a [RestorableCell].
  ///
  /// **NOTE**: Only cells holding values encodable by [StandardMessageCodec],
  /// can have their state restored. To restore the state of cells holding other
  /// value types, a [CellValueCoder] subclass has to be implemented for the
  /// value types. To use a [CellValueCoder] subclass, provide the constructor of
  /// the subclass in [coder].
  ///
  /// **NOTE**: This method may only be called within the [build] method.
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create, {
    bool? restorable,
    CellValueCoder Function()? coder
  }) {
    assert(_activeCellElement != null);

    final cell = _activeCellElement!.getCell(
        create,
        forceRestore: restorable ?? false,
        makeCoder: coder
    );

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

/// Provides the [cell] method for creating and retrieving instances of [ValueCell]'s.
extension CellWidgetContextExtension on BuildContext {
  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// The functionality of this method is the same as [CellInitializer.cell].
  ///
  /// **NOTE**: This method may only be called if [this] is the [BuildContext]
  /// of a [CellWidget] with the [CellInitializer] mixin.
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create, {
    bool? restorable,
    CellValueCoder Function()? coder
  }) {
    final element = this as _CellStorageElement;

    return element.getCell(create,
      forceRestore: restorable ?? false,
      makeCoder: coder
    );
  }

  /// Register a callback function to be called whenever the values of cells change.
  ///
  /// The functionality of this method is the same as [CellInitializer.watch].
  ///
  /// **NOTE**: This method may only be called if [this] is the [BuildContext]
  /// of a [CellWidget] with the [CellInitializer] mixin.
  void watch(VoidCallback watch) {
    final element = this as _CellStorageElement;
    element.getWatcher(watch);
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
  V getCell<T, V extends ValueCell<T>>(CreateCell<V> create, {
    required bool forceRestore,
    required CellValueCoder Function()? makeCoder
  }) {
    assert(
      !forceRestore,
      'No active CellRestorationManager. This happens when CellWidget.cell(), '
          'or BuildContext.cell() was called with `restorable: true` but the '
          "CellWidget doesn't have a restorationId associated with it. Either "
          'provide a non-null restorationId in the constructor or remove '
          '`restorable: true`.'
    );

    if (_isFirstBuild) {
      final cell = create();
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
    final previousActiveElement = CellInitializer._activeCellElement;

    try {
      _curCell = 0;
      _curWatcher = 0;

      CellInitializer._activeCellElement = this;
      return super.build();
    }
    finally {
      _isFirstBuild = false;
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

/// A [_CellStorageElement] which restores the state of the cells created within it.
class _RestorableCellStorageElement extends _CellStorageElement {
  /// Restoration ID
  final String _restorationId;

  _RestorableCellStorageElement(super.widget, this._restorationId);

  /// Retrieve/create the current cell and restore its state.
  ///
  /// If [forceRestore] is true an assertion is violated if the cell returned
  /// by [create] is not a [RestorableCell]. If [forceRestore] is false and
  /// the cell returned by [create] is not a [RestorableCell], its state is
  /// not restored.
  ///
  /// [makeCoder] is a [CellValueCoder] constructor to use when encoding/decoding
  /// the cell's value.
  @override
  V getCell<T, V extends ValueCell<T>>(CreateCell<V> create, {
    required bool forceRestore,
    required CellValueCoder Function()? makeCoder
  }) {
    final cell = super.getCell(create,
        forceRestore: false,
        makeCoder: null
    );

    if (_isFirstBuild) {
      assert(
        !forceRestore || cell is RestorableCell<T>,
        'RestorableCellWidget.cell(): cell returned by creation function is not '
          'a RestorableCell. You are seeing this error because you\'ve created a '
          'cell with cell(..., restore: true) which is not a RestorableCell. To '
          'fix this either return a RestorableCell from the creation function or '
          'call cell() without the restore argument.'
      );

      if (cell is! RestorableCell<T>) {
        return cell;
      }

      final coder = makeCoder?.call() ?? const CellValueCoder();

      CellRestorationManagerState.activeState.registerCell(
          cell: cell,
          coder: coder
      );
    }

    return cell;
  }

  @override
  Widget build() => CellRestorationManager(
      builder: super.build,
      restorationId: _restorationId
    );
}