import 'package:live_cells/live_cells.dart';

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