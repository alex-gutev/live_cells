import 'package:flutter_test/flutter_test.dart';

import 'package:live_cells/live_cells.dart';
import 'package:mockito/mockito.dart';

class Listener {
  void onChange() {}
}

class MockListener extends Mock implements Listener {}

void main() {
  group('ConstantCell', () {
    test('Integer ConstantCell.value equals value given in constructor', () {
      final cell = ConstantCell(10);
      expect(cell.value, equals(10));
    });
    test('String ConstantCell.value equals value given in constructor', () {
      final cell = ConstantCell('Hello World');
      expect(cell.value, equals('Hello World'));
    });
  });

  group('MutableCell', () {
    test('MutableCell.value equals initial value when not changed', () {
      final cell = MutableCell(15);
      expect(cell.value, equals(15));
    });

    test('Setting MutableCell.value changes cell value', () {
      final cell = MutableCell(15);
      cell.value = 23;

      expect(cell.value, equals(23));
    });

    test('MutableCell.value keeps latest value that was set', () {
      final cell = MutableCell(15);
      cell.value = 23;
      cell.value = 101;

      expect(cell.value, equals(101));
    });

    test('Setting MutableCell.value calls cell listeners', () {
      final cell = MutableCell(15);
      final listener = MockListener();

      cell.addListener(listener.onChange);
      cell.value = 23;

      verify(listener.onChange()).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final listener = MockListener();

      cell.addListener(listener.onChange);

      cell.value = 23;
      cell.value = 101;

      verify(listener.onChange()).called(2);
    });

    test('MutableCell listener not called after it is removed', () {
      final cell = MutableCell(15);
      final listener = MockListener();

      cell.addListener(listener.onChange);
      cell.value = 23;

      cell.removeListener(listener.onChange);
      cell.value = 101;

      verify(listener.onChange()).called(1);
    });

    test('MutableCell listener not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final listener = MockListener();

      cell.addListener(listener.onChange);
      cell.value = 56;

      verifyNever(listener.onChange());
    });
  });

  group('Equality Comparisons', () {
    test('ConstantCell\'s are eq if they have equal values', () {
      final a = ConstantCell(1);
      final b = ConstantCell(1);

      expect(a.eq(b).value, equals(true));
    });

    test('ConstantCell\'s are not eq if they have unequal values', () {
      final a = ConstantCell(1);
      final b = ConstantCell(2);

      expect(a.eq(b).value, equals(false));
    });

    test('ConstantCell\'s are neq if they have unequal values', () {
      final a = ConstantCell(3);
      final b = ConstantCell(4);

      expect(a.neq(b).value, equals(true));
    });

    test('ConstantCell\'s are not neq if they have equal values', () {
      final a = ConstantCell(3);
      final b = ConstantCell(3);

      expect(a.neq(b).value, equals(false));
    });

    test('EqCell is reevaluated when 1st argument cell value changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      a.value = 4;

      expect(a.eq(b).value, equals(true));
    });

    test('EqCell is reevaluated when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      b.value = 3;

      expect(a.eq(b).value, equals(true));
    });

    test('EqCell listeners notified when 1st argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final listener = MockListener();

      eq.addListener(listener.onChange);
      a.value = 4;

      verify(listener.onChange()).called(1);
    });

    test('EqCell listeners notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final listener = MockListener();

      eq.addListener(listener.onChange);
      b.value = 3;

      verify(listener.onChange()).called(1);
    });

    test('NeqCell is reevaluated when 1st argument cell value changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      a.value = 4;

      expect(a.neq(b).value, equals(false));
    });

    test('NeqCell is reevaluated when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      b.value = 3;

      expect(a.neq(b).value, equals(false));
    });

    test('NeqCell listeners notified when 1st argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.neq(b);
      final listener = MockListener();

      neq.addListener(listener.onChange);
      a.value = 4;

      verify(listener.onChange()).called(1);
    });

    test('NeqCell listeners notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.eq(b);
      final listener = MockListener();

      neq.addListener(listener.onChange);
      b.value = 3;

      verify(listener.onChange()).called(1);
    });
  });
}
