import '../value_cell.dart';
import 'cell_observer.dart';

/// A stateless cell which evaluates to [ValueCell.none()].
///
/// The purpose of the type argument [T] is to allow this cel to be used where
/// a [ValueCell] with a specific type is expected. Otherwise the type argument
/// has no effect on its functionality, since it never returns a value.
class NoneCell<T> extends ValueCell<T> {
  const NoneCell();

  @override
  void addObserver(CellObserver observer) {}

  @override
  void removeObserver(CellObserver observer) {}

  @override
  T get value => ValueCell.none();

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}