import '../compute_cell/mutable_compute_cell.dart';
import '../value_cell.dart';
import '../maybe_cell/maybe.dart';
import '../mutable_cell/mutable_cell.dart';

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
  }) => MutableComputeCell(
      arguments: {this},
      compute: () => value.toString(),
      reverseCompute: (value) {
        this.value = int.tryParse(value) ?? errorValue.value;
      }
  );
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
  }) => MutableComputeCell(
      arguments: {this},
      compute: () => value.toString(),
      reverseCompute: (value) {
        this.value = double.tryParse(value) ?? errorValue.value;
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
  }) => MutableComputeCell(
      arguments: {this},
      compute: () => value.toString(),
      reverseCompute: (value) {
        this.value = num.tryParse(value) ?? errorValue.value;
      }
  );
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
  MutableCell<String> mutableString() =>
      MutableComputeCell(
          arguments: {this},
          compute: () => value.unwrap.toString(),
          reverseCompute: (value) {
            this.value = Maybe.wrap(() => int.parse(value));
          }
      );
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
  MutableCell<String> mutableString() =>
      MutableComputeCell(
          arguments: {this},
          compute: () => value.unwrap.toString(),
          reverseCompute: (value) {
            this.value = Maybe.wrap(() => double.parse(value));
          }
      );
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
  MutableCell<String> mutableString() =>
      MutableComputeCell(
          arguments: {this},
          compute: () => value.unwrap.toString(),
          reverseCompute: (value) {
            this.value = Maybe.wrap(() => num.parse(value));
          }
      );
}