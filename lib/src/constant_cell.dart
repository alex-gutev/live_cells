part of 'value_cell.dart';

/// A cell with a constant value.
///
/// This class implements the [ValueCell] interface but its observers
/// are never called since the cell's value does not change.
///
/// [ConstantCell]'s compare [==] if their [value]'s are [==].
class ConstantCell<T> extends ValueCell<T> {
  const ConstantCell(this._value);

  @override
  T get value => _value;

  @override
  void addObserver(CellObserver observer) {
    // Do nothing since the value of the cell never changes
  }

  @override
  bool removeObserver(CellObserver observer) => false;

  @override
  bool operator ==(other) => other is ConstantCell && value == other.value;

  @override
  int get hashCode => _value.hashCode;

  // Private

  final T _value;
}