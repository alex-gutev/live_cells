import 'dart:collection';

import 'package:live_cells_core/live_cells_core.dart';

import 'restorable_cell_state_list.dart';

/// Observes restorable cells for changes in their values.
///
/// Whenever the value of an observed cell changes, its state is saved in a
/// [RestorableCellStateList].
class CellRestorationObserver implements CellObserver {
  /// The restorable list into which to save the cell states.
  final RestorableCellStateList _values;

  /// Maps cells to the indices, within [_values] at which to save their state.
  final Map<RestorableCell, int> _indices = HashMap();

  /// Maps cells to the [CellValueCoder] objects to use for encoding their values.
  final Map<RestorableCell, CellValueCoder> _coders = HashMap();

  /// Set of cells updated during the current update cycle
  final Set<RestorableCell> _updatedCells = HashSet();

  /// Is an update cycle ongoing?
  var _isUpdating = false;

  CellRestorationObserver(this._values);

  /// Stop observing the cells for changes.
  ///
  /// **NOTE**: This method must be called otherwise resources will be leaked.
  void dispose() {
    for (final cell in _indices.keys) {
      cell.removeObserver(this);
    }
  }

  /// Start observing [cell] for changes and save its state at [index] within [_values].
  ///
  /// [coder] is the [CellValueCoder] used for encoding the cell's value.
  void addCell({
    required RestorableCell cell,
    required int index,
    required CellValueCoder coder
  }) {
    if (!_indices.containsKey(cell)) {
      _indices[cell] = index;
      _coders[cell] = coder;

      cell.addObserver(this);
    }
  }

  @override
  bool get shouldNotifyAlways => true;

  @override
  void update(covariant RestorableCell<dynamic> cell, bool didChange) {
    if (_isUpdating) {
      for (final cell in _updatedCells) {
        final index = _indices[cell]!;
        final coder = _coders[cell]!;

        _values[index] = cell.dumpState(coder);
      }

      _isUpdating = false;
      _updatedCells.clear();

      _values.notifyChanged();
    }
  }

  @override
  void willUpdate(ValueCell<dynamic> cell) {
    _isUpdating = true;
    _updatedCells.add(cell as RestorableCell);
  }
}
