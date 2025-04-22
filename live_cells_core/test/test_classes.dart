import 'package:live_cells_core/live_cells_core.dart';

part 'test_classes.g.dart';

@CellExtension(mutable: true)
class TestBaseClass {
  final String testValue;

  const TestBaseClass({
    required this.testValue,
  });

  @override
  bool operator ==(Object other) =>
      _$TestBaseClassEquals(this, other);

  @override
  int get hashCode => _$TestBaseClassHashCode(this);
}

@CellExtension(mutable: true)
class TestInheritedClass extends TestBaseClass {
  final int testValueTwo;

  const TestInheritedClass({
    required super.testValue,
    required this.testValueTwo,
  });

  TestInheritedClass copyWith({
    String? testValue,
    int? testValueTwo,
  }) {
    return TestInheritedClass(
      testValue: testValue ?? this.testValue,
      testValueTwo: testValueTwo ?? this.testValueTwo,
    );
  }

  // **NOTE**: Both the generated comparator and the superclass == method
  // have to be called since the generated comparator does not call the
  // superclass == method automatically
  @override
  bool operator ==(Object other) => super == other &&
    _$TestInheritedClassEquals(this, other);

  @override
  int get hashCode => super.hashCode ^ _$TestInheritedClassHashCode(this);
}
