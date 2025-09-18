import '../../live_cells_core.dart';
import '../cell_watch/cell_watcher.dart';

/// Provides the [watch] extension method
extension WatchCellExtension on List<ValueCell> {
  /// Create a cell watcher that observes the cells in this list.
  ///
  /// Unlike the cell watch functions created with [ValueCell.watch] and [Watch],
  /// this cell watcher does not track the cells that are referenced in the
  /// [callback] function. Instead the argument cells are given in the list,
  /// on which this method is called. Likewise, the values of the argument
  /// cells should be referenced with [ValueCell.value] within [callback]
  /// rather than the function call syntax.callback
  ///
  /// The watch function is identified by [key] if it is not null.
  CellWatcher watch(WatchCallback callback, {key}) =>
      StaticCellWatcher(this, key: key)..init(callback);
}