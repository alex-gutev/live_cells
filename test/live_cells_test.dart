import 'package:flutter_test/flutter_test.dart';

import 'package:live_cells/live_cells.dart';
import 'package:mockito/mockito.dart';

/// Mock class interface for recording whether a listener was called
abstract class SimpleListener {
  /// Method added as listener function
  void call();
}

/// Mock class interface for recording the value of a cell at the time a listener was called
abstract class ValueListener extends SimpleListener {
  /// Mock method called by listener to record cell value
  void gotValue(value);
}

/// Like [ValueListener] but also provides interface for recording whether a [FutureCell] has a valu
abstract class AsyncValueListener extends ValueListener {
  /// Mock method called by listener to record [hasValue] property
  void hasValue(value);
}

/// Mock class implementing [SimpleListener]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance())
class MockSimpleListener extends Mock implements SimpleListener {}

/// Mock class implementing [ValueListener]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance.gotValue(expected))
class MockValueListener extends ValueListener with Mock {
  final ValueCell cell;

  MockValueListener(this.cell);

  @override
  void call() {
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
      final listener = MockSimpleListener();

      cell.addListener(listener);
      cell.value = 23;

      verify(listener()).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final listener = MockSimpleListener();

      cell.addListener(listener);

      cell.value = 23;
      cell.value = 101;

      verify(listener()).called(2);
    });

    test('MutableCell listener not called after it is removed', () {
      final cell = MutableCell(15);
      final listener = MockSimpleListener();

      cell.addListener(listener);
      cell.value = 23;

      cell.removeListener(listener);
      cell.value = 101;

      verify(listener()).called(1);
    });

    test('MutableCell listener not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final listener = MockSimpleListener();

      cell.addListener(listener);
      cell.value = 56;

      verifyNever(listener());
    });

    test('All MutableCell listeners called when value changes', () {
      final cell = MutableCell(3);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1);
      cell.value = 5;

      cell.addListener(listener2);
      cell.value = 8;
      cell.value = 12;

      verify(listener1()).called(3);
      verify(listener2()).called(2);
    });

    test('MutableCell.value updated when listener called', () {
      final cell = MutableCell('hello');
      final listener = MockValueListener(cell);

      cell.addListener(listener);

      cell.value = 'bye';
      verify(listener.gotValue('bye'));
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
      final listener = MockSimpleListener();

      eq.addListener(listener);
      a.value = 4;

      verify(listener()).called(1);
    });

    test('EqCell listeners notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final listener = MockSimpleListener();

      eq.addListener(listener);
      b.value = 3;

      verify(listener()).called(1);
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
      final listener = MockSimpleListener();

      neq.addListener(listener);
      a.value = 4;

      verify(listener()).called(1);
    });

    test('NeqCell listeners notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.eq(b);
      final listener = MockSimpleListener();

      neq.addListener(listener);
      b.value = 3;

      verify(listener()).called(1);
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

      final listener = MockSimpleListener();
      c.addListener(listener);

      a.value = 8;

      verify(listener()).called(1);
    });

    test('ComputeCell listeners notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockSimpleListener();
      c.addListener(listener);

      b.value = 8;

      verify(listener()).called(1);
    });

    test('ComputeCell listeners notified for each change of value of argument cell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockSimpleListener();
      c.addListener(listener);

      b.value = 8;
      a.value = 10;
      b.value = 100;

      verify(listener()).called(3);
    });

    test('ComputeCell listener not called after it is removed', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener = MockSimpleListener();

      c.addListener(listener);
      a.value = 8;

      c.removeListener(listener);
      b.value = 10;
      a.value = 100;

      verify(listener()).called(1);
    });

    test('All ComputeCell listeners called when value changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ComputeCell(
          compute: () => a.value + b.value,
          arguments: [a,b]
      );

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      c.addListener(listener1);
      a.value = 8;

      c.addListener(listener2);
      b.value = 10;
      a.value = 100;

      verify(listener1()).called(3);
      verify(listener2()).called(2);
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

      final listener = MockSimpleListener();

      a.value = 'bye';
      store.addListener(listener);

      expect(store.value, equals('bye'));
    });

    test('StoreCell listeners notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = a.store();

      final listener = MockSimpleListener();

      store.addListener(listener);
      a.value = 'bye';
      a.value = 'goodbye';

      verify(listener()).called(2);
    });

    test('All StoreCell listeners notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = a.store();

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      store.addListener(listener1);
      a.value = 'bye';

      store.addListener(listener2);
      a.value = 'goodbye';

      verify(listener1()).called(2);
      verify(listener2()).called(1);
    });

    test('StoreCell listener not called after it is removed', () {
      final a = MutableCell('hello');
      final store = a.store();

      final listener = MockSimpleListener();

      store.addListener(listener);
      a.value = 'bye';

      store.removeListener(listener);
      a.value = 'goodbye';

      verify(listener()).called(1);
    });

    test('StoreCell listeners not called when argument cell value does not change', () {
      final a = MutableCell(2);
      final b = a.apply((value) => value.isEven);
      final store = b.store();

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      b.addListener(listener1);
      store.addListener(listener2);

      a.value = 4;
      a.value = 6;
      a.value = 8;

      verify(listener1()).called(3);
      verifyNever(listener2());

      a.value = 11;

      verify(listener2()).called(1);
    });

    test('StoreCell.value updated when listener called', () {
      final cell = MutableCell('hello');
      final store = cell.store();

      final listener = MockValueListener(store);

      store.addListener(listener);

      cell.value = 'bye';
      verify(listener.gotValue('bye'));
    });
  });

  group('Cell initialization and cleanup', () {
    test('init() not called if no listeners added', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);
      
      verifyNever(resource.init());
    });

    test('init() called once when adding first listener', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1);
      cell.addListener(listener2);

      verify(resource.init()).called(1);
    });

    test('dispose() not called when not all listeners removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1);
      cell.addListener(listener2);

      cell.removeListener(listener1);

      verifyNever(resource.dispose());
    });

    test('dispose() called when all listeners removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1);
      cell.addListener(listener2);

      cell.removeListener(listener1);
      cell.removeListener(listener2);

      verify(resource.dispose()).called(1);
    });

    test('init() called again when adding new listener after all listeners removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1);
      cell.addListener(listener2);

      cell.removeListener(listener1);
      cell.removeListener(listener2);

      cell.addListener(listener1);

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

      final listener = MockSimpleListener();
      cell.value = 20;

      delay.addListener(listener);

      expect(delay.value, equals(20));
    });

    test('DelayCell.value is updated after setting argument cell value', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final listener = MockValueListener(delay);
      delay.addListener(listener);

      cell.value = 2;

      await untilCalled(listener.gotValue(2)).timeout(const Duration(seconds: 1), onTimeout: () {
        fail('DelayCell.value not updated');
      });
    });

    test('DelayCell.value listeners called for every argument cell value change', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final listener = MockValueListener(delay);
      delay.addListener(listener);

      cell.value = 2;
      cell.value = 5;

      await untilCalled(listener.gotValue(5)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      verify(listener.gotValue(any)).called(2);
    });

    test('DelayCell.value listener not called after it is removed', () async {
      final cell = MutableCell(1);
      final delay = DelayCell(const Duration(milliseconds: 1), cell);

      final listener1 = MockValueListener(delay);
      final listener2 = MockValueListener(delay);

      delay.addListener(listener1);
      delay.addListener(listener2);

      cell.value = 2;

      await untilCalled(listener1.gotValue(2)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      await untilCalled(listener2.gotValue(2)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      delay.removeListener(listener1);
      cell.value = 5;

      await untilCalled(listener2.gotValue(5)).timeout(const Duration(seconds: 2), onTimeout: () {
        fail('DelayCell.value not updated');
      });

      verify(listener1.gotValue(any)).called(1);
      verify(listener2.gotValue(any)).called(2);
    });
  });
}
