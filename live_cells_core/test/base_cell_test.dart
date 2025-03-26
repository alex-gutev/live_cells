import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'util.dart';
import 'util.mocks.dart';

void main() {
  group('ConstantCell', () {
    test('Integer ConstantCell.value equals value given in constructor', () {
      final cell = 10.cell;
      expect(cell.value, equals(10));
    });

    test('String ConstantCell.value equals value given in constructor', () {
      final cell = 'Hello World'.cell;
      expect(cell.value, equals('Hello World'));
    });

    test('Boolean ConstantCell.value equals value given in constructor', () {
      final cell1 = true.cell;
      final cell2 = false.cell;

      expect(cell1.value, isTrue);
      expect(cell2.value, isFalse);
    });

    test('Null ConstantCell.value equals value given in constructor', () {
      final cell = null.cell;

      expect(cell.value, isNull);
    });

    test('Enum ConstantCell.value equals value given in constructor', () {
      final cell1 = TestEnum.value1.cell;
      final cell2 = TestEnum.value2.cell;
      final cell3 = TestEnum.value3.cell;

      expect(cell1.value, equals(TestEnum.value1));
      expect(cell2.value, equals(TestEnum.value2));
      expect(cell3.value, equals(TestEnum.value3));
    });

    test('Constant cells compare == if they hold the same value', () {
      final a = 1.cell;
      const b = ValueCell.value(1);

      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('Constant cells compare != if they hold the different values', () {
      final a = 1.cell;
      final b = 2.cell;

      expect(a != b, isTrue);
    });  });

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

      verify(observer.update(cell, any)).called(1);
    });

    test('Setting MutableCell.value twice calls cell listeners twice', () {
      final cell = MutableCell(15);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);

      cell.value = 23;
      cell.value = 101;

      verify(observer.update(cell, any)).called(2);
    });

    test('MutableCell observer not called after it is removed', () {
      final cell = MutableCell(15);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 23;

      cell.removeObserver(observer);
      cell.value = 101;

      verify(observer.update(cell, any)).called(1);
    });

    test('MutableCell observer not called if new value is equal to old value', () {
      final cell = MutableCell(56);
      final observer = MockSimpleObserver();

      cell.addObserver(observer);
      cell.value = 56;

      verifyNever(observer.update(cell, any));
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

      verify(observer1.update(cell, any)).called(3);
      verify(observer2.update(cell, any)).called(2);
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
      final msg = (a, b, op, sum)
          .apply((a, b, op, sum) => '$a $op $b = $sum');

      final observer = MockSimpleObserver();
      msg.addObserver(observer);

      MutableCell.batch(() {
        a.value = 1;
        b.value = 2;
        op.value = '+';
      });

      expect(msg.value, '1 + 2 = 3');
    });

    test('Compares == when same key', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final b = MutableCell(0, key: 'mutable-cell-key1');

      expect(a == b, isTrue);
      expect(a.hashCode == b.hashCode, isTrue);
    });

    test('Compares != with different keys', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final b = MutableCell(0, key: 'mutable-cell-key2');

      expect(a != b, isTrue);
      expect(a == a, isTrue);
    });

    test('Compares != with null keys', () {
      final a = MutableCell(0);
      final b = MutableCell(0);

      expect(a != b, isTrue);
      expect(a == a, isTrue);
    });

    test('Cells with the same keys share the same state', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final b = MutableCell(0, key: 'mutable-cell-key1');

      observeCell(a);
      observeCell(b);

      a.value = 10;

      expect(a.value, 10);
      expect(b.value, 10);
    });

    test('Cells with the same keys manage the same set of observers', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final b = MutableCell(0, key: 'mutable-cell-key1');

      observeCell(a);
      observeCell(b);

      final observer1 = addObserver(a, MockValueObserver());
      final observer2 = addObserver(b, MockValueObserver());

      a.value = 10;
      b.value = 20;
      a.value = 30;
      b.value = 40;

      b.removeObserver(observer1);
      a.value = 50;

      a.removeObserver(observer2);
      a.value = 60;
      b.value = 70;

      expect(observer1.values, equals([10, 20, 30, 40]));
      expect(observer2.values, equals([10, 20, 30, 40, 50]));
    });

    test('Cells with different keys do not share the same state', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final b = MutableCell(0, key: 'mutable-cell-key2');

      observeCell(a);
      observeCell(b);

      a.value = 10;

      expect(a.value, 10);
      expect(b.value, 0);
    });

    test('Cells with different keys manage different sets of observers', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final b = MutableCell(0, key: 'mutable-cell-key2');

      final observer1 = addObserver(a, MockValueObserver());
      final observer2 = addObserver(b, MockValueObserver());

      a.value = 10;
      b.value = 20;
      a.value = 30;
      b.value = 40;

      b.removeObserver(observer1);
      a.value = 50;

      a.removeObserver(observer2);
      a.value = 60;
      b.value = 70;

      expect(observer1.values, equals([10, 30, 50, 60]));
      expect(observer2.values, equals([20, 40, 70]));
    });

    test('State recreated after disposal when using keys', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');

      final observer1 = addObserver(a, MockSimpleObserver());
      expect(a.value, 0);

      a.value = 10;
      a.value = 15;

      expect(a.value, 15);

      a.removeObserver(observer1);

      addObserver(a, MockSimpleObserver());
      expect(a.value, 0);

      a.value = 17;
      expect(a.value, 17);
    });

    test('Cells with keys do not leak resources', () {
      final a = MutableCell(0, key: 'mutable-cell-key1');
      final observer = addObserver(a, MockSimpleObserver());

      expect(CellState.maybeGetState('mutable-cell-key1'), isNotNull);

      a.removeObserver(observer);
      expect(CellState.maybeGetState('mutable-cell-key1'), isNull);
    });

    test('Value of mutable cells reset to initial value when reset = true', () {
      final a = MutableCell(1,
          key: 'mutable-cell-key1',
          reset: true
      );

      final obs = addObserver(a, MockValueObserver());
      expect(a.value, 1);

      final b = MutableCell(2,
          key: 'mutable-cell-key1',
          reset: true
      );

      expect(a.value, 2);
      expect(b.value, 2);

      final c = MutableCell(5,
          key: 'mutable-cell-key1',
          reset: true
      );

      expect(a.value, 5);
      expect(b.value, 5);
      expect(c.value, 5);

      final d = MutableCell(10, key: 'mutable-cell-key1');

      expect(a.value, 5);
      expect(b.value, 5);
      expect(c.value, 5);
      expect(d.value, 5);

      final e = MutableCell(15,
          key: 'mutable-cell-key2',
          reset: true
      );

      observeCell(e);

      expect(a.value, 5);
      expect(b.value, 5);
      expect(c.value, 5);
      expect(d.value, 5);
      expect(e.value, 15);

      expect(obs.values, equals([2, 5]));
    });

    test('Cells with UniqueCellKeys are not equal to each other', () {
      final m = MutableCell(0);

      final a = m.apply((m) => m + 1, key: UniqueCellKey());
      final b = m.apply((m) => m + 1, key: UniqueCellKey());

      expect(a != b, isTrue);
      expect(a == a, isTrue);
    });
  });

  group('Equality Comparisons', () {
    test('ConstantCell\'s are eq if they have equal values', () {
      const a = ConstantCell(1);
      const b = ConstantCell(1);

      expect(a.eq(b).value, equals(true));
    });

    test('ConstantCell\'s are not eq if they have unequal values', () {
      const a = ConstantCell(1);
      const b = ConstantCell(2);

      expect(a.eq(b).value, equals(false));
    });

    test('ConstantCell\'s are neq if they have unequal values', () {
      const a = ConstantCell(3);
      const b = ConstantCell(4);

      expect(a.neq(b).value, equals(true));
    });

    test('ConstantCell\'s are not neq if they have equal values', () {
      const a = ConstantCell(3);
      const b = ConstantCell(3);

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

      verify(observer.update(eq, any)).called(1);
    });

    test('EqCell observers notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final eq = a.eq(b);
      final observer = MockSimpleObserver();

      eq.addObserver(observer);
      b.value = 3;

      verify(observer.update(eq, any)).called(1);
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

      verify(observer.update(neq, any)).called(1);
    });

    test('NeqCell observers notified when 2nd argument cell values changes', () {
      final a = MutableCell(3);
      final b = MutableCell(4);

      final neq = a.eq(b);
      final observer = MockSimpleObserver();

      neq.addObserver(observer);
      b.value = 3;

      verify(observer.update(neq, any)).called(1);
    });

    test("EqCell's compare == if they compare the same cells", () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final eq1 = a.eq(b);
      final eq2 = a.eq(b);

      expect(eq1 == eq2, isTrue);
      expect(eq1.hashCode == eq2.hashCode, isTrue);
    });

    test("EqCell's compare != if they compare different cells", () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final eq1 = a.eq(b);
      final eq2 = a.eq(2.cell);
      final eq3 = 2.cell.eq(b);

      expect(eq1 != eq2, isTrue);
      expect(eq1 != eq3, isTrue);
    });

    test("NeqCell's compare == if they compare the same cells", () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final neq1 = a.neq(b);
      final neq2 = a.neq(b);

      expect(neq1 == neq2, isTrue);
      expect(neq1.hashCode == neq2.hashCode, isTrue);
    });

    test("NeqCell's compare != if they compare different cells", () {
      final a = MutableCell(1);
      final b = MutableCell(2);

      final neq1 = a.neq(b);
      final neq2 = a.neq(2.cell);
      final neq3 = 2.cell.neq(b);

      expect(neq1 != neq2, isTrue);
      expect(neq1 != neq3, isTrue);
    });
  });

  group('ActionCell', () {
    test('Notifies observers when triggered', () {
      final action = ActionCell();
      final listener = addListener(action, MockSimpleListener());

      action.trigger();
      verify(listener()).called(1);
    });

    test('Notifies observers on every trigger', () {
      final action = ActionCell();
      final listener = addListener(action, MockSimpleListener());

      action.trigger();
      action.trigger();
      action.trigger();

      verify(listener()).called(3);
    });

    test('Can be added as a cell dependency', () {
      final action = ActionCell();
      final a = MutableCell(0);

      var i = 0;
      final b = ValueCell.computed(() {
        action();
        return a() + (i++);
      });

      final observer = addObserver(b, MockValueObserver());

      action.trigger();
      action.trigger();

      a.value = 10;

      expect(observer.values, equals([1, 2, 13]));
    });

    test('Works correctly with ValueCell.batch', () {
      final action = ActionCell();
      final a = MutableCell(0);

      var i = 0;
      final b = ValueCell.computed(() {
        action();
        return a() + (i++);
      });

      final observer = addObserver(b, MockValueObserver());

      action.trigger();

      MutableCell.batch(() {
        action.trigger();
        a.value = 10;
      });

      expect(observer.values, equals([1, 12]));
    });

    test('List.combined notifies observers when any action triggers', () {
      final a1 = ActionCell();
      final a2 = ActionCell();
      final a3 = ActionCell();

      final b = [a1, a2, a3].combined;
      final listener = addListener(b, MockSimpleListener());

      a1.trigger();
      a1.trigger();

      a2.trigger();
      a3.trigger();

      a2.trigger();

      verify(listener()).called(5);
    });
  });

  group('ActionCell.chain', () {
    test('action function is called when triggered', () {
      final action = ActionCell();
      final listener = MockSimpleListener();

      final chain = action.chain(() {
        listener();
        action.trigger();
      });

      chain.trigger();
      verify(listener()).called(1);

      chain.trigger();
      verify(listener()).called(1);
    });

    test('Original action is triggered', () {
      final action = ActionCell();
      final chain = action.chain(action.trigger);

      final listener1 = addListener(action, MockSimpleListener());
      final listener2 = addListener(chain, MockSimpleListener());

      chain.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      chain.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);
    });

    test('Conditionally triggering original action', () {
      var trigger = false;

      final action = ActionCell();
      final chain = action.chain(() {
        if (trigger) {
          action.trigger();
        }
      });

      final listener1 = addListener(action, MockSimpleListener());
      final listener2 = addListener(chain, MockSimpleListener());

      chain.trigger();
      verifyNever(listener1());
      verifyNever(listener2());

      chain.trigger();
      verifyNever(listener1());
      verifyNever(listener2());

      trigger = true;

      chain.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      chain.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);
    });

    test('Compare == when same keys', () {
      final action = ActionCell();

      final c1 = action.chain(action.trigger, key: 'key1');
      final c2 = action.chain(action.trigger, key: 'key1');

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test('Compare != when different keys', () {
      final action = ActionCell();

      final c1 = action.chain(action.trigger, key: 'key1');
      final c2 = action.chain(action.trigger, key: 'key2');

      expect(c1 != c2, isTrue);
    });

    test('Compare != when null keys', () {
      final action = ActionCell();

      final c1 = action.chain(action.trigger);
      final c2 = action.chain(action.trigger);

      expect(c1 != c2, isTrue);
    });
  });

  group('EffectCell', () {
    test('Throws UninitializedCellError before observer added', () {
      final a = ActionCell();

      final listener = MockSimpleListener();
      final effect = a.effect(() {
        listener();
        return 1;
      });

      expect(() => effect.value, throwsA(isA<UninitializedCellError>()));

      verifyZeroInteractions(listener);
    });

    test('Throws UninitializedCellError before first value change', () {
      final a = ActionCell();

      final listener = MockSimpleListener();
      final effect = a.effect(() {
        listener();
        return 1;
      });

      observeCell(effect);
      expect(() => effect.value, throwsA(isA<UninitializedCellError>()));

      verifyZeroInteractions(listener);
    });

    test('Runs effect when action triggered', () {
      final a = ActionCell();

      final listener = MockSimpleListener();
      final effect = a.effect(() {
        listener();
        return 1;
      });

      final observer = addObserver(effect, MockValueObserver());

      a.trigger();

      expect(effect.value, 1);
      expect(observer.values, equals([1]));

      verify(listener()).called(1);
    });

    test('Runs effect only one per action trigger', () {
      final a = ActionCell();

      final listener = MockSimpleListener();
      final effect = a.effect(() {
        listener();
        return 1;
      });

      final observer = addObserver(effect, MockValueObserver());

      a.trigger();

      expect(effect.value, 1);

      // Reference the value multiple times to check whether the effect will be
      // run again
      effect.value;
      effect.value;

      expect(observer.values, equals([1]));

      verify(listener()).called(1);
    });

    test('Runs effect every time action is triggered', () {
      final a = ActionCell();
      final listener = MockSimpleListener();

      var i = 1;
      final effect = a.effect(() {
        listener();
        return i++;
      });

      final observer = addObserver(effect, MockValueObserver());

      a.trigger();
      a.trigger();
      a.trigger();

      expect(effect.value, 3);
      expect(observer.values, equals([1, 2, 3]));

      verify(listener()).called(3);
    });

    test('Effect not run when peeked cell changed.', () {
      final a = ActionCell();
      final delta = MutableCell(1);

      final listener = MockSimpleListener();

      var i = 0;
      final effect = a.effect(() {
        listener();

        return i += delta();
      });

      final observer = addObserver(effect, MockValueObserver());

      a.trigger();
      delta.value = 2;
      expect(effect.value, 1);

      a.trigger();
      expect(effect.value, 3);

      expect(observer.values, equals([1, 3]));
      verify(listener()).called(2);
    });

    test('Previous value preserved if ValueCell.none is used', () {
      final a = ActionCell();
      final listener = MockSimpleListener();

      var i = 0;

      final effect = a.effect(() {
        listener();

        final next = i++;

        return next.isEven ? next : ValueCell.none();
      });

      final observer = addObserver(effect, MockValueObserver());

      a.trigger();
      expect(effect.value, 0);

      a.trigger();
      expect(effect.value, 0);

      a.trigger();
      expect(effect.value, 2);

      expect(observer.values, equals([0, 2]));
      verify(listener()).called(3);
    });

    test('value initialized to defaultValue if ValueCell.none is used', () {
      final a = ActionCell();
      final listener = MockSimpleListener();

      var i = 1;

      final effect = a.effect(() {
        listener();

        final next = i++;

        return next.isEven ? next : ValueCell.none(-1);
      });

      final observer = addObserver(effect, MockValueObserver());

      a.trigger();
      expect(effect.value, -1);

      a.trigger();
      expect(effect.value, 2);

      a.trigger();
      expect(effect.value, 2);

      a.trigger();
      expect(effect.value, 4);

      expect(observer.values, equals([-1, 2, 4]));
      verify(listener()).called(4);
    });

    test('UninitializedCellError thrown if defaultValue given to ValueCell.none is null', () {
      final a = ActionCell();
      final listener = MockSimpleListener();

      var i = 1;

      final effect = a.effect<int>(() {
        listener();

        final next = i++;
        return next.isEven ? next : ValueCell.none();
      });

      observeCell(effect);

      a.trigger();
      expect(() => effect.value, throwsA(isA<UninitializedCellError>()));

      a.trigger();
      expect(effect.value, 2);

      a.trigger();
      expect(effect.value, 2);

      a.trigger();
      expect(effect.value, 4);

      verify(listener()).called(4);
    });

    test('Value initialized to null if defaultValue given to ValueCell.none is null', () {
      final a = ActionCell();
      final listener = MockSimpleListener();

      var i = 1;

      final effect = a.effect<int?>(() {
        listener();

        final next = i++;

        return next.isEven ? next : ValueCell.none();
      });

      final observer = addObserver(effect, MockValueObserver());

      // A non-null 'sentinal' has to be added since MockValueObserver does not
      // record initial null values
      observer.values.add(0);

      a.trigger();
      expect(effect.value, null);

      a.trigger();
      expect(effect.value, 2);

      a.trigger();
      expect(effect.value, 2);

      a.trigger();
      expect(effect.value, 4);

      expect(observer.values, equals([0, null, 2, 4]));
      verify(listener()).called(4);
    });

    test('Exception reproduced when value accessed', () {
      final a = ActionCell();
      final listener = MockSimpleListener();

      var i = 1;

      final effect = a.effect(() {
        listener();

        final next = i++;

        return next.isEven ? next : throw ArgumentError();
      });

      observeCell(effect);

      a.trigger();

      // Do the check twice to ensure the effect is only run once
      expect(() => effect.value, throwsArgumentError);
      expect(() => effect.value, throwsArgumentError);

      a.trigger();
      expect(effect.value, 2);

      verify(listener()).called(2);
    });

    test('Compares == if same argument key', () {
      final a = ActionCell();
      final c1 = a.effect(() => 1, key: 'effect-cell-1');
      final c2 = a.effect(() => 1, key: 'effect-cell-1');

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test('Compares != if different keys', () {
      final a = ActionCell();
      final c1 = a.effect(() => 1, key: 'effect-cell-1');
      final c2 = a.effect(() => 1, key: 'effect-cell-2');

      expect(c1 != c2, isTrue);
      expect(c1 == c1, isTrue);
    });

    test('Manages the same set of observers when keys equal', () {
      final resource = MockResource();
      final m = TestManagedCell(resource, 2);
      final a = ActionCell();

      f() => a.effect(() => m.peek(), key: 'effect-cell-1');

      verifyNever(resource.init());

      final observer = addObserver(f(), MockValueObserver());
      a.trigger();

      f().removeObserver(observer);

      verify(resource.init()).called(1);
      verify(resource.dispose()).called(1);
    });

    test('State recreated on adding observer after dispose', () {
      final resource = MockResource();
      final m = TestManagedCell(resource, 2);
      final a = ActionCell();

      f() => a.effect(() => m.peek(), key: 'effect-cell-1');

      verifyNever(resource.init());

      final observer = addObserver(f(), MockValueObserver());
      a.trigger();

      f().removeObserver(observer);

      addObserver(f(), MockValueObserver());
      a.trigger();

      verify(resource.init()).called(2);
      verify(resource.dispose()).called(1);
    });
  });

  group('PrevValueCell', () {
    test('PrevValueCell.value holds error on initialization', () {
      final a = MutableCell(0);
      final prev = a.previous;

      expect(() => prev.value, throwsA(isA<UninitializedCellError>()));
    });

    test('PrevValueCell.value holds previous value of cell after being set once', () {
      final a = MutableCell(0);
      final prev = a.previous;

      addObserver(prev, MockSimpleObserver());

      a.value = 10;

      expect(prev.value, equals(0));
    });

    test('PrevValueCell.value holds previous value of cell after being set multiple times', () {
      final a = MutableCell(0);
      final prev = a.previous;

      addObserver(prev, MockSimpleObserver());

      a.value = 10;
      a.value = 5;
      a.value = 32;
      a.value = 40;

      expect(prev.value, equals(32));
    });

    test('PrevValueCell.value set to previous value when observer called', () {
      final a = MutableCell(0);
      final prev = a.previous;

      final observer = addObserver(prev, MockValueObserver());

      a.value = 10;
      a.value = 5;
      a.value = 32;
      a.value = 40;

      expect(observer.values, [0, 10, 5, 32]);
    });

    test('Restoration of PrevValueCell restores value', () {
      final a = MutableCell(10);
      final prev = a.previous as RestorableCell<int>;

      final observer = addObserver(prev, MockSimpleObserver());
      a.value = 30;

      final dump = prev.dumpState(const CellValueCoder());
      prev.removeObserver(observer);

      final restored = a.previous as RestorableCell<int>;
      restored.restoreState(dump, const CellValueCoder());

      observeCell(restored);

      expect(restored.value, equals(10));
    });

    test('Restoration of PrevValueCell restores error', () {
      final a = MutableCell(10);
      final prev = a.previous as RestorableCell<int>;

      addObserver(prev, MockSimpleObserver());

      final restored = a.previous as RestorableCell<int>;
      restored.restoreState(prev.dumpState(const CellValueCoder()), const CellValueCoder());

      expect(() => restored.value, throwsA(isA<UninitializedCellError>()));
    });

    test('Restoration of PrevValueCell restores functionality', () {
      final a = MutableCell(10);
      final prev = a.previous as RestorableCell<int>;

      addObserver(prev, MockSimpleObserver());

      final restored = a.previous as RestorableCell<int>;
      restored.restoreState(prev.dumpState(const CellValueCoder()), const CellValueCoder());

      addObserver(restored, MockSimpleObserver());

      a.value = 45;

      expect(restored.value, equals(10));
    });

    test("PrevValueCell's compare == if they have the same argument cell", () {
      final a = MutableCell(0);

      final c1 = a.previous;
      final c2 = a.previous;

      expect(c1 == c2, isTrue);
      expect(c1.hashCode == c2.hashCode, isTrue);
    });

    test("PrevValueCell's compare != if they have different argument cells", () {
      final a = MutableCell(0);
      final b = MutableCell(1);

      final c1 = a.previous;
      final c2 = b.previous;

      expect(c1 != c2, isTrue);
      expect(c1 == c1, isTrue);
    });

    test("PrevValueCell's manage the same set of observers", () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);
      final b = MutableCell(0);
      final c = a + b;

      f() => c.previous;

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      verify(resource.init()).called(1);
      verify(resource.dispose()).called(1);
    });

    test('PrevValueCell state recreated on adding observer after dispose', () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);
      final b = MutableCell(0);
      final c = a + b;

      f() => c.previous;

      verifyNever(resource.init());

      final observer = addObserver(f(), MockSimpleObserver());
      f().removeObserver(observer);

      observeCell(f());

      verify(resource.init()).called(2);
      verify(resource.dispose()).called(1);
    });

    test("PrevValueCell does not track value that hasn't changed", () {
      final a = MutableCell([0, 0, 0]);
      final b = ValueCell.computed(() => a()[1], changesOnly: true);
      final prev = b.previous;

      observeCell(prev);

      a.value = [1, 2, 3];
      a.value = [4, 2, 6];
      expect(prev.value, 0);

      a.value = [7, 8, 9];
      expect(prev.value, 2);

      a.value = [10, 8, 11];
      expect(prev.value, 2);

      a.value = [12, 13, 14];
      expect(prev.value, 8);
    });
  });
}