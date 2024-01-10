import '../value_cell.dart';
import 'compute_extension.dart';
import '../mutable_cell/mutable_cell.dart';

/// Provides methods for converting an integer to a string and vice versa.
extension ParseIntExtension on MutableCell<int> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, an integer is parsed from the assigned string
  /// value and is assigned to this cell's value.
  ///
  /// If [error] is given, any exception thrown while parsing an integer
  /// from the value assigned to the returned cell, is assigned to the cell
  /// [error]. If there are no errors `null` is assigned.
  ///
  /// [errorValue] is the value to assign to [this] cell when there is an
  /// error parsing an integer. If this is `null`, no value is assigned to [this]
  /// in the case of errors.
  ///
  /// If [radix] is given the integer is parsed using the given radix.
  ///
  /// **Note** [radix] and [errorValue] are [ValueCell]'s to allow the radix
  /// and default value to be chosen dynamically. If a constant is required use
  /// the [NumValueCellExtension.cell] property e.g. `10.cell`.
  ///
  /// **Pitfalls**:
  /// 
  /// A binding is not established between [errorValue], [radix] and [this] 
  /// cell. This means that [this] cell will not react to changes in [errorValue]
  /// or [radix]. Only the values at the time of assigning a value to the returned
  /// cell are used.
  MutableCell<String> mutableString({
    MutableCell? error,
    ValueCell<int>? errorValue = const ValueCell.value(0),
    ValueCell<int>? radix,
  }) => [this].mutableComputeCell(() => value.toString(), (value) {
    try {
      this.value = int.parse(value, radix: radix?.value);
      error?.value = null;
    }
    catch (e) {
      error?.value = e;

      if (errorValue != null) {
        this.value = errorValue.value;
      }
    }
  });
}

/// Provides methods for converting a double to a string and vice versa.
extension ParseDoubleExtension on MutableCell<double> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, an integer is parsed from the assigned string
  /// value and is assigned to this cell's value.
  ///
  /// If [error] is given, any exception thrown while parsing an integer
  /// from the value assigned to the returned cell, is assigned to the cell
  /// [error]. If there are no errors `null` is assigned.
  ///
  /// [errorValue] is the value to assign to [this] cell when there is an
  /// error parsing an integer. If this is `null`, no value is assigned to [this]
  /// in the case of errors.
  ///
  /// **Note** [errorValue] is a [ValueCell] to allow the default value
  /// to be chosen dynamically. If a constant is required use
  /// the [NumValueCellExtension.cell] property e.g. `1.0.cell`.
  ///
  /// **Pitfalls**:
  ///
  /// A binding is not established between [errorValue] and [this] cell.
  /// This means that [this] cell will not react to changes in [errorValue].
  /// Only the values at the time of assigning a value to the returned
  /// cell are used.
  MutableCell<String> mutableString({
    MutableCell? error,
    ValueCell<double>? errorValue = const ValueCell.value(0.0),
  }) => [this].mutableComputeCell(() => value.toString(), (value) {
    try {
      this.value = double.parse(value);
      error?.value = null;
    }
    catch (e) {
      error?.value = e;

      if (errorValue != null) {
        this.value = errorValue.value;
      }
    }
  });
}

/// Provides methods for converting a num to a string and vice versa.
extension ParseNumExtension on MutableCell<num> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, a [num] is parsed from the assigned string
  /// value and is assigned to this cell's value.
  ///
  /// If [error] is given, any exception thrown while parsing an integer
  /// from the value assigned to the returned cell, is assigned to the cell
  /// [error]. If there are no errors `null` is assigned.
  ///
  /// [errorValue] is the value to assign to [this] cell when there is an
  /// error parsing an integer. If this is `null`, no value is assigned to [this]
  /// in the case of errors.
  ///
  /// **Note** [errorValue] is a [ValueCell] to allow the default value
  /// to be chosen dynamically. If a constant is required use
  /// the [NumValueCellExtension.cell] property e.g. `1.0.cell`.
  ///
  /// **Pitfalls**:
  ///
  /// A binding is not established between [errorValue] and [this] cell.
  /// This means that [this] cell will not react to changes in [errorValue].
  /// Only the values at the time of assigning a value to the returned
  /// cell are used.
  MutableCell<String> mutableString({
    MutableCell? error,
    ValueCell<num>? errorValue = const ValueCell.value(0),
  }) => [this].mutableComputeCell(() => value.toString(), (value) {
    try {
      this.value = num.parse(value);
      error?.value = null;
    }
    catch (e) {
      error?.value = e;

      if (errorValue != null) {
        this.value = errorValue.value;
      }
    }
  });
}

/// Provides the [mutableString] method for String cells
extension ConvertStringExtension on MutableCell<String> {
  /// Simply returns this cell
  MutableCell<String> mutableString() => this;
}