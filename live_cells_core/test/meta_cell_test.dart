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

    test('.whenReady stops execution of watch function', () {
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