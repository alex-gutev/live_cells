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
/// **NOTE**: By default, this also generates equals and hashCode functions
/// for the annotated class as if it is annotated by [DataClass]. To suppress
/// the generation of these functions, pass a value of false for
/// [generateEquals].
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

  /// Should equals and hash code functions be generated for the annotated class?
  final bool generateEquals;

  /// Annotate a class to generate an extension on [ValueCell] for the class's properties.
  ///
  /// If [mutable] is true an extension on [MutableCell] is also generated.
  ///
  /// If [nullable] is true extensions on the nullable type of the annotated
  /// class are generated. This only affects the extension on [ValueCell] and
  /// not [MutableCell].
  ///
  /// If [generateEquals] is true (the default), equals and hashCode functions
  /// are generated for the annotated class as if it is annotated by [DataClass].
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
    this.nullable = false,
    this.generateEquals = true
  });
}

/// Annotate a class to generate equals and hash code functions for it.
/// 
/// An equals function, called `_$<class name>Equals` is generated for the 
/// annotated class. The method takes two arguments `self` and `other` and 
/// returns [true] if `other` is an instance of the annotated class and
/// every property of `self` is equal to the corresponding property of `other` 
/// by `==`.
/// 
/// Similarly a hashCode function, called `_$<class name>HashCode` is generated
/// for the annotated class. This function computes the hashCode of the class
/// instance passed to it by computing the hashes of each of its properties, using
/// the [Object.hashCode] property.
///    
/// Example:
/// 
/// ```
/// @DataClass()
/// class Point {
///   final int x;
///   final int y;
///   
///   ...
///   
///   @override
///   bool operator ==(Object other) =>
///     _$PointEquals(this, other);
///     
///   @override
///   int get hashCode => _$PointHashCode(this);
/// }
/// ```
/// 
/// **NOTE**: Synthetic properties are ignored by both the generated equals
/// and hashCode functions.
/// 
/// To use a different comparator and hash function for a property, annotate it
/// with [DataField].
class DataClass {
  const DataClass();
}

/// Specify the comparator and hash function to use for a given property.
///
/// This annotation controls the comparator and hash function to use for a
/// given property when generating the equals and hashCode functions for a
/// given class that is annotated with [DataClass] or [CellExtension].
///
/// The function [equals] is used, instead of `==`, to compare whether two
/// properties are equal. Similarly the function [hash] is used to compute the
/// hash code of the property instead of the [Object.hashCode] property.
///
/// Example:
///
/// ```dart
/// @DataClass()
/// class Point {
///   // Use `listEquals` from `flutter:foundation.dart` as the comparator and
///   // `Object.hashAll` as the hash function for this property.
///   @DataField(
///      equals: listEquals,
///      hash: Object.hashAll
///   )
///   final List<int> coordinates;
///
///   ...
///
///   @override
///   bool operator ==(Object other) => _$PointEquals(this, other);
///
///   @override
///   int get hashCode => _$PointHashCode(this);
/// }
/// ```
class DataField {
  final Function? equals;
  final Function? hash;

  const DataField({
    this.equals,
    this.hash
  });
}