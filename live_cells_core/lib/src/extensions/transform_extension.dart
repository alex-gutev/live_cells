import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';

/// Extension to transform a single [ValueCell] of type [T] into a [ValueCell] of type [U].
/// [U] must be  a subtype of [T]
extension TransformExtension<T> on ValueCell<T> {
  ValueCell<U> transform<U extends T>() => apply((value) => value as U,
          key: _TransformTypedPropKey<U>(this, #transform))
      .store();
}

/// Extension to transform a single [MutableCell] of type [T] into a [MutableCell] of type [U].
/// [U] must be  a subtype of [T]
extension MutableTransformExtension<T> on MutableCell<T> {
  MutableCell<U> transform<U extends T>() =>
      mutableApply((value) => value as U, (v) => value = v as T,
          key: _TransformTypedPropKey<U>(this, #transform));
}

/// Key identifying a [ValueCell], which access a [List] property with a type parameter.
class _TransformTypedPropKey<T> extends CellKey2<ValueCell, Symbol> {
  _TransformTypedPropKey(super.value1, super.value2);
}
