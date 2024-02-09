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

  /// List of type arguments to add to generated class
  final List<String> typeArguments;

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

  /// Map from property names to code which computes the default property values.
  ///
  /// If a property is a key in this map, the code in the corresponding value
  /// is used as the default value in the generated constructor.
  final Map<Symbol, String> propertyDefaultValues;

  /// Map from property names to property types.
  ///
  /// If a property is a key in this map, the type in the corresponding value
  /// is used instead of the declared type in the widget class constructor.
  final Map<Symbol, String> propertyTypes;

  /// List of properties to add to generated wrapper class.
  final List<WidgetPropertySpec> addProperties;

  /// List of super formal constructor parameters to include in generated class
  /// properties.
  final List<Symbol> includeSuperProperties;

  /// Documentation comment for the generated class.
  final String? documentation;

  const WidgetSpec({
    this.as,
    this.typeArguments = const [],
    this.mutableProperties = const [],
    this.excludeProperties = const [],
    this.propertyValues = const {},
    this.propertyDefaultValues = const {},
    this.propertyTypes = const {},
    this.addProperties = const [],
    this.includeSuperProperties = const [],
    this.documentation
  });
}

/// Specifier for an additional property to add to a widget wrapper class.
///
/// **NOTE**: This is currently only for internal use by the `live_cells`
/// package.
///
/// A property of type `ValueCell` holding a [T] is generated.
class WidgetPropertySpec<T extends Object> {
  /// Property name
  final Symbol name;

  /// Default value to assign to property
  final String? defaultValue;

  /// Is this property optional?
  final bool optional;

  /// Should this property be held in a `MutableCell`?
  final bool mutable;

  /// Documentation comment for this property
  final String? documentation;

  const WidgetPropertySpec({
    required this.name,
    required this.defaultValue,
    this.optional = true,
    this.mutable = false,
    this.documentation
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

/// Specifies that an extensions with the `.cell` property should be generated for the given value types.
///
/// **NOTE**: This annotation is currently only for internal use by the `live_cells`
/// package.
///
/// An extension which provides the `.cell` property is generated for every
/// specification in [specs]. This annotation can be applied to any element.
class GenerateValueExtensions {
  /// Specifications of the extensions to generate
  final List<ExtensionSpec> specs;

  const GenerateValueExtensions(this.specs);
}

/// Specifier for a cell value extension for [T].
///
/// **NOTE**: This is currently only for internal use by the `live_cells`
/// package.
class ExtensionSpec<T> {
  /// Should this extension be applied to subclasses of [T] or just [T]
  final bool forSubclasses;

  const ExtensionSpec({
    this.forSubclasses = false
  });
}