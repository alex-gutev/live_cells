import 'package:live_cells_core/live_cells_core.dart';

extension TransformExtension<T> on ValueCell<T> {
  ValueCell<U> transform<U extends T>() => ValueCell<U>.value(call() as U);
}

extension MutableTransformExtension<T> on MutableCell<T> {
  MutableCell<U> transform<U extends T>() => MutableCell<U>(call() as U);
}
