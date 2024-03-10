import 'package:fake_async/fake_async.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'util.dart';
import 'util.mocks.dart';

void main() {
  group('Cell watcher', () {
    test('Watch function called once on registration', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      verify(observer.gotValue(any)).called(1);
    });

    test('Watch function called with correct cell values on registration', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      verify(observer.gotValue(3)).called(1);
    });

    test('Watch function called when referenced cell values change', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      a.value = 5;
      b.value = 10;

      verify(observer.gotValue(any)).called(3);
    });

    test('Cell values updated when function is called', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      a.value = 5;
      b.value = 10;

      verifyInOrder([
        observer.gotValue(3),
        observer.gotValue(7),
        observer.gotValue(15)
      ]);
    });

    test('Watch function called when referenced cell values change during batch update', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      MutableCell.batch(() {
        a.value = 5;
        b.value = 10;
      });

      verify(observer.gotValue(any)).called(2);
    });

    test('Cell values updated when function is called during batch update', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      MutableCell.batch(() {
        a.value = 5;
        b.value = 10;
      });

      verifyInOrder([
        observer.gotValue(3),
        observer.gotValue(15)
      ]);
    });

    test('Watch function called when cell value changes in conditional expression', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final select = MutableCell(true);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        if (select()) {
          observer.gotValue(a());
        }
        else {
          observer.gotValue(b());
        }
      });

      addTearDown(() => watcher.stop());

      a.value = 2;
      select.value = false;
      b.value = 5;

      verify(observer.gotValue(any)).called(4);
    });

    test('Watch function not called after CellWatcher.stop()', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final observer = MockValueObserver();

      final watcher = ValueCell.watch(() {
        observer.gotValue(a() + b());
      });

      addTearDown(() => watcher.stop());

      a.value = 5;
      b.value = 10;
      watcher.stop();

      b.value = 100;
      a.value = 30;

      verify(observer.gotValue(any)).called(3);
    });

    test('init() called when cell is watched', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final watcher = ValueCell.watch(() {
        cell();
      });

      addTearDown(() => watcher.stop());

      verify(resource.init()).called(1);
    });

    test('dispose() called after CellWatcher.stop', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final watcher = ValueCell.watch(() {
        cell() + cell();
      });

      watcher.stop();
      verify(resource.dispose()).called(1);
    });

    test('dispose() not called when not all watchers are stopped', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final watcher1 = ValueCell.watch(() {
        cell() + cell();
      });

      final watcher2 = ValueCell.watch(() {
        cell() * cell();
      });

      addTearDown(() {
        watcher1.stop();
        watcher2.stop();
      });

      watcher1.stop();
      verifyNever(resource.dispose());
    });

    test('Setting cells in watch function', () {
      final a = MutableCell(0);
      final b = MutableCell(0);

      final listener = addListener(b, MockSimpleListener());

      final watch = ValueCell.watch(() {
        b.value = a() + 1;
      });

      addTearDown(() => watch.stop());

      expect(b.value, 1);
      verify(listener()).called(1);

      a.value = 5;
      expect(b.value, 6);
      verify(listener()).called(1);
    });

    test('Setting cells with MutableCell.batch in watch function', () {
      final a = MutableCell(0);
      final b = MutableCell(0);
      final c = MutableCell(0);
      final d = (b + c).store();

      final observer = addObserver(d, MockValueObserver());

      final watch = ValueCell.watch(() {
        MutableCell.batch(() {
          b.value = a() + 1;
          c.value = a() + 2;
        });
      });

      addTearDown(() => watch.stop());

      expect(b.value, 1);
      expect(c.value, 2);
      expect(observer.values, equals([3]));

      a.value = 5;
      expect(b.value, 6);
      expect(c.value, 7);
      expect(observer.values, equals([3, 13]));
    });
  });

  group('changesOnly cell option', () {
    test('Observer.update() called with didChange = false, when value unchanged.', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final observer = MockSimpleObserver();
      addObserver(b, observer);

      a.value = [4, 2, 6];
      verify(observer.willUpdate(b)).called(1);
      verify(observer.update(b, false)).called(1);
      verifyNoMoreInteractions(observer);
    });

    test('Observer.update() called with didChange = true, when value changed.', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final observer = MockSimpleObserver();
      addObserver(b, observer);

      a.value = [7, 8, 9];
      verify(observer.willUpdate(b)).called(1);
      verify(observer.update(b, any)).called(1);
    });

    test('Watch function not called when didChange is false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final listener = addListener(b, MockSimpleListener());
      a.value = [4, 2, 6];

      verifyNever(listener());
    });

    test('Watch function not called when didChange is false in MutableCell.batch', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final listener = addListener(b, MockSimpleListener());

      MutableCell.batch(() {
        a.value = [4, 2, 6];
      });

      verifyNever(listener());
    });

    test('Watch function called when didChange is true after returning false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final listener = addListener(b, MockSimpleListener());

      a.value = [4, 2, 6];
      a.value = [7, 8, 9];

      verify(listener()).called(1);
    });

    test('Watch function called when didChange is true for at least one argument', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final c = MutableCell(3);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        b();
        c();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
        c.value = 5;
      });

      verify(listener()).called(2);
    });

    test('Computed cell not recomputed when didChange is false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = ValueCell.computed(() => b() * 10);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];

      verify(listener()).called(1);
    });

    test('Computed cell not recomputed when didChange is false in MutableCell.batch', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = ValueCell.computed(() => b() * 10);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
      });

      verify(listener()).called(1);
    });

    test('Computed cell recomputed when didChange is true after returning false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = ValueCell.computed(() => b() * 10);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      a.value = [7, 8, 9];

      verify(listener()).called(2);
    });

    test('Computed cell recomputed when didChange is true for at least one argument', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final c = MutableCell(3);
      final d = ValueCell.computed(() => b() * c());

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        d();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
        c.value = 5;
      });

      verify(listener()).called(2);
    });

    test('StoreCell not recomputed when didChange is false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = (b * 10.cell).store();

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];

      verify(listener()).called(1);
    });

    test('StoreCell not recomputed when didChange is false in MutableCell.batch', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = (b * 10.cell).store();

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
      });

      verify(listener()).called(1);
    });

    test('StoreCell recomputed when didChange is true after returning false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = (b * 10.cell).store();

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      a.value = [7, 8, 9];

      verify(listener()).called(2);
    });

    test('StoreCell recomputed when didChange is true for at least one argument', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final c = MutableCell(3);
      final d = (b * c).store();

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        d();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
        c.value = 5;
      });

      verify(listener()).called(2);
    });

    test('MutableComputeCell not recomputed when didChange is false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = (b, 10.cell).mutableApply((a1, a2) => a1 * a2, (_) {});

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];

      verify(listener()).called(1);
    });

    test('MutableComputeCell not recomputed when didChange is false in MutableCell.batch', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = (b, 10.cell).mutableApply((a1, a2) => a1 * a2, (_) {});

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
      });

      verify(listener()).called(1);
    });

    test('MutableComputeCell recomputed when didChange is true after returning false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = (b, 10.cell).mutableApply((a1, a2) => a1 * a2, (_) {});

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      a.value = [7, 8, 9];

      verify(listener()).called(2);
    });

    test('MutableComputeCell recomputed when didChange is true for at least one argument', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final c = MutableCell(3);
      final d = (b, c).mutableApply((b, c) => b * c, (_) {});

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        d();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
        c.value = 5;
      });

      verify(listener()).called(2);
    });

    test('DynamicMutableComputeCell not recomputed when didChange is false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = MutableCell.computed(() => b() * 10, (_) { });

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];

      verify(listener()).called(1);
    });

    test('DynamicMutableComputeCell not recomputed when didChange is false in MutableCell.batch', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = MutableCell.computed(() => b() * 10, (_) { });

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
      });

      verify(listener()).called(1);
    });

    test('DynamicMutableComputeCell recomputed when didChange is true after returning false', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final c = MutableCell.computed(() => b() * 10, (_) { });

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        c();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      a.value = [7, 8, 9];

      verify(listener()).called(2);
    });

    test('DynamicMutableComputeCell recomputed when didChange is true for at least one argument', () {
      final a = MutableCell([1, 2, 3]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);

      final c = MutableCell(3);
      final d = MutableCell.computed(() => b() * c(), (_) { });

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        d();
        listener();
      });

      addTearDown(watcher.stop);

      MutableCell.batch(() {
        a.value = [4, 2, 6];
        c.value = 5;
      });

      verify(listener()).called(2);
    });

    test('MutableComputedCell implements shouldNotify correctly', () {
      final a = MutableCell([1, 2, 3]);
      final b = MutableComputeCell(
          compute: () => a.value[1],
          reverseCompute: (_) {},
          arguments: {a},
          changesOnly: true
      );

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        b();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      verify(listener()).called(1);

      a.value = [7, 2, 8];
      verifyNever(listener());

      a.value = [9, 10, 11];
      verify(listener()).called(1);
    });

    test('DynamicMutableComputedCell implements shouldNotify correctly', () {
      final a = MutableCell([1, 2, 3]);
      final b = MutableCell.computed(() => a()[1], (_) {}, changesOnly: true);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        b();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      verify(listener()).called(1);

      a.value = [7, 2, 8];
      verifyNever(listener());

      a.value = [9, 10, 11];
      verify(listener()).called(1);
    });

    test('StoreCell implements shouldNotify correctly', () {
      final a = MutableCell([1, 2, 3]);
      final b = a.apply((a) => a[1]).store(changesOnly: true);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        b();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      verify(listener()).called(1);

      a.value = [7, 2, 8];
      verifyNever(listener());

      a.value = [9, 10, 11];
      verify(listener()).called(1);
    });

    test('MutableCellView implements shouldNotify correctly', () {
      final a = MutableCell([1, 2, 3]);
      final b = a.mutableApply((a) => a[1], (_) {}, changesOnly: true);

      final listener = MockSimpleListener();

      final watcher = ValueCell.watch(() {
        b();
        listener();
      });

      addTearDown(watcher.stop);

      a.value = [4, 2, 6];
      verify(listener()).called(1);

      a.value = [7, 2, 8];
      verifyNever(listener());

      a.value = [9, 10, 11];
      verify(listener()).called(1);
    });
  });

  group('Peek cell values', () {
    test('ValueCell.peek.value == ValueCell.value', () {
      final cell = MutableCell(0);
      final peek = cell.peek;

      expect(peek.value, equals(0));

      cell.value = 2;
      expect(peek.value, equals(2));
    });

    test('ValueCell.peek does not notify observers when cell value changed', () {
      final a = MutableCell(0);
      final b = MutableCell(1);

      final sum = ValueCell.computed(() => a.peek() + b());
      final observer = addObserver(sum, MockValueObserver());

      a.value = 1;
      a.value = 2;
      a.value = 3;
      b.value = 5;
      b.value = 10;
      a.value = 2;
      b.value = 13;

      expect(observer.values, equals([8, 13, 15]));
    });

    test("PeekCell's compare == if they have the same argument cell", () {
      final a = MutableCell(0);

      final p1 = a.peek;
      final p2 = a.peek;

      expect(p1 == p2, isTrue);
      expect(p1.hashCode == p2.hashCode, isTrue);
    });

    test("PeekCell's compare != if they different same argument cells", () {
      final a = MutableCell(0);
      final b = MutableCell(1);

      final p1 = a.peek;
      final p2 = b.peek;

      expect(p1 != p2, isTrue);
      expect(p1 == p1, isTrue);
    });

    test("PeekCell's manage the same set of observers", () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);

      p() => a.peek;

      verifyNever(resource.init());

      final observer = addObserver(p(), MockSimpleObserver());
      p().removeObserver(observer);

      verify(resource.init()).called(1);
      verify(resource.dispose()).called(1);
    });

    test("Removing PeekCell observer removes correct observer", () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);

      p() => a.peek;

      verifyNever(resource.init());

      addObserver(p(), MockSimpleObserver());
      final observer2 = MockSimpleObserver();

      p().removeObserver(observer2);

      verify(resource.init()).called(1);
      verifyNever(resource.dispose());
    });
  });

  group('ValueChangeExtension', () {
    group ('.nextValue()', () {
      test('Completes when MutableCell value changed', () {
        final a = MutableCell(0);
        final future = a.nextValue();

        a.value = 1;
        expect(future, completion(1));
      });

      test('Completes when computed cell value changed', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() + 1);

        final future = b.nextValue();

        a.value = 1;
        expect(future, completion(2));
      });

      test('Completes on first change only', () {
        final a = MutableCell(0);
        final future = a.nextValue();

        a.value = 1;
        a.value = 10;

        expect(future, completion(1));
      });

      test('Completes with error if exception is thrown', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() >= 0 ? a() : throw ArgumentError());

        final future = b.nextValue();
        a.value = -1;

        expect(future, throwsArgumentError);
      });

      test('Completes only on actual value change of MutableCell', () {
        final a = MutableCell(0);
        final future = a.nextValue();

        a.value = 0;
        expect(future, doesNotComplete);
      });

      test('Completes only on actual value change when changesOnly: true', () {
        final a = MutableCell(0);
        final b = (a % 2.cell).store(changesOnly: true);
        final future = b.nextValue();

        a.value = 10;
        expect(future, doesNotComplete);
      });

      test('Completes if cell is updated to same value with changesOnly: false', () {
        final a = MutableCell(0);
        final b = (a % 2.cell).store(changesOnly: false);
        final future = b.nextValue();

        a.value = 10;
        expect(future, completion(0));
      });

      test('Does not leak resources', () {
        fakeAsync((async) {
          final resource = MockResource();
          final a = TestManagedCell(resource, 1);
          final b = MutableCell(2);
          final sum = (a + b).store();

          sum.nextValue();
          b.value = 3;

          async.elapse(Duration(seconds: 1));

          verify(resource.dispose()).called(1);
        });
      });
    });

    group ('.untilValue()', () {
      test('Completes when MutableCell value set to expected value', () {
        final a = MutableCell(0);
        final future = a.untilValue(10);

        a.value = 10;
        expect(future, completes);
      });

      test('Completes when MutableCell value is already expected value', () {
        final a = MutableCell(3);
        expect(a.untilValue(3), completes);
      });

      test('Does not complete when MutableCell value not set to expected value', () {
        final a = MutableCell(0);
        final future = a.untilValue(5);

        a.value = 10;
        expect(future, doesNotComplete);
      });

      test('Completes when computed cell value equals expected value', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() + 1);

        final future = b.untilValue(2);

        a.value = 1;
        expect(future, completes);
      });

      test('Completes when computed cell is already expected value', () {
        final a = MutableCell(3);
        final b = ValueCell.computed(() => a() + 1);

        expect(b.untilValue(4), completes);
      });

      test('Does not complete when computed cell value does not equal expected value', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() + 1);

        final future = b.untilValue(2);

        a.value = 5;
        expect(future, doesNotComplete);
      });

      test('Completes if condition satisfied on second change', () {
        final a = MutableCell(0);
        final future = a.untilValue(10);

        a.value = 1;
        a.value = 10;

        expect(future, completes);
      });

      test('Exceptions handled', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() >= 0 ? a() : throw ArgumentError());

        final future = b.untilValue(-1);
        a.value = -1;

        expect(future, doesNotComplete);
      });

      test('Does not leak resources', () {
        fakeAsync((async) {
          final resource = MockResource();
          final a = TestManagedCell(resource, 1);
          final b = MutableCell(2);
          final sum = (a + b).store();

          sum.untilValue(4);
          b.value = 3;

          async.elapse(Duration(seconds: 1));

          verify(resource.dispose()).called(1);
        });
      });
    });

    group ('.untilTrue()', () {
      test('Completes when MutableCell value set to true', () {
        final a = MutableCell(false);
        final future = a.untilTrue();

        a.value = true;
        expect(future, completes);
      });

      test('Completes when MutableCell value is already true', () {
        final a = MutableCell(true);
        expect(a.untilTrue(), completes);
      });

      test('Does not complete when MutableCell value changes to false', () {
        final a = MutableCell(false);
        final future = a.untilTrue();

        a.value = false;
        expect(future, doesNotComplete);
      });

      test('Completes when computed cell value is true', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() % 2 != 0);

        final future = b.untilTrue();

        a.value = 1;
        expect(future, completes);
      });

      test('Completes when computed cell is already true', () {
        final a = MutableCell(3);
        final b = ValueCell.computed(() => a() % 2 != 0);

        expect(b.untilTrue(), completes);
      });

      test('Does not complete when computed cell value is not true', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() % 2 != 0);

        final future = b.untilTrue();

        a.value = 6;
        expect(future, doesNotComplete);
      });

      test('Completes if value is true on second change', () {
        final a = MutableCell(false);
        final future = a.untilTrue();

        a.value = false;
        a.value = true;

        expect(future, completes);
      });

      test('Exceptions handled', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() > 0 ? true : throw ArgumentError());

        final future = b.untilTrue();
        a.value = -1;

        expect(future, doesNotComplete);
      });

      test('Does not leak resources', () {
        fakeAsync((async) {
          final resource = MockResource();
          final a = TestManagedCell(resource, true);
          final b = MutableCell(false);
          final c = a.and(b).store();

          c.untilTrue();
          b.value = true;

          async.elapse(Duration(seconds: 1));

          verify(resource.dispose()).called(1);
        });
      });
    });

    group ('.untilFalse()', () {
      test('Completes when MutableCell value set to false', () {
        final a = MutableCell(true);
        final future = a.untilFalse();

        a.value = false;
        expect(future, completes);
      });

      test('Completes when MutableCell value is already false', () {
        final a = MutableCell(false);
        expect(a.untilFalse(), completes);
      });

      test('Does not complete when MutableCell value changes to true', () {
        final a = MutableCell(true);
        final future = a.untilFalse();

        a.value = true;
        expect(future, doesNotComplete);
      });

      test('Completes when computed cell value is false', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() % 2 == 0);

        final future = b.untilFalse();

        a.value = 1;
        expect(future, completes);
      });

      test('Completes when computed cell is already false', () {
        final a = MutableCell(3);
        final b = ValueCell.computed(() => a() % 2 == 0);

        expect(b.untilFalse(), completes);
      });

      test('Does not complete when computed cell value is not false', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() % 2 == 0);

        final future = b.untilFalse();

        a.value = 6;
        expect(future, doesNotComplete);
      });

      test('Completes if value is false on second change', () {
        final a = MutableCell(true);
        final future = a.untilFalse();

        a.value = true;
        a.value = false;

        expect(future, completes);
      });

      test('Exceptions handled', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() > 0 ? true : throw ArgumentError());

        final future = b.untilFalse();
        a.value = -1;

        expect(future, doesNotComplete);
      });

      test('Does not leak resources', () {
        fakeAsync((async) {
          final resource = MockResource();
          final a = TestManagedCell(resource, true);
          final b = MutableCell(true);
          final c = a.and(b).store();

          c.untilFalse();
          b.value = false;

          async.elapse(Duration(seconds: 1));

          verify(resource.dispose()).called(1);
        });
      });
    });
  });
}