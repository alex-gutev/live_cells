// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_classes.dart';

// **************************************************************************
// CellExtensionGenerator
// **************************************************************************

/// Extends ValueCell with accessors for TestBaseClass properties
extension TestBaseClassCellExtension on ValueCell<TestBaseClass> {
  ValueCell<String> get testValue => apply((value) => value.testValue,
          key: _$ValueCellPropKeyTestBaseClass(this, #testValue))
      .store(changesOnly: true);
}

class _$ValueCellPropKeyTestBaseClass {
  final ValueCell _cell;
  final Symbol _prop;
  _$ValueCellPropKeyTestBaseClass(this._cell, this._prop);
  @override
  bool operator ==(other) =>
      other is _$ValueCellPropKeyTestBaseClass &&
      _cell == other._cell &&
      _prop == other._prop;
  @override
  int get hashCode => Object.hash(runtimeType, _cell, _prop);
}

/// Extends MutableCell with accessors for TestBaseClass properties
extension TestBaseClassMutableCellExtension on MutableCell<TestBaseClass> {
  static TestBaseClass _copyWith(
    TestBaseClass $instance, {
    String? testValue,
  }) {
    return TestBaseClass(
      testValue: testValue ?? $instance.testValue,
    );
  }

  MutableCell<String> get testValue =>
      mutableApply((value) => value.testValue, (p) {
        value = _copyWith(value, testValue: p);
      },
          key: _$MutableCellPropKeyTestBaseClass(this, #testValue),
          changesOnly: true);
}

class _$MutableCellPropKeyTestBaseClass {
  final ValueCell _cell;
  final Symbol _prop;
  _$MutableCellPropKeyTestBaseClass(this._cell, this._prop);
  @override
  bool operator ==(other) =>
      other is _$MutableCellPropKeyTestBaseClass &&
      _cell == other._cell &&
      _prop == other._prop;
  @override
  int get hashCode => Object.hash(runtimeType, _cell, _prop);
}

/// Extends ValueCell with accessors for TestInheritedClass properties
extension TestInheritedClassCellExtension on ValueCell<TestInheritedClass> {
  ValueCell<int> get testValueTwo => apply((value) => value.testValueTwo,
          key: _$ValueCellPropKeyTestInheritedClass(this, #testValueTwo))
      .store(changesOnly: true);
}

class _$ValueCellPropKeyTestInheritedClass {
  final ValueCell _cell;
  final Symbol _prop;
  _$ValueCellPropKeyTestInheritedClass(this._cell, this._prop);
  @override
  bool operator ==(other) =>
      other is _$ValueCellPropKeyTestInheritedClass &&
      _cell == other._cell &&
      _prop == other._prop;
  @override
  int get hashCode => Object.hash(runtimeType, _cell, _prop);
}

/// Extends MutableCell with accessors for TestInheritedClass properties
extension TestInheritedClassMutableCellExtension
    on MutableCell<TestInheritedClass> {
  static TestInheritedClass _copyWith(
    TestInheritedClass $instance, {
    String? testValue,
    int? testValueTwo,
  }) {
    return TestInheritedClass(
      testValue: testValue ?? $instance.testValue,
      testValueTwo: testValueTwo ?? $instance.testValueTwo,
    );
  }

  MutableCell<String> get testValue =>
      mutableApply((value) => value.testValue, (p) {
        value = _copyWith(value, testValue: p);
      },
          key: _$MutableCellPropKeyTestInheritedClass(this, #testValue),
          changesOnly: true);

  MutableCell<int> get testValueTwo =>
      mutableApply((value) => value.testValueTwo, (p) {
        value = _copyWith(value, testValueTwo: p);
      },
          key: _$MutableCellPropKeyTestInheritedClass(this, #testValueTwo),
          changesOnly: true);
}

class _$MutableCellPropKeyTestInheritedClass {
  final ValueCell _cell;
  final Symbol _prop;
  _$MutableCellPropKeyTestInheritedClass(this._cell, this._prop);
  @override
  bool operator ==(other) =>
      other is _$MutableCellPropKeyTestInheritedClass &&
      _cell == other._cell &&
      _prop == other._prop;
  @override
  int get hashCode => Object.hash(runtimeType, _cell, _prop);
}
