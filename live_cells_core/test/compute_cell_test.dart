import 'package:live_cells_core/live_cells_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'util.dart';
import 'util.mocks.dart';

void main() {
  group('ComputeCell', () {
    test('ComputeCell function applied on ConstantCell value', () {
      const a = ConstantCell(1);
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

      final c = (a,b).apply((a, b) => a + b);

      a.value = 5;

      expect(c.value, equals(7));
    });

    test('N-ary ComputeCell reevaluated when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = (a,b).apply((a, b) => a + b);

      b.value = 8;

      expect(c.value, equals(9));
    });

    test('ComputeCell observers notified when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = (a,b).apply((a, b) => a + b);

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      a.value = 8;

      verify(observer.update(c, any)).called(1);
    });

    test('ComputeCell observers notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = (a,b).apply((a, b) => a + b);

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      b.value = 8;

      verify(observer.update(c, any)).called(1);
    });

    test('ComputeCell observers notified for each change of value of argument cell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = (a,b).apply((a, b) => a + b);

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      b.value = 8;
      a.value = 10;
      b.value = 100;

      verify(observer.update(c, any)).called(3);
    });

    test('ComputeCell observer not called after it is removed', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = (a,b).apply((a, b) => a + b);

      final observer = MockSimpleObserver();

      addObserver(c, observer);
      a.value = 8;

      c.removeObserver(observer);
      b.value = 10;
      a.value = 100;

      verify(observer.update(c, any)).called(1);
    });

    test('All ComputeCell observers called when value changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = (a,b).apply((a, b) => a + b);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(c, observer1);
      a.value = 8;

      addObserver(c, observer2);
      b.value = 10;
      a.value = 100;

      verify(observer1.update(c, any)).called(3);
      verify(observer2.update(c, any)).called(2);
    });

    test("ComputeCell's compare == if they have the same key", () {
      final a = MutableCell(0);
      final b = MutableCell(1);

      final c1 = (a, b).apply((a, b) => a + b, key: 'theKey');
      final c2 = (a, b).apply((a, b) => a + b, key: 'theKey');

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test("ComputeCell's compare != if they have different keys", () {
      final a = MutableCell(0);
      final b = MutableCell(1);

      final c1 = (a, b).apply((a, b) => a + b, key: 'theKey1');
      final c2 = (a, b).apply((a, b) => a + b, key: 'theKey2');

      expect(c1 != c2, isTrue);
    });

    test("ComputeCell's compare != if they have null keys", () {
      final a = MutableCell(0);
      final b = MutableCell(1);

      final c1 = (a, b).apply((a, b) => a + b);
      final c2 = (a, b).apply((a, b) => a + b);

      expect(c1 != c2, isTrue);
      expect(c1 == c1, isTrue);
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
      addObserver(b, observer);

      a.value = 5;

      expect(b.value, equals(6));
    });

    test('N-ary DynamicComputeCell reevaluated when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      a.value = 5;

      expect(c.value, equals(7));
    });

    test('N-ary DynamicComputeCell reevaluated when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      b.value = 8;

      expect(c.value, equals(9));
    });

    test('DynamicComputeCell observers notified when value of 1st argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      a.value = 8;

      verify(observer.update(c, any)).called(1);
    });

    test('DynamicComputeCell observers notified when value of 2nd argument cell changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      b.value = 8;

      verify(observer.update(c, any)).called(1);
    });

    test('DynamicComputeCell observers notified for each change of value of argument cell', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();
      addObserver(c, observer);

      b.value = 8;
      a.value = 10;
      b.value = 100;

      verify(observer.update(c, any)).called(3);
    });

    test('DynamicComputeCell observer not called after it is removed', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer = MockSimpleObserver();

      addObserver(c, observer);
      a.value = 8;

      c.removeObserver(observer);
      b.value = 10;
      a.value = 100;

      verify(observer.update(c, any)).called(1);
    });

    test('All DynamicComputeCell observers called when value changes', () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final c = ValueCell.computed(() => a() + b());

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(c, observer1);
      a.value = 8;

      addObserver(c, observer2);
      b.value = 10;
      a.value = 100;

      verify(observer1.update(c, any)).called(3);
      verify(observer2.update(c, any)).called(2);
    });

    test('DynamicComputeCell arguments tracked correctly when using conditionals', () {
      final a = MutableCell(true);
      final b = MutableCell(2);
      final c = MutableCell(3);

      final d = ValueCell.computed(() => a() ? b() : c());

      final observer = MockValueObserver();
      addObserver(d, observer);

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
      addObserver(f, observer);

      b.value = 1;
      e.value = 10;
      a.value = false;
      c.value = 10;

      expect(observer.values, equals([1, 11, 13, 20]));
    });

    test('Previous DynamicComputeCell.value preserved if ValueCell.none is used', () {
      final a = MutableCell(0);
      final evens = ValueCell.computed(() => a().isEven ? a() : ValueCell.none());

      final observer = addObserver(evens, MockValueObserver());

      a.value = 1;
      a.value = 2;
      a.value = 3;
      a.value = 4;
      a.value = 5;

      expect(observer.values, equals([0, 2, 4]));
    });

    test('DynamicComputeCell.value initialized to defaultValue if ValueCell.none is used', () {
      final a = MutableCell(1);
      final evens = ValueCell.computed(() => a().isEven ? a() : ValueCell.none(0));

      final observer = addObserver(evens, MockValueObserver());

      a.value = 3;
      a.value = 4;
      a.value = 5;
      a.value = 6;

      expect(observer.values, equals([0, 4, 6]));
    });

    test('UninitializedCellError thrown if defaultValue given to ValueCell.none is null', () {
      final a = MutableCell(1);
      final evens = ValueCell<int>.computed(() => a().isEven ? a() : ValueCell.none());

      expect(() => evens.value, throwsA(isA<UninitializedCellError>()));

      addListener(evens, MockSimpleListener());
      expect(() => evens.value, throwsA(isA<UninitializedCellError>()));
    });

    test('Value initialized to null if defaultValue given to ValueCell.none is null', () {
      final a = MutableCell(1);
      final evens = ValueCell<int?>.computed(() => a().isEven ? a() : ValueCell.none());

      final observer = addObserver(evens, MockValueObserver());

      // A non-null 'sentinal' has to be added since MockValueObserver does not
      // record initial null values
      observer.values.add(0);

      a.value = 3;
      a.value = 4;
      a.value = 5;
      a.value = 6;

      expect(observer.values, equals([0, null, 4, 6]));
    });

    test('Exception on initialization of value reproduced on value access', () {
      final cell = ValueCell.computed(() => throw Exception());

      expect(() => cell.value, throwsException);
    });

    test('Exception on initialization of value reproduced on value access while observed', () {
      final cell = ValueCell.computed(() => throw Exception());
      observeCell(cell);

      expect(() => cell.value, throwsException);
    });

    test("DynamicComputeCell's compare == if they have the same keys", () {
      final a = MutableCell(0);
      final b = MutableCell(0);

      final c1 = ValueCell.computed(() => a() + b(), key: 'theKey');
      final c2 = ValueCell.computed(() => a() + b(), key: 'theKey');

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test("DynamicComputeCell's compare != if they have different keys", () {
      final a = MutableCell(0);
      final b = MutableCell(0);

      final c1 = ValueCell.computed(() => a() + b(), key: 'theKey1');
      final c2 = ValueCell.computed(() => a() + b(), key: 'theKey2');

      expect(c1 != c2, isTrue);
    });

    test("DynamicComputeCell's compare != if they have null keys", () {
      final a = MutableCell(0);
      final b = MutableCell(0);

      final c1 = ValueCell.computed(() => a() + b());
      final c2 = ValueCell.computed(() => a() + b());

      expect(c1 != c2, isTrue);
      expect(c1 == c1, isTrue);
    });

    test("Keyed DynamicComputeCell's manage the same set of observers", () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 0);
      f() => ValueCell.computed(() => a() + 1, key: 'theKey');

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      verify(resource.init()).called(1);
      verify(resource.dispose()).called(1);
    });

    test('DynamicComputeCell state recreated on adding observer after dispose', () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 0);
      f() => ValueCell.computed(() => a() + 1, key: 'theKey');

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      observeCell(f());

      verify(resource.init()).called(2);
      verify(resource.dispose()).called(1);
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
      addObserver(store, observer);

      expect(store.value, equals('bye'));
    });

    test('StoreCell observers notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer = MockSimpleObserver();

      addObserver(store, observer);
      a.value = 'bye';
      a.value = 'goodbye';

      verify(observer.update(store, any)).called(2);
    });

    test('All StoreCell observers notified when argument cell value changes', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(store, observer1);
      a.value = 'bye';

      addObserver(store, observer2);
      a.value = 'goodbye';

      verify(observer1.update(store, any)).called(2);
      verify(observer2.update(store, any)).called(1);
    });

    test('StoreCell observer not called after it is removed', () {
      final a = MutableCell('hello');
      final store = a.store();

      final observer = MockSimpleObserver();

      addObserver(store, observer);
      a.value = 'bye';

      store.removeObserver(observer);
      a.value = 'goodbye';

      verify(observer.update(store, any)).called(1);
    });

    test('StoreCell.value updated when observer called', () {
      final cell = MutableCell('hello');
      final store = cell.store();

      final observer = MockValueObserver();

      addObserver(store, observer);

      cell.value = 'bye';
      verify(observer.gotValue('bye'));
    });

    test('Previous StoreCell.value preserved if ValueCell.none is used', () {
      final a = MutableCell(0);
      final evens = a.apply((a) => a.isEven ? a : ValueCell.none()).store();

      final observer = addObserver(evens, MockValueObserver());

      a.value = 1;
      a.value = 2;
      a.value = 3;
      a.value = 4;
      a.value = 5;

      expect(observer.values, equals([0, 2, 4]));
    });

    test('StoreCell.value initialized to defaultValue if ValueCell.none is used', () {
      final a = MutableCell(1);
      final evens = a.apply((a) => a.isEven ? a : ValueCell.none(10)).store();

      final observer = addObserver(evens, MockValueObserver());

      a.value = 3;
      a.value = 4;
      a.value = 5;
      a.value = 6;

      expect(observer.values, equals([10, 4, 6]));
    });

    test('UninitializedCellError thrown if defaultValue given to ValueCell.none is null', () {
      final a = MutableCell(1);
      final evens = a.apply<int>((a) => a.isEven ? a : ValueCell.none()).store();

      expect(() => evens.value, throwsA(isA<UninitializedCellError>()));

      addListener(evens, MockSimpleListener());
      expect(() => evens.value, throwsA(isA<UninitializedCellError>()));
    });

    test('Value initialized to null if defaultValue given to ValueCell.none is null', () {
      final a = MutableCell(1);
      final evens = a.apply<int?>((a) => a.isEven ? a : ValueCell.none()).store();

      final observer = addObserver(evens, MockValueObserver());

      // A non-null 'sentinal' has to be added since MockValueObserver does not
      // record initial null values
      observer.values.add(0);

      a.value = 3;
      a.value = 4;
      a.value = 5;
      a.value = 6;

      expect(observer.values, equals([0, null, 4, 6]));
    });

    test('Exception on initialization of value reproduced on value access', () {
      final a = MutableCell(0);
      final cell = (a).apply((a) => a == 0 ? throw Exception() : a);
      final store = cell.store();

      expect(() => store.value, throwsException);
    });

    test('Exception on initialization of value reproduced on value access while observed', () {
      final a = MutableCell(0);
      final cell = a.apply((a) => a == 0 ? throw Exception() : a);
      final store = cell.store();

      observeCell(store);

      expect(() => store.value, throwsException);
    });

    test("StoreCell's compare == if they have the same argument cell", () {
      final a = MutableCell(0);
      final b = a * a;

      final c1 = b.store();
      final c2 = b.store();

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test("StoreCell's compare != if they have different argument cell", () {
      final a = MutableCell(0);
      final b1 = a * a;
      final b2 = a + a;

      final c1 = b1.store();
      final c2 = b2.store();

      expect(c1 != c2, isTrue);
      expect(c1 == c1, isTrue);
    });

    test("StoreCell's manage the same set of observers", () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);
      final b = MutableCell(0);
      final c = a + b;

      f() => c.store();

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      verify(resource.init()).called(1);
      verify(resource.dispose()).called(1);
    });

    test('StoreCell state recreated on adding observer after dispose', () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);
      final b = MutableCell(0);
      final c = a + b;

      f() => c.store();

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      observeCell(f());

      verify(resource.init()).called(2);
      verify(resource.dispose()).called(1);
    });
  });

  group('Cell update consistency', () {
    test('All observer methods called in correct order', () {
      final cell = MutableCell(10);
      final observer = MockSimpleObserver();

      addObserver(cell, observer);
      cell.value = 15;

      verifyInOrder([
        observer.willUpdate(cell),
        observer.update(cell, any)
      ]);

      verifyNoMoreInteractions(observer);
    });

    test('No intermediate values are recorded when using multi argument cells', () {
      final a = MutableCell(0);
      final sum = a + 1.cell;
      final prod = a * 8.cell;
      final result = sum + prod;

      final observer = MockValueObserver();
      addObserver(result, observer);

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
      addObserver(result, observer);

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
      addObserver(result, observer);

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
      addObserver(result, observer);

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
      addObserver(result, observer);

      a.value = 2;
      a.value = 6;

      expect(observer.values, equals([(2 + 1 + 10) + (2 * 8), (6 + 1 + 10) + (6 * 8)]));
    });

    test('No intermediate values are produced when using MutableCell.batch', () {
      final a = MutableCell(0);
      final b = MutableCell(0);
      final op = MutableCell('');

      final sum = a + b;
      final msg = (a, b, op, sum)
          .apply((a, b, op, sum) => '$a $op $b = $sum');

      final observer = MockValueObserver();
      addObserver(msg, observer);

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
      final msg = (a, b, op, sum)
          .apply((a, b, op, sum) => '$a $op $b = $sum');

      final observer = MockValueObserver();
      addObserver(msg, observer);

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

    test('All StoreCell observers called correct number of times', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final sum = (a + b).store();

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

    test('Correct values produced with StoreCell across all observer cells', () {
      final a = MutableCell(1);
      final b = MutableCell(2);
      final sum = (a + b).store();

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

      addObserver(cell, observer1);
      addObserver(cell, observer2);

      verify(resource.init()).called(1);
    });

    test('dispose() not called when not all observers removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(cell, observer1);
      addObserver(cell, observer2);

      cell.removeObserver(observer1);

      verifyNever(resource.dispose());
    });

    test('dispose() called when all observers removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(cell, observer1);
      addObserver(cell, observer2);

      cell.removeObserver(observer1);
      cell.removeObserver(observer2);

      verify(resource.dispose()).called(1);
    });

    test('init() called again when adding new observer after all observers removed', () {
      final resource = MockResource();
      final cell = TestManagedCell(resource, 1);

      final observer1 = MockSimpleObserver();
      final observer2 = MockSimpleObserver();

      addObserver(cell, observer1);
      addObserver(cell, observer2);

      cell.removeObserver(observer1);
      cell.removeObserver(observer2);

      addObserver(cell, observer1);

      verify(resource.init()).called(2);
    });
  });

  group('SelfCell', () {
    test('Correctly references previous value', () {
      final increment = ActionCell();
      final cell = SelfCell((self) {
        increment.observe();
        return self() + 1;
      }, initialValue: 0);

      final observer = addObserver(cell, MockValueObserver());

      expect(cell.value, 1);

      increment.trigger();
      increment.trigger();
      increment.trigger();

      expect(observer.values, equals([2, 3, 4]));
    });

    test('Exceptions rethrown when self accessed', () {
      final increment = ActionCell();

      final cell = SelfCell((self) {
        increment.observe();

        int count;

        try {
          count = self() + 1;
        }
        on ArgumentError {
          return 2;
        }

        if (count.isEven) {
          throw ArgumentError();
        }

        return count;
      }, initialValue: 0);

      observeCell(cell);
      expect(cell.value, 1);

      increment.trigger();
      expect(() => cell.value, throwsArgumentError);

      increment.trigger();
      expect(cell.value, 2);

      increment.trigger();
      expect(cell.value, 3);

      increment.trigger();
      expect(() => cell.value, throwsArgumentError);

      increment.trigger();
      expect(cell.value, 2);
    });

    test('Correctly tracks dependencies', () {
      final increment = ActionCell();
      final delta = MutableCell(1);

      final cell = SelfCell((self) {
        increment.observe();
        return self() + delta();
      }, initialValue: 0);

      final observer = addObserver(cell, MockValueObserver());
      expect(cell.value, 1);

      increment.trigger();
      delta.value = 5;

      increment.trigger();
      increment.trigger();

      delta.value = 10;
      increment.trigger();

      expect(observer.values, equals([2, 7, 12, 17, 27, 37]));
    });

    test('Works correctly with .peek', () {
      final increment = ActionCell();
      final delta = MutableCell(1);

      final cell = SelfCell((self) {
        increment.observe();
        return self() + delta.peek();
      }, initialValue: 0);

      final observer = addObserver(cell, MockValueObserver());
      expect(cell.value, 1);

      increment.trigger();
      delta.value = 5;

      increment.trigger();
      increment.trigger();

      delta.value = 10;
      increment.trigger();

      expect(observer.values, equals([2, 7, 12, 22]));
    });

    test('Initialized to null if no initial value given', () {
      final increment = ActionCell();

      final cell = SelfCell<int?>((self) {
        increment.observe();

        final count = self();

        return count == null
            ? 0
            : count + 1;
      });

      final observer = addObserver(cell, MockValueObserver());

      expect(cell.value, 0);

      increment.trigger();
      increment.trigger();
      increment.trigger();

      expect(observer.values, equals([1, 2, 3]));
    });

    test('Uninitialized cell error thrown when no initial value and not nullable', () {
      final increment = ActionCell();

      final cell = SelfCell<int>((self) {
        increment.observe();

        try {
          return self() + 1;
        }
        on UninitializedCellError {
          return 0;
        }
      });

      final observer = addObserver(cell, MockValueObserver());

      expect(cell.value, 0);

      increment.trigger();
      increment.trigger();
      increment.trigger();

      expect(observer.values, equals([1, 2, 3]));
    });

    test('Previous value preserved if ValueCell.none is used', () {
      final increment = ActionCell();
      final delta = MutableCell(1);

      final cell = SelfCell((self) {
        increment.observe();

        final count = self() + delta.peek();

        if (count.isOdd) {
          ValueCell.none();
        }

        return count;
      }, initialValue: -1);

      final observer = addObserver(cell, MockValueObserver());

      expect(cell.value, 0);
      increment.trigger();
      increment.trigger();

      expect(cell.value, 0);

      delta.value = 2;

      increment.trigger();
      increment.trigger();
      increment.trigger();

      expect(observer.values, equals([0, 2, 4, 6]));
    });

    test('Initialized to defaultValue if ValueCell.none is used', () {
      final increment = ActionCell();
      final delta = MutableCell(1);

      final cell = SelfCell((self) {
        increment.observe();

        final count = self() + delta.peek();

        if (count.isOdd) {
          ValueCell.none(1);
        }

        return count;
      }, initialValue: 0);

      final observer = addObserver(cell, MockValueObserver());

      expect(cell.value, 1);
      increment.trigger();
      increment.trigger();
      expect(cell.value, 2);

      delta.value = 2;

      increment.trigger();
      increment.trigger();
      increment.trigger();

      expect(observer.values, equals([2, 4, 6, 8]));
    });

    test('Pagination test', () {
      final pageIndex = MutableCell(0);

      final page = ValueCell.computed(() {
        final start = pageIndex() * 3;
        return List.generate(3, (index) => start + index);
      });

      final cell = SelfCell((self) => [...self(), ...page()],
          initialValue: []
      );

      observeCell(cell);
      expect(cell.value, equals([0, 1, 2]));

      pageIndex.value = 1;
      expect(cell.value, equals([0, 1, 2, 3, 4, 5]));

      pageIndex.value = 2;
      expect(cell.value, equals([0, 1, 2, 3, 4, 5, 6, 7, 8]));
    });

    test('Compares == when same keys', () {
      final increment = ActionCell();

      final c1 = SelfCell((self) {
        increment.observe();

        return self() + 1;
      }, initialValue: 0, key: 'self-key-1');

      final c2 = SelfCell((self) {
        increment.observe();

        return self() + 1;
      }, initialValue: 0, key: 'self-key-1');

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test('Compares != when different keys', () {
      final increment = ActionCell();

      final c1 = SelfCell((self) {
        increment.observe();

        return self() + 1;
      }, initialValue: 0, key: 'self-key-1');

      final c2 = SelfCell((self) {
        increment.observe();

        return self() + 1;
      }, initialValue: 0, key: 'self-key-2');

      expect(c1 != c2, isTrue);
    });

    test('Compares != when null keys', () {
      final increment = ActionCell();

      final c1 = SelfCell((self) {
        increment.observe();

        return self() + 1;
      }, initialValue: 0);

      final c2 = SelfCell((self) {
        increment.observe();

        return self() + 1;
      }, initialValue: 0);

      expect(c1 != c2, isTrue);
    });

    test('Manage the same set of observers when same keys', () {
      final increment = ActionCell();

      final resource = MockResource();
      final delta = TestManagedCell(resource, 1);

      f() => SelfCell((self) {
        increment.observe();

        return self() + delta();
      }, initialValue: 0, key: 'self-key-1');

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      observeCell(f());

      verify(resource.init()).called(2);
      verify(resource.dispose()).called(1);
    });
  });
}
