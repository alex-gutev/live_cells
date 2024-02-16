import 'package:collection/collection.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/src/base/keys.dart';

/// Provides [Map] methods directly on cells holding [Maps]s.
extension MapCellExtension<K,V> on ValueCell<Map<K,V>> {
  /// Returns a cell which evaluates to [Map.entries] applied on the [value] in this cell.
  ValueCell<Iterable<MapEntry<K,V>>> get entries => apply((map) => map.entries,
    key: _MapPropKey(this, #entries)
  );

  /// Returns a cell which evaluates to [Map.keys] applied on the [value] in this cell.
  ValueCell<Iterable<K>> get keys => apply((map) => map.keys,
    key: _MapPropKey(this, #keys)
  );

  /// Returns a cell which evaluates to [Map.values] applied on the [value] in this cell.
  ValueCell<Iterable<V>> get values => apply((map) => map.values,
      key: _MapPropKey(this, #values)
  );

  /// Returns a cell which evaluates to the value of the entry with key [key].
  ValueCell<V?> operator[] (ValueCell key) => (this, key).apply((m, k) => m[k],
    key: _MapMethodKey(this, #indexOperator, key),
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to true if the [Map] held in this cell contains the key [key].
  ValueCell<bool> containsKey(ValueCell key) => (this, key).apply((map, k) => map.containsKey(k),
      key: _MapMethodKey(this, #containsKey, key),
  ).store(changesOnly: true);

  /// Returns a cell which evaluates to true if the [Map] held in this cell contains the value [val].
  ValueCell<bool> containsValue(ValueCell val) => (this, val).apply((map, v) => map.containsValue(v),
      key: _MapMethodKey(this, #containsValue, val),
  ).store(changesOnly: true);
}

/// Provides variants which return [MutableCell] of the methods provided by [MapCellExtension].
extension MutableMapCellExtension<K,V> on MutableCell<Map<K,V>> {
  /// Returns a cell which evaluates to the value of the entry with key [key].
  ///
  /// Changing the value of the returned cell, changes the value of the entry
  /// with key [key] in the [Map] held in this cell.
  ///
  /// **NOTE**: The actual map is not modified but a new map is created.
  MutableCell<V?> operator [](ValueCell key) => (this, key).mutableApply((m, k) => m[k],
      (v) => value = _updatedMap(value, key.value, v as V),
      key: _MutableMapMethodKey(this, #indexOperator, key),
      changesOnly: true
  );

  /// Set the value of entry with key [k] to [v] in the [Map] held in this cell.
  ///
  /// **NOTE**: The actual map is not modified but a map list is created.
  void operator []=(K k, V v) => value = _updatedMap(value, k, v);
}

/// Key identifying a cell which accesses a [Map] property
class _MapPropKey extends ValueKey2<ValueCell, Symbol> {
  /// [value1] is the map cell and [value2] is the property identifier
  _MapPropKey(super.value1, super.value2);
}

/// Key identifying a cell which calls a [Map] method
class _MapMethodKey extends ValueKey3<ValueCell, Symbol, ValueCell> {
  /// [value1] is the map cell and [value2] is the method identifier
  _MapMethodKey(super.value1, super.value2, super.value3);
}

/// Key identifying a mutable cell which calls a [Map] method
class _MutableMapMethodKey extends ValueKey3<ValueCell, Symbol, ValueCell> {
  /// [value1] is the map cell and [value2] is the method identifier
  _MutableMapMethodKey(super.value1, super.value2, super.value3);
}

/// Return a copy of [map] with entry [key] set to [value].
///
/// This is not the most efficient way of doing this. Eventually the underlying
/// hash map should be replaced by a different data structure.
Map<K,V> _updatedMap<K,V>(Map<K,V> map, K key, V value) {
  final newMap = Map.fromEntries(map.entries);

  newMap[key] = value;
  return UnmodifiableMapView(newMap);
}