/// Annotation used to specify a class for which to generate a [ValueCell] extension.
///
/// When this annotation is applied to a class, an extension is generated for
/// [ValueCell]'s holding instances of the class. The extension extends
/// [ValueCell] with an accessor for each property of the class. Each
/// accessor returns a *computed cell* that accesses the property
/// of the instance held in the cell on which the accessor was used.
///
/// **NOTE**: The [live_cell_extension](https://pub.dev/packages/live_cell_extension)
/// package does the actual code generation.
///
/// For example when the annotation is applied on the following class:
///
/// ```dart
/// @CellExtension()
/// class Person {
///    final String name;
///    final int age;
///
///    const Person({
///      required this.name,
///      required this.age
///    });
/// }
/// ```
///
/// `ValueCell<Person>` will be extended with accessors for the `name` and `age`
/// properties:
///
///
/// ```dart
/// final person = MutableCell(
///   const Person(
///     name: 'John Smith',
///     age: 25
///   )
/// );
///
/// // name and age are both ValueCell's
/// final name = person.name;
/// final age = person.age;
///
/// print(name.value); // Prints: John Smith
/// print(age.value);  // Prints: 25
///
/// person.value = Person(name: 'Bob', age: 49);
///
/// print(name.value); // Prints: Bob
/// print(age.value);  // Prints: 49
/// ```
///
/// If [mutable] is true, [MutableCell] is also extended with accessors for the
/// properties. Unlike the accessors created on [ValueCell], these accessors
/// return [MutableCell]'s, which modify the value of the property of the object
/// held in the cell on which the accessor was used. This is achieved by copying
/// the instance with a new value for the modified property.
///
/// If the `Person` class was annotated with `@CellExtension(mutable: true)`,
/// the following accessors would be generated:
///
/// ```dart
/// final person = MutableCell(
///   const Person(
///     name: 'John Smith',
///     age: 25
///   )
/// );
///
/// // name and age are both MutableCell's
/// final name = person.name;
/// final age = person.age;
///
/// name.value = 'Bob';
/// print('${person.value.name} - ${person.value.age}'); // Prints Bob 25
///
/// age.value = 49;
/// print('${person.value.name} - ${person.value.age}'); // Prints Bob 49
/// ```
class CellExtension {
  /// Name of the `ValueCell` extension to generate.
  /// 
  /// If not given the name of the generated extension is the name of the class
  /// followed by `CellExtension`.
  final Symbol? name;

  /// Name of the `MutableCell` extension to generate.
  ///
  /// If not given the name of the generated extension is the name of the class
  /// followed by `MutableCellExtension`.
  ///
  /// This property is ignored if [mutable] is false.
  final Symbol? mutableName;
  
  /// Should an extension on [MutableCell] be generated?
  final bool mutable;

  /// Should extension on cells holding a nullable type be generated?
  final bool nullable;

  /// Annotate a class to generate an extension on [ValueCell] for the class's properties.
  ///
  /// If [mutable] is true an extension on [MutableCell] is also generated.
  ///
  /// If [nullable] is true extensions on the nullable type of the annotated
  /// class are generated. This only affects the extension on [ValueCell] and
  /// not [MutableCell].
  ///
  /// The name of the generated `ValueCell` extension is [name] and the name
  /// of the `MutableCell` extension, if one is generated, is [mutableName]. If
  /// these are [null] the name of the `ValueCell` extension is the name of
  /// the annotated class followed by `CellExtension` and the name of the
  /// `MutableCell` extension is the name of the class followed by
  /// `MutableCellExtension`.
  const CellExtension({
    this.name,
    this.mutableName,
    this.mutable = false,
    this.nullable = false
  });
}