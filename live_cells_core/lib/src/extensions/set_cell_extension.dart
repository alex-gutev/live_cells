import '../compute_cell/store_cell.dart';
import 'compute_extension.dart';
import '../base/keys.dart';
import '../value_cell.dart';

/// Provides [Set] methods directly on cells holding [Set]s.
extension SetCellExtension<T> on ValueCell<Set<T>> {
  /// Returns a cell that evaluates to true if the [Set] contains [elem].
  ValueCell<bool> contains(ValueCell elem) => (this, elem).apply((set, elem) => set.contains(elem),
    key: _SetContainsKey(this, elem),
  ).store(changesOnly: true);

  /// Returns a cell that evaluates to true if the [Set] contains [elems].
  ValueCell<bool> containsAll(ValueCell<Iterable> elems) => (this, elems).apply((set, elems) => set.containsAll(elems),
      key: _SetContainsAllKey(this, elems),
  );
}

/// Key identifying a cell which applies the [Set.contains] method.
class _SetContainsKey extends CellKey2<ValueCell, ValueCell> {
  _SetContainsKey(super.value1, super.value2);
}

/// Key identifying a cell which applies the [Set.containsAll] method.
class _SetContainsAllKey extends CellKey2<ValueCell, ValueCell> {
  _SetContainsAllKey(super.value1, super.value2);
}