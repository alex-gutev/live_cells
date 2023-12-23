part of 'value_cell.dart';

/// A cell with a constant value.
///
/// This class implements the [ValueCell] interface but its listeners
/// are never called since the cell's value does not change.
class ConstantCell<T> extends ValueCell<T> with CellEquality<T> {
  ConstantCell(this._value);

  @override
  T get value => _value;

  @override
  void addListener(VoidCallback listener) {
    // Do nothing since the value of the cell never changes
  }

  @override
  void removeListener(VoidCallback listener) {
    // Do nothing since the value of the cell never changes
  }

  /// Private

  final T _value;
}