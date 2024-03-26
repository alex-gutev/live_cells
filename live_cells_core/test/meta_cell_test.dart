import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';
import 'package:mockito/mockito.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'util.dart';
import 'util.mocks.dart';

void main() {
  group('MetaCell', () {
    test('Takes value of referenced cell when initialized', () {
      final meta = MetaCell<int>();
      observeCell(meta);

      meta.setCell(1.cell);
      expect(meta.value, 1);

      meta.setCell(14.cell);
      expect(meta.value, 14);
    });

    test('Observers notified when referenced cell value changes', () {
      final a = MutableCell(0);
      final b = MutableCell(10);

      final meta = MetaCell<int>();
      final observer = addObserver(meta, MockValueObserver());

      a.value = 1;
      meta.setCell(a);

      a.value = 2;
      a.value = 3;
      a.value = 4;
      b.value = 11;

      meta.setCell(b);
      a.value = 5;
      b.value = 12;
      b.value = 13;
      b.value = 14;

      expect(observer.values, equals([2, 3, 4, 12, 13, 14]));
    });

    test('Does not leak resources', () {
      final resource1 = MockResource();
      final resource2 = MockResource();

      final a = TestManagedCell(resource1, 1);
      final b = TestManagedCell(resource2, 2);

      final meta = MetaCell<int>();
      observeCell(meta);

      meta.setCell(a);

      expect(meta.value, 1);
      verify(resource1.init()).called(1);
      verifyNever(resource1.dispose());

      meta.setCell(b);

      expect(meta.value, 2);
      verifyNever(resource1.init());
      verify(resource1.dispose()).called(1);
      verify(resource2.init()).called(1);
      verifyNever(resource2.dispose());
    });

    test('Throws EmptyMetaCellError when no cell set', () {
      final meta = MetaCell<int>();
      observeCell(meta);

      expect(() => meta.value, throwsA(isA<EmptyMetaCellError>()));
    });

    test('Compares == when same key', () {
      final a = MetaCell(key: 'meta-cell-key1');
      final b = MetaCell(key: 'meta-cell-key1');

      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('Compares != with different keys', () {
      final a = MetaCell(key: 'meta-cell-key1');
      final b = MetaCell(key: 'meta-cell-key2');

      expect(a != b, isTrue);
      expect(a == a, isTrue);
    });

    test('Cells with the same key share the same state', () {
      final a = MetaCell<int>(key: 'meta-cell-key1');
      final b = MetaCell<int>(key: 'meta-cell-key1');

      observeCell(a);
      observeCell(b);

      a.setCell(1.cell);
      expect(a.value, 1);
      expect(b.value, 1);

      b.setCell(2.cell);
      expect(a.value, 2);
      expect(b.value, 2);
    });

    test('Cells with the same key manage the same set of observers', () {
      final m = MutableCell(0);

      final a = MetaCell<int>(key: 'meta-cell-key1');
      final b = MetaCell<int>(key: 'meta-cell-key1');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockValueObserver());
      final observer2 = addObserver(b, MockValueObserver());

      a.setCell(m);
      m.value = 1;
      m.value = 2;
      m.value = 3;
      m.value = 4;

      b.removeObserver(observer1);
      m.value = 5;

      a.removeObserver(observer2);
      m.value = 6;
      m.value = 7;

      expect(observer1.values, equals([1, 2, 3, 4]));
      expect(observer2.values, equals([1, 2, 3, 4, 5]));
    });

    test('Cells with the different keys do not share the same state', () {
      final a = MetaCell<int>(key: 'meta-cell-key1');
      final b = MetaCell<int>(key: 'meta-cell-key2');

      observeCell(a);
      observeCell(b);

      a.setCell(1.cell);
      b.setCell(2.cell);

      expect(a.value, 1);
      expect(b.value, 2);
    });

    test('Cells with different keys manage different sets of observers', () {
      final m1 = MutableCell(0);
      final m2 = MutableCell(0);

      final a = MetaCell<int>(key: 'meta-cell-key1');
      final b = MetaCell<int>(key: 'meta-cell-key2');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockValueObserver());
      final observer2 = addObserver(b, MockValueObserver());

      a.setCell(m1);
      b.setCell(m2);

      m1.value = 1;
      m2.value = 2;
      m1.value = 3;
      m2.value = 4;

      b.removeObserver(observer1);
      m1.value = 5;

      a.removeObserver(observer2);
      m1.value = 6;
      m2.value = 7;

      expect(observer1.values, equals([1, 3, 5, 6]));
      expect(observer2.values, equals([2, 4, 7]));
    });

    test('State recreated after disposal when using keys', () {
      final meta = MetaCell<int>(key: 'meta-cell-key1');
      final observer1 = addObserver(meta, MockSimpleObserver());

      meta.setCell(1.cell);
      expect(meta.value, 1);

      meta.setCell(15.cell);
      expect(meta.value, 15);

      meta.removeObserver(observer1);

      addObserver(meta, MockSimpleObserver());
      expect(() => meta.value, throwsA(isA<EmptyMetaCellError>()));

      meta.setCell(17.cell);
      expect(meta.value, 17);
    });

    test('Cells with keys do not leak resources', () {
      final meta = MetaCell<int>(key: 'meta-cell-key-1');
      final observer = addObserver(meta, MockSimpleObserver());

      expect(CellState.maybeGetState('meta-cell-key-1'), isNotNull);

      meta.removeObserver(observer);
      expect(CellState.maybeGetState('meta-cell-key-1'), isNull);
    });
  });

  group('MutableMetaCell', () {
    test('Sets value of referenced cell', () {
      final a = MutableCell(0);
      final b = MutableCell(10);

      final meta = MetaCell.mutable<int>();

      final observerA = addObserver(a, MockValueObserver());
      final observerB = addObserver(b, MockValueObserver());
      final observerM = addObserver(meta, MockValueObserver());

      a.value = 1;
      b.value = 11;

      meta.inject(a);

      meta.value = 2;
      meta.value = 3;
      meta.value = 4;
      a.value = 5;

      meta.inject(b);
      meta.value = 6;
      meta.value = 7;
      meta.value = 8;
      b.value = 9;

      expect(observerA.values, equals([1, 2, 3, 4, 5]));
      expect(observerB.values, equals([11, 6, 7, 8, 9]));
      expect(observerM.values, equals([2, 3, 4, 5, 6, 7, 8, 9]));
    });

    test('Does not leak resources', () {
      final resource1 = MockResource();
      final resource2 = MockResource();

      final a = TestManagedCell(resource1, 1);
      final b = TestManagedCell(resource2, 2);

      final c1 = MutableCell.computed(() => a(), (value) { });
      final c2 = MutableCell.computed(() => b(), (value) { });

      final meta = MetaCell.mutable<int>();
      observeCell(meta);

      meta.inject(c1);

      expect(meta.value, 1);
      verify(resource1.init()).called(1);
      verifyNever(resource1.dispose());

      meta.inject(c2);

      expect(meta.value, 2);
      verifyNever(resource1.init());
      verify(resource1.dispose()).called(1);
      verify(resource2.init()).called(1);
      verifyNever(resource2.dispose());
    });

    test('Throws EmptyMetaCellError when no cell set', () {
      final meta = MetaCell.mutable<int>();
      observeCell(meta);

      expect(() => meta.value, throwsA(isA<EmptyMetaCellError>()));
      expect(() => meta.value = 1, throwsA(isA<EmptyMetaCellError>()));
    });

    test('Compares == when same key', () {
      final a = MetaCell.mutable(key: 'meta-cell-key1');
      final b = MetaCell.mutable(key: 'meta-cell-key1');

      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('Compares != with different keys', () {
      final a = MetaCell.mutable(key: 'meta-cell-key1');
      final b = MetaCell.mutable(key: 'meta-cell-key2');

      expect(a != b, isTrue);
      expect(a == a, isTrue);
    });

    test('Cells with the same key share the same state', () {
      final s1 = MutableCell(1);
      final s2 = MutableCell(2);

      final a = MetaCell.mutable<int>(key: 'meta-cell-key1');
      final b = MetaCell.mutable<int>(key: 'meta-cell-key1');

      observeCell(a);
      observeCell(b);

      a.inject(s1);
      expect(a.value, 1);
      expect(b.value, 1);

      b.inject(s2);
      expect(a.value, 2);
      expect(b.value, 2);
    });

    test('Cells with the same key manage the same set of observers', () {
      final m = MutableCell(0);

      final a = MetaCell.mutable<int>(key: 'meta-cell-key1');
      final b = MetaCell.mutable<int>(key: 'meta-cell-key1');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockValueObserver());
      final observer2 = addObserver(b, MockValueObserver());

      a.setCell(m);
      a.value = 1;
      a.value = 2;
      b.value = 3;
      b.value = 4;

      b.removeObserver(observer1);
      m.value = 5;

      a.removeObserver(observer2);
      m.value = 6;
      m.value = 7;

      expect(observer1.values, equals([1, 2, 3, 4]));
      expect(observer2.values, equals([1, 2, 3, 4, 5]));
    });

    test('Cells with the different keys do not share the same state', () {
      final s1 = MutableCell(1);
      final s2 = MutableCell(2);

      final a = MetaCell.mutable<int>(key: 'meta-cell-key1');
      final b = MetaCell.mutable<int>(key: 'meta-cell-key2');

      observeCell(a);
      observeCell(b);

      a.setCell(s1);
      b.setCell(s2);

      expect(a.value, 1);
      expect(b.value, 2);
    });

    test('Cells with different keys manage different sets of observers', () {
      final m1 = MutableCell(0);
      final m2 = MutableCell(0);

      final a = MetaCell.mutable<int>(key: 'meta-cell-key1');
      final b = MetaCell.mutable<int>(key: 'meta-cell-key2');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockValueObserver());
      final observer2 = addObserver(b, MockValueObserver());

      a.setCell(m1);
      b.setCell(m2);

      m1.value = 1;
      m2.value = 2;
      m1.value = 3;
      m2.value = 4;

      b.removeObserver(observer1);
      m1.value = 5;

      a.removeObserver(observer2);
      m1.value = 6;
      m2.value = 7;

      expect(observer1.values, equals([1, 3, 5, 6]));
      expect(observer2.values, equals([2, 4, 7]));
    });

    test('State recreated after disposal when using keys', () {
      final s1 = MutableCell(1);
      final s2 = MutableCell(15);
      final s3 = MutableCell(17);

      final meta = MetaCell.mutable<int>(key: 'meta-cell-key1');
      final observer1 = addObserver(meta, MockSimpleObserver());

      meta.setCell(s1);
      expect(meta.value, 1);

      meta.setCell(s2);
      expect(meta.value, 15);

      meta.removeObserver(observer1);

      addObserver(meta, MockSimpleObserver());
      expect(() => meta.value, throwsA(isA<EmptyMetaCellError>()));

      meta.setCell(s3);
      expect(meta.value, 17);
    });

    test('Cells with keys do not leak resources', () {
      final meta = MetaCell.mutable<int>(key: 'meta-cell-key-1');
      final observer = addObserver(meta, MockSimpleObserver());

      expect(CellState.maybeGetState('meta-cell-key-1'), isNotNull);

      meta.removeObserver(observer);
      expect(CellState.maybeGetState('meta-cell-key-1'), isNull);
    });
  });

  group('ActionMetaCell', () {
    test('Triggers referenced cell', () {
      final a = ActionCell();
      final b = ActionCell();

      final meta = MetaCell.action();

      final listenerA = addListener(a, MockSimpleListener());
      final listenerB = addListener(b, MockSimpleListener());
      final listenerM = addListener(meta, MockSimpleListener());

      a.trigger();
      b.trigger();

      verify(listenerA()).called(1);
      verify(listenerB()).called(1);
      verifyNever(listenerM());

      meta.inject(a);

      meta.trigger();
      meta.trigger();
      meta.trigger();
      a.trigger();

      verify(listenerA()).called(4);
      verifyNever(listenerB());
      verify(listenerM()).called(4);

      meta.inject(b);
      meta.trigger();
      meta.trigger();
      meta.trigger();
      b.trigger();

      verifyNever(listenerA());
      verify(listenerB()).called(4);
      verify(listenerM()).called(4);
    });

    test('Throws EmptyMetaCellError when no cell set', () {
      final meta = MetaCell.action();
      observeCell(meta);

      expect(() => meta.trigger(), throwsA(isA<EmptyMetaCellError>()));
    });

    test('Compares == when same key', () {
      final a = MetaCell.action(key: 'meta-cell-key1');
      final b = MetaCell.action(key: 'meta-cell-key1');

      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('Compares != with different keys', () {
      final a = MetaCell.action(key: 'meta-cell-key1');
      final b = MetaCell.action(key: 'meta-cell-key2');

      expect(a != b, isTrue);
      expect(a == a, isTrue);
    });

    test('Cells with the same key share the same state', () {
      final s1 = ActionCell();
      final s2 = ActionCell();

      final a = MetaCell.action(key: 'meta-cell-key1');
      final b = MetaCell.action(key: 'meta-cell-key1');

      final listenerA = addListener(a, MockSimpleListener());
      final listenerB = addListener(b, MockSimpleListener());

      a.inject(s1);
      s1.trigger();

      verify(listenerA()).called(1);
      verify(listenerB()).called(1);

      b.inject(s2);
      s2.trigger();

      verify(listenerA()).called(1);
      verify(listenerB()).called(1);
    });

    test('Cells with the same key manage the same set of observers', () {
      final m = ActionCell();

      final a = MetaCell.action(key: 'meta-cell-key1');
      final b = MetaCell.action(key: 'meta-cell-key1');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockSimpleObserver());
      final observer2 = addObserver(b, MockSimpleObserver());

      a.setCell(m);
      a.trigger();
      a.trigger();
      b.trigger();
      b.trigger();

      verify(observer1.update(any, any)).called(4);
      verify(observer2.update(any, any)).called(4);

      b.removeObserver(observer1);
      m.trigger();

      verify(observer2.update(any, any)).called(1);
      verifyNever(observer1.update(any, any));

      a.removeObserver(observer2);
      m.trigger();
      m.trigger();

      verifyNever(observer1.update(any, any));
      verifyNever(observer2.update(any, any));
    });

    test('Cells with the different keys do not share the same state', () {
      final s1 = ActionCell();
      final s2 = ActionCell();

      final a = MetaCell.action(key: 'meta-cell-key1');
      final b = MetaCell.action(key: 'meta-cell-key2');

      final listenerA = addListener(a, MockSimpleListener());
      final listenerB = addListener(b, MockSimpleListener());

      a.inject(s1);
      s1.trigger();

      verify(listenerA()).called(1);
      verifyNever(listenerB());

      b.inject(s2);
      s2.trigger();

      verifyNever(listenerA());
      verify(listenerB()).called(1);
    });

    test('Cells with different keys manage different sets of observers', () {
      final m1 = ActionCell();
      final m2 = ActionCell();

      final a = MetaCell.action(key: 'meta-cell-key1');
      final b = MetaCell.action(key: 'meta-cell-key2');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockSimpleObserver());
      final observer2 = addObserver(b, MockSimpleObserver());

      a.setCell(m1);
      b.setCell(m2);

      m1.trigger();
      m1.trigger();
      m2.trigger();
      m2.trigger();

      verify(observer1.update(any, any)).called(2);
      verify(observer2.update(any, any)).called(2);

      b.removeObserver(observer1);
      m1.trigger();

      verify(observer1.update(any, any)).called(1);
      verifyNever(observer2.update(any, any));

      a.removeObserver(observer2);
      m1.trigger();
      m2.trigger();

      verify(observer1.update(any, any)).called(1);
      verify(observer2.update(any, any)).called(1);
    });

    test('State recreated after disposal when using keys', () {
      final s1 = ActionCell();
      final s2 = ActionCell();
      final s3 = ActionCell();

      final meta = MetaCell.action(key: 'meta-cell-key1');
      final observer1 = addObserver(meta, MockSimpleObserver());

      meta.setCell(s1);
      s1.trigger();
      verify(observer1.update(any, any)).called(1);

      meta.setCell(s2);
      s2.trigger();
      verify(observer1.update(any, any)).called(1);

      meta.removeObserver(observer1);

      final observer2 = addObserver(meta, MockSimpleObserver());
      expect(() => meta.trigger(), throwsA(isA<EmptyMetaCellError>()));

      meta.setCell(s3);
      s3.trigger();
      verifyNever(observer1.update(any, any));
      verify(observer2.update(any, any)).called(1);
    });

    test('Cells with keys do not leak resources', () {
      final meta = MetaCell.action(key: 'meta-cell-key-1');
      final observer = addObserver(meta, MockSimpleObserver());

      expect(CellState.maybeGetState('meta-cell-key-1'), isNotNull);

      meta.removeObserver(observer);
      expect(CellState.maybeGetState('meta-cell-key-1'), isNull);
    });
  });

  group('MetaCellExtension', () {
    test('.withDefault() takes value of given cell when MetaCell is empty', () {
      final meta = MetaCell<int>();
      final cell = meta.withDefault((-1).cell);

      observeCell(cell);

      expect(cell.value, -1);

      final a = MutableCell(0);
      meta.setCell(a);

      a.value = 10;
      expect(cell.value, 10);
    });

    test('.ignoreEmpty prevents EmptyMetaCellError from being thrown', () {
      final meta = MetaCell<void>();
      final cell = meta.onTrigger;

      final listener = addListener(cell, MockSimpleListener());

      expect(Future(() => cell.value), completes);

      final a = ActionCell();
      meta.setCell(a);

      expect(Future(() => cell.value), completes);

      a.trigger();
      a.trigger();

      verify(listener()).called(2);
    });

    test('.whenReady stops execution of watch function on EmptyMetaCellError', () {
      final meta = MetaCell<int>();

      final listener = MockSimpleListener();
      final watch = ValueCell.watch(() {
        meta.whenReady();
        listener();
      });

      addTearDown(() => watch.stop());
      verifyNever(listener());

      final a = MutableCell(0);
      meta.setCell(a);

      a.value = 1;
      a.value = 2;

      verify(listener()).called(2);
    });
  });
}