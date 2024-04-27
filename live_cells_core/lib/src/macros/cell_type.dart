import 'dart:async';

import 'package:macros/macros.dart';

import 'data_class.dart';

/// Generates an extension on [ValueCell] that provides accessors for the annotated class's properties
///
/// This macro extends [ValueCell]'s holding instances of the annotated class,
/// with accessors for the class's properties, that return cells.
///
/// For example consider the following class:
///
/// ```dart
/// CellType()
/// class Person {
///    final String firstName;
///    final String lastName;
///    final int age;
///    ...
/// }
/// ```
///
/// This will generate an extension on `ValueCell<Person>` which provides
/// accessors for the `firstName`, `lastName` and `age` properties:
///
/// ```dart
/// ValueCell<Person> person;
/// ...
/// print('Name: ${person.firstName.value}');
///
/// ValueCell.watch(() {
///   print('${person.firstName()} ${person.lastName()}: ${person.age()}');
/// });
/// ```
macro class CellType implements ClassDeclarationsMacro, ClassDefinitionMacro, ClassTypesMacro {
  /// Identifiers reserved for [Object] properties.
  static const reservedObjectFieldNames = {
    'hashCode'
  };

  /// Set of identifiers which are reserved for [ValueCell] properties
  static const reservedFieldNames = {
    // ValueCell
    'value',
    'call',
    'eq',
    'neq',
    'addObserver',
    'removeObserver',

    // CellListenableExtension
    'listenable'

    // ComputeExtension
        'apply',

    // ErrorCellExtension
    'error',
    'onError',

    // MaybeCellExtension
    'unwrap',

    // PrevValueCellExtension
    'previous',

    // StoreCellExtension
    'store',

    // WidgetExtension
    'toWidget'
  };

  /// Set of identifiers which are reserved for [MutableCell] properties
  static const reservedMutableFieldNames = {
    // MutableCell
    'notifyUpdate',
    'notifyWillUpdate',

    // CellMaybeExtension
    'maybe',
  };

  /// Set of identifiers which are reserved for both [ValueCell] and [MutableCell] properties
  static final allReservedFieldNames =
  reservedFieldNames.union(reservedMutableFieldNames);

  /// Should an extension on [MutableCell] be generated?
  final bool mutable;

  /// Should extensions on nullable types also be generated?
  final bool nullable;

  /// Generate an extension on [ValueCell] that provides accessors for the class's properties.
  ///
  /// An extension for [ValueCell]s holding instances of this class, is generated.
  /// The extension provides getters for each public final property of the class,
  /// directly on [ValueCell].
  ///
  /// Each property getter returns a cell that observes the value of the
  /// corresponding property of the object held in the cell. The observers of the
  /// cell returned by the getter are notified only when the value of the
  /// property actually changes. This means, if a new instance is assigned
  /// to the cell but the value for a property *a* is identical to the value of
  /// the property in the previous instance, the observers of the cell returned
  /// by the property getter are not notified.
  ///
  /// If [mutable] is true, an extension is also generated on [MutableCell].
  /// This extension provides getters for the same properties, that return
  /// [MutableCell]s instead of [ValueCell]s. Setting the value of the cell
  /// returned by the getter updates the value of the property of the instance
  /// held in the cell on which the property getter is called.
  ///
  /// **NOTE**: the actual instance is not modified but a copy of the instance,
  /// with the value of the property changed, is created and assigned to the
  /// cell.
  ///
  /// If [nullable] is true, extensions on [ValueCell] and [MutableCell] holding
  /// a nullable instance of the class are also generated.
  const CellType({
    this.mutable = false,
    this.nullable = false
  });

  @override
  FutureOr<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    final fields = _filterReservedFields(await builder.fieldsOf(clazz));

    if (fields.isEmpty) {
      // TODO: Proper exception type and full message
      throw Exception('No public final properties found on class ${clazz.identifier.name}.');
    }

    await const DataClass().buildDeclarationsForClass(clazz, builder);

    _generateCellExtension(
        clazz: clazz,
        builder: builder,
        fields: fields,
        nullable: false
    );

    if (nullable) {
      _generateCellExtension(
          clazz: clazz,
          builder: builder,
          fields: fields,
          nullable: true,
          addImport: false
      );
    }

    if (mutable) {
      final fields = _filterReservedFields(
          await builder.fieldsOf(clazz),
          allReservedFieldNames
      );

      if (fields.isEmpty) {
        // TODO: Proper exception type and full message
        throw Exception('No public final properties found on class ${clazz.identifier.name}.');
      }

      _generateMutableCellExtension(
          clazz: clazz,
          builder: builder,
          fields: fields
      );
    }
  }

  @override
  FutureOr<void> buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {
    await const DataClass().buildDefinitionForClass(clazz, builder);
  }

  @override
  FutureOr<void> buildTypesForClass(ClassDeclaration clazz, ClassTypeBuilder builder) {
    _generatePropKeyClass(_propKeyClass(clazz.identifier.name), builder);

    if (mutable) {
      _generatePropKeyClass(
          _propKeyClass(
              clazz.identifier.name,
              cellClass: 'MutableCell'
          ),
          builder,
          addImport: false
      );
    }
  }

  /// Generate the extension on [ValueCell] for the class
  void _generateCellExtension({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
    required List<FieldDeclaration> fields,
    required bool nullable,
    bool addImport = true
  }) {
    final className = clazz.identifier.name;
    final extensionName = '${className}Cell${nullable ? 'N' : ''}Extension';

    final typeParams = clazz.typeParameters.map((e) => e.code.parts).toList();
    final typeParamNames = clazz.typeParameters.map((e) => e.name);

    builder.declareInLibrary(DeclarationCode.fromParts([
      if (addImport) "import 'package:live_cells_core/live_cells_core.dart';\n",

      '/// Extends ValueCell with accessors for $className properties\n',
      'extension $extensionName',

      if (typeParams.isNotEmpty) ...[
        '<',
        ...typeParams,
        '>'
      ],

      ' on ValueCell<',
      className,

      if (typeParamNames.isNotEmpty) ...[
        '<',
        typeParamNames.join(','),
        '>'
      ],

      if (nullable) '?',

      '> {\n',

      for (final field in fields)
        ..._generateCellAccessor(
            field: field,
            className: className,
            nullable: nullable
        ),

      '}'
    ]));
  }

  /// Generate an accessor that returns a cell which accesses a [field]
  List _generateCellAccessor({
    required FieldDeclaration field,
    required String className,
    required bool nullable
  }) {
    final name = field.identifier.name;

    final type = nullable
        ? field.type.code.asNullable
        : field.type.code;

    final keyClass = _propKeyClass(className);

    final nullableSuffix = nullable ? '?' : '';

    return [
      'ValueCell<', type, '> ',
      'get $name => apply(\n',
      '  (value) => value$nullableSuffix.$name,\n',
      '  key: $keyClass(this, #$name)\n',
      ').store(changesOnly: true);'
    ];
  }

  /// Get the name of the property cell key class for the class [className].
  ///
  /// [cellClass] is the name of the cell class for which an extension is being
  /// generated.
  String _propKeyClass(String className, {
    String cellClass = 'ValueCell'
  }) => '_\$${cellClass}PropKey$className';

  /// Generate a property cell key class with name [className].
  ///
  /// If [addImport] is true an import directive, for the live_cells, library
  /// is emitted.
  void _generatePropKeyClass(String className, ClassTypeBuilder builder, {
    bool addImport = true,
  }) {
    builder.declareType(className, DeclarationCode.fromParts([
      if (addImport)
        "import 'package:live_cells_core/live_cells_core.dart';\n",

      'class $className {',
      '  final ValueCell _cell;',
      '  final Symbol _prop;',
      '  $className(this._cell, this._prop);',

      '  @override',
      '  bool operator==(other) => other is $className &&',
      '    _cell == other._cell &&',
      '    _prop == other._prop;',

      '  @override',
      '  int get hashCode => Object.hash(runtimeType, _cell, _prop);',
      '}'
    ]));
  }

  /// Generate an extension for [MutableCell]s holding instances of [clazz].
  void _generateMutableCellExtension({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
    required List<FieldDeclaration> fields
  }) {
    final className = clazz.identifier.name;
    final extensionName = '${className}MutableCellExtension';

    final typeParams = clazz.typeParameters.map((e) => e.code.parts).toList();
    final typeParamNames = clazz.typeParameters.map((e) => e.name);

    builder.declareInLibrary(DeclarationCode.fromParts([
      '/// Extends ValueCell with accessors for $className properties\n',
      'extension $extensionName',

      if (typeParams.isNotEmpty) ...[
        '<',
        ...typeParams,
        '>'
      ],

      ' on MutableCell<',
      className,

      if (typeParamNames.isNotEmpty) ...[
        '<',
        typeParamNames.join(','),
        '>'
      ],

      '> {\n',

      for (final field in fields)
        ..._generateMutableAccessor(
            field: field,
            className: className
        ),

      '}'
    ]));
  }

  /// Generate a property getter than returns a [MutableCell] observing [field].
  List _generateMutableAccessor({
    required FieldDeclaration field,
    required String className
  }) {
    final name = field.identifier.name;
    final type = field.type.code;
    final keyClass = _propKeyClass(className, cellClass: 'MutableCell');

    return [
      'MutableCell<', type, '> ',
      'get $name => mutableApply(\n',
      '  (value) => value.$name,\n',
      '  (p) => value = value.copyWith($name: p),\n',
      '  key: $keyClass(this, #$name),\n',
      '  changesOnly: true\n',
      ');'
    ];
  }

  /// Remove fields which use a reserved identifier.
  ///
  /// If a field uses an identifier present in [reserved], it is removed from
  /// [fields] and a warning is emitted with [extType] naming the extended class.
  ///
  /// The filtered list is returned, [fields] is not modified.
  static List<FieldDeclaration> _filterReservedFields(
      List<FieldDeclaration> fields,
      [Set<String> reserved = reservedFieldNames, String extType = 'ValueCell']) {
    List<FieldDeclaration> filtered = [];

    for (final field in fields) {
      if (reservedObjectFieldNames.contains(field.identifier.name)) {
        continue;
      }
      else if (reserved.contains(field.identifier.name)) {
        // TODO: Print warning log
      }
      else {
        filtered.add(field);
      }
    }

    return filtered;
  }
}