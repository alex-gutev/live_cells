import 'package:collection/collection.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'util.dart';

part 'live_cell_extension_test.g.dart';

@CellExtension(mutable: true)
class Person {
  final String firstName;
  final String lastName;
  final int age;

  String get fullName => '$firstName $lastName';

  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, age);

  // Accessors not generated for static properties

  static final key = 'personKey';

  const Person({
    required this.firstName,
    required this.lastName,
    required this.age,
  });

  @override
  bool operator ==(Object other) => other is Person &&
    other.runtimeType == runtimeType &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.age == age;
}

@CellExtension(mutable: true)
class Student extends Person {
  final int studentNo;

  const Student({
    required super.firstName,
    required super.lastName,
    required super.age,
    required this.studentNo
  });

  @override
  bool operator ==(Object other) => other is Student &&
    super == other &&
    studentNo == other.studentNo;

  @override
  int get hashCode => Object.hash(super.hashCode, studentNo);

}

void main() {
  group('ValueCell', () {
    test('Property cells change when object cell value changes', () {
      final firstName = MutableCell('John');
      final lastName = MutableCell('Smith');
      final age = MutableCell(25);

      final person = ValueCell.computed(() => Person(
        firstName: firstName(),
        lastName: lastName(),
        age: age()
      ));

      final oFirstName = addObserver(person.firstName, MockValueObserver());
      final oLastName = addObserver(person.lastName, MockValueObserver());
      final oFullName = addObserver(person.fullName, MockValueObserver());
      final oAge = addObserver(person.age, MockValueObserver());

      firstName.value = 'Bob';
      age.value = 30;

      MutableCell.batch(() {
        firstName.value = 'Jane';
        lastName.value = 'Doe';
        age.value = 35;
      });

      expect(oFirstName.values, equals(['Bob', 'Jane']));
      expect(oLastName.values, equals(['Doe']));
      expect(oFullName.values, equals(['Bob Smith', 'Jane Doe']));
      expect(oAge.values, equals([30, 35]));
    });

    test('Property cells work correctly with inheritance', () {
      final firstName = MutableCell('John');
      final lastName = MutableCell('Smith');
      final age = MutableCell(25);
      final studentNo = MutableCell(1);

      final person = ValueCell.computed(() => Student(
          firstName: firstName(),
          lastName: lastName(),
          age: age(),
          studentNo: studentNo()
      ));

      final oFirstName = addObserver(person.firstName, MockValueObserver());
      final oLastName = addObserver(person.lastName, MockValueObserver());
      final oFullName = addObserver(person.fullName, MockValueObserver());
      final oAge = addObserver(person.age, MockValueObserver());
      final oStudentNo = addObserver(person.studentNo, MockValueObserver());

      firstName.value = 'Bob';
      age.value = 30;

      MutableCell.batch(() {
        firstName.value = 'Jane';
        lastName.value = 'Doe';
        age.value = 35;
      });

      studentNo.value = 11;
      studentNo.value = 100;

      expect(oFirstName.values, equals(['Bob', 'Jane']));
      expect(oLastName.values, equals(['Doe']));
      expect(oFullName.values, equals(['Bob Smith', 'Jane Doe']));
      expect(oAge.values, equals([30, 35]));
      expect(oStudentNo.values, equals([11, 100]));
    });

    test('Property cells compare == when same object cell', () {
      final person = Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ).cell;

      final props1 = [
        person.firstName,
        person.lastName,
        person.fullName,
        person.age
      ];

      final props2 = [
        person.firstName,
        person.lastName,
        person.fullName,
        person.age
      ];

      for (final [p1, p2] in IterableZip([props1, props2])) {
        expect(p1 == p2, isTrue);
        expect(p1.hashCode == p2.hashCode, isTrue);
      }
    });

    test('Property cells compare != when different object cells', () {
      final person1 = MutableCell(Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ));

      final person2 = MutableCell(Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ));

      final props1 = [
        person1.firstName,
        person1.lastName,
        person1.fullName,
        person1.age
      ];

      final props2 = [
        person2.firstName,
        person2.lastName,
        person2.fullName,
        person2.age
      ];

      for (final [p1, p2] in IterableZip([props1, props2])) {
        expect(p1 != p2, isTrue);
      }
    });

    test('Property cells compare != when same different properties', () {
      final person = Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ).cell;

      expect(person.firstName != person.lastName, isTrue);
      expect(person.fullName != person.firstName, isTrue);
      expect(person.age != person.lastName, isTrue);
    });
  });

  group('MutableCell', () {
    test('Property cells change when object cell value changes', () {
      final person = MutableCell(Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ));

      final oFirstName = addObserver(person.firstName, MockValueObserver());
      final oLastName = addObserver(person.lastName, MockValueObserver());
      final oFullName = addObserver(person.fullName, MockValueObserver());
      final oAge = addObserver(person.age, MockValueObserver());

      expect(person.firstName.value, 'John');
      expect(person.lastName.value, 'Smith');
      expect(person.fullName.value, 'John Smith');
      expect(person.age.value, 25);

      person.firstName.value = 'Bob';
      person.age.value = 30;

      MutableCell.batch(() {
        person.firstName.value = 'Jane';
        person.lastName.value = 'Doe';
        person.age.value = 35;
      });

      person.value = Person(
          firstName: 'Eric',
          lastName: 'Jones',
          age: 60
      );

      expect(oFirstName.values, equals(['Bob', 'Jane', 'Eric']));
      expect(oLastName.values, equals(['Doe', 'Jones']));
      expect(oFullName.values, equals(['Bob Smith', 'Jane Doe', 'Eric Jones']));
      expect(oAge.values, equals([30, 35, 60]));
    });

    test('Property cells work correctly with inheritance', () {
      final person = MutableCell(Student(
          firstName: 'John',
          lastName: 'Smith',
          age: 25,
          studentNo: 1
      ));

      final oFirstName = addObserver(person.firstName, MockValueObserver());
      final oLastName = addObserver(person.lastName, MockValueObserver());
      final oFullName = addObserver(person.fullName, MockValueObserver());
      final oAge = addObserver(person.age, MockValueObserver());
      final oStudentNo = addObserver(person.studentNo, MockValueObserver());

      person.firstName.value = 'Bob';
      person.age.value = 30;

      MutableCell.batch(() {
        person.firstName.value = 'Jane';
        person.lastName.value = 'Doe';
        person.age.value = 35;
      });

      person.studentNo.value = 11;
      person.studentNo.value = 100;

      person.value = Student(
          firstName: 'Eric',
          lastName: 'Jones',
          age: 27,
          studentNo: 15
      );

      expect(oFirstName.values, equals(['Bob', 'Jane', 'Eric']));
      expect(oLastName.values, equals(['Doe', 'Jones']));
      expect(oFullName.values, equals(['Bob Smith', 'Jane Doe', 'Eric Jones']));
      expect(oAge.values, equals([30, 35, 27]));
      expect(oStudentNo.values, equals([11, 100, 15]));
    });

    test('Property cells compare == when same object cell', () {
      final person = Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ).cell;

      final props1 = [
        person.firstName,
        person.lastName,
        person.fullName,
        person.age
      ];

      final props2 = [
        person.firstName,
        person.lastName,
        person.fullName,
        person.age
      ];

      for (final [p1, p2] in IterableZip([props1, props2])) {
        expect(p1 == p2, isTrue);
        expect(p1.hashCode == p2.hashCode, isTrue);
      }
    });

    test('Property cells compare != when different object cells', () {
      final person1 = MutableCell(Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ));

      final person2 = MutableCell(Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ));

      final props1 = [
        person1.firstName,
        person1.lastName,
        person1.fullName,
        person1.age
      ];

      final props2 = [
        person2.firstName,
        person2.lastName,
        person2.fullName,
        person2.age
      ];

      for (final [p1, p2] in IterableZip([props1, props2])) {
        expect(p1 != p2, isTrue);
      }
    });

    test('Property cells compare != when same different properties', () {
      final person = Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      ).cell;

      expect(person.firstName != person.lastName, isTrue);
      expect(person.fullName != person.firstName, isTrue);
      expect(person.age != person.lastName, isTrue);
    });
  });
}
