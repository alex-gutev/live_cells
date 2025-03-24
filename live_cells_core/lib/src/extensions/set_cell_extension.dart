import '../compute_cell/store_cell.dart';
import '../mutable_cell/mutable_cell.dart';
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

/// Provides [MutableCell] variants of the methods provided by [SetCellExtension].
extension MutableSetCellExtension<T> on MutableCell<Set<T>> {
  /// Creates a cell that is true if the value held in [elem] is present in the set held in [this].
  ///
  /// A mutable cell is created. When the value of the cell is set to true,
  /// the value held in [elem] is added to the set in [this]. When the value of the
  /// cell is set to false, the value held in [elem] is removed from the set
  /// held in [this].
  ///
  /// A keyed cell is created.
  MutableCell<bool> contains(ValueCell<T> elem) =>
      (this, elem).mutableApply((set, elem) => set.contains(elem), (bool inSet) {
        final copy = Set<T>.from(value);

        if (inSet) {
          copy.add(elem.value);
        }
        else {
          copy.remove(elem.value);
        }

        value = copy;
      }, key: _MutableSetContainsKey(this, elem));

  MutableCell<bool> containsAll(ValueCell<Iterable> elems) =>
      (this, elems).mutableApply((set, elems) => set.containsAll(elems), (bool inSet) {
        if (inSet) {
          value = value.union(Set.from(elems.value));
        }
        else {
          value = value.difference(Set.from(elems.value));
        }
      }, key: _MutableSetContainsAllKey(this, elems));
}

/// Key identifying a cell which applies the [Set.contains] method.
class _SetContainsKey extends CellKey2<ValueCell, ValueCell> {
  _SetContainsKey(super.value1, super.value2);
}

/// Key identifying a cell which applies the [Set.containsAll] method.
class _SetContainsAllKey extends CellKey2<ValueCell, ValueCell> {
  _SetContainsAllKey(super.value1, super.value2);
}

/// Key identifying cells created by [MutableSetCellExtension.contains].
class _MutableSetContainsKey extends CellKey2<ValueCell, ValueCell> {
  _MutableSetContainsKey(super.value1, super.value2);
}

// Key identifying cells created by [MutableSetCellExtension.containsAll].
class _MutableSetContainsAllKey extends CellKey2<ValueCell, ValueCell> {
  _MutableSetContainsAllKey(super.value1, super.value2);
}