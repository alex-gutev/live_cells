import 'package:collection/collection.dart';

import '../base/keys.dart';
import '../compute_cell/store_cell.dart';
import 'compute_extension.dart';
import '../value_cell.dart';

/// Provides [Iterable] properties and methods directly on cells holding [Iterables]s.
extension IterableCellExtension<T> on ValueCell<Iterable<T>> {
  /// Returns a cell which evaluates to [Iterable.first] applied on the [value] in this cell.
  ValueCell<T> get first => apply((value) => value.first,
      key: _IterablePropKey(this, #first)
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to [Iterable.isEmpty] applied on the [value] in this cell.
  ValueCell<bool> get isEmpty => apply((value) => value.isEmpty,
      key: _IterablePropKey(this, #isEmpty)
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to [Iterable.isNotEmpty] applied on the [value] in this cell.
  ValueCell<bool> get isNotEmpty => apply((value) => value.isNotEmpty,
      key: _IterablePropKey(this, #isNotEmpty)
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to [Iterable.last] applied on the [value] in this cell.
  ValueCell<T> get last => apply((value) => value.last,
      key: _IterablePropKey(this, #last)
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to [Iterable.length] applied on the [value] in this cell.
  ValueCell<int> get length => apply((value) => value.length,
      key: _IterablePropKey(this, #length)
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to [Iterable.single] applied on the [value] in this cell.
  ValueCell<T> get single => apply((value) => value.single,
      key: _IterablePropKey(this, #single)
  );

  /// Returns a cell which evaluates to [Iterable.toList] applied on the [value] in this cell.
  ValueCell<List<T>> toList() => apply((value) => value.toList(),
      key: _IterablePropKey(this, #toList)
  ).store();

  /// Returns a cell which evaluates to [Iterable.toSet] applied on the [value] in this cell.
  ValueCell<Set<T>> toSet() => apply((value) => value.toSet(),
      key: _IterablePropKey(this, #toSet)
  ).store();

  /// Returns a cell which evaluates to [Iterable.cast<R>()] applied on the value in this cell.
  ValueCell<Iterable<R>> cast<R>() => apply((value) => value.cast<R>(),
      key: _IterableTypedPropKey<R>(this, #cast)
  ).store();

  /// Returns a cell which evaluates to [Iterable.map] applied on the value in this cell.
  ValueCell<Iterable<E>> map<E>(E Function(T e) convert) =>
      apply((value) => value.map(convert),
        key: _IterablePropKey(this, (#map, convert))
      ).store();

  /// Returns a cell which evaluates to [Iterable.mapIndexed] applied on the value in this cell.
  ///
  /// The [convert] function is called with the index and element of each item in the list.
  /// The returned cell is recomputed whenever the value of this cell changes.
  ValueCell<Iterable<E>> mapIndexed<E>(E Function(int i, T e) convert) =>
      apply((value) => value.mapIndexed(convert),
        key: _IterablePropKey(this, (#mapIndexed, convert))
      ).store();
}

/// Key identifying a [ValueCell], which accesses an [Iterable] property.
class _IterablePropKey extends CellKey2<ValueCell, Object> {
  /// Create the key.
  ///
  /// [value1] is a [ValueCell] holding an [Iterable] and [value2] is the property
  /// being accessed.
  _IterablePropKey(super.value1, super.value2);
}

/// Key identifying a [ValueCell], which access an [Iterable] property with a type parameter.
class _IterableTypedPropKey<T> extends CellKey2<ValueCell, Symbol> {
  _IterableTypedPropKey(super.value1, super.value2);
}