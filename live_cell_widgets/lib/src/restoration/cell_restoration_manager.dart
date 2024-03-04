import 'package:flutter/widgets.dart';
import 'package:live_cells_core/live_cells_core.dart';

import 'restorable_cell_state_list.dart';
import 'cell_restoration_observer.dart';

/// Widget responsible for restoring the state of the cells
class CellRestorationManager extends StatefulWidget {
  /// Child widget builder function
  final Widget Function() builder;

  /// Restoration identifier to use
  final String restorationId;

  const CellRestorationManager({
    super.key,
    required this.builder,
    required this.restorationId
  });

  @override
  State<CellRestorationManager> createState() => CellRestorationManagerState();
}

class CellRestorationManagerState extends State<CellRestorationManager> with 
    RestorationMixin {
  /// State of the RestorableWidget currently being built
  static CellRestorationManagerState? _activeState;

  /// Restorable list holding the saved cell states
  final _cellStates = RestorableCellStateList();

  /// Index of the saved state to use when restoring the cell in [getRestorableCell].
  var _curCellState = 0;

  /// If true the widget hasn't been built for the first time yet.
  var _firstBuild = true;

  /// Observes the restorable cells for changes in their values
  late final _observer = CellRestorationObserver(_cellStates);

  /// Is there a [CellRestorationManagerState] in effect?
  static bool get isActive => _activeState != null;

  /// Get the current [CellRestorationManagerState].
  ///
  /// An assertion is violated if there is no active
  /// [CellRestorationManagerState].
  static CellRestorationManagerState get activeState {
    assert(
      _activeState != null,
      'No active CellRestorationManager. This happens when CellWidget.cell() / '
          'BuildContext.cell() or ValueCell.restore() was called outside of the '
          'build method of a widget that provides cell state restoration. This '
          "can happen either if you haven't specified a non-null `restorationId`, "
          'or you called the method inside a nested widget builder function, such '
          'as those used with Builder and ValueListenablBuilder.'
    );

    return _activeState!;
  }

  /// Register [cell] for restoration and restore its state.
  void registerCell({
    required RestorableCell cell,
    required CellValueCoder coder
  }) {
    if (!_firstBuild) {
      return;
    }

    var isSaved = _curCellState < _cellStates.length;

    if (!isSaved) {
      _cellStates.add(cell.dumpState(coder));
    }

    final index = _curCellState;

    _observer.addCell(
        cell: cell,
        index: index,
        coder: coder
    );

    _curCellState++;

    /// Restoration needs to happen after the cell is observed
    /// since some cells are not fully functional until they
    /// have at least one observer,

    if (isSaved) {
      cell.restoreState(_cellStates[index], coder);
    }
  }

  @override
  String? get restorationId => widget.restorationId;


  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_cellStates, 'live_cells_cell_values');
  }

  @override
  void dispose() {
    _observer.dispose();
    _cellStates.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previousActiveState = _activeState;

    try {
      _activeState = this;
      _curCellState = 0;

      return widget.builder();
    }
    finally {
      _firstBuild = false;
      _activeState = previousActiveState;
    }
  }
}