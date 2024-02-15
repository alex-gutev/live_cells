import '../base/keys.dart';
import '../compute_cell/store_cell.dart';
import 'compute_extension.dart';
import '../value_cell.dart';

/// Provides [Iterable] properties and methods directly on cells holding [Iterables]s.
extension IterableCellExtension<T> on ValueCell<Iterable<T>> {
  /// Returns a cell which evaluates to [Iterable.first] applied on the [value] in this cell.
  ValueCell<T> get first => apply((value) => value.first,
      willChange: (_, v) => value.first != v.first,
      key: _IterablePropKey(this, #first)
  );

  /// Returns a cell which evaluates to [Iterable.isEmpty] applied on the [value] in this cell.
  ValueCell<bool> get isEmpty => apply((value) => value.isEmpty,
      willChange: (_, v) => value.isEmpty != v.isEmpty,
      key: _IterablePropKey(this, #isEmpty)
  );

  /// Returns a cell which evaluates to [Iterable.isNotEmpty] applied on the [value] in this cell.
  ValueCell<bool> get isNotEmpty => apply((value) => value.isNotEmpty,
      willChange: (_, v) => value.isNotEmpty != v.isNotEmpty,
      key: _IterablePropKey(this, #isNotEmpty)
  );

  /// Returns a cell which evaluates to [Iterable.last] applied on the [value] in this cell.
  ValueCell<T> get last => apply((value) => value.last,
      willChange: (_, v) => value.last != v.last,
      key: _IterablePropKey(this, #last)
  );

  /// Returns a cell which evaluates to [Iterable.length] applied on the [value] in this cell.
  ValueCell<int> get length => apply((value) => value.length,
      willChange: (_, v) => value.length != v.length,
      key: _IterablePropKey(this, #length)
  );

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
}

/// Key identifying a [ValueCell], which accesses an [Iterable] property.
class _IterablePropKey extends ValueKey2<ValueCell, Symbol> {
  /// Create the key.
  ///
  /// [value1] is a [ValueCell] holding an [Iterable] and [value2] is the property
  /// being accessed.
  _IterablePropKey(super.value1, super.value2);
}
