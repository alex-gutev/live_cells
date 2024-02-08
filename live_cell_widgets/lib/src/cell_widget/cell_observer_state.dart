part of 'cell_widget.dart';

/// Provides functionality for rebuilding the widget in response to changes in the values of cells.
mixin CellObserverState<W extends StatefulWidget> on State<W> {
  /// Rebuilds the widget whenever the values of the cells referenced in [build] change.
  ///
  /// The function [build] is called and the value returned by it is returned
  /// from this method. [build] may reference the values of [ValueCell]'s using
  /// [ValueCell.call]. Further changes to the values of the referenced cells
  /// trigger a rebuild of the [widget] corresponding to this [State], as if
  /// by [setState].
  Widget observe(Widget Function() build) {
    return ComputeArgumentsTracker.computeWithTracker(build, (cell) {
      if (!_arguments.contains(cell)) {
        _arguments.add(cell);
        cell.addObserver(_observer);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _observer = _WidgetCellObserver(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final cell in _arguments) {
      cell.removeObserver(_observer);
    }

    super.dispose();
  }

  // Private

  /// Cells referenced within this state
  final Set<ValueCell> _arguments = HashSet();

  /// Observer object of referenced cells
  late _WidgetCellObserver _observer;
}