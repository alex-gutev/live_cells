import 'package:live_cells/live_cells.dart';

/// Extends [ValueCell] with numeric operators for cells holding [num] values.
///
/// The methods and operator overloads provided by this extension return
/// [ValueCell]'s which perform the same operation as the corresponding method /
/// operator provided by the [num] interface. The returned [ValueCell]'s are
/// dependent on the method arguments which means their value is recomputed
/// whenever the value of one of the argument cells changes.
extension NumericExtension on ValueCell<num> {
  ValueCell<num> operator + (ValueCell<num> other) =>
      [this, other].computeCell(() => value + other.value);

  ValueCell<num> operator - (ValueCell<num> other) =>
      [this, other].computeCell(() => value - other.value);

  ValueCell<num> operator - () => apply((value) => -value);

  ValueCell<num> operator * (ValueCell<num> other) =>
      [this, other].computeCell(() => value * other.value);

  ValueCell<num> operator / (ValueCell<num> other) =>
      [this, other].computeCell(() => value / other.value);

  ValueCell<num> operator ~/ (ValueCell<num> arg) =>
      [this, arg].computeCell(() => value ~/ arg.value);

  ValueCell<num> operator % (ValueCell<num> other) =>
      [this, other].computeCell(() => value % other.value);

  ValueCell<num> remainder(ValueCell<num> other) =>
      [this, other].computeCell(() => value.remainder(other.value));

  ValueCell<bool> operator < (ValueCell<num> other) =>
      [this, other].computeCell(() => value < other.value);

  ValueCell<bool> operator <= (ValueCell<num> other) =>
      [this, other].computeCell(() => value <= other.value);

  ValueCell<bool> operator > (ValueCell<num> other) =>
      [this, other].computeCell(() => value > other.value);

  ValueCell<bool> operator >= (ValueCell<num> other) =>
      [this, other].computeCell(() => value >= other.value);

  ValueCell<bool> get isNaN => apply((value) => value.isNaN);

  ValueCell<bool> get isFinite => apply((value) => value.isFinite);

  ValueCell<bool> get isInfinite => apply((value) => value.isInfinite);

  ValueCell<num> abs() => apply((value) => value.abs());

  ValueCell<num> get sign => apply((value) => value.sign);
}