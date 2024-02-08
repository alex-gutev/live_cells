import 'package:flutter/widgets.dart';
import 'package:live_cells_core/live_cells_core.dart';

/// Extends [Widget] with a [cell] property to wrap the [Widget] in a [ValueCell].
extension WidgetCellValueExtension<T extends Widget> on T {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<T> get cell => ValueCell.value(this);
}

/// Extends [TextStyle] with the [cell] property.
extension TextStyleCellValueExtension on TextStyle {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<TextStyle> get cell => ValueCell.value(this);
}

/// Extends [StrutStyle] with the [cell] property.
extension StrutStyleCellValueExtension on StrutStyle {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<StrutStyle> get cell => ValueCell.value(this);
}

/// Extends [TextAlign] with the [cell] property.
extension TextAlignCellValueExtension on TextAlign {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<TextAlign> get cell => ValueCell.value(this);
}

/// Extends [Locale] with the [cell] property.
extension LocaleCellValueExtension on Locale {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<Locale> get cell => ValueCell.value(this);
}

/// Extends [TextOverflow] with the [cell] property.
extension TextOverflowCellValueExtension on TextOverflow {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<TextOverflow> get cell => ValueCell.value(this);
}

/// Extends [TextScaler] with the [cell] property.
extension TextScalerCellValueExtension on TextScaler {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<TextScaler> get cell => ValueCell.value(this);
}

/// Extends [TextWidthBasis] with the [cell] property.
extension TextWidthBasisCellValueExtension on TextWidthBasis {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<TextWidthBasis> get cell => ValueCell.value(this);
}

/// Extends [TextHeightBehavior] with the [cell] property.
extension TextHeightBehaviorCellValueExtension on TextHeightBehavior {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<TextHeightBehavior> get cell => ValueCell.value(this);
}

/// Extends [Color] with the [cell] property.
extension ColorCellValueExtension on Color {
  /// Create a constant [ValueCell] holding [this].
  ValueCell<Color> get cell => ValueCell.value(this);
}