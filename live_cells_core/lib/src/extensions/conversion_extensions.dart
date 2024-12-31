import 'package:intl/intl.dart';

import '../base/exceptions.dart';
import '../base/keys.dart';
import '../compute_cell/compute_cell.dart';
import 'compute_extension.dart';
import '../compute_cell/mutable_compute_cell.dart';
import '../compute_cell/store_cell.dart';
import '../value_cell.dart';
import '../maybe_cell/maybe.dart';
import '../mutable_cell/mutable_cell.dart';

/// Adds the [cell] property for creating a constant cell.
extension ValueCellExtension<T> on T {
  /// Create a constant cell with value equal to [this].
  ValueCell<T> get cell => ValueCell.value(this);

  /// Create a [MutableCell] with value initialized to [this].
  ///
  /// **Note**: the cell is created with the "reset" parameter set to true.
  MutableCell<T> get mutableCell => MutableCell(this, reset: true);
}

/// Provides methods for converting an integer to a string and vice versa.
extension ParseIntExtension on MutableCell<int> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, an integer is parsed from the assigned string
  /// value and is assigned to this cell's value.
  ///
  /// [errorValue] is the value to assign to [this] cell when there is an
  /// error parsing an integer from the string.
  ///
  /// [format] is of type [NumberFormat] and is used to format the string
  /// representation of the [num] value.
  ///
  /// **Note** [errorValue] is a [ValueCell]'s to allow the default value to be
  /// chosen dynamically. If a constant is required use the
  /// [NumValueCellExtension.cell] property e.g. `10.cell`.
  ///
  /// **Pitfalls**:
  ///
  /// A binding is not established between [errorValue] and [this] cell. This
  /// means that [this] cell will not react to changes in [errorValue]. Only
  /// the values at the time of assigning a value to the returned cell are used.
  MutableCell<String> mutableString({
    ValueCell<int> errorValue = const ValueCell.value(0),
    NumberFormat? format,
  }) =>
      MutableComputeCell(
          arguments: {this},
          compute: () => format?.format(value) ?? value.toString(),
          reverseCompute: (value) {
            this.value = format?.tryParse(value)?.toInt() ??
                int.tryParse(value) ??
                errorValue.value;
          });
}

/// Provides methods for converting a double to a string and vice versa.
extension ParseDoubleExtension on MutableCell<double> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, a double is parsed from the assigned string
  /// value and is assigned to this cell's value.
  ///
  /// [errorValue] is the value to assign to [this] cell when there is an
  /// error parsing a a double from the string.
  ///
  /// [format] is of type [NumberFormat] and is used to format the string
  /// representation of the [num] value.
  ///
  /// **Note** [errorValue] is a [ValueCell] to allow the default value
  /// to be chosen dynamically. If a constant is required use
  /// the [NumValueCellExtension.cell] property e.g. `1.0.cell`.
  ///
  /// **Pitfalls**:
  ///
  /// A binding is not established between [errorValue] and [this] cell.
  /// This means that [this] cell will not react to changes in [errorValue].
  /// Only the value at the time of assigning a value to the returned
  /// cell are used.
  MutableCell<String> mutableString({
    ValueCell<double> errorValue = const ValueCell.value(0.0),
    NumberFormat? format,
  }) =>
      MutableComputeCell(
        arguments: {this},
        compute: () => format?.format(value) ?? value.toString(),
        reverseCompute: (value) {
          this.value = format?.tryParse(value)?.toDouble() ??
              double.tryParse(value) ??
              errorValue.value;
        },
      );
}

/// Provides methods for converting a num to a string and vice versa.
extension ParseNumExtension on MutableCell<num> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, a [num] is parsed from the assigned string
  /// value and is assigned to this cell's value.
  ///
  /// [errorValue] is the value to assign to [this] cell when there is an
  /// error parsing a [num] from the string.
  ///
  /// [format] is of type [NumberFormat] and is used to format the string
  /// representation of the [num] value.
  ///
  /// **Note** [errorValue] is a [ValueCell] to allow the default value
  /// to be chosen dynamically. If a constant is required use
  /// the [NumValueCellExtension.cell] property e.g. `1.0.cell`.
  ///
  /// **Pitfalls**:
  ///
  /// A binding is not established between [errorValue] and [this] cell.
  /// This means that [this] cell will not react to changes in [errorValue].
  /// Only the value at the time of assigning a value to the returned
  /// cell are used.
  MutableCell<String> mutableString({
    ValueCell<num> errorValue = const ValueCell.value(0),
    NumberFormat? format,
  }) =>
      MutableComputeCell(
          arguments: {this},
          compute: () => format?.format(value) ?? value.toString(),
          reverseCompute: (value) {
            this.value = format?.tryParse(value) ??
                num.tryParse(value) ??
                errorValue.value;
          });
}

/// Provides the [mutableString] method for String cells
extension ConvertStringExtension on MutableCell<String> {
  /// Simply returns this cell
  MutableCell<String> mutableString() => this;
}

/// Provides methods for converting an integer to a string and vice versa with error handling.
extension ParseMaybeIntExtension on MaybeCell<int> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, an integer is parsed from the assigned string
  /// value, wrapped in a [Maybe], which is assigned to this cell's value.
  ///
  /// If an exception is thrown during parsing, a [Maybe] holding the exception
  /// is assigned to this cell's value.
  MutableCell<String> mutableString({NumberFormat? format}) =>
      MutableComputeCell(
          arguments: {this},
          compute: () =>
              format?.format(value.unwrap) ?? value.unwrap.toString(),
          reverseCompute: (value) {
            this.value = Maybe.wrap(
                () => format?.parse(value).toInt() ?? int.parse(value));
          });
}

/// Provides methods for converting a double to a string and vice versa with error handling.
extension ParseMaybeDoubleExtension on MaybeCell<double> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, a double is parsed from the assigned string
  /// value, wrapped in a [Maybe], which is assigned to this cell's value.
  ///
  /// If an exception is thrown during parsing, a [Maybe] holding the exception
  /// is assigned to this cell's value.
  MutableCell<String> mutableString({NumberFormat? format}) =>
      MutableComputeCell(
          arguments: {this},
          compute: () =>
              format?.format(value.unwrap) ?? value.unwrap.toString(),
          reverseCompute: (value) {
            this.value = Maybe.wrap(() =>
                format?.parse(value).toDouble() ?? double.parse(value));
          });
}

/// Provides methods for converting a [num] to a string and vice versa with error handling.
extension ParseMaybeNumExtension on MaybeCell<num> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, a [num] is parsed from the assigned string
  /// value, wrapped in a [Maybe], which is assigned to this cell's value.
  ///
  /// If an exception is thrown during parsing, a [Maybe] holding the exception
  /// is assigned to this cell's value.
  MutableCell<String> mutableString({NumberFormat? format}) =>
      MutableComputeCell(
          arguments: {this},
          compute: () =>
              format?.format(value.unwrap) ?? value.unwrap.toString(),
          reverseCompute: (value) {
            this.value =
                Maybe.wrap(() => format?.parse(value) ?? num.parse(value));
          });
}

/// Provides methods that check for and handle null values.
extension NullCheckExtension<T> on ValueCell<T?> {
  /// A cell that is guaranteed to hold a non-null value.
  ///
  /// If the value of [this] cell is null, accessing the value of the [notNull]
  /// cell results in a [NullCellError] exception being thrown.
  ValueCell<T> get notNull => apply((value) => value ?? (throw NullCellError()),
      key: _NullCheckExtensionKey(this));

  /// Replace null values in this cell with value of another cell.
  ///
  /// The value of the returned cell is the value of this cell if it is not null.
  /// If the value of this cell is null, the value of the returned cell is the
  /// value of the [ifNull] cell.
  ValueCell<T> coalesce(ValueCell<T> ifNull) => ComputeCell(
      arguments: {this, ifNull},
      key: _NullCheckCoalesceKey(this, ifNull),
      compute: () => value ?? ifNull.value).store(changesOnly: true);
}

/// Provides methods that check for null values.
extension MutableNullCheckExtension<T> on MutableCell<T?> {
  /// MutableCell version of [NullCheckExtension.notNull].
  MutableCell<T> get notNull =>
      (this as ValueCell<T?>).notNull.mutableApply((p0) => p0, (p0) {
        value = p0;
      }, key: _MutableNullCheckExtensionKey(this));

  /// Mutable version of [NullCheckExtension.coalesce].
  ///
  /// Setting the value of the returned cell sets the value of [this] cell.
  MutableCell<T> coalesce(ValueCell<T> ifNull) =>
      (this as ValueCell<T?>).coalesce(ifNull).mutableApply((p0) => p0, (p0) {
        value = p0;
      }, key: _MutableNullCheckCoalesceKey(this, ifNull));
}

/// Key identifying a cell created with [NullCheckExtension.notNull].
class _NullCheckExtensionKey<T> extends CellKey1<ValueCell<T?>> {
  _NullCheckExtensionKey(super.value1);
}

/// Key identifying a cell created with [MutableNullCheckExtension.notNull].
class _MutableNullCheckExtensionKey<T> extends CellKey1<MutableCell<T>> {
  _MutableNullCheckExtensionKey(super.value);
}

/// Key identifying a cell created with [NullCheckExtension.coalesce].
class _NullCheckCoalesceKey<T> extends CellKey2<ValueCell<T?>, ValueCell<T>> {
  _NullCheckCoalesceKey(super.value1, super.value2);
}

/// Key identifying a cell created with [MutableNullCheckExtension.coalesce].
class _MutableNullCheckCoalesceKey<T>
    extends CellKey2<MutableCell<T?>, ValueCell<T>> {
  _MutableNullCheckCoalesceKey(super.value1, super.value2);
}
