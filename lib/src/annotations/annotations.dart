/// Annotation for generatin an extension on [ValueCell]'s holding values of this type.
///
/// When this annotation is applied to a class, an extension is generated for
/// [ValueCell]'s holding instances of the class. The extension adds
/// accessors for each property of the class directly to [ValueCell]. Each
/// accessor returns a *computed cell* which accesses the corresponding property
/// of the value held in the cell on which the accessor was used.
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
/// ValueCell<Person> will be extended with accessors for the `name` and `age`
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
/// held in the cell on which the accessor was used. This is achieved by creating
/// a new instance of the class with the new value of the modified property
/// and the same values for the remaining properties.
class CellExtension {
  /// Should an extension on [MutableCell] be generated?
  final bool mutable;

  /// Annotate a class to generate an extension on [ValueCell] for the class's properties.
  ///
  /// If [mutable] is true an extension on [MutableCell] is also generated.
  const CellExtension({
    this.mutable = false
  });
}