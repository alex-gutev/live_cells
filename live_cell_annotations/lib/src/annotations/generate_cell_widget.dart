/// Specification of a widget wrapper class to generate.
///
/// **NOTE**: This is currently only for internal use by the `live_cells`
/// package.
///
/// A wrapper class for the widget [T] is generated. The wrapper has the same
/// properties as those exposed in the unnamed constructor of [T], but as
/// `ValueCell`'s holding values of the same types as the properties. This
/// allows a property of a widget, created using the generated wrapper class,
/// to be set by setting the value of a cell.
class WidgetSpec<T extends Object> {
  /// Name of the generated class.
  ///
  /// If [null] the class is
  final Symbol? as;

  /// List of property names which should be `MutableCell`'s
  final List<Symbol> mutableProperties;

  /// List of property names which to exclude from the generated class
  final List<Symbol> excludeProperties;

  /// Map from property names to code which computes the property values.
  ///
  /// If a property is a key in this map, the code in the corresponding value
  /// is inserted directly when passing the property to the constructor of [T].
  /// Otherwise, the value of the property of the generated widget wrapper
  /// class is used.
  final Map<Symbol, String> propertyValues;

  const WidgetSpec({
    this.as,
    this.mutableProperties = const [],
    this.excludeProperties = const [],
    this.propertyValues = const {},
  });
}

/// Specifies that a wrapper, exposing the properties as cells, should be generated for a widget.
///
/// **NOTE**: This annotation is currently only for internal use by the `live_cells`
/// package.
///
/// A widget wrapper class is generated for every specification in [specs]. This
/// annotation can be applied to any element.
class GenerateCellWidgets {
  /// Specifications of the widget wrapper classes to generated
  final List<WidgetSpec> specs;

  const GenerateCellWidgets(this.specs);
}