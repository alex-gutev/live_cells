import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:live_cells/live_cells.dart';
import 'package:mockito/mockito.dart';

/// Mock class interface for recording whether a listener was called
abstract class SimpleListener {
  /// Method added as listener function
  void onChange();
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
///   - Add [onChange] method as a listener of a cell
///   - verify(instance.onChange())
class MockSimpleListener extends Mock implements SimpleListener {}

/// Mock class implementing [ValueListener]
///
/// Usage:
///
///   - Add [onChange] method as a listener of a cell
///   - verify(instance.gotValue(expected))
class MockValueListener extends ValueListener with Mock {
  final ValueCell cell;

  MockValueListener(this.cell);

  void onChange() {
    gotValue(cell.value);
  }
}

/// Mock class implementing [AsyncValueListener]
///
/// Usage:
///
///   - Add [onChange] method as a listener of a cell
///   - verify(instance.gotValue(expected))
///   - verify(instance.hasValue(expected))
class MockAsyncValueListener extends AsyncValueListener with Mock {
  final FutureCell cell;

  MockAsyncValueListener(this.cell);

  void onChange() {
    hasValue(cell.hasValue);
    gotValue(cell.value);
  }
}

abstract class TestResource {
  void init();
  void dispose();
}

class MockResource extends Mock implements TestResource {
  void init();
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

      cell.addListener(listener.onChange);
      cell.value = 23;

      verify(listener.onChange()).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final listener = MockSimpleListener();

      cell.addListener(listener.onChange);

      cell.value = 23;
      cell.value = 101;

      verify(listener.onChange()).called(2);
    });

    test('MutableCell listener not called after it is removed', () {
      final cell = MutableCell(15);
      final listener = MockSimpleListener();

      cell.addListener(listener.onChange);
      cell.value = 23;

      cell.removeListener(listener.onChange);
      cell.value = 101;

      verify(listener.onChange()).called(1);
    });

    test('MutableCell listener not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final listener = MockSimpleListener();

      cell.addListener(listener.onChange);
      cell.value = 56;

      verifyNever(listener.onChange());
    });

    test('All MutableCell listeners called when value changes', () {
      final cell = MutableCell(3);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1.onChange);
      cell.value = 5;

      cell.addListener(listener2.onChange);
      cell.value = 8;
      cell.value = 12;

      verify(listener1.onChange()).called(3);
      verify(listener2.onChange()).called(2);
    });

    test('MutableCell.value updated when listener called', () {
      final cell = MutableCell('hello');
      final listener = MockValueListener(cell);

      cell.addListener(listener.onChange);

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

      eq.addListener(listener.onChange);
      a.value = 4;

      verify(listener.onChange()).called(1);
    });

    test('EqCell listeners notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final listener = MockSimpleListener();

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
      final listener = MockSimpleListener();

      neq.addListener(listener.onChange);
      a.value = 4;

      verify(listener.onChange()).called(1);
    });

    test('NeqCell listeners notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.eq(b);
      final listener = MockSimpleListener();

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

      final listener = MockSimpleListener();
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

      final listener = MockSimpleListener();
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

      final listener = MockSimpleListener();
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

      final listener = MockSimpleListener();

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

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      c.addListener(listener1.onChange);
      a.value = 8;

      c.addListener(listener2.onChange);
      b.value = 10;
      a.value = 100;

      verify(listener1.onChange()).called(3);
      verify(listener2.onChange()).called(2);
    });
  });

  group('StoreCell', () {
    test('StoreCell takes value of argument cell', () {
      final a = MutableCell('hello');
      final store = StoreCell(a);

      expect(store.value, equals('hello'));
    });

    test('StoreCell takes latest value of argument cell', () {
      final a = MutableCell('hello');
      final store = StoreCell(a);

      final listener = MockSimpleListener();

      a.value = 'bye';
      store.addListener(listener.onChange);

      expect(store.value, equals('bye'));
    });

    test('StoreCell listeners notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = StoreCell(a);

      final listener = MockSimpleListener();

      store.addListener(listener.onChange);
      a.value = 'bye';
      a.value = 'goodbye';

      verify(listener.onChange()).called(2);
    });

    test('All StoreCell listeners notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = StoreCell(a);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      store.addListener(listener1.onChange);
      a.value = 'bye';

      store.addListener(listener2.onChange);
      a.value = 'goodbye';

      verify(listener1.onChange()).called(2);
      verify(listener2.onChange()).called(1);
    });

    test('StoreCell listener not called after it is removed', () {
      final a = MutableCell('hello');
      final store = StoreCell(a);

      final listener = MockSimpleListener();

      store.addListener(listener.onChange);
      a.value = 'bye';

      store.removeListener(listener.onChange);
      a.value = 'goodbye';

      verify(listener.onChange()).called(1);
    });

    test('StoreCell listeners not called when argument cell value does not change', () {
      final a = MutableCell(2);
      final b = a.apply((value) => value.isEven);
      final store = StoreCell(b);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      b.addListener(listener1.onChange);
      store.addListener(listener2.onChange);

      a.value = 4;
      a.value = 6;
      a.value = 8;

      verify(listener1.onChange()).called(3);
      verifyNever(listener2.onChange());

      a.value = 11;

      verify(listener2.onChange()).called(1);
    });

    test('StoreCell.value updated when listener called', () {
      final cell = MutableCell('hello');
      final store = StoreCell(cell);

      final listener = MockValueListener(store);

      store.addListener(listener.onChange);

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

      cell.addListener(listener1.onChange);
      cell.addListener(listener2.onChange);

      verify(resource.init()).called(1);
    });

    test('dispose() not called when not all listeners removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1.onChange);
      cell.addListener(listener2.onChange);

      cell.removeListener(listener1.onChange);

      verifyNever(resource.dispose());
    });

    test('dispose() called when all listeners removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1.onChange);
      cell.addListener(listener2.onChange);

      cell.removeListener(listener1.onChange);
      cell.removeListener(listener2.onChange);

      verify(resource.dispose()).called(1);
    });

    test('init() called again when adding new listener after all listeners removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1.onChange);
      cell.addListener(listener2.onChange);

      cell.removeListener(listener1.onChange);
      cell.removeListener(listener2.onChange);

      cell.addListener(listener1.onChange);

      verify(resource.init()).called(2);
    });
  });

  group('FutureCell', () {
    test('FutureCell listeners called when Future value is ready', () async {
      final completer = Completer<int>();
      final cell = FutureCell.fromFuture(completer.future);

      final listener = MockSimpleListener();
      cell.addListener(listener.onChange);

      completer.complete(100);

      await untilCalled(listener.onChange()).timeout(Duration(seconds: 10), onTimeout: () {
        fail('listener not called after 10 seconds');
      });

      verify(listener.onChange()).called(1);
    });

    test('FutureCell listeners called when Future value is ready before construction', () async {
      final future = Future.value(200);
      final cell = FutureCell.fromFuture(future);

      final listener = MockSimpleListener();
      cell.addListener(listener.onChange);

      await untilCalled(listener.onChange()).timeout(Duration(seconds: 10), onTimeout: () {
        fail('listener not called after 10 seconds');
      });

      verify(listener.onChange()).called(1);
    });

    test('FutureCell.value is set to Future value', () async {
      final future = Future.value(10);
      final cell = FutureCell.fromFuture(future);

      final listener = MockAsyncValueListener(cell);
      cell.addListener(listener.onChange);

      await untilCalled(listener.hasValue(any))
          .timeout(Duration(seconds: 10), onTimeout: () {
            fail('Listener not called after 10 seconds');
      });

      verify(listener.hasValue(true)).called(1);
      verify(listener.gotValue(10)).called(1);
    });

    test('FutureCell.value is set when Future value is ready', () async {
      final completer = Completer<int>();
      final cell = FutureCell.fromFuture(completer.future);

      final listener = MockAsyncValueListener(cell);
      cell.addListener(listener.onChange);

      completer.complete(100);

      await untilCalled(listener.hasValue(any))
          .timeout(Duration(seconds: 10), onTimeout: () {
        fail('Listener not called after 10 seconds');
      });

      verify(listener.hasValue(true)).called(1);
      verify(listener.gotValue(100)).called(1);
    });

    test('All FutureCell listeners called when future is ready', () async {
      final completer = Completer<int>();
      final cell = FutureCell.fromFuture(completer.future);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1.onChange);
      cell.addListener(listener2.onChange);

      completer.complete(500);

      await untilCalled(listener1.onChange()).timeout(Duration(seconds: 10), onTimeout: () {
        fail('listener not called after 10 seconds');
      });

      verify(listener1.onChange()).called(1);
      verify(listener2.onChange()).called(1);
    });

    test('FutureCell listener not called after it is removed', () async {
      final completer = Completer<int>();
      final cell = FutureCell.fromFuture(completer.future);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.addListener(listener1.onChange);
      cell.addListener(listener2.onChange);

      cell.removeListener(listener2.onChange);

      completer.complete(600);

      await untilCalled(listener1.onChange()).timeout(Duration(seconds: 10), onTimeout: () {
        fail('listener not called after 10 seconds');
      });

      verify(listener1.onChange()).called(1);
      verifyNever(listener2.onChange());
    });

    test('FutureCell.value = defaultValue until future is complete', () async {
      final future = Future.value('bye');
      final cell = FutureCell.fromFuture(future, defaultValue: 'hello');

      expect(cell.value, equals('hello'));
    });

    test('Nullable type FutureCell.value = null until complete', () async {
      final future = Future.value('bye');
      final cell = FutureCell<String?>.fromFuture(future);

      expect(cell.value, equals(null));
    });

    test('FutureCell.value throws NoCellValueError until complete if no default value given', () async {
      final future = Future.value('bye');
      final cell = FutureCell.fromFuture(future);

      expect(() => cell.value, throwsA(isA<NoCellValueError>()));
    });
  });

  group('StreamCell', () {
    test('StreamCell.value is set to all values in stream in order', () async {
      final stream = Stream.fromIterable([1, 2, 3]);
      final cell = StreamCell(stream);

      final listener = MockAsyncValueListener(cell);
      cell.addListener(listener.onChange);

      await untilCalled(listener.gotValue(3))
          .timeout(Duration(seconds: 10), onTimeout: () {
        fail('Listener not called (for final stream value) after 10 seconds');
      });

      verify(listener.hasValue(true)).called(3);

      verifyInOrder([
        listener.gotValue(1),
        listener.gotValue(2),
        listener.gotValue(3)
      ]);
    });
  });
}
