import 'dart:async';

import 'package:macros/macros.dart';

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
macro class CellType implements ClassDeclarationsMacro {
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

  const CellType();

  @override
  FutureOr<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder) async {
    final fields = _filterReservedFields(await builder.fieldsOf(clazz));

    if (fields.isEmpty) {
      // TODO: Proper exception type and full message
      throw Exception('No public final properties found on class ${clazz.identifier.name}.');
    }

    _generateCellExtension(
        clazz: clazz,
        builder: builder,
        fields: fields
    );
  }

  /// Generate the extension on [ValueCell] for the class
  void _generateCellExtension({
    required ClassDeclaration clazz,
    required MemberDeclarationBuilder builder,
    required List<FieldDeclaration> fields
  }) {
    final className = clazz.identifier.name;
    final extensionName = '${className}CellExtension';

    final typeParams = clazz.typeParameters.map((e) => e.code.parts).toList();
    final typeParamNames = clazz.typeParameters.map((e) => e.name);

    builder.declareInLibrary(DeclarationCode.fromParts([
      "import 'package:live_cells_core/live_cells_core.dart';\n",
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

      '> {\n',

      for (final field in fields)
        ..._generateCellAccessor(
            field: field,
            className: className
        ),

      '}'
    ]));
  }

  /// Generate an accessor that returns a cell which accesses a [field]
  List _generateCellAccessor({
    required FieldDeclaration field,
    required String className,
  }) {
    final name = field.identifier.name;
    final type = field.type.code;

    return [
      'ValueCell<', type, '> ',
      'get $name => apply(\n',
      '  (value) => value.$name,\n',
      '  key: CellTypePropKey(this, #$className, #$name)\n',
      ').store(changesOnly: true);'
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