import 'compute_extension.dart';
import '../value_cell.dart';

/// Extends [ValueCell] with numeric operators for cells holding [num] values.
///
/// The methods and operator overloads provided by this extension return
/// [ValueCell]'s which perform the same operation as the corresponding method /
/// operator provided by the [num] interface. The returned [ValueCell]'s are
/// dependent on the method arguments which means their value is recomputed
/// whenever the value of one of the argument cells changes.
extension NumericExtension on ValueCell<num> {
  ValueCell<num> operator + (ValueCell<num> other) =>
      (this, other).apply((a, b) => a + b);

  ValueCell<num> operator - (ValueCell<num> other) =>
      (this, other).apply((a, b) => a - b);

  ValueCell<num> operator - () => apply((value) => -value);

  ValueCell<num> operator * (ValueCell<num> other) =>
      (this, other).apply((a, b) => a * b);

  ValueCell<num> operator / (ValueCell<num> other) =>
      (this, other).apply((a, b) => a / b);

  ValueCell<num> operator ~/ (ValueCell<num> arg) =>
      (this, arg).apply((a, b) => a ~/ b);

  ValueCell<num> operator % (ValueCell<num> other) =>
      (this, other).apply((a, b) => a % b);

  ValueCell<num> remainder(ValueCell<num> other) =>
      (this, other).apply((a, b) => a.remainder(b));

  ValueCell<bool> operator < (ValueCell<num> other) =>
      (this, other).apply((a, b) => a < b);

  ValueCell<bool> operator <= (ValueCell<num> other) =>
      (this, other).apply((a, b) => a <= b);

  ValueCell<bool> operator > (ValueCell<num> other) =>
      (this, other).apply((a, b) => a > b);

  ValueCell<bool> operator >= (ValueCell<num> other) =>
      (this, other).apply((a, b) => a >= b);

  ValueCell<bool> get isNaN => apply((value) => value.isNaN);

  ValueCell<bool> get isFinite => apply((value) => value.isFinite);

  ValueCell<bool> get isInfinite => apply((value) => value.isInfinite);

  ValueCell<num> abs() => apply((value) => value.abs());

  ValueCell<num> get sign => apply((value) => value.sign);
}