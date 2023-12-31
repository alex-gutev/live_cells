import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:live_cells/live_cells.dart';
import 'package:mockito/mockito.dart';

/// Mock class interface for recording the value of a cell at the time an observer was called
abstract class ValueObserver {
  /// Mock method called by listener to record cell value
  void gotValue(value);
}

/// Mock class implementing [CellObserver]
///
/// Usage:
///
///   - Add instance as an observer of a cell
///   - verify(instance.update())
class MockSimpleObserver extends Mock implements CellObserver {}

/// Mock class implementing [ValueObserver]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance.gotValue(expected))
class MockValueObserver extends MockSimpleObserver implements ValueObserver {
  /// List of values obtained (duplicates are removed)
  final values = [];

  @override
  void update(ValueCell cell) {
    final value = cell.value;

    if (values.lastOrNull != value) {
      values.add(value);
    }

    gotValue(value);
  }
}

/// Mock class interface for recording whether a listener was called
abstract class SimpleListener {
  /// Method added as listener function
  void call();
}

/// Mock class implementing [SimpleListener]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance())
class MockSimpleListener extends Mock implements SimpleListener {}

abstract class TestResource {
  void init();
  void dispose();
}

class MockResource extends Mock implements TestResource {
  @override
  void init();
  @override
  void dispose();
}

class TestManagedCell<T> extends NotifierCell<T> {
  final TestResource _resouce;

  TestManagedCell(this._resouce, super.value);
  
  @override
  void init() {
    super.init();
    _resouce.init();
  }
  
  @override
  void dispose() {
    super.dispose();
    _resouce.dispose();
  }
}

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
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 23;

      verify(observer.update(cell)).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);

      cell.value = 23;
      cell.value = 101;

      verify(observer.update(cell)).called(2);
    });

    test('MutableCell observer not called after it is removed', () {
      final cell = MutableCell(15);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 23;

      cell.removeObserver(observer);
      cell.value = 101;

      verify(observer.update(cell)).called(1);
    });

    test('MutableCell observer not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 56;

      verifyNever(observer.update(cell));
    });

    test('All MutableCell observers called when value changes', () {
      final cell = MutableCell(3);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      cell.addObserver(observer1);
      cell.value = 5;

      cell.addObserver(observer2);
      cell.value = 8;
      cell.value = 12;

      verify(observer1.update(cell)).called(3);
      verify(observer2.update(cell)).called(2);
    });

    test('MutableCell.value updated when observer called', () {
      final cell = MutableCell('hello');
      final observer = MockValueObserver();

      cell.addObserver(observer);

      cell.value = 'bye';
      verify(observer.gotValue('bye'));
    });

    test('All cell values updates using MutableCell.batch', () {
      final a = MutableCell(0);
      final b = MutableCell(0);
      final op = MutableCell('');

      final sum = a + b;
      final msg = [a, b, op, sum].computeCell(
              () => '${a.value} ${op.value} ${b.value} = ${sum.value}'
      );

      final observer = MockSimpleObserver();
      msg.addObserver(observer);

      MutableCell.batch(() {
        a.value = 1;
        b.value = 2;
        op.value = '+';
      });

      expect(msg.value, '1 + 2 = 3');
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

    test('EqCell observers notified when 1st argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final observer = MockSimpleObserver();

      eq.addObserver(observer);
      a.value = 4;

      verify(observer.update(eq)).called(1);
    });

    test('EqCell observers notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final observer = MockSimpleObserver();

      eq.addObserver(observer);
      b.value = 3;

      verify(observer.update(eq)).called(1);
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

    test('NeqCell observers notified when 1st argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.neq(b);
      final observer = MockSimpleObserver();

      neq.addObserver(observer);
      a.value = 4;

      verify(observer.update(neq)).called(1);
    });

    test('NeqCell observers notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.eq(b);
      final observer = MockSimpleObserver();

      neq.addObserver(observer);
      b.value = 3;

      verify(observer.update(neq)).called(1);
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

      final c = [a,b].computeCell(() => a.value + b.value);

      a.value = 5;

      expect(c.value, equals(7));
    });

    test('N-ary ComputeCell reevaluated when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      b.value = 8;

      expect(c.value, equals(9));
    });

    test('ComputeCell observers notified when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      a.value = 8;

      verify(observer.update(c)).called(1);
    });

    test('ComputeCell observers notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      b.value = 8;

      verify(observer.update(c)).called(1);
    });

    test('ComputeCell observers notified for each change of value of argument cell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      b.value = 8;
      a.value = 10;
      b.value = 100;

      verify(observer.update(c)).called(3);
    });

    test('ComputeCell observer not called after it is removed', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      a.value = 8;

      c.removeObserver(observer);
      b.value = 10;
      a.value = 100;

      verify(observer.update(c)).called(1);
    });

    test('All ComputeCell observers called when value changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      c.addObserver(observer1);
      a.value = 8;

      c.addObserver(observer2);
      b.value = 10;
      a.value = 100;

      verify(observer1.update(c)).called(3);
      verify(observer2.update(c)).called(2);
    });
  });

  group('DynamicComputeCell', () {
    test('DynamicComputeCell function applied on ConstantCell value', () {
      final a = 1.cell;
      final b = ValueCell.computed(() => a() + 1);

      expect(b.value, equals(2));
    });

    test('DynamicComputeCell reevaluated when value of argument cell changes', () {
      final a = MutableCell(1);
      final b = ValueCell.computed(() => a() + 1);

      final observer = MockSimpleObserver();
      b.addObserver(observer);

      a.value = 5;

      expect(b.value, equals(6));
    });

    test('N-ary DynamicComputeCell reevaluated when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      a.value = 5;

      expect(c.value, equals(7));
    });

    test('N-ary DynamicComputeCell reevaluated when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      b.value = 8;

      expect(c.value, equals(9));
    });

    test('DynamicComputeCell observers notified when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      a.value = 8;

      verify(observer.update(c)).called(1);
    });

    test('DynamicComputeCell observers notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      b.value = 8;

      verify(observer.update(c)).called(1);
    });

    test('DynamicComputeCell observers notified for each change of value of argument cell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      b.value = 8;
      a.value = 10;
      b.value = 100;

      verify(observer.update(c)).called(3);
    });

    test('DynamicComputeCell observer not called after it is removed', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      a.value = 8;

      c.removeObserver(observer);
      b.value = 10;
      a.value = 100;

      verify(observer.update(c)).called(1);
    });

    test('All DynamicComputeCell observers called when value changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      c.addObserver(observer1);
      a.value = 8;

      c.addObserver(observer2);
      b.value = 10;
      a.value = 100;

      verify(observer1.update(c)).called(3);
      verify(observer2.update(c)).called(2);
    });
    
    test('DynamicComputeCell arguments tracked correctly when using conditionals', () {
      final a = MutableCell(true);
      final b = MutableCell(2);
      final c = MutableCell(3);
      
      final d = ValueCell.computed(() => a() ? b() : c());

      final observer = MockValueObserver();
      d.addObserver(observer);

      b.value = 1;
      a.value = false;
      c.value = 10;

      expect(observer.values, equals([1, 3, 10]));
    });

    test('DynamicComputeCell arguments tracked correctly when argument is a DynamicComputeCell', () {
      final a = MutableCell(true);
      final b = MutableCell(2);
      final c = MutableCell(3);

      final d = ValueCell.computed(() => a() ? b() : c());

      final e = MutableCell(0);

      final f = ValueCell.computed(() => d() + e());

      final observer = MockValueObserver();
      f.addObserver(observer);

      b.value = 1;
      e.value = 10;
      a.value = false;
      c.value = 10;

      expect(observer.values, equals([1, 11, 13, 20]));
    });
  });

  group('StoreCell', () {
    test('StoreCell takes value of argument cell', () {
      final a = MutableCell('hello');
      final store = a.store();

      expect(store.value, equals('hello'));
    });

    test('StoreCell takes latest value of argument cell', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer = MockSimpleObserver();

      a.value = 'bye';
      store.addObserver(observer);

      expect(store.value, equals('bye'));
    });

    test('StoreCell observers notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer = MockSimpleObserver();

      store.addObserver(observer);
      a.value = 'bye';
      a.value = 'goodbye';

      verify(observer.update(store)).called(2);
    });

    test('All StoreCell observers notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      store.addObserver(observer1);
      a.value = 'bye';

      store.addObserver(observer2);
      a.value = 'goodbye';

      verify(observer1.update(store)).called(2);
      verify(observer2.update(store)).called(1);
    });

    test('StoreCell observer not called after it is removed', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer = MockSimpleObserver();

      store.addObserver(observer);
      a.value = 'bye';

      store.removeObserver(observer);
      a.value = 'goodbye';

      verify(observer.update(store)).called(1);
    });

    test('StoreCell.value updated when observer called', () {
      final cell = MutableCell('hello');
      final store = cell.store();

      final observer = MockValueObserver();

      store.addObserver(observer);

      cell.value = 'bye';
      verify(observer.gotValue('bye'));
    });
  });

  group('NumericExtension', () {
    test('a + b creates ValueCell which is equal to the sum of a and b', () {
      final a = 5.cell;
      final b = 6.cell;

      final c = a + b;

      expect(c.value, equals(11));
    });

    test('a - b creates ValueCell which is equal to the difference of a and b', () {
      final a = 13.cell;
      final b = 20.cell;

      final c = a - b;

      expect(c.value, equals(-7));
    });

    test('a * b creates ValueCell which is equal to the product of a and b', () {
      final a = 10.cell;
      final b = 8.cell;

      final c = a * b;

      expect(c.value, equals(80));
    });

    test('a / b creates ValueCell which is equal to the quotient of a and b', () {
      final a = 7.cell;
      final b = 2.cell;

      final c = a / b;

      expect(c.value, equals(3.5));
    });

    test('a ~/ b creates ValueCell which is equal to the truncated quotient of a and b', () {
      final a = 7.cell;
      final b = 2.cell;

      final c = a ~/ b;

      expect(c.value, equals(3));
    });

    test('a % b creates ValueCell which is equal to the modulo of a / b', () {
      final a = 17.cell;
      final b = 3.cell;

      final c = a % b;

      expect(c.value, equals(2));
    });


    test('a.remainder(b) creates ValueCell which is equal to the remainder of a / b', () {
      final a = 7.cell;
      final b = 2.cell;

      final c = a.remainder(b);

      expect(c.value, equals(1));
    });

    test('a < b creates ValueCell which equals true if a is less than b', () {
      final a = 3.cell;
      final b = 8.cell;

      final lt = a < b;
      final gt = b < a;

      expect(lt.value, isTrue);
      expect(gt.value, isFalse);
    });

    test('a <= b creates ValueCell which equals true if a is less than b', () {
      final a = 3.cell;
      final b = 8.cell;

      final lt = a <= b;
      final gt = b <= a;

      expect(lt.value, isTrue);
      expect(gt.value, isFalse);
    });

    test('a <= b creates ValueCell which equals true if a is equal to b', () {
      final a = 5.cell;
      final b = 5.cell;

      final lt = a <= b;
      final gt = b <= a;

      expect(lt.value, isTrue);
      expect(gt.value, isTrue);
    });

    test('a > b creates ValueCell which equals true if a is greater than b', () {
      final a = 3.cell;
      final b = 8.cell;

      final lt = a > b;
      final gt = b > a;

      expect(lt.value, isFalse);
      expect(gt.value, isTrue);
    });

    test('a >= b creates ValueCell which equals true if a is greater than b', () {
      final a = 3.cell;
      final b = 8.cell;

      final lt = a >= b;
      final gt = b >= a;

      expect(lt.value, isFalse);
      expect(gt.value, isTrue);
    });

    test('a >= b creates ValueCell which equals true if a is equal to b', () {
      final a = 5.cell;
      final b = 5.cell;

      final lt = a <= b;
      final gt = b <= a;

      expect(lt.value, isTrue);
      expect(gt.value, isTrue);
    });

    test('a.isNaN creates ValueCell which equals true if a is NaN', () {
      final a = 0.cell;
      final c = a / a;
      final d = c.isNaN;

      expect(d.value, isTrue);
    });

    test('a.isNaN creates ValueCell which equals false if a is not NaN', () {
      final a = 2.cell;
      final c = a / a;
      final d = c.isNaN;

      expect(d.value, isFalse);
    });

    test('a.isFinite creates ValueCell which equals true if a is finite', () {
      final a = 3.cell;
      final c = a / a;
      final d = c.isFinite;

      expect(d.value, isTrue);
    });

    test('a.isFinite creates ValueCell which equals false if a is not finite', () {
      final a = 3.cell;
      final b = 0.cell;
      final c = a / b;
      final d = c.isFinite;

      expect(d.value, isFalse);
    });

    test('a.isInfinite creates ValueCell which equals false if a is finite', () {
      final a = 3.cell;
      final c = a / a;
      final d = c.isInfinite;

      expect(d.value, isFalse);
    });

    test('a.isInfinite creates ValueCell which equals true if a is not finite', () {
      final a = 3.cell;
      final b = 0.cell;
      final c = a / b;
      final d = c.isInfinite;

      expect(d.value, isTrue);
    });

    test('a.abs() creates ValueCell which is equal to absolute value of a', () {
      final a = ValueCell.value(-3);

      expect(a.abs().value, equals(3));
    });

    test('a.sign creates ValueCell which is equal to 1 if a > 0', () {
      final a = 3.cell;

      expect(a.sign.value, equals(1));
    });

    test('a.sign creates ValueCell which is equal to -1 if a < 0', () {
      final a = ValueCell.value(-3);

      expect(a.sign.value, equals(-1));
    });

    test('a.sign creates ValueCell which is equal to 0 if a == 0', () {
      final a = 0.cell;

      expect(a.sign.value, equals(0));
    });
  });

  group('Cell update consistency', () {
    test('All observer methods called in correct order', () {
      final cell = MutableCell(10);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 15;

      verifyInOrder([
        observer.willUpdate(cell),
        observer.update(cell)
      ]);

      verifyNoMoreInteractions(observer);
    });

    test('No intermediate values are recorded when using multi argument cells', () {
      final a = MutableCell(0);
      final sum = a + 1.cell;
      final prod = a * 8.cell;
      final result = sum + prod;

      final observer = MockValueObserver();
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1) + (2 * 8), (6 + 1) + (6 * 8)]));
    });

    test('No intermediate values are produced when using StoreCells', () {
      final a = MutableCell(0);
      final sum = (a + 1.cell).store();
      final prod = (a * 8.cell).store();
      final result = sum + prod;

      final observer = MockValueObserver();
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1) + (2 * 8), (6 + 1) + (6 * 8)]));
    });

    test('No intermediate values are produced when using StoreCells and branches are unequal', () {
      final a = MutableCell(0);
      final sum = ((a + 1.cell).store() + 10.cell).store();
      final prod = (a * 8.cell).store();
      final result = (sum + prod).store();

      final observer = MockValueObserver();
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1 + 10) + (2 * 8), (6 + 1 + 10) + (6 * 8)]));
    });

    test('No intermediate values are produced when using DynamicComputeCell', () {
      final a = MutableCell(0);
      final sum = ValueCell.computed(() => a() + 1);
      final prod = ValueCell.computed(() => a() * 8);
      final result = ValueCell.computed(() => sum() + prod());

      final observer = MockValueObserver();
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1) + (2 * 8), (6 + 1) + (6 * 8)]));
    });

    test('No intermediate values are produced when using DynamicComputeCell and branches are unequal', () {
      final a = MutableCell(0);

      final sum1 = ValueCell.computed(() => a() + 1);
      final sum = ValueCell.computed(() => sum1() + 10);

      final prod = ValueCell.computed(() => a() * 8);
      final result = ValueCell.computed(() => sum() + prod());

      final observer = MockValueObserver();
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1 + 10) + (2 * 8), (6 + 1 + 10) + (6 * 8)]));
    });

    test('No intermediate values are produced when using MutableCell.batch', () {
      final a = MutableCell(0);
      final b = MutableCell(0);
      final op = MutableCell('');

      final sum = a + b;
      final msg = [a, b, op, sum].computeCell(
              () => '${a.value} ${op.value} ${b.value} = ${sum.value}'
      );

      final observer = MockValueObserver();
      msg.addObserver(observer);

      MutableCell.batch(() {
        a.value = 1;
        b.value = 2;
        op.value = '+';
      });

      MutableCell.batch(() {
        a.value = 5;
        b.value = 6;
        op.value = 'plus';
      });

      expect(observer.values, equals([
        '1 + 2 = 3',
        '5 plus 6 = 11'
      ]));
    });

    test('No intermediate values are produced when using MutableCell.batch and StoreCells', () {
      final a = MutableCell(0);
      final b = MutableCell(0);
      final op = MutableCell('');

      final sum = (a + b).store();
      final msg = [a, b, op, sum].computeCell(
              () => '${a.value} ${op.value} ${b.value} = ${sum.value}'
      );

      final observer = MockValueObserver();
      msg.addObserver(observer);

      MutableCell.batch(() {
        a.value = 1;
        b.value = 2;
        op.value = '+';
      });

      MutableCell.batch(() {
        a.value = 5;
        b.value = 6;
        op.value = 'plus';
      });

      expect(observer.values, equals([
        '1 + 2 = 3',
        '5 plus 6 = 11'
      ]));
    });

    test('No intermediate values are produced when using MutableCell.batch and DynamicComputeCell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final c = MutableCell(3);
      final select = MutableCell(true);

      final sum = ValueCell.computed(() => a() + b());
      final result = ValueCell.computed(() => select() ? c() : sum());

      final observer = MockValueObserver();
      result.addObserver(observer);

      MutableCell.batch(() {
        select.value = true;
        c.value = 10;
        a.value = 5;
      });

      MutableCell.batch(() {
        b.value = 20;
        select.value = false;
      });

      expect(observer.values, equals([10, 25]));
    });

    test('All StoreCell observers called correct number of times', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final sum = (a + b).store();

      final c = (a + sum).store();
      final d = sum + 2.cell;

      final observerC = MockSimpleObserver();
      final observerD = MockSimpleObserver();

      c.addObserver(observerC);
      d.addObserver(observerD);

      MutableCell.batch(() {
        a.value = 2;
        b.value = 3;
      });

      MutableCell.batch(() {
        a.value = 3;
        b.value = 2;
      });

      MutableCell.batch(() {
        a.value = 10;
        b.value = 20;
      });

      verify(observerC.update(c)).called(3);
      verify(observerD.update(d)).called(3);
    });

    test('Correct values produced with StoreCell across all observer cells', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final sum = (a + b).store();

      final c = a + sum;
      final d = sum + 2.cell;

      final observerC = MockValueObserver();
      final observerD = MockValueObserver();

      c.addObserver(observerC);
      d.addObserver(observerD);

      MutableCell.batch(() {
        a.value = 2;
        b.value = 3;
      });

      MutableCell.batch(() {
        a.value = 3;
        b.value = 2;
      });

      MutableCell.batch(() {
        a.value = 10;
        b.value = 20;
      });

      expect(observerC.values, equals([7, 8, 40]));
      expect(observerD.values, equals([7, 32]));
    });
  });

  group('Cell initialization and cleanup', () {
    test('init() not called if no observers added', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);
      
      verifyNever(resource.init());
    });

    test('init() called once when adding first observer', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      cell.addObserver(observer1);
      cell.addObserver(observer2);

      verify(resource.init()).called(1);
    });

    test('dispose() not called when not all observers removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      cell.addObserver(observer1);
      cell.addObserver(observer2);

      cell.removeObserver(observer1);

      verifyNever(resource.dispose());
    });

    test('dispose() called when all observers removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      cell.addObserver(observer1);
      cell.addObserver(observer2);

      cell.removeObserver(observer1);
      cell.removeObserver(observer2);

      verify(resource.dispose()).called(1);
    });

    test('init() called again when adding new observer after all observers removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      cell.addObserver(observer1);
      cell.addObserver(observer2);

      cell.removeObserver(observer1);
      cell.removeObserver(observer2);

      cell.addObserver(observer1);

      verify(resource.init()).called(2);
    });
  });

  group('ValueCell.listenable', () {
    test('Listeners called when value of cell changes', () {
      final cell = MutableCell(10);
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.value = 30;

      verify(listener1()).called(1);
      verify(listener2()).called(1);
    });

    test('Listeners not called after they are removed', () {
      final cell = MutableCell(10);
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.value = 30;
      cell.listenable.removeListener(listener1);

      cell.value = 40;

      verify(listener1()).called(1);
      verify(listener2()).called(2);
    });

    test('init() called when first listener is added', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      verify(cell.init()).called(1);
    });

    test('dispose() called when all listeners are removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.listenable.removeListener(listener2);
      cell.listenable.removeListener(listener1);

      verify(cell.dispose()).called(1);
    });

    test('dispose() not called when not all listeners are removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.listenable.removeListener(listener1);

      verifyNever(cell.dispose());
    });
  });

  group('MutableComputeCell', () {
    test('MutableComputeCell.value computed on construction', () {
      final a = MutableCell(1);
      final b = [a].mutableComputeCell(
        () => a.value + 1,
        (b) {
          a.value = b - 1;
        }
      );

      expect(b.value, equals(2));
    });

    test('MutableComputeCell.value recomputed when value of argument cell changes', () {
      final a = MutableCell(1);
      final b = [a].mutableComputeCell(
          () => a.value + 1,
          (b) {
            a.value = b - 1;
          }
      );

      final observer = MockSimpleObserver();

      b.addObserver(observer);
      a.value = 5;

      expect(b.value, equals(6));
    });

    test('MutableComputeCell.value recomputed when value of 1st argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      a.value = 5;

      expect(c.value, equals(8));
    });

    test('MutableComputeCell.value recomputed when value of 2nd argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      b.value = 9;

      expect(c.value, equals(10));
    });

    test('MutableComputeCell observers notified when value is recomputed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      b.value = 9;
      a.value = 10;

      verify(observer.update(c)).called(2);
    });

    test('MutableComputeCell observer not called after it is removed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      c.addObserver(observer1);
      c.addObserver(observer2);
      b.value = 9;

      c.removeObserver(observer1);
      a.value = 10;

      verify(observer1.update(c)).called(1);
      verify(observer2.update(c)).called(2);
    });

    test('Setting MutableComputeCell.value updates values of argument cells', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      c.value = 10;

      expect(a.value, equals(5));
      expect(b.value, equals(5));
      expect(c.value, equals(10));
    });

    test('Setting MutableComputeCell.value calls observers of MutableCell and argument cells', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);

      c.value = 10;

      verify(observerA.update(a)).called(1);
      verify(observerB.update(b)).called(1);
      verify(observerC.update(c)).called(1);
    });

    test('Observers of MutableComputeCell and argument cells called every time value is set', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);

      c.value = 10;
      c.value = 12;

      verify(observerA.update(a)).called(2);
      verify(observerB.update(b)).called(2);
      verify(observerC.update(c)).called(2);
    });

    test('Consistency of values maintained when setting MutableComputeCell.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final d = MutableCell(50);
      final e = (c + d).store();

      final observerA = MockValueObserver();
      final observerB = MockValueObserver();
      final observerC = MockValueObserver();
      final observerE = MockValueObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);
      e.addObserver(observerE);

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      expect(observerA.values, equals([5]));
      expect(observerB.values, equals([5]));
      expect(observerC.values, equals([10]));
      expect(observerE.values, equals([19]));
    });

    test('Observers notified correct number of times when setting MutableComputeCell.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = [a, b].mutableComputeCell(
          () => a.value + b.value,
          (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final d = MutableCell(50);
      final e = (c + d).store();

      final observerA = MockValueObserver();
      final observerB = MockValueObserver();
      final observerC = MockValueObserver();
      final observerE = MockValueObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);
      e.addObserver(observerE);

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      verify(observerA.update(a)).called(1);
      verify(observerB.update(b)).called(1);
      verify(observerC.update(c)).called(1);
      verify(observerE.update(e)).called(1);
    });

    test('All MutableComputeCell observers called correct number of times', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = [a, b].mutableComputeCell(() => a.value + b.value, (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      });

      final c = (a + sum).store();
      final d = sum + 2.cell;

      final observerC = MockSimpleObserver();
      final observerD = MockSimpleObserver();

      c.addObserver(observerC);
      d.addObserver(observerD);

      MutableCell.batch(() {
        a.value = 2;
        b.value = 3;
      });

      MutableCell.batch(() {
        a.value = 3;
        b.value = 2;
      });

      MutableCell.batch(() {
        a.value = 10;
        b.value = 20;
      });

      verify(observerC.update(c)).called(3);
      verify(observerD.update(d)).called(3);
    });

    test('Correct values produced with MutableComputeCell across all observer cells', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = [a, b].mutableComputeCell(() => a.value + b.value, (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      });

      final c = a + sum;
      final d = sum + 2.cell;

      final observerC = MockValueObserver();
      final observerD = MockValueObserver();

      c.addObserver(observerC);
      d.addObserver(observerD);

      MutableCell.batch(() {
        a.value = 2;
        b.value = 3;
      });

      MutableCell.batch(() {
        a.value = 3;
        b.value = 2;
      });

      MutableCell.batch(() {
        a.value = 10;
        b.value = 20;
      });

      expect(observerC.values, equals([7, 8, 40]));
      expect(observerD.values, equals([7, 32]));
    });
  });

  group('DynamicMutableComputeCell', () {
    test('DynamicMutableComputeCell.value computed on construction', () {
      final a = MutableCell(1);
      final b = MutableCell.computed(() => a() + 1, (b) {
        a.value = b - 1;
      });

      expect(b.value, equals(2));
    });

    test('DynamicMutableComputeCell.value recomputed when value of argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell.computed(() => a() + 1, (b) {
        a.value = b - 1;
      });

      final observer = MockSimpleObserver();

      b.addObserver(observer);
      a.value = 5;

      expect(b.value, equals(6));
    });

    test('DynamicMutableComputeCell.value recomputed when value of 1st argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      a.value = 5;

      expect(c.value, equals(8));
    });

    test('DynamicMutableComputeCell.value recomputed when value of 2nd argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      b.value = 9;

      expect(c.value, equals(10));
    });

    test('DynamicMutableComputeCell observers notified when value is recomputed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final observer = MockSimpleObserver();

      c.addObserver(observer);
      b.value = 9;
      a.value = 10;

      verify(observer.update(c)).called(2);
    });

    test('DynamicMutableComputeCell observer not called after it is removed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      c.addObserver(observer1);
      c.addObserver(observer2);
      b.value = 9;

      c.removeObserver(observer1);
      a.value = 10;

      verify(observer1.update(c)).called(1);
      verify(observer2.update(c)).called(2);
    });

    test('Setting DynamicMutableComputeCell.value updates values of argument cells', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      c.value = 10;

      expect(a.value, equals(5));
      expect(b.value, equals(5));
      expect(c.value, equals(10));
    });

    test('Setting DynamicMutableComputeCell.value calls observers of MutableCell and argument cells', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);

      c.value = 10;

      verify(observerA.update(a)).called(1);
      verify(observerB.update(b)).called(1);
      verify(observerC.update(c)).called(1);
    });

    test('Observers of DynamicMutableComputeCell and argument cells called every time value is set', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);

      c.value = 10;
      c.value = 12;

      verify(observerA.update(a)).called(2);
      verify(observerB.update(b)).called(2);
      verify(observerC.update(c)).called(2);
    });

    test('Consistency of values maintained when setting DynamicMutableComputeCell.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final d = MutableCell(50);
      final e = ValueCell.computed(() => c() + d());

      final observerA = MockValueObserver();
      final observerB = MockValueObserver();
      final observerC = MockValueObserver();
      final observerE = MockValueObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);
      e.addObserver(observerE);

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      expect(observerA.values, equals([5]));
      expect(observerB.values, equals([5]));
      expect(observerC.values, equals([10]));
      expect(observerE.values, equals([19]));
    });

    test('Observers notified correct number of times when setting DynamicMutableComputeCell.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = MutableCell.computed(() => a() + b(), (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      });

      final d = MutableCell(50);
      final e = ValueCell.computed(() => c() + d());

      final observerA = MockValueObserver();
      final observerB = MockValueObserver();
      final observerC = MockValueObserver();
      final observerE = MockValueObserver();

      a.addObserver(observerA);
      b.addObserver(observerB);
      c.addObserver(observerC);
      e.addObserver(observerE);

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      verify(observerA.update(a)).called(1);
      verify(observerB.update(b)).called(1);
      verify(observerC.update(c)).called(1);
      verify(observerE.update(e)).called(1);
    });

    test('All DynamicMutableComputeCell observers called correct number of times', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = MutableCell.computed(() => a() + b(), (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      });

      final c = (a + sum).store();
      final d = sum + 2.cell;

      final observerC = MockSimpleObserver();
      final observerD = MockSimpleObserver();

      c.addObserver(observerC);
      d.addObserver(observerD);

      MutableCell.batch(() {
        a.value = 2;
        b.value = 3;
      });

      MutableCell.batch(() {
        a.value = 3;
        b.value = 2;
      });

      MutableCell.batch(() {
        a.value = 10;
        b.value = 20;
      });

      verify(observerC.update(c)).called(3);
      verify(observerD.update(d)).called(3);
    });

    test('Correct values produced with DynamicMutableComputeCell across all observer cells', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = MutableCell.computed(() => a() + b(), (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      });

      final c = ValueCell.computed(() => a() + sum());
      final d = ValueCell.computed(() => sum() + 2);

      final observerC = MockValueObserver();
      final observerD = MockValueObserver();

      c.addObserver(observerC);
      d.addObserver(observerD);

      MutableCell.batch(() {
        a.value = 2;
        b.value = 3;
      });

      MutableCell.batch(() {
        a.value = 3;
        b.value = 2;
      });

      MutableCell.batch(() {
        a.value = 10;
        b.value = 20;
      });

      expect(observerC.values, equals([7, 8, 40]));
      expect(observerD.values, equals([7, 32]));
    });


    test('DynamicMutableComputeCell arguments tracked correctly when using conditionals', () {
      final a = MutableCell(true);
      final b = MutableCell(2);
      final c = MutableCell(3);

      final d = MutableCell.computed(() => a() ? b() : c(), (d) {
        a.value = true;
        b.value = d;
        c.value = d;
      });

      final observer = MockValueObserver();
      d.addObserver(observer);

      b.value = 1;
      a.value = false;
      c.value = 10;

      expect(observer.values, equals([1, 3, 10]));
    });

    test('DynamicMutableComputeCell arguments tracked correctly when argument is a DynamicComputeCell', () {
      final a = MutableCell(true);
      final b = MutableCell(2);
      final c = MutableCell(3);

      final d = MutableCell.computed(() => a() ? b() : c(), (d) {
        a.value = true;
        b.value = d;
        c.value = d;
      });

      final e = MutableCell(0);

      final f = MutableCell.computed(() => d() + e(), (f) {
        final half = f ~/ 2;

        d.value = half;
        e.value = half;
      });

      final observer = MockValueObserver();
      f.addObserver(observer);

      b.value = 1;
      e.value = 10;
      a.value = false;
      c.value = 10;

      expect(observer.values, equals([1, 11, 13, 20]));
    });

    test('No intermediate values are produced when using DynamicMutableComputeCell and branches are unequal', () {
      final a = MutableCell(0);

      final sum1 = MutableCell.computed(() => a() + 1, (v) {
        // Reverse computation not necessary for this test
      });
      final sum = MutableCell.computed(() => sum1() + 10, (v) {
        // Reverse computation not necessary for this test
      });

      final prod = MutableCell.computed(() => a() * 8, (v) {
        // Reverse computation not necessary for this test
      });
      final result = MutableCell.computed(() => sum() + prod(), (v) {
        // Reverse computation not necessary for this test
      });

      final observer = MockValueObserver();
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1 + 10) + (2 * 8), (6 + 1 + 10) + (6 * 8)]));
    });

    test('No intermediate values are produced when using MutableCell.batch and DynamicMutableComputeCell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final c = MutableCell(3);
      final select = MutableCell(true);

      final sum = MutableCell.computed(() => a() + b(), (v) {
        // Reverse computation not necessary for this test
      });
      final result = MutableCell.computed(() => select() ? c() : sum(), (v) {
        // Reverse computation not necessary for this test
      });

      final observer = MockValueObserver();
      result.addObserver(observer);

      MutableCell.batch(() {
        select.value = true;
        c.value = 10;
        a.value = 5;
      });

      MutableCell.batch(() {
        b.value = 20;
        select.value = false;
      });

      expect(observer.values, equals([10, 25]));
    });
  });

  group('Type Conversions', () {
    test('ParseIntExtension.mutableString() converts argument cell to string', () {
      final a = MutableCell(1);
      final strA = a.mutableString();

      final observer = MockSimpleObserver();
      strA.addObserver(observer);

      a.value = 5;

      expect(strA.value, equals('5'));
    });

    test('ParseIntExtension.mutableString() sets argument cell to parsed integer', () {
      final a = MutableCell(1);
      final strA = a.mutableString();

      final observer = MockSimpleObserver();
      strA.addObserver(observer);

      strA.value = '32';

      expect(a.value, equals(32));
    });

    test('ParseDoubleExtension.mutableString() converts argument cell to string', () {
      final a = MutableCell(1.0);
      final strA = a.mutableString();

      final observer = MockSimpleObserver();
      strA.addObserver(observer);

      a.value = 7.5;

      expect(strA.value, equals('7.5'));
    });

    test('ParseDoubleExtension.mutableString() sets argument cell to parsed double', () {
      final a = MutableCell(1.0);
      final strA = a.mutableString();

      final observer = MockSimpleObserver();
      strA.addObserver(observer);

      strA.value = '3.5';

      expect(a.value, equals(3.5));
    });

    test('ParseNumExtension.mutableString() converts argument cell to string', () {
      final a = MutableCell<num>(1);
      final strA = a.mutableString();

      final observer = MockValueObserver();
      strA.addObserver(observer);

      a.value = 7.5;
      a.value = 3;

      expect(observer.values, equals(['7.5', '3']));
    });

    test('ParseNumExtension.mutableString() sets argument cell to parsed num', () {
      final a = MutableCell<num>(1);
      final strA = a.mutableString();

      final observer = MockValueObserver();
      a.addObserver(observer);

      strA.value = '3.5';
      strA.value = '100';

      expect(observer.values, equals([3.5, 100]));
    });

    test('ConvertStringExtension.mutableString() converts argument cell to string', () {
      final a = MutableCell('');
      final strA = a.mutableString();

      final observer = MockSimpleObserver();
      strA.addObserver(observer);

      a.value = 'hello';

      expect(strA.value, equals('hello'));
    });

    test('ConvertStringExtension.mutableString() simply sets argument cell value', () {
      final a = MutableCell('');
      final strA = a.mutableString();

      final observer = MockSimpleObserver();
      strA.addObserver(observer);

      strA.value = '3.5';

      expect(a.value, equals('3.5'));
    });
  });

  group('DelayCell', () {
    test('DelayCell.value equals initial value of cell when not changed', () {
      final cell = MutableCell(2);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      expect(delay.value, equals(2));
    });

    test('DelayCell takes latest value of argument cell', () {
      final cell = MutableCell(10);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final observer = MockSimpleObserver();
      cell.value = 20;

      delay.addObserver(observer);

      expect(delay.value, equals(20));
    });

    test('DelayCell.value is updated after setting argument cell value', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final observer = MockValueObserver();
      delay.addObserver(observer);

      cell.value = 2;

      await untilCalled(observer.gotValue(2)).timeout(const Duration(seconds: 1), onTimeout: () {
        fail('DelayCell.value not updated');
      });
    });

    test('DelayCell.value observers called for every argument cell value change', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final observer = MockValueObserver();
      delay.addObserver(observer);

      cell.value = 2;
      cell.value = 5;

      await untilCalled(observer.gotValue(5)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      verify(observer.gotValue(any)).called(2);
    });

    test('DelayCell.value observer not called after it is removed', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final observer1 = MockValueObserver();
      final observer2 = MockValueObserver();

      delay.addObserver(observer1);
      delay.addObserver(observer2);

      cell.value = 2;

      await untilCalled(observer1.gotValue(2)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      await untilCalled(observer2.gotValue(2)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      delay.removeObserver(observer1);
      cell.value = 5;

      await untilCalled(observer2.gotValue(5)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      verify(observer1.gotValue(any)).called(1);
      verify(observer2.gotValue(any)).called(2);
    });
  });
}
