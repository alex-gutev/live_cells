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
  final ValueCell cell;

  MockValueObserver(this.cell);

  @override
  void update() {
    gotValue(cell.value);
  }
}

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

      verify(observer.update()).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);

      cell.value = 23;
      cell.value = 101;

      verify(observer.update()).called(2);
    });

    test('MutableCell observer not called after it is removed', () {
      final cell = MutableCell(15);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 23;

      cell.removeObserver(observer);
      cell.value = 101;

      verify(observer.update()).called(1);
    });

    test('MutableCell observer not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 56;

      verifyNever(observer.update());
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

      verify(observer1.update()).called(3);
      verify(observer2.update()).called(2);
    });

    test('MutableCell.value updated when observer called', () {
      final cell = MutableCell('hello');
      final observer = MockValueObserver(cell);

      cell.addObserver(observer);

      cell.value = 'bye';
      verify(observer.gotValue('bye'));
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

      verify(observer.update()).called(1);
    });

    test('EqCell observers notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final observer = MockSimpleObserver();

      eq.addObserver(observer);
      b.value = 3;

      verify(observer.update()).called(1);
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

      verify(observer.update()).called(1);
    });

    test('NeqCell observers notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.eq(b);
      final observer = MockSimpleObserver();

      neq.addObserver(observer);
      b.value = 3;

      verify(observer.update()).called(1);
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

      verify(observer.update()).called(1);
    });

    test('ComputeCell observers notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = [a,b].computeCell(() => a.value + b.value);

      final observer = MockSimpleObserver();
      c.addObserver(observer);

      b.value = 8;

      verify(observer.update()).called(1);
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

      verify(observer.update()).called(3);
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

      verify(observer.update()).called(1);
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

      verify(observer1.update()).called(3);
      verify(observer2.update()).called(2);
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

      verify(observer.update()).called(2);
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

      verify(observer1.update()).called(2);
      verify(observer2.update()).called(1);
    });

    test('StoreCell observer not called after it is removed', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer = MockSimpleObserver();

      store.addObserver(observer);
      a.value = 'bye';

      store.removeObserver(observer);
      a.value = 'goodbye';

      verify(observer.update()).called(1);
    });

    test('StoreCell observers not called when argument cell value does not change', () {
      final a = MutableCell(2);
      final b = a.apply((value) => value.isEven);
      final store = b.store();

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      b.addObserver(observer1);
      store.addObserver(observer2);

      a.value = 4;
      a.value = 6;
      a.value = 8;

      verify(observer1.update()).called(3);
      verifyNever(observer2.update());

      a.value = 11;

      verify(observer2.update()).called(1);
    });

    test('StoreCell.value updated when observer called', () {
      final cell = MutableCell('hello');
      final store = cell.store();

      final observer = MockValueObserver(store);

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
        observer.willUpdate(),
        observer.update()
      ]);

      verifyNoMoreInteractions(observer);
    });

    test('No intermediate values are recorded when using multi argument cells', () {
      final a = MutableCell(0);
      final sum = a + 1.cell;
      final prod = a * 8.cell;
      final result = sum + prod;

      final observer = MockValueObserver(result);
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      verifyInOrder([
        observer.gotValue((2 + 1) + (2 * 8)),
        observer.gotValue((6 + 1) + (6 * 8))
      ]);
    });

    test('No intermediate values are produced when using StoreCells', () {
      final a = MutableCell(0);
      final sum = (a + 1.cell).store();
      final prod = (a * 8.cell).store();
      final result = sum + prod;

      final observer = MockValueObserver(result);
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      verifyInOrder([
        observer.gotValue((2 + 1) + (2 * 8)),
        observer.gotValue((6 + 1) + (6 * 8)),
      ]);
    });

    test('No intermediate values are produced when using StoreCells and branches are unequal', () {
      final a = MutableCell(0);
      final sum = ((a + 1.cell).store() + 10.cell).store();
      final prod = (a * 8.cell).store();
      final result = (sum + prod).store();

      final observer = MockValueObserver(result);
      result.addObserver(observer);

      a.value = 2;
      a.value = 6;

      verifyInOrder([
        observer.gotValue((2 + 1 + 10) + (2 * 8)),
        observer.gotValue((6 + 1 + 10) + (6 * 8)),
      ]);
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

      final observer = MockValueObserver(delay);
      delay.addObserver(observer);

      cell.value = 2;

      await untilCalled(observer.gotValue(2)).timeout(const Duration(seconds: 1), onTimeout: () {
        fail('DelayCell.value not updated');
      });
    });

    test('DelayCell.value observers called for every argument cell value change', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final observer = MockValueObserver(delay);
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

      final observer1 = MockValueObserver(delay);
      final observer2 = MockValueObserver(delay);

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
