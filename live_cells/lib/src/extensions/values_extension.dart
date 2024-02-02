import '../value_cell.dart';

/// Extends [num] with a [cell] property to create a [ValueCell] out of a value.
extension NumValueCellExtension<T extends num> on T {
  /// Create a constant [ValueCell] with value equal to [this].
  ValueCell<T> get cell => ValueCell.value(this);
}

/// Extends [String] with a [cell] property to create a [ValueCell] out of a value.
extension StringValueCellExtension on String {
  /// Create a constant [ValueCell] with value equal to [this].
  ValueCell<String> get cell => ValueCell.value(this);
}

/// Extends [bool] with a [cell] property to create a [ValueCell] out of a value.
extension BoolValueCellExtension on bool {
  /// Create a constant [ValueCell] with value equal to [this].
  ValueCell<bool> get cell => ValueCell.value(this);
}

/// Extends [Enum] with a [cell] property to create a [ValueCell] out of a value.
extension EnumValueCellExtension<T extends Enum> on T {
  /// Create a constant [ValueCell] with value equal to [this].
  ValueCell<T> get cell => ValueCell.value(this);
}

/// Extends [Null] with a [cell] property to create a [ValueCell] holding [null].
extension NullValueCellExtension on Null {
  /// Create a constant [ValueCell] with value equal to [null].
  ValueCell<Null> get cell => ValueCell.value(this);
}