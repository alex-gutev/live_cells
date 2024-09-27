import 'package:live_cells_core/live_cells_core.dart';

part 'test_classes.g.dart';

@CellExtension(mutable: true)
class TestBaseClass {
  final String testValue;

  const TestBaseClass({
    required this.testValue,
  });
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
}
