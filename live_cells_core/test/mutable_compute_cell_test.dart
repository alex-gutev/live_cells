import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'util.dart';
import 'util.mocks.dart';

void main() {
  group('MutableComputeCell', () {
    test('MutableComputeCell.value computed on construction', () {
      final a = MutableCell(1);
      final b = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (b) {
            a.value = b - 1;
          }
      );

      expect(b.value, equals(2));
    });

    test('MutableComputeCell.value recomputed when value of argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (b) {
            a.value = b - 1;
          }
      );

      final observer = MockSimpleObserver();

      addObserver(b, observer);
      a.value = 5;

      expect(b.value, equals(6));
    });

    test('MutableComputeCell.value recomputed when value of 1st argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a, b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer = MockSimpleObserver();

      addObserver(c, observer);
      a.value = 5;

      expect(c.value, equals(8));
    });

    test('MutableComputeCell.value recomputed when value of 2nd argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a, b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer = MockSimpleObserver();

      addObserver(c, observer);
      b.value = 9;

      expect(c.value, equals(10));
    });

    test('MutableComputeCell observers notified when value is recomputed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a, b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer = MockSimpleObserver();

      addObserver(c, observer);
      b.value = 9;
      a.value = 10;

      verify(observer.update(c, any)).called(2);
    });

    test('MutableComputeCell observer not called after it is removed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a,b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(c, observer1);
      addObserver(c, observer2);
      b.value = 9;

      c.removeObserver(observer1);
      a.value = 10;

      verify(observer1.update(c, any)).called(1);
      verify(observer2.update(c, any)).called(2);
    });

    test('Setting MutableComputeCell.value updates values of argument cells', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a, b) => a + b,
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

      final c = (a, b).mutableApply(
              (a, b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);

      c.value = 10;

      verify(observerA.update(a, any)).called(1);
      verify(observerB.update(b, any)).called(1);
      verify(observerC.update(c, any)).called(1);
    });

    test('Observers of MutableComputeCell and argument cells called every time value is set', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a, b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);

      c.value = 10;
      c.value = 12;

      verify(observerA.update(a, any)).called(2);
      verify(observerB.update(b, any)).called(2);
      verify(observerC.update(c, any)).called(2);
    });

    test('Consistency of values maintained when setting MutableComputeCell.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply(
              (a, b) => a + b,
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

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);
      addObserver(e, observerE);

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

      final c = (a, b).mutableApply(
              (a, b) => a + b,
              (c) {
            final half = c / 2;

            a.value = half;
            b.value = half;
          }
      );

      final d = MutableCell(50);
      final e = (c + d).store();

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();
      final observerE = MockSimpleObserver();

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);
      addObserver(e, observerE);

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      verify(observerA.update(a, any)).called(1);
      verify(observerB.update(b, any)).called(1);
      verify(observerC.update(c, any)).called(1);
      verify(observerE.update(e, any)).called(1);
    });

    test('All MutableComputeCell observers called correct number of times', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = (a, b).mutableApply((a, b) => a + b, (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      });

      final c = (a + sum).store();
      final d = sum + 2.cell;

      final observerC = MockSimpleObserver();
      final observerD = MockSimpleObserver();

      addObserver(c, observerC);
      addObserver(d, observerD);

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

      verify(observerC.update(c, any)).called(3);
      verify(observerD.update(d, any)).called(3);
    });

    test('Correct values produced with MutableComputeCell across all observer cells', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = (a, b).mutableApply((a, b) => a + b, (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      });

      final c = a + sum;
      final d = sum + 2.cell;

      final observerC = MockValueObserver();
      final observerD = MockValueObserver();

      addObserver(c, observerC);
      addObserver(d, observerD);

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

    test('Previous MutableComputeCell.value preserved if ValueCell.none is used', () {
      final a = MutableCell(0);
      final evens = MutableComputeCell(arguments: {a}, compute: () => a().isEven ? a() : ValueCell.none(), reverseCompute: (v) {
        a.value = v;
      });

      final observer = addObserver(evens, MockValueObserver());

      a.value = 1;
      a.value = 2;
      a.value = 3;
      a.value = 4;
      a.value = 5;

      expect(observer.values, equals([0, 2, 4]));

    });

    test('MutableComputeCell.value initialized to defaultValue if ValueCell.none is used', () {
      final a = MutableCell(1);
      final evens = MutableComputeCell(arguments: {a}, compute: () => a().isEven ? a() : ValueCell.none(10), reverseCompute: (v) {
        a.value = v;
      });

      final observer = addObserver(evens, MockValueObserver());

      a.value = 3;
      a.value = 4;
      a.value = 5;
      a.value = 6;

      expect(observer.values, equals([10, 4, 6]));
    });

    test('Exception on initialization of value reproduced on value access', () {
      final a = MutableCell(0);
      final cell = MutableComputeCell(arguments: {a}, compute: () => a() == 0 ? throw Exception() : a(), reverseCompute: (val) {
        a.value = val;
      });

      expect(() => cell.value, throwsException);
    });

    test('Exception on initialization of value reproduced on value access while observed', () {
      final a = MutableCell(0);
      final cell = MutableComputeCell(arguments: {a}, compute: () => a() == 0 ? throw Exception() : a(), reverseCompute: (val) {
        a.value = val;
      });

      observeCell(cell);
      expect(() => cell.value, throwsException);
    });

    test('Compares == when same key', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key1'
      );

      expect(b1 == b2, isTrue);
      expect(b1.hashCode == b2.hashCode, isTrue);
    });

    test('Compares != when different keys', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key2'
      );

      expect(b1 != b2, isTrue);
      expect(b1 == b1, isTrue);
    });

    test('Compares != when null keys', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1
      );

      expect(b1 != b2, isTrue);
      expect(b1 == b1, isTrue);
    });

    test('Cells with the same keys share the same state', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      observeCell(b1);
      observeCell(b2);

      b1.value = 10;
      expect(a.value, 15);
      expect(b1.value, 10);
      expect(b2.value, 10);

      b2.value = 20;
      expect(a.value, 25);
      expect(b1.value, 20);
      expect(b2.value, 20);
    });

    test('Cells with the same keys manage the same set of observers', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      observeCell(b1);
      observeCell(b2);

      final observer1 = addObserver(b1, MockValueObserver());
      final observer2 = addObserver(b2, MockValueObserver());

      b1.value = 10;
      b2.value = 20;
      b1.value = 30;
      b2.value = 40;

      b2.removeObserver(observer1);
      b1.value = 50;

      b2.removeObserver(observer2);
      b1.value = 60;
      b2.value = 70;

      expect(observer1.values, equals([10, 20, 30, 40]));
      expect(observer2.values, equals([10, 20, 30, 40, 50]));
    });

    test('Cells with different keys do not share the same state', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key2'
      );

      observeCell(b1);
      observeCell(b2);

      b1.value = 10;
      expect(a.value, 15);
      expect(b1.value, 10);
      expect(b2.value, 16);

      b2.value = 20;
      expect(a.value, 25);
      expect(b1.value, 26);
      expect(b2.value, 20);
    });

    test('Cells with different keys manage different sets of observers', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key2'
      );

      observeCell(b1);
      observeCell(b2);

      final observer1 = addObserver(b1, MockValueObserver());
      final observer2 = addObserver(b2, MockValueObserver());

      b1.value = 10;
      b2.value = 20;
      b1.value = 30;
      b2.value = 40;

      b2.removeObserver(observer1);
      b1.value = 50;

      b1.removeObserver(observer2);
      b1.value = 60;
      b2.value = 70;

      expect(observer1.values, equals([10, 26, 30, 46, 50, 60, 76]));
      expect(observer2.values, equals([16, 20, 36, 40, 56, 66, 70]));
    });

    test('State recreated after disposal when using keys', () {
      final a = MutableCell(0);

      final b = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      // The cell's value is recomputed when its state is initialized
      final observer1 = addObserver(b, MockSimpleObserver());
      expect(b.value, 1);

      b.value = 10;
      b.value = 15;

      expect(b.value, 15);

      // The cell's value is recomputed when its state is recreated
      b.removeObserver(observer1);

      // The cell's value is recomputed when its state is initialized
      addObserver(b, MockSimpleObserver());
      expect(b.value, 21);

      b.value = 17;
      expect(b.value, 17);
    });

    test('Cells with keys do not leak resources', () {
      final resource = MockResource();
      final testCell = TestManagedCell(resource, 1);

      final a = MutableCell(0);

      final b = MutableComputeCell(
          arguments: {a, testCell},
          compute: () => a.value + testCell.value,
          reverseCompute: (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final observer = addObserver(b, MockSimpleObserver());

      expect(CellState.maybeGetState('mutable-cell-key1'), isNotNull);
      verifyNever(resource.dispose());

      b.value = 5;

      b.removeObserver(observer);
      expect(CellState.maybeGetState('mutable-cell-key1'), isNull);

      verify(resource.dispose()).called(1);
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

      addObserver(b, observer);
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

      addObserver(c, observer);
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

      addObserver(c, observer);
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

      addObserver(c, observer);
      b.value = 9;
      a.value = 10;

      verify(observer.update(c, any)).called(2);
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

      addObserver(c, observer1);
      addObserver(c, observer2);
      b.value = 9;

      c.removeObserver(observer1);
      a.value = 10;

      verify(observer1.update(c, any)).called(1);
      verify(observer2.update(c, any)).called(2);
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

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);

      c.value = 10;

      verify(observerA.update(a, any)).called(1);
      verify(observerB.update(b, any)).called(1);
      verify(observerC.update(c, any)).called(1);
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

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);

      c.value = 10;
      c.value = 12;

      verify(observerA.update(a, any)).called(2);
      verify(observerB.update(b, any)).called(2);
      verify(observerC.update(c, any)).called(2);
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

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);
      addObserver(e, observerE);

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

      final observerA = MockSimpleObserver();
      final observerB = MockSimpleObserver();
      final observerC = MockSimpleObserver();
      final observerE = MockSimpleObserver();

      addObserver(a, observerA);
      addObserver(b, observerB);
      addObserver(c, observerC);
      addObserver(e, observerE);

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      verify(observerA.update(a, any)).called(1);
      verify(observerB.update(b, any)).called(1);
      verify(observerC.update(c, any)).called(1);
      verify(observerE.update(e, any)).called(1);
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

      addObserver(c, observerC);
      addObserver(d, observerD);

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

      verify(observerC.update(c, any)).called(3);
      verify(observerD.update(d, any)).called(3);
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

      addObserver(c, observerC);
      addObserver(d, observerD);

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
      addObserver(d, observer);

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
      addObserver(f, observer);

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
      addObserver(result, observer);

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
      addObserver(result, observer);

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

    test('Previous DynamicMutableComputeCell.value preserved if ValueCell.none is used', () {
      final a = MutableCell(0);
      final evens = MutableCell.computed(() => a().isEven ? a() : ValueCell.none(), (a) {
        a.value = a;
      });

      final observer = addObserver(evens, MockValueObserver());

      a.value = 1;
      a.value = 2;
      a.value = 3;
      a.value = 4;
      a.value = 5;

      expect(observer.values, equals([0, 2, 4]));
    });

    test('DynamicMutableComputeCell.value initialized to defaultValue if ValueCell.none is used', () {
      final a = MutableCell(1);
      final evens = MutableCell.computed(() => a().isEven ? a() : ValueCell.none(20), (a) {
        a.value = a;
      });

      final observer = addObserver(evens, MockValueObserver());

      a.value = 3;
      a.value = 4;
      a.value = 5;
      a.value = 6;

      expect(observer.values, equals([20, 4, 6]));
    });

    test('Exception on initialization of value reproduced on value access', () {
      final a = MutableCell(0);
      final cell = MutableCell.computed(() => a() == 0 ? throw Exception() : a(), (val) {
        a.value = val;
      });

      expect(() => cell.value, throwsException);
    });

    test('Exception on initialization of value reproduced on value access while observed', () {
      final a = MutableCell(0);
      final cell = MutableCell.computed(() => a() == 0 ? throw Exception() : a(), (val) {
        a.value = val;
      });

      observeCell(cell);
      expect(() => cell.value, throwsException);
    });

    test('Compares == when same key', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key1'
      );

      expect(b1 == b2, isTrue);
      expect(b1.hashCode == b2.hashCode, isTrue);
    });

    test('Compares != when different keys', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1,
          key: 'mutable-cell-key2'
      );

      expect(b1 != b2, isTrue);
      expect(b1 == b1, isTrue);
    });

    test('Compares != when null keys', () {
      final a = MutableCell(0);

      final b1 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1
      );

      final b2 = MutableComputeCell(
          arguments: {a},
          compute: () => a.value + 1,
          reverseCompute: (v) => a.value = v - 1
      );

      expect(b1 != b2, isTrue);
      expect(b1 == b1, isTrue);
    });

    test('Cells with the same keys share the same state', () {
      final a = MutableCell(0);

      final b1 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      observeCell(b1);
      observeCell(b2);

      b1.value = 10;
      expect(a.value, 15);
      expect(b1.value, 10);
      expect(b2.value, 10);

      b2.value = 20;
      expect(a.value, 25);
      expect(b1.value, 20);
      expect(b2.value, 20);
    });

    test('Cells with the same keys manage the same set of observers', () {
      final a = MutableCell(0);

      final b1 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      observeCell(b1);
      observeCell(b2);

      final observer1 = addObserver(b1, MockValueObserver());
      final observer2 = addObserver(b2, MockValueObserver());

      b1.value = 10;
      b2.value = 20;
      b1.value = 30;
      b2.value = 40;

      b2.removeObserver(observer1);
      b1.value = 50;

      b2.removeObserver(observer2);
      b1.value = 60;
      b2.value = 70;

      expect(observer1.values, equals([10, 20, 30, 40]));
      expect(observer2.values, equals([10, 20, 30, 40, 50]));
    });

    test('Cells with different keys do not share the same state', () {
      final a = MutableCell(0);

      final b1 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key2'
      );

      observeCell(b1);
      observeCell(b2);

      b1.value = 10;
      expect(a.value, 15);
      expect(b1.value, 10);
      expect(b2.value, 16);

      b2.value = 20;
      expect(a.value, 25);
      expect(b1.value, 26);
      expect(b2.value, 20);
    });

    test('Cells with different keys manage different sets of observers', () {
      final a = MutableCell(0);

      final b1 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final b2 = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key2'
      );

      observeCell(b1);
      observeCell(b2);

      final observer1 = addObserver(b1, MockValueObserver());
      final observer2 = addObserver(b2, MockValueObserver());

      b1.value = 10;
      b2.value = 20;
      b1.value = 30;
      b2.value = 40;

      b2.removeObserver(observer1);
      b1.value = 50;

      b1.removeObserver(observer2);
      b1.value = 60;
      b2.value = 70;

      expect(observer1.values, equals([10, 26, 30, 46, 50, 60, 76]));
      expect(observer2.values, equals([16, 20, 36, 40, 56, 66, 70]));
    });

    test('State recreated after disposal when using keys', () {
      final a = MutableCell(0);

      final b = MutableCell.computed(() => a() + 1, (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      // The cell's value is recomputed when its state is initialized
      final observer1 = addObserver(b, MockSimpleObserver());
      expect(b.value, 1);

      b.value = 10;
      b.value = 15;

      expect(b.value, 15);

      // The cell's value is recomputed when its state is recreated
      b.removeObserver(observer1);

      // The cell's value is recomputed when its state is initialized
      addObserver(b, MockSimpleObserver());
      expect(b.value, 21);

      b.value = 17;
      expect(b.value, 17);
    });

    test('Cells with keys do not leak resources', () {
      final resource = MockResource();
      final testCell = TestManagedCell(resource, 1);

      final a = MutableCell(0);

      final b = MutableCell.computed(() => a() + testCell(), (v) => a.value = v + 5,
          key: 'mutable-cell-key1'
      );

      final observer = addObserver(b, MockSimpleObserver());

      expect(CellState.maybeGetState('mutable-cell-key1'), isNotNull);
      verifyNever(resource.dispose());

      b.value = 5;

      b.removeObserver(observer);
      expect(CellState.maybeGetState('mutable-cell-key1'), isNull);

      verify(resource.dispose()).called(1);
    });
  });

  group('MutableCellView', () {
    test('MutableCellView.value computed on construction', () {
      final a = MutableCell(1);
      final b = a.mutableApply((a) => a + 1, (b) => a.value = b - 1);

      expect(b.value, equals(2));
    });

    test('MutableCellView.value recomputed when value of argument cell changes', () {
      final a = MutableCell(1);
      final b = a.mutableApply((a) => a + 1, (b) => a.value = b - 1);

      observeCell(b);
      a.value = 5;

      expect(b.value, equals(6));
    });

    test('MutableCellView.value recomputed when value of 1st argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      a.value = 5;

      expect(c.value, equals(8));
    });

    test('MutableCellView.value recomputed when value of 2nd argument cell changes', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      b.value = 9;

      expect(c.value, equals(10));
    });

    test('MutableCellView observers notified when value is recomputed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      final observer = addObserver(c, MockSimpleObserver());

      a.value = 6;
      b.value = 10;

      verify(observer.update(c, any)).called(2);
    });

    test('MutableCellView observer not called after it is removed', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      final observer1 = addObserver(c, MockSimpleObserver());
      final observer2 = addObserver(c, MockSimpleObserver());

      b.value = 9;

      c.removeObserver(observer1);
      a.value = 10;

      verify(observer1.update(c, any)).called(1);
      verify(observer2.update(c, any)).called(2);
    });

    test('Setting MutableCellView.value updates values of argument cell', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      c.value = 10;

      expect(a.value, equals(5));
      expect(b.value, equals(5));
      expect(c.value, equals(10));
    });

    test('Setting MutableCellView.value calls observers of MutableCell and argument cells', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      final observerA = addListener(a, MockSimpleListener());
      final observerB = addListener(b, MockSimpleListener());
      final observerC = addListener(c, MockSimpleListener());

      c.value = 10;

      verify(observerA()).called(1);
      verify(observerB()).called(1);
      verify(observerC()).called(1);
    });

    test('Observers of MutableCellView and argument cells called every time value is set', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      final observerA = addListener(a, MockSimpleListener());
      final observerB = addListener(b, MockSimpleListener());
      final observerC = addListener(c, MockSimpleListener());

      c.value = 10;
      c.value = 12;

      verify(observerA()).called(2);
      verify(observerB()).called(2);
      verify(observerC()).called(2);
    });

    test('Consistency of values maintained when setting MutableCellView.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      final d = MutableCell(50);
      final e = ValueCell.computed(() => c() + d());

      final observerA = addObserver(a, MockValueObserver());
      final observerB = addObserver(b, MockValueObserver());
      final observerC = addObserver(c, MockValueObserver());
      final observerE = addObserver(e, MockValueObserver());

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      expect(observerA.values, equals([5]));
      expect(observerB.values, equals([5]));
      expect(observerC.values, equals([10]));
      expect(observerE.values, equals([19]));
    });

    test('Observers notified correct number of times when setting MutableCellView.value in batch update', () {
      final a = MutableCell(1.0);
      final b = MutableCell(3.0);

      final c = (a, b).mutableApply((a, b) => a + b, (c) {
        final half = c / 2;

        a.value = half;
        b.value = half;
      }, key: 'key'); // A non-null key to create a MutableCellView

      final d = MutableCell(50);
      final e = ValueCell.computed(() => c() + d());

      final observerA = addListener(a, MockSimpleListener());
      final observerB = addListener(b, MockSimpleListener());
      final observerC = addListener(c, MockSimpleListener());
      final observerE = addListener(e, MockSimpleListener());

      MutableCell.batch(() {
        c.value = 10;
        d.value = 9;
      });

      verify(observerA()).called(1);
      verify(observerB()).called(1);
      verify(observerC()).called(1);
      verify(observerE()).called(1);
    });

    test('All MutableCellView observers called correct number of times', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = (a, b).mutableApply((a, b) => a + b, (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      }, key: 'A key'); // A non-null key to create a MutableCellView

      final c = (a + sum).store();
      final d = sum + 2.cell;

      final observerC = addListener(c, MockSimpleListener());
      final observerD = addListener(d, MockSimpleListener());

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

      verify(observerC()).called(3);
      verify(observerD()).called(3);
    });

    test('Correct values produced with MutableCellView across all observer cells', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final sum = (a, b).mutableApply((a, b) => a + b, (sum) {
        final half = sum ~/ 2;
        a.value = half;
        b.value = half;
      }, key: 'A key'); // A non-null key to create a MutableCellView

      final c = ValueCell.computed(() => a() + sum());
      final d = ValueCell.computed(() => sum() + 2);

      final observerC = addObserver(c, MockValueObserver());
      final observerD = addObserver(d, MockValueObserver());

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

    test('Exception on initialization of value reproduced on value access', () {
      final a = MutableCell(0);
      final cell = a.mutableApply((a) => a == 0 ? throw Exception() : a, (v) => a.value = v);

      expect(() => cell.value, throwsException);
    });

    test('Exception on initialization of value reproduced on value access while observed', () {
      final a = MutableCell(0);
      final cell = a.mutableApply((a) => a == 0 ? throw Exception() : a, (v) => a.value = v);

      observeCell(cell);
      expect(() => cell.value, throwsException);
    });

    test("MutableCellView's compare == if they have the same keys", () {
      final a = MutableCell(0);

      final b1 = a.mutableApply((a) => a + 1, (v) => v - 1, key: 'theKey');
      final b2 = a.mutableApply((a) => a + 1, (v) => v - 1, key: 'theKey');

      expect(b1 == b2, isTrue);
      expect(b1.hashCode == b2.hashCode, isTrue);
    });

    test("MutableCellView's compare != if they have different keys", () {
      final a = MutableCell(0);

      final b1 = a.mutableApply((a) => a + 1, (v) => v - 1, key: 'theKey');
      final b2 = a.mutableApply((a) => a + 1, (v) => v - 1, key: 'theKey1');

      expect(b1 != b2, isTrue);
    });

    test("MutableCellView's compare != if they have null keys", () {
      final a = MutableCell(0);

      final b1 = a.mutableApply((a) => a + 1, (v) => v - 1);
      final b2 = a.mutableApply((a) => a + 1, (v) => v - 1);

      expect(b1 != b2, isTrue);
      expect(b1 == b1, isTrue);
    });
  });
}
