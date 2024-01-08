import 'compute_extension.dart';
import '../mutable_cell/mutable_cell.dart';

/// Provides methods for converting an integer to a string and vice versa.
extension ParseIntExtension on MutableCell<int> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, an integer is parsed from the assigned string
  /// value and is assigned to this cell's value.
  MutableCell<String> toMutableString() =>
      [this].mutableComputeCell(() => value.toString(), (value) {
        this.value = int.tryParse(value) ?? 0;
      });
}

/// Provides methods for converting a num to a string and vice versa.
extension ParseNumExtension on MutableCell<num> {
  /// Return a cell which evaluates to a string representation of this cell's value.
  ///
  /// The returned cell is a mutable computed cell. If the value of the returned
  /// cell is set explicitly, a [num] is parsed from the assigned string
  /// value and is assigned to this cell's value.
  MutableCell<String> toMutableString() =>
      [this].mutableComputeCell(() => value.toString(), (value) {
        this.value = num.tryParse(value) ?? 0;
      });
}

/// Provides the [toMutableString] method for String cells
extension ConvertStringExtension on MutableCell<String> {
  /// Simply returns this cell
  MutableCell<String> toMutableString() => this;
}