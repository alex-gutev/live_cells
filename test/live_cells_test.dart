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

    test('All MutableCell listeners called when value changes', () {
      final cell = MutableCell(3);

      final listener1 = MockListener();
      final listener2 = MockListener();

      cell.addListener(listener1.onChange);
      cell.value = 5;

      cell.addListener(listener2.onChange);
      cell.value = 8;
      cell.value = 12;

      verify(listener1.onChange()).called(3);
      verify(listener2.onChange()).called(2);
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

  group('ComputeCell', () {
    test('ComputeCell function applied on ConstantCell value', () {
      final a = ConstantCell(1);
      final b = a.apply((value) => value + 1);

      expect(b.value, equals(2));
    });

    test('ComputeCell reevaluated when value of argument cell changes', () {
      final a = MutableCell(1);
      final b = a.apply((value) => value + 1);

      a.value = 5;

      expect(b.value, equals(6));
    });

    test('N-ary ComputeCell reevaluated when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      a.value = 5;

      expect(c.value, equals(7));
    });

    test('N-ary ComputeCell reevaluated when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      b.value = 8;

      expect(c.value, equals(9));
    });

    test('ComputeCell listeners notified when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockListener();
      c.addListener(listener.onChange);

      a.value = 8;

      verify(listener.onChange()).called(1);
    });

    test('ComputeCell listeners notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockListener();
      c.addListener(listener.onChange);

      b.value = 8;

      verify(listener.onChange()).called(1);
    });

    test('ComputeCell listeners notified for each change of value of argument cell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockListener();
      c.addListener(listener.onChange);

      b.value = 8;
      a.value = 10;
      b.value = 100;

      verify(listener.onChange()).called(3);
    });

    test('ComputeCell listener not called after it is removed', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockListener();

      c.addListener(listener.onChange);
      a.value = 8;

      c.removeListener(listener.onChange);
      b.value = 10;
      a.value = 100;

      verify(listener.onChange()).called(1);
    });

    test('All ComputeCell listeners called when value changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener1 = MockListener();
      final listener2 = MockListener();

      c.addListener(listener1.onChange);
      a.value = 8;

      c.addListener(listener2.onChange);
      b.value = 10;
      a.value = 100;

      verify(listener1.onChange()).called(3);
      verify(listener2.onChange()).called(2);
    });
  });
}
