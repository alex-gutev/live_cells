import 'package:flutter/widgets.dart';

import '../cell_watch/cell_watcher.dart';
import '../value_cell.dart';
import 'restoration.dart';
import '../cell_widget/cell_widget.dart';

/// Provides functionality for creating cells which support state restoration.
///
/// Cells created using the [cell] method are persisted between builds of the
/// widget, see [CellInitializer.cell] for more information. Additionally, the
/// state of these cells is restored during state restoration of the application.
abstract class RestorableCellWidget extends StatelessWidget {
  /// Restoration id used to identify the state of the widget, see [RestorationMixin.restorationId]
  String get restorationId;

  /// Return an instance of a [ValueCell] that is kept between builds of the widget.
  ///
  /// This method has the same functionality as [CellInitializer.cell] with the
  /// addition that the state of the created cells is restored when restoring
  /// the widget state.
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
  /// (the default) the state of the cell is only restored if [RestorableCell]
  /// is true.
  ///
  /// **NOTE**: Only cells holding values encodable by [StandardMessageCodec],
  /// can have their state restored. To restore the state of cells holding other
  /// value types, a [CellValueCoder] subclass has to be implemented for the
  /// value types. To use a [CellValueCoder] subclass, pass the constructor of
  /// the subclass in [coder].
  ///
  /// **NOTE**: This method may only be called within the [build] method.
  V cell<T, V extends ValueCell<T>>(CreateCell<V> create, {
    bool? restorable,
    CellValueCoder Function() coder = CellValueCoder.new
  }) {
    assert(_RestorableCellWidgetState._activeState != null);

    if (restorable ?? true) {
      return _RestorableCellWidgetState._activeState!.getRestorableCell(
          create: create,
          makeCoder: coder,
          forceRestore: restorable ?? false
      );
    }
    else {
      return _RestorableCellWidgetState._activeState!.getCell(create);
    }
  }

  @override
  StatelessElement createElement() => _RestorableCellWidgetElement(
      this,
      restorationId: restorationId
  );
}

/// Element holding a [RestorableCellWidget]
class _RestorableCellWidgetElement extends StatelessElement {
  /// Restoration identifier to user
  final String restorationId;

  _RestorableCellWidgetElement(super.widget, {
    required this.restorationId
  });

  @override
  Widget build() {
    return _RestorableCellWidget(
        builder: super.build,
        restorationId: restorationId
    );
  }
}

/// Widget responsible for restoring the state of the cells
class _RestorableCellWidget extends StatefulWidget {
  /// Child widget builder function
  final Widget Function() builder;

  /// Restoration identifier to use
  final String restorationId;

  const _RestorableCellWidget({
    required this.builder,
    required this.restorationId
  });

  @override
  State<_RestorableCellWidget> createState() => _RestorableCellWidgetState();
}

class _RestorableCellWidgetState extends State<_RestorableCellWidget> with
    CellObserverState, RestorationMixin {
  /// State of the RestorableWidgee currently being built
  static _RestorableCellWidgetState? _activeState = null;

  /// Restorable list holding the cell values
  final _cellValues = _RestorableCellValueList();

  /// List of created cells
  final List<ValueCell> _cells = [];

  /// List of registered cell watchers
  final List<CellWatcher> _watchers = [];

  /// Index of the cell to retrieve/create when calling [getCell]/[getRestorableCell].
  var _curCell = 0;

  /// Index of the value to which to restore the cell returned by [getRestorableCell].
  var _curCellValue = 0;

  /// Retrieve/create the current cell.
  ///
  /// If there is no cell instance at the current cell index, [create] is called
  /// to create a new instance. Calling [getCell] again at the current cell index
  /// returns the existing cell instance.
  ///
  /// The cell index is advanced when calling this method.
  V getCell<T, V extends ValueCell<T>>(CreateCell<V> create) {
    if (_curCell < _cells.length) {
      return _cells[_curCell] as V;
    }

    final cell = create();
    _cells.add(cell);

    _curCell++;

    return cell;
  }

  /// Retrieve/create the current cell, and restore its value.
  ///
  /// Like [getCell] but also restores the value of the cell, if there is a
  /// saved value. If there is no saved cell value, the cell is registered for
  /// restoration.
  ///
  /// If [forceRestore] is true an assertion is violated if the cell returned
  /// by [create] is not a [RestorableCell]. If [forceRestore] is false and
  /// the cell returned by [create] is not a [RestorableCell], its state is
  /// not restored.
  ///
  /// [makeCoder] is a [CellValueCoder] constructor to use when encoding/decoding
  /// the cell's value.
  ///
  /// The cell index is advanced when calling this method.
  V getRestorableCell<T, V extends ValueCell<T>>({
    required CreateCell<V> create,
    required CellValueCoder Function() makeCoder,
    required bool forceRestore,
  }) {
    final isNew = _curCell == _cells.length;
    final cell = getCell(create);
    
    if (isNew) {
      if (!(forceRestore || cell is RestorableCell<T>)) {
        return cell;
      }

      final coder = makeCoder();
      
      if (_curCellValue <= _cellValues.length) {
        final restorableCell = cell as RestorableCell<T>;
        restorableCell.restoreValue(coder.decode(_cellValues[_curCellValue]));
      }
      else {
        final index = _curCellValue;
        
        _watchers.add(ValueCell.watch(() {
          _cellValues[index] = coder.encode(cell());
        }));
      }

      _curCellValue++;
    }

    return cell;
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_cellValues, 'live_cells_cell_values');
  }
  
  @override
  void dispose() {
    for (final watcher in _watchers) {
      watcher.stop();
    }

    _cellValues.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    try {
      _activeState = this;
      _curCell = 0;
      _curCellValue = 0;

      return observe(widget.builder);
    }
    finally {
      _activeState = null;
    }
  }
}

/// A [RestorableProperty] holding a list of encoded cell values.
class _RestorableCellValueList extends RestorableProperty<List>{
  /// List of encoded values
  List _values = [];

  /// Number of cell value in list
  int get length => _values.length;

  /// Retrieve the cell value at [index].
  operator [](int index) => _values[index];

  /// Set the cell value at [index].
  ///
  /// [index] may be equal to [length] in which case a new value is added
  /// to the list.
  ///
  /// [value] must be of a type supported by [StandardMessageCodec].
  operator []=(int index, value) {
    if (index == _values.length) {
      _values.add(value);
    }
    else {
      _values[index] = value;
    }

    notifyListeners();
  }

  @override
  List createDefaultValue() {
    return [];
  }

  @override
  List fromPrimitives(Object? data) {
    return data as List;
  }

  @override
  void initWithValue(List value) {
    _values = value;
  }

  @override
  Object? toPrimitives() {
    return _values;
  }
}