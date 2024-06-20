import 'package:live_cells_core/live_cells_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'util.dart';
import 'util.mocks.dart';

void main() {
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
      final a = -3.cell;

      expect(a.abs().value, equals(3));
    });

    test('a.sign creates ValueCell which is equal to 1 if a > 0', () {
      final a = 3.cell;

      expect(a.sign.value, equals(1));
    });

    test('a.sign creates ValueCell which is equal to -1 if a < 0', () {
      final a = -3.cell;

      expect(a.sign.value, equals(-1));
    });

    test('a.sign creates ValueCell which is equal to 0 if a == 0', () {
      final a = 0.cell;

      expect(a.sign.value, equals(0));
    });
  });

  group('BoolCellExtension', () {
    group('.and()', () {
      test('Evaluates to the logical and of its arguments', () {
        final a = MutableCell(true);
        final b = MutableCell(true);
        final and = a.and(b);

        expect(and.value, isTrue);

        a.value = false;
        expect(and.value, isFalse);

        b.value = false;
        expect(and.value, isFalse);

        a.value = true;
        expect(and.value, isFalse);

        b.value = true;
        expect(and.value, isTrue);
      });

      test('Compares == if same cells', () {
        final a = MutableCell(true);
        final b = MutableCell(true);

        final c1 = a.and(b);
        final c2 = a.and(b);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != if different cells', () {
        final a = MutableCell(true);
        final b = MutableCell(true);
        final c = MutableCell(true);

        final c1 = a.and(b);
        final c2 = b.and(c);
        final c3 = b.and(a);

        expect(c1 == c1, isTrue);
        expect(c1 != c2, isTrue);
        expect(c1 != c3, isTrue);
        expect(c2 != c3, isTrue);
      });
    });

    group('.or()', () {
      test('Evaluates to the logical or of its arguments', () {
        final a = MutableCell(true);
        final b = MutableCell(true);
        final or = a.or(b);

        expect(or.value, isTrue);

        a.value = false;
        expect(or.value, isTrue);

        b.value = false;
        expect(or.value, isFalse);

        a.value = true;
        expect(or.value, isTrue);

        b.value = true;
        expect(or.value, isTrue);
      });

      test('Compares == if same cells', () {
        final a = MutableCell(true);
        final b = MutableCell(true);

        final c1 = a.or(b);
        final c2 = a.or(b);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != if different cells', () {
        final a = MutableCell(true);
        final b = MutableCell(true);
        final c = MutableCell(true);

        final c1 = a.or(b);
        final c2 = b.or(c);
        final c3 = b.or(a);

        expect(c1 == c1, isTrue);
        expect(c1 != c2, isTrue);
        expect(c1 != c3, isTrue);
        expect(c2 != c3, isTrue);
      });
    });

    group('.not()', () {
      test('Evaluates to the logical not of itself', () {
        final a = MutableCell(true);
        final not = a.not();

        expect(not.value, isFalse);

        a.value = false;
        expect(not.value, isTrue);
      });

      test('Compares == if same cells', () {
        final a = MutableCell(true);

        final c1 = a.not();
        final c2 = a.not();

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != if different cells', () {
        final a = MutableCell(true);
        final b = MutableCell(true);

        final c1 = a.not();
        final c2 = b.not();

        expect(c1 == c1, isTrue);
        expect(c1 != c2, isTrue);
      });
    });

    group('.select()', () {
      test('Selects correct value with ifFalse', () {
        final a = 'true'.cell;
        final b = MutableCell('false');
        final cond = MutableCell(true);

        final select = cond.select(a, b);
        final observer = addObserver(select, MockValueObserver());

        expect(select.value, equals('true'));

        cond.value = false;
        b.value = 'else';
        cond.value = true;

        expect(observer.values, equals(['false', 'else', 'true']));
      });

      test('Does not update value when condition is false and ifFalse is not given', () {
        final a = MutableCell('true');
        final cond = MutableCell(true);

        final select = cond.select(a);

        observeCell(select);
        expect(select.value, equals('true'));

        cond.value = false;
        expect(select.value, equals('true'));

        a.value = 'then';
        expect(select.value, equals('true'));

        cond.value = true;
        expect(select.value, equals('then'));

        a.value = 'when';
        expect(select.value, equals('when'));
      });
    });
  });

  group('ErrorCellExtension', () {
    group('.onError()', () {
      test('Handles all exceptions without type argument', () {
        final a = MutableCell(1);
        final b = ValueCell.computed(() {
          if (a() <= 0) {
            throw 'A generic exception';
          }

          return a();
        });

        final c = MutableCell(2);
        final result = b.onError(c);

        final observer = addObserver(result, MockValueObserver());
        expect(result.value, equals(1));

        a.value = 0;
        c.value = 4;
        a.value = 10;
        c.value = 100;

        expect(observer.values, equals([2, 4, 10]));
      });

      test('Handles only given exception with type argument', () {
        final a = MutableCell(1);
        final b = ValueCell.computed(() {
          if (a() < 0) {
            throw Exception('A generic exception');
          }
          else if (a() == 0) {
            throw ArgumentError('A cannot be 0');
          }

          return a();
        });

        final c = MutableCell(2);
        final result = b.onError<ArgumentError>(c);

        final observer = addObserver(result, MockValueObserver());
        expect(result.value, equals(1));

        a.value = 0;
        c.value = 4;
        a.value = 10;
        c.value = 100;

        expect(observer.values, equals([2, 4, 10]));

        result.removeObserver(observer);

        a.value = -1;
        expect(() => result.value, throwsException);
      });

      test('Compares == when same cells and type', () {
        final a = MutableCell(0);
        final e1 = a.onError((-1).cell);
        final e2 = a.onError((-1).cell);

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('Compares != when different `this` cell', () {
        final a = MutableCell(0);
        final b = MutableCell(0);

        final e1 = a.onError((-1).cell);
        final e2 = b.onError((-1).cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('Compares != when different error value cell', () {
        final a = MutableCell(0);

        final e1 = a.onError((-1).cell);
        final e2 = a.onError(2.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('Compares != when different exception type', () {
        final a = MutableCell(0);

        final e1 = a.onError((-1).cell);
        final e2 = a.onError<Exception>((-1).cell);
        final e3 = a.onError<Exception>((-1).cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
        expect(e2 == e3, isTrue);
      });
    });

    group('.error()', () {
      test('Captures exceptions thrown during computation', () {
        final a = MutableCell(1);
        final b = ValueCell.computed(() {
          if (a() < 0) {
            throw 'A generic exception';
          }

          return a();
        });

        final error = b.error();
        final observer = addObserver(error, MockValueObserver());

        expect(error.value, isNull);

        a.value = 2;
        a.value = -1;
        a.value = 3;

        expect(observer.values, equals(['A generic exception']));
      });

      test('Always updates when all = true', () {
        final a = MutableCell(1);
        final b = ValueCell.computed(() {
          if (a() < 0) {
            throw 'A generic exception';
          }

          return a();
        });

        final error = b.error(all: true);

        observeCell(error);
        expect(error.value, isNull);

        a.value = 2;
        expect(error.value, isNull);

        a.value = -1;
        expect(error.value, equals('A generic exception'));

        a.value = 3;
        expect(error.value, isNull);
      });

      test('Captures exception of given type thrown during computation', () {
        final a = MutableCell(1);
        final b = ValueCell.computed(() {
          if (a() < 0) {
            throw 'A generic exception';
          }
          else if (a() == 0) {
            throw ArgumentError('Cannot be zero');
          }

          return a();
        });

        final error = b.error<ArgumentError>();

        observeCell(error);
        expect(error.value, isNull);

        a.value = 2;
        expect(error.value, isNull);

        a.value = 0;
        expect(error.value, isA<ArgumentError>());

        a.value = 3;
        expect(error.value, isA<ArgumentError>());

        a.value = -1;
        expect(error.value, isA<ArgumentError>());
      });

      test('Always updates when all = true and type argument given', () {
        final a = MutableCell(1);
        final b = ValueCell.computed(() {
          if (a() < 0) {
            throw 'A generic exception';
          }
          else if (a() == 0) {
            throw ArgumentError('Cannot be zero');
          }

          return a();
        });

        final error = b.error<ArgumentError>(all: true);

        observeCell(error);
        expect(error.value, isNull);

        a.value = 2;
        expect(error.value, isNull);

        a.value = 0;
        expect(error.value, isA<ArgumentError>());

        a.value = -1;
        expect(error.value, isNull);
      });

      test('Compares == when same cell', () {
        final a = MutableCell(0);

        final e1 = a.error();
        final e2 = a.error();

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('Compares == when same cell and type', () {
        final a = MutableCell(0);

        final e1 = a.error<UninitializedCellError>();
        final e2 = a.error<UninitializedCellError>();

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('Compares != when different cells', () {
        final a = MutableCell(0);
        final b = MutableCell(0);

        final e1 = a.error();
        final e2 = b.error();

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('Compares != when different exception types', () {
        final a = MutableCell(0);

        final e1 = a.error();
        final e2 = a.error<Exception>();

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('Compares != when all options is not equal', () {
        final a = MutableCell(0);

        final e1 = a.error(all: true);
        final e2 = a.error(all: false);
        final e3 = a.error(all: true);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
        expect(e1 == e3, isTrue);
      });
    });

    group('.initialValue()', () {
      test('Passes through cell value when initialized', () {
        final a = MutableCell(0);
        final b = a.initialValue((-1).cell);

        final obs = addObserver(b, MockValueObserver());

        a.value = 1;
        a.value = 2;

        expect(obs.values, equals([1, 2]));
      });

      test('Passes through init value when uninitialized', () {
        final a = MutableCell(0);
        final b = ValueCell.computed(() => a() == 0 ? throw UninitializedCellError() : a());

        final init = MutableCell(-1);
        final c = b.initialValue(init);

        expect(c.value, -1);
        final obs = addObserver(c, MockValueObserver());

        a.value = 1;
        a.value = 2;
        a.value = 0;
        init.value = -5;

        expect(obs.values, equals([1, 2, -1, -5]));
      });

      test('Compares == if same cells', () {
        final a = MutableCell(0);
        final b = MutableCell(1);

        final c1 = a.initialValue(b);
        final c2 = a.initialValue(b);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != if different this cell', () {
        final a = MutableCell(0);
        final b = MutableCell(1);

        final c1 = a.initialValue(1.cell);
        final c2 = b.initialValue(1.cell);

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });

      test('Compares != if different initial value cell', () {
        final a = MutableCell(0);
        final b = MutableCell(1);
        final c = MutableCell(1);

        final c1 = a.initialValue(b);
        final c2 = a.initialValue(c);

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });
    });

    group('.whenReady', () {
      test('Stops execution of watch function on UninitializedCellError', () {
        final a = MutableCell(-1);
        final cell = ValueCell.computed(() => a() > 0 ? a() : throw UninitializedCellError());

        final listener = MockSimpleListener();
        final watch = ValueCell.watch(() {
          cell.whenReady();
          listener();
        });

        addTearDown(() => watch.stop());
        verifyNever(listener());

        a.value = 0;
        a.value = 1;
        a.value = 2;

        verify(listener()).called(2);
      });

      test('Stops execution of watch function on PendingAsyncValueError', () {
        final a = MutableCell(-1);
        final cell = ValueCell.computed(() => a() > 0 ? a() : throw PendingAsyncValueError());

        final listener = MockSimpleListener();
        final watch = ValueCell.watch(() {
          cell.whenReady();
          listener();
        });

        addTearDown(() => watch.stop());
        verifyNever(listener());

        a.value = 0;
        a.value = 1;
        a.value = 2;

        verify(listener()).called(2);
      });
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

    test('ParseIntExtension.mutableString() sets cell to errorValue on errors during parsing integer', () {
      final a = MutableCell(1);

      final strA = a.mutableString(
          errorValue: 7.cell
      );

      strA.value = '25';
      expect(a.value, equals(25));

      strA.value = '12djdjdjdj';
      expect(a.value, equals(7));

      strA.value = '16';
      expect(a.value, equals(16));
    });

    test('ParseMaybeIntExtension.mutableString() forwards errors to argument cell', () {
      final a = MutableCell(1);
      final maybe = a.maybe();
      final error = maybe.error;

      final strA = maybe.mutableString();

      strA.value = '25';

      expect(a.value, equals(25));
      expect(error.value, isNull);

      strA.value = '12djdjdjdj';

      expect(a.value, equals(25));
      expect(error.value, isNotNull);

      strA.value = '16';

      expect(a.value, equals(16));
      expect(error.value, isNull);
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

    test('ParseDoubleExtension.mutableString() sets cell to errorValue on errors during parsing double', () {
      final a = MutableCell(1.0);

      final strA = a.mutableString(
          errorValue: 2.5.cell
      );

      strA.value = '7.5';
      expect(a.value, equals(7.5));

      strA.value = '3.4djdjdjdj';
      expect(a.value, equals(2.5));

      strA.value = '9.0';
      expect(a.value, equals(9.0));
    });

    test('ParseMaybeDoubleExtension.mutableString() forwards errors to argument cell', () {
      final a = MutableCell(1.0);
      final maybe = a.maybe();
      final error = maybe.error;

      final strA = maybe.mutableString();

      strA.value = '7.5';

      expect(a.value, equals(7.5));
      expect(error.value, isNull);

      strA.value = '3.4djdjdjdj';

      expect(a.value, equals(7.5));
      expect(error.value, isNotNull);

      strA.value = '9.0';

      expect(a.value, equals(9.0));
      expect(error.value, isNull);
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

    test('ParseNumExtension.mutableString() sets cell to errorValue on errors during parsing num', () {
      final a = MutableCell<num>(0);

      final strA = a.mutableString(
          errorValue: 8.cell
      );

      strA.value = '7.5';
      expect(a.value, equals(7.5));

      strA.value = '3.4djdjdjdj';
      expect(a.value, equals(8));

      strA.value = '5';
      expect(a.value, equals(5));

    });

    test('ParseNumExtension.mutableString() forwards errors to argument cell', () {
      final a = MutableCell<num>(0);
      final maybe = a.maybe();
      final error = maybe.error;

      final strA = maybe.mutableString();

      strA.value = '7.5';

      expect(a.value, equals(7.5));
      expect(error.value, isNull);

      strA.value = '3.4djdjdjdj';

      expect(a.value, equals(7.5));
      expect(error.value, isNotNull);

      strA.value = '5';

      expect(a.value, equals(5));
      expect(error.value, isNull);
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

  group('NullCheckExtension', () {
    group('.notNull', () {
      test('Returns value of cell when not null', () {
        final a = MutableCell<int?>(0);
        final ValueCell<int?> cell = a;
        final b = cell.notNull;

        final observer = addObserver(b, MockValueObserver());
        expect(b.value, 0);

        a.value = 1;
        a.value = 2;
        a.value = 3;

        expect(observer.values, equals([1, 2, 3]));
      });

      test('Throws NullCellError when value is null', () {
        final a = MutableCell<int?>(null);
        final ValueCell<int?> cell = a;
        final b = cell.notNull;

        observeCell(b);
        expect(() => b.value, throwsA(isA<NullCellError>()));

        a.value = 1;
        expect(b.value, 1);

        a.value = null;
        expect(() => b.value, throwsA(isA<NullCellError>()));

        a.value = 2;
        expect(b.value, 2);
      });

      test('Compares == when same cell', () {
        final m = MutableCell<int?>(0);
        final ValueCell<int?> a = m;

        final c1 = a.notNull;
        final c2 = a.notNull;

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != when different cells', () {
        final m1 = MutableCell<int?>(0);
        final m2 = MutableCell<int?>(0);

        final ValueCell<int?> a = m1;
        final ValueCell<int?> b = m2;

        final c1 = a.notNull;
        final c2 = b.notNull;

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });
    });

    group('Mutable .notNull', () {
      test('Returns value of cell when not null', () {
        final a = MutableCell<int?>(0);
        final b = a.notNull;

        final observer = addObserver(b, MockValueObserver());
        expect(b.value, 0);

        a.value = 1;
        a.value = 2;
        a.value = 3;

        expect(observer.values, equals([1, 2, 3]));
      });

      test('Throws NullCellError when value is null', () {
        final a = MutableCell<int?>(null);
        final b = a.notNull;

        observeCell(b);
        expect(() => b.value, throwsA(isA<NullCellError>()));

        a.value = 1;
        expect(b.value, 1);

        a.value = null;
        expect(() => b.value, throwsA(isA<NullCellError>()));

        a.value = 2;
        expect(b.value, 2);
      });

      test('Compares == when same cell', () {
        final a = MutableCell<int?>(0);

        final c1 = a.notNull;
        final c2 = a.notNull;

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != when different cells', () {
        final a = MutableCell<int?>(0);
        final b = MutableCell<int?>(0);

        final c1 = a.notNull;
        final c2 = b.notNull;

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });
    });

    group('.coalesce', () {
      test('Returns value of cell when not null', () {
        final a = MutableCell<int?>(0);
        final n = MutableCell(-1);
        final b = a.coalesce(n);

        final observer = addObserver(b, MockValueObserver());
        expect(b.value, 0);

        a.value = 1;
        a.value = 2;
        a.value = 3;

        expect(observer.values, equals([1, 2, 3]));
      });

      test('Returns value of coalesce when null.', () {
        final a = MutableCell<int?>(null);
        final n = MutableCell(-1);
        final b = a.coalesce(n);

        final observer = addObserver(b, MockValueObserver());

        expect(b.value, -1);

        a.value = 1;
        a.value = null;
        n.value = -2;
        a.value = 3;
        n.value = -10;
        a.value = 4;
        a.value = null;

        expect(observer.values, equals([1, -1, -2, 3, 4, -10]));
      });

      test('Only evaluates coalesce when value is null', () {
        final a = MutableCell<int?>(null);
        final b = a.coalesce(ValueCell.computed(() => throw ArgumentError()));

        observeCell(b);
        expect(() => b.value, throwsArgumentError);

        a.value = 1;
        expect(b.value, 1);

        a.value = null;
        expect(() => b.value, throwsArgumentError);
      });

      test('Compares == when same cells', () {
        final a = MutableCell<int?>(0);
        final n = MutableCell<int>(-1);

        final c1 = a.coalesce(n);
        final c2 = a.coalesce(n);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Compares != when different cells', () {
        final a = MutableCell<int?>(0);
        final b = MutableCell<int?>(0);
        final n = MutableCell<int>(-1);

        final c1 = a.coalesce(n);
        final c2 = b.coalesce(n);
        final c3 = a.coalesce((-1).cell);

        expect(c1 == c1, isTrue);
        expect(c1 != c2, isTrue);
        expect(c1 != c3, isTrue);
        expect(c2 != c3, isTrue);
      });
    });
  });

  group('Duration extensions', () {
    test('Duration properties are accessed correctly on ValueCell', () {
      const duration = Duration(
          days: 24,
          hours: 10,
          minutes: 23,
          seconds: 47,
          milliseconds: 100,
          microseconds: 500
      );

      final cell = duration.cell;
      final days = cell.inDays;
      final hours = cell.inHours;
      final minutes = cell.inMinutes;
      final seconds = cell.inSeconds;
      final milliseconds = cell.inMilliseconds;
      final microseconds = cell.inMicroseconds;

      expect(cell.value, equals(duration));
      expect(days.value, equals(duration.inDays));
      expect(hours.value, equals(duration.inHours));
      expect(minutes.value, equals(duration.inMinutes));
      expect(seconds.value, equals(duration.inSeconds));
      expect(milliseconds.value, equals(duration.inMilliseconds));
      expect(microseconds.value, equals(duration.inMicroseconds));
    });

    test('Duration properties are accessed correctly on MutableCell', () {
      const duration = Duration(days: 24);
      final cell = MutableCell(Duration.zero);

      cell.value = duration;

      final days = cell.inDays;
      final hours = cell.inHours;
      final minutes = cell.inMinutes;
      final seconds = cell.inSeconds;
      final milliseconds = cell.inMilliseconds;
      final microseconds = cell.inMicroseconds;

      expect(cell.value, equals(duration));
      expect(days.value, equals(duration.inDays));
      expect(hours.value, equals(duration.inHours));
      expect(minutes.value, equals(duration.inMinutes));
      expect(seconds.value, equals(duration.inSeconds));
      expect(milliseconds.value, equals(duration.inMilliseconds));
      expect(microseconds.value, equals(duration.inMicroseconds));
    });

    test('Setting MutableCell Duration properties updates Duration stored in cell', () {
      final cell = MutableCell(Duration.zero);

      final days = cell.inDays;
      final hours = cell.inHours;
      final minutes = cell.inMinutes;
      final seconds = cell.inSeconds;
      final milliseconds = cell.inMilliseconds;
      final microseconds = cell.inMicroseconds;

      days.value = 30;
      expect(cell.value, equals(const Duration(days: 30)));

      hours.value = 45;
      expect(cell.value, equals(const Duration(hours: 45)));

      minutes.value = 23;
      expect(cell.value, equals(const Duration(minutes: 23)));

      seconds.value = 45;
      expect(cell.value, equals(const Duration(seconds: 45)));

      milliseconds.value = 398;
      expect(cell.value, equals(const Duration(milliseconds: 398)));

      microseconds.value = 1204;
      expect(cell.value, equals(const Duration(microseconds: 1204)));
    });

    test('Arithmetic involving Duration cells', () {
      final a = const Duration(hours: 5).cell;
      final delta = const Duration(hours: 10, minutes: 30).cell;

      final sum = a + delta;
      final diff = a - delta;
      final prod = delta * 2.cell;
      final div = delta ~/ 2.cell;
      final neg = -a;

      expect(sum.value, equals(const Duration(hours: 15, minutes: 30)));
      expect(diff.value, equals(const Duration(hours: -5, minutes: -30)));
      expect(prod.value, equals(const Duration(hours: 21)));
      expect(div.value, equals(const Duration(hours: 5, minutes: 15)));
      expect(neg.value, equals(const Duration(hours: -5)));
    });

    test('Comparison of Duration cells', () {
      final a = const Duration(hours: 5).cell;
      final b = const Duration(hours: 10, minutes: 30).cell;

      expect((a < b).value, isTrue);
      expect((b < a).value, isFalse);

      expect((a > b).value, isFalse);
      expect((b > a).value, isTrue);

      expect((a <= b).value, isTrue);
      expect((a <= a).value, isTrue);
      expect((b <= a).value, isFalse);

      expect((a >= b).value, isFalse);
      expect((a >= a).value, isTrue);
      expect((b >= a).value, isTrue);
    });

    test('isNegative property of Duration cells', () {
      final a = const Duration(hours: 1, minutes: 20).cell;

      expect(a.isNegative.value, isFalse);
      expect((-a).isNegative.value, isTrue);
    });

    test('abs() method of Duration cells', () {
      final a = const Duration(hours: 5).cell;
      final b = const Duration(hours: -5).cell;

      expect(a.abs().value, equals(const Duration(hours: 5)));
      expect(b.abs().value, equals(const Duration(hours: 5)));
    });
  });

  group('List Cell Extensions', () {
    group('.first', () {
      test('ValueCell.first retrieves first element', () {
        final l = [1, 2, 3].cell;
        final f = l.first;

        expect(f.value, 1);
      });

      test('MutableCell.first retrieves first element', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.first;

        expect(f.value, 1);
      });

      test('ValueCell.first notifies observers when first element changed', () {
        final l = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = l;
        final observer = addObserver(l2.first, MockValueObserver());

        l.value = [4, 5, 6];
        l.value = [7, 8, 9];
        l.value = [10, 11, 12];

        expect(observer.values, equals([4, 7, 10]));
      });

      test('Mutable.first notifies observers when first element changed', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l.first, MockValueObserver());

        l.value = [4, 5, 6];
        l.value = [7, 8, 9];
        l.value = [10, 11, 12];

        expect(observer.values, equals([4, 7, 10]));
      });

      test('ValueCell.first does not notify observers when first element not changed', () {
        final l = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = l;
        final f = l2.first;

        final listener = addListener(f, MockSimpleListener());

        l.value = [1, 4, 5];
        verifyNever(listener());

        l.value = [1, 6, 7];
        verifyNever(listener());

        l.value = [8, 9, 10];
        verify(listener()).called(1);

        l.value = [11, 12, 13];
        verify(listener()).called(1);

        l.value = [11, 14, 15];
        verifyNever(listener());

        l.value = [16, 17, 18];
        verify(listener()).called(1);
      });

      test('MutableCell.first does not notify observers when first element not changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.first;

        final listener = addListener(f, MockSimpleListener());

        l.value = [1, 4, 5];
        verifyNever(listener());

        l.value = [1, 6, 7];
        verifyNever(listener());

        l.value = [8, 9, 10];
        verify(listener()).called(1);

        l.value = [11, 12, 13];
        verify(listener()).called(1);

        l.value = [11, 14, 15];
        verifyNever(listener());

        l.value = [16, 17, 18];
        verify(listener()).called(1);
      });

      test('Setting MutableCell.first.value, updates list cell value', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.first;

        f.value = 10;
        expect(l.value, equals([10, 2, 3]));

        f.value = 20;
        expect(l.value, equals([20, 2, 3]));
      });

      test('ValueCell.first compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.first;
        final f2 = l.first;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.first compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.first;
        final f2 = l2.first;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });

      test('MutableCell.first compares == when same list cell', () {
        final l = MutableCell([1, 2, 3]);
        final f1 = l.first;
        final f2 = l.first;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('MutableCell.first compares != when different list cells', () {
        final l1 = MutableCell([1, 2, 3]);
        final l2 = MutableCell([1, 2, 3]);

        final f1 = l1.first;
        final f2 = l2.first;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.last', () {
      test('ValueCell.last retrieves last element', () {
        final l = [1, 2, 3].cell;
        final f = l.last;

        expect(f.value, 3);
      });

      test('MutableCell.last retrieves last element', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.last;

        expect(f.value, 3);
      });

      test('ValueCell.last notifies observers when last element changed', () {
        final l = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = l;
        final observer = addObserver(l2.last, MockValueObserver());

        l.value = [4, 5, 6];
        l.value = [7, 8, 9];
        l.value = [10, 11, 12];

        expect(observer.values, equals([6, 9, 12]));
      });

      test('Mutable.last notifies observers when last element changed', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l.last, MockValueObserver());

        l.value = [4, 5, 6];
        l.value = [7, 8, 9];
        l.value = [10, 11, 12];

        expect(observer.values, equals([6, 9, 12]));
      });

      test('ValueCell.last does not notify observers when last element not changed', () {
        final l = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = l;
        final f = l2.last;

        final listener = addListener(f, MockSimpleListener());

        l.value = [4, 5, 3];
        verifyNever(listener());

        l.value = [6, 7, 3];
        verifyNever(listener());

        l.value = [8, 9, 10];
        verify(listener()).called(1);

        l.value = [11, 12, 13];
        verify(listener()).called(1);

        l.value = [14, 15, 13];
        verifyNever(listener());

        l.value = [16, 17, 18];
        verify(listener()).called(1);
      });

      test('MutableCell.last does not notify observers when last element not changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.last;

        final listener = addListener(f, MockSimpleListener());

        l.value = [4, 5, 3];
        verifyNever(listener());

        l.value = [6, 7, 3];
        verifyNever(listener());

        l.value = [8, 9, 10];
        verify(listener()).called(1);

        l.value = [11, 12, 13];
        verify(listener()).called(1);

        l.value = [14, 15, 13];
        verifyNever(listener());

        l.value = [16, 17, 18];
        verify(listener()).called(1);
      });

      test('Setting MutableCell.last.value, updates list cell value', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.last;

        f.value = 10;
        expect(l.value, equals([1, 2, 10]));

        f.value = 20;
        expect(l.value, equals([1, 2, 20]));
      });

      test('ValueCell.last compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.last;
        final f2 = l.last;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.last compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.last;
        final f2 = l2.last;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });

      test('MutableCell.last compares == when same list cell', () {
        final l = MutableCell([1, 2, 3]);
        final f1 = l.last;
        final f2 = l.last;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('MutableCell.last compares != when different list cells', () {
        final l1 = MutableCell([1, 2, 3]);
        final l2 = MutableCell([1, 2, 3]);

        final f1 = l1.last;
        final f2 = l2.last;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.isEmpty', () {
      test('ValueCell.isEmpty is true when list is empty', () {
        final l = [].cell;
        final f = l.isEmpty;

        expect(f.value, isTrue);
      });

      test('ValueCell.isEmpty is false when list is not empty', () {
        final l = [1, 2, 3].cell;
        final f = l.isEmpty;

        expect(f.value, isFalse);
      });

      test('ValueCell.isEmpty notifies observers when list length changes', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l.isEmpty, MockValueObserver());

        l.value = [];
        l.value = [4, 5, 6];
        l.value = [7, 8, 9];
        l.value = [];

        expect(observer.values, equals([true, false, true]));
      });

      test('ValueCell.isEmpty does not notify observers when value has not changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.isEmpty;

        final listener = addListener(f, MockSimpleListener());

        l.value = [4, 5, 3];
        verifyNever(listener());

        l.value = [6, 7, 3];
        verifyNever(listener());

        l.value = [];
        verify(listener()).called(1);

        l.value = [];
        verifyNever(listener());

        l.value = [];
        verifyNever(listener());

        l.value = [8, 9, 10];
        verify(listener()).called(1);

        l.value = [11, 12, 13];
        verifyNever(listener());

        l.value = [14, 15, 13];
        verifyNever(listener());

        l.value = [16, 17, 18];
        verifyNever(listener());
      });

      test('ValueCell.isEmpty compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.isEmpty;
        final f2 = l.isEmpty;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.isEmpty compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.isEmpty;
        final f2 = l2.isEmpty;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.isNotEmpty', () {
      test('ValueCell.isNotEmpty is false when list is empty', () {
        final l = [].cell;
        final f = l.isNotEmpty;

        expect(f.value, isFalse);
      });

      test('ValueCell.isNotEmpty is true when list is not empty', () {
        final l = [1, 2, 3].cell;
        final f = l.isNotEmpty;

        expect(f.value, isTrue);
      });

      test('ValueCell.isNotEmpty notifies observers when list length changes', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l.isNotEmpty, MockValueObserver());

        l.value = [];
        l.value = [4, 5, 6];
        l.value = [7, 8, 9];
        l.value = [];

        expect(observer.values, equals([false, true, false]));
      });

      test('ValueCell.isNotEmpty does not notify observers when value has not changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.isNotEmpty;

        final listener = addListener(f, MockSimpleListener());

        l.value = [4, 5, 3];
        verifyNever(listener());

        l.value = [6, 7, 3];
        verifyNever(listener());

        l.value = [];
        verify(listener()).called(1);

        l.value = [];
        verifyNever(listener());

        l.value = [];
        verifyNever(listener());

        l.value = [8, 9, 10];
        verify(listener()).called(1);

        l.value = [11, 12, 13];
        verifyNever(listener());

        l.value = [14, 15, 13];
        verifyNever(listener());

        l.value = [16, 17, 18];
        verifyNever(listener());
      });

      test('ValueCell.isNotEmpty compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.isNotEmpty;
        final f2 = l.isNotEmpty;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.isNotEmpty compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.isNotEmpty;
        final f2 = l2.isNotEmpty;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.length', () {
      test('ValueCell.length retrieves list length', () {
        final l = [1, 1, 1, 1].cell;
        final f = l.length;

        expect(f.value, 4);
      });

      test('MutableCell.length retrieves list length', () {
        final l = MutableCell([1, 1, 1, 1]);
        final f = l.length;

        expect(f.value, 4);
      });

      test('ValueCell.length notifies observers when list length changed', () {
        final l = MutableCell([1]);
        final ValueCell<List<int>> l2 = l;
        final observer = addObserver(l2.length, MockValueObserver());

        l.value = [1, 2];
        l.value = [1, 2, 1];
        l.value = [2, 2, 2, 2, 2];

        expect(observer.values, equals([2, 3, 5]));
      });

      test('Mutable.length notifies observers when list length changed', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l.length, MockValueObserver());

        l.value = [1, 2];
        l.value = [1, 2, 1];
        l.value = [2, 2, 2, 2, 2];

        expect(observer.values, equals([2, 3, 5]));
      });

      test('ValueCell.length does not notify observers when list length not changed', () {
        final l = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = l;
        final f = l2.length;

        final listener = addListener(f, MockSimpleListener());

        l.value = [1, 1, 1];
        verifyNever(listener());

        l.value = [2, 2, 2];
        verifyNever(listener());

        l.value = [1, 1, 1, 1];
        verify(listener()).called(1);

        l.value = [3, 2, 1, 0];
        verifyNever(listener());

        l.value = [4, 5, 6, 7, 8];
        verify(listener()).called(1);
      });

      test('MutableCell.length does not notify observers when list length not changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.length;

        final listener = addListener(f, MockSimpleListener());

        l.value = [1, 1, 1];
        verifyNever(listener());

        l.value = [2, 2, 2];
        verifyNever(listener());

        l.value = [1, 1, 1, 1];
        verify(listener()).called(1);

        l.value = [3, 2, 1, 0];
        verifyNever(listener());

        l.value = [4, 5, 6, 7, 8];
        verify(listener()).called(1);
      });

      test('Setting MutableCell.length.value shrinks list', () {
        final l = MutableCell([1, 2, 3, 4, 5 ,6]);
        final f = l.length;

        f.value = 4;
        expect(l.value, equals([1, 2, 3, 4]));

        f.value = 1;
        expect(l.value, equals([1]));
      });

      test('Setting MutableCell.length.value expands list', () {
        final l = MutableCell<List<int?>>([1, 2, 3]);
        final f = l.length;

        f.value = 6;
        expect(l.value, equals([1, 2, 3, null, null, null]));

        f.value = 1;
        expect(l.value, equals([1]));
      });

      test('ValueCell.length compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.length;
        final f2 = l.length;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.length compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.length;
        final f2 = l2.length;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });

      test('MutableCell.length compares == when same list cell', () {
        final l = MutableCell([1, 2, 3]);
        final f1 = l.length;
        final f2 = l.length;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('MutableCell.length compares != when different list cells', () {
        final l1 = MutableCell([1, 2, 3]);
        final l2 = MutableCell([1, 2, 3]);

        final f1 = l1.length;
        final f2 = l2.length;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.reversed', () {
      test('ValueCell.reversed returns reversed list', () {
        final l = MutableCell([1, 2, 3, 4]);
        final f = l.reversed;

        expect(f.value.toList(), [4, 3, 2, 1]);
      });

      test('ValueCell.reversed notifies observers when list has changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.reversed;

        final listener = addListener(f, MockSimpleListener());

        l.value = [4, 5, 3];
        l.value = [6, 7, 3];
        l.value = [];
        l.value = [8, 9, 10];
        l.value = [16, 17, 18, 19, 20];

        verify(listener()).called(5);
      });

      test('ValueCell.reversed compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.reversed;
        final f2 = l.reversed;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.reversed compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.reversed;
        final f2 = l2.reversed;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.single', () {
      test('ValueCell.single returns element when single', () {
        final l = MutableCell([100]);
        final f = l.single;

        expect(f.value, 100);
      });

      test('ValueCell.single throws exception when empty or not single', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.single;

        expect(() => f.value, throwsStateError);

        l.value = [];
        expect(() => f.value, throwsStateError);
      });

      test('ValueCell.single notifies observers when list has changed', () {
        final l = MutableCell([1, 2, 3]);
        final f = l.single;

        final listener = addListener(f, MockSimpleListener());

        l.value = [4];
        l.value = [6, 7, 3];
        l.value = [];
        l.value = [8, 9];

        verify(listener()).called(4);
      });

      test('ValueCell.single compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.reversed;
        final f2 = l.reversed;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.single compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.reversed;
        final f2 = l2.reversed;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.operator[]', () {
      test('ValueCell.operator[] retrieves indexed element', () {
        final l = [10, 20, 30, 40].cell;
        final f = l[2.cell];

        expect(f.value, 30);
      });

      test('MutableCell.operator[] retrieves indexed element', () {
        final l = MutableCell([10, 20, 30, 40]);
        final f = l[1.cell];

        expect(f.value, 20);
      });

      test('ValueCell.operator[] notifies observers when indexed element changed', () {
        final l = MutableCell([11, 22, 33, 44, 55]);
        final ValueCell<List<int>> l2 = l;
        final observer = addObserver(l2[3.cell], MockValueObserver());

        l.value = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        l.value = [11, 12, 13, 14];
        l.value = [2, 4, 8, 16, 32];

        expect(observer.values, equals([4, 14, 16]));
      });

      test('Mutable.operator[] notifies observers when indexed element changed', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l[3.cell], MockValueObserver());

        l.value = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        l.value = [11, 12, 13, 14];
        l.value = [2, 4, 8, 16, 32];

        expect(observer.values, equals([4, 14, 16]));
      });

      test('ValueCell.operator[] does not notify observers when indexed element not changed', () {
        final l = MutableCell([1, 2, 3, 4, 5, 6, 7]);
        final ValueCell<List<int>> l2 = l;
        final f = l2[3.cell];

        final listener = addListener(f, MockSimpleListener());

        l.value = [10, 20, 30, 4, 50];
        verifyNever(listener());

        l.value = [11, 12, 13, 4, 15, 16, 17, 18];
        verifyNever(listener());

        l.value = [22, 33, 44, 55, 66];
        verify(listener()).called(1);

        l.value = [1, 2, 3, 4];
        verify(listener()).called(1);

        l.value = [5, 6, 7, 4, 8];
        verifyNever(listener());

        l.value = [9, 10, 11, 12];
        verify(listener()).called(1);
      });

      test('MutableCell.operator[] does not notify observers when indexed element not changed', () {
        final l = MutableCell([1, 2, 3, 4, 5, 6, 7]);
        final f = l[3.cell];

        final listener = addListener(f, MockSimpleListener());

        l.value = [10, 20, 30, 4, 50];
        verifyNever(listener());

        l.value = [11, 12, 13, 4, 15, 16, 17, 18];
        verifyNever(listener());

        l.value = [22, 33, 44, 55, 66];
        verify(listener()).called(1);

        l.value = [1, 2, 3, 4];
        verify(listener()).called(1);

        l.value = [5, 6, 7, 4, 8];
        verifyNever(listener());

        l.value = [9, 10, 11, 12];
        verify(listener()).called(1);
      });

      test('Setting MutableCell.operator[].value, updates list cell value', () {
        final l = MutableCell([1, 2, 3]);
        final f = l[1.cell];

        f.value = 10;
        expect(l.value, equals([1, 10, 3]));

        f.value = 20;
        expect(l.value, equals([1, 20, 3]));
      });

      test('ValueCell.operator[] notifies observers when index changed', () {
        final l = [2, 4, 8, 16, 32].cell;
        final i = MutableCell(2);
        final e = l[i];

        final observer = addObserver(e, MockValueObserver());

        i.value = 0;
        i.value = 3;
        i.value = 1;

        expect(observer.values, equals([2, 16, 4]));
      });

      test('Mutable.operator[] notifies observers when index changed', () {
        final l = MutableCell([2, 4, 8, 16, 32]);
        final i = MutableCell(2);
        final e = l[i];

        final observer = addObserver(e, MockValueObserver());

        i.value = 0;
        i.value = 3;
        i.value = 1;

        expect(observer.values, equals([2, 16, 4]));
      });

      test('ValueCell.operator[] does not notify observers when index not changed', () {
        final l = [2, 4, 8, 16, 32].cell;
        final i = MutableCell(2);
        final e = l[i];

        final listener = addListener(e, MockSimpleListener());

        i.value = 2;
        verifyNever(listener());

        i.value = 2;
        verifyNever(listener());

        i.value = 1;
        verify(listener()).called(1);

        i.value = 1;
        verifyNever(listener());

        i.value = 0;
        verify(listener()).called(1);
      });

      test('Mutable.operator[] does not notify observers when index not changed', () {
        final l = MutableCell([2, 4, 8, 16, 32]);
        final i = MutableCell(2);
        final e = l[i];

        final listener = addListener(e, MockSimpleListener());

        i.value = 2;
        verifyNever(listener());

        i.value = 2;
        verifyNever(listener());

        i.value = 1;
        verify(listener()).called(1);

        i.value = 1;
        verifyNever(listener());

        i.value = 0;
        verify(listener()).called(1);
      });

      test('ValueCell.operator[] gets correct value in batch update', () {
        final l1 = MutableCell([2, 4, 8]);
        final ValueCell<List<int>> l2 = l1;
        final i = MutableCell(2);
        final e = l2[i];

        final observer = addObserver(e, MockValueObserver());

        MutableCell.batch(() {
          i.value = 4;
          l1.value = [16, 32, 64, 128, 256, 512];
        });

        expect(observer.values, equals([256]));
      });

      test('MutableCell.operator[] gets correct value in batch update', () {
        final l = MutableCell([2, 4, 8]);
        final i = MutableCell(2);
        final e = l[i];

        final observer = addObserver(e, MockValueObserver());

        MutableCell.batch(() {
          i.value = 4;
          l.value = [16, 32, 64, 128, 256, 512];
        });

        expect(observer.values, equals([256]));
      });

      test('ValueCell.operator[] compares == when same list cell and same index', () {
        final l = [1, 2, 3].cell;
        final f1 = l[2.cell];
        final f2 = l[2.cell];

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.operator[] compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1[1.cell];
        final f2 = l2[1.cell];

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });

      test('ValueCell.operator[] compares != when different indices', () {
        final ValueCell<List<int>> l = MutableCell([1, 2, 3]);

        final f1 = l[0.cell];
        final f2 = l[1.cell];

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });

      test('MutableCell.operator[] compares == when same list cell and same index', () {
        final l = MutableCell([1, 2, 3]);
        final f1 = l[2.cell];
        final f2 = l[2.cell];

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('MutableCell.operator[] compares != when different list cells', () {
        final l1 = MutableCell([1, 2, 3]);
        final l2 = MutableCell([1, 2, 3]);

        final f1 = l1[1.cell];
        final f2 = l2[1.cell];

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });

      test('Mutable.operator[] compares != when different indices', () {
        final l = MutableCell([1, 2, 3]);

        final f1 = l[0.cell];
        final f2 = l[1.cell];

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.operator[]=', () {
      test('MutableCell.operator[]= updates list cell value', () {
        final l = MutableCell([1, 2, 3]);
        final observer = addObserver(l, MockValueObserver());

        l[1] = 10;
        l[2] = 20;

        expect(observer.values, equals([[1, 10, 3], [1, 10, 20]]));
      });
    });

    group('.cellList', () {
      test('ValueCell.cells returns list of cells observing each element', () {
        final list = ['a', 'b', 'c'].cell;
        final cells = list.cellList.value.toList();

        expect(cells[0].value, 'a');
        expect(cells[1].value, 'b');
        expect(cells[2].value, 'c');
      });

      test('ValueCell.cells notifies observer when list length changed', () {
        final list = MutableCell([1, 2, 3, 4]);
        final cells = list.cellList;

        final l = addListener(cells, MockSimpleListener());

        list.value = [5, 6, 7, 8];
        list.value = [1, 2];
        list.value = [0];
        list.value = [100];

        verify(l()).called(2);
      });

      test('ValueCell.cells returns list of cells which notify observer when element changed', () {
        final list = MutableCell([1, 2, 3, 4]);
        final cells = list.cellList.value.toList();

        final o1 = addObserver(cells[0], MockValueObserver());
        final o2 = addObserver(cells[2], MockValueObserver());

        list.value = [5, 6, 7, 8];
        list.value = [5, 10, 15, 20];
        list.value = [100, 101, 102, 103, 104, 105, 106];

        expect(o1.values, equals([5, 100]));
        expect(o2.values, equals([7, 15, 102]));
      });

      test('ValueCell.cells returns list of cells which do not notify observer when element not changed', () {
        final list = MutableCell([1, 2, 3, 4]);
        final cells = list.cellList.value.toList();

        final l1 = addListener(cells[0], MockSimpleListener());
        final l2 = addListener(cells[2], MockSimpleListener());

        list.value = [5, 6, 7, 8];
        list.value = [5, 10, 15, 20];
        list.value = [100, 101, 102, 103, 104, 105, 106];
        list.value = [100, 0, 102];

        verify(l1()).called(2);
        verify(l2()).called(3);
      });

      test('ValueCell.cells compares == when same list cell', () {
        final l = [1, 2, 3].cell;
        final f1 = l.cellList;
        final f2 = l.cellList;

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.cells compares != when different list cells', () {
        final ValueCell<List<int>> l1 = MutableCell([1, 2, 3]);
        final ValueCell<List<int>> l2 = MutableCell([1, 2, 3]);

        final f1 = l1.cellList;
        final f2 = l2.cellList;

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.cast()', () {
      test('Returns correct value', () {
        final ValueCell<List<dynamic>> cell = [1, 2, 3, 4, 5].cell;
        final ValueCell<List<num>> cast = cell.cast<num>();

        expect(cast.value.toList(), equals([1, 2, 3, 4, 5]));
      });

      test('Compares == when same cell and same type', () {
        final ValueCell<List<dynamic>> cell = [0, 1, 2, 3, 4].cell;
        final ValueCell<List<num>> cast1 = cell.cast<num>();
        final ValueCell<List<num>> cast2 = cell.cast<num>();

        expect(cast1 == cast2, isTrue);
        expect(cast1.hashCode == cast2.hashCode, isTrue);
      });

      test('Compares != when different cells', () {
        final cell1 = MutableCell<Iterable<dynamic>>([0, 1, 2, 3, 4]);
        final cell2 = MutableCell<Iterable<dynamic>>([0, 1, 2, 3, 4]);

        final cast1 = cell1.cast<num>();
        final cast2 = cell2.cast<num>();

        expect(cast1 != cast2, isTrue);
        expect(cast1 == cast1, isTrue);
      });

      test('Compares != when different types', () {
        final ValueCell<List<dynamic>> cell = [0, 1, 2, 3, 4].cell;
        final cast1 = cell.cast<num>();
        final cast2 = cell.cast<int>();

        expect(cast1 != cast2, isTrue);
        expect(cast1 == cast1, isTrue);
      });
    });

    group('.mapCell()', () {
      test('Returns correct value', () {
        final it = [1, 2, 3].cell;
        final map = it.mapCells((e) => e * 2);

        expect(map.value.map((e) => e.value).toList(), equals([2, 4, 6]));
      });

      test('Reacts to changes in list length only', () {
        final it = MutableCell([1, 2, 3]);
        final map = it.mapCells((e) => e * 2);

        final listener = addListener(map, MockSimpleListener());

        expect(map.value.map((e) => e.value).toList(), equals([2, 4, 6]));

        it.value = [4, 5, 6];
        expect(map.value.map((e) => e.value).toList(), equals([8, 10, 12]));

        verifyNever(listener());

        it.value = [7, 8];
        expect(map.value.map((e) => e.value).toList(), equals([14, 16]));

        verify(listener()).called(1);
      });

      test('Element cells react to element changes only', () {
        final it = MutableCell([1, 2, 3, 4]);
        final map = it.mapCells((e) => e * 2);

        final listener1 = addListener(map.value.first, MockSimpleListener());
        final listener2 = addListener(map.value.elementAt(1), MockSimpleListener());
        final listener3 = addListener(map.value.elementAt(2), MockSimpleListener());

        it.value = [1, 10, 3, 20];
        verifyNever(listener1());
        verifyNever(listener3());
        verify(listener2()).called(1);

        it.value = [5, 6, 7];
        verify(listener1()).called(1);
        verify(listener2()).called(1);
        verify(listener3()).called(1);
      });

      test('Compares == when same cell and same function', () {
        f(a) => a * 2;

        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells(f);
        final map2 = l.mapCells(f);

        expect(map1 == map2, isTrue);
        expect(map1.hashCode == map2.hashCode, isTrue);
      });

      test('Compares != when same cell and different function', () {
        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells((e) => e * 2);
        final map2 = l.mapCells((e) => e + 1);

        expect(map1 != map2, isTrue);
        expect(map1 == map1, isTrue);
      });

      test('Compares != when different cells', () {
        f(a) => a * 2;

        final l1 = MutableCell([1, 2, 3, 4]);
        final l2 = MutableCell([1, 2, 3, 4]);
        final map1 = l1.mapCells(f);
        final map2 = l2.mapCells(f);

        expect(map1 != map2, isTrue);
        expect(map1 == map1, isTrue);
      });

      test('Element cells compare == when same cell and function', () {
        f(a) => a * 2;

        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells(f);
        final map2 = l.mapCells(f);

        final c1 = map1.value.elementAt(1);
        final c2 = map2.value.elementAt(1);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Element cells compare != when same cell and different function', () {
        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells((a) => a * 2);
        final map2 = l.mapCells((a) => a + 1);

        final c1 = map1.value.elementAt(1);
        final c2 = map2.value.elementAt(1);

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });

      test('Element cells compare != when different cells', () {
        f(a) => a * 2;

        final l1 = MutableCell([1, 2, 3, 4]);
        final l2 = MutableCell([1, 2, 3, 4]);
        final map1 = l1.mapCells(f);
        final map2 = l2.mapCells(f);

        final c1 = map1.value.elementAt(1);
        final c2 = map2.value.elementAt(1);

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });

      test('Element cells compare != when different elements', () {
        f(a) => a * 2;

        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells(f);

        final c1 = map1.value.elementAt(1);
        final c2 = map1.value.elementAt(2);

        expect(c1 != c2, isTrue);
        expect(c1 == c1, isTrue);
      });

      test('Element cells compare == after changes to elements', () {
        f(a) => a * 2;

        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells(f);

        final c1 = map1.value.elementAt(1);

        l.value = [5, 6, 7, 8];

        final c2 = map1.value.elementAt(1);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });

      test('Element cells compare == after changes to elements and list length', () {
        f(a) => a * 2;

        final l = MutableCell([1, 2, 3, 4]);
        final map1 = l.mapCells(f);

        final c1 = map1.value.elementAt(1);

        l.value = [5, 6];

        final c2 = map1.value.elementAt(1);

        expect(c1 == c2, isTrue);
        expect(c1.hashCode == c2.hashCode, isTrue);
      });
    });
  });

  group('Iterable Cell Extensions', () {
    group('.toList()', () {
      test('ValueCell.toList() returns iterable elements in list', () {
        final it = Iterable.generate(5, (i) => i).cell;
        final l = it.toList();

        expect(l.value, equals([0, 1, 2, 3, 4]));
      });

      test('ValueCell.toList() reevaluated when list changes', () {
        final it = MutableCell(Iterable.generate(5, (i) => i));
        final l = it.toList();

        observeCell(l);
        expect(l.value, equals([0, 1, 2, 3, 4]));

        it.value = Iterable.generate(3, (i) => 2 + i);
        expect(l.value, equals([2, 3, 4]));
      });

      test('ValueCell.toList() notifies observers when list changes', () {
        final it = MutableCell(Iterable.generate(5, (i) => i));
        final l = it.toList();

        final listener = addListener(l, MockSimpleListener());

        it.value = Iterable.generate(3, (i) => 2 + i);
        it.value = Iterable.generate(10, (i) => 2 * i);
        it.value = Iterable.generate(5, (_) => 0);

        verify(listener()).called(3);
      });

      test('ValueCell.toList() compares == when same list cell', () {
        final it = MutableCell(Iterable.generate(5, (i) => i));
        final f1 = it.toList();
        final f2 = it.toList();

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.toList() compares != when different list cells', () {
        final it1 = MutableCell(Iterable.generate(5, (i) => i));
        final it2 = MutableCell(Iterable.generate(5, (i) => i));

        final f1 = it1.toList();
        final f2 = it2.toList();

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.toSet()', () {
      test('ValueCell.toSet() returns iterable elements in list', () {
        final it = Iterable.generate(5, (i) => i).cell;
        final l = it.toSet();

        expect(l.value, equals({0, 1, 2, 3, 4}));
      });

      test('ValueCell.toSet() reevaluated when list changes', () {
        final it = MutableCell(Iterable.generate(5, (i) => i));
        final l = it.toSet();

        observeCell(l);
        expect(l.value, equals({0, 1, 2, 3, 4}));

        it.value = Iterable.generate(3, (i) => 2 + i);
        expect(l.value, equals({2, 3, 4}));

        it.value = Iterable.generate(15, (i) => i % 2);
        expect(l.value, {0, 1});
      });

      test('ValueCell.toSet() notifies observers when list changes', () {
        final it = MutableCell(Iterable.generate(5, (i) => i));
        final l = it.toSet();

        final listener = addListener(l, MockSimpleListener());

        it.value = Iterable.generate(3, (i) => 2 + i);
        it.value = Iterable.generate(10, (i) => 2 * i);
        it.value = Iterable.generate(5, (_) => 0);

        verify(listener()).called(3);
      });

      test('ValueCell.toSet() compares == when same list cell', () {
        final it = MutableCell(Iterable.generate(5, (i) => i));
        final f1 = it.toSet();
        final f2 = it.toSet();

        expect(f1 == f2, isTrue);
        expect(f1.hashCode == f2.hashCode, isTrue);
      });

      test('ValueCell.toSet() compares != when different list cells', () {
        final it1 = MutableCell(Iterable.generate(5, (i) => i));
        final it2 = MutableCell(Iterable.generate(5, (i) => i));

        final f1 = it1.toSet();
        final f2 = it2.toSet();

        expect(f1 != f2, isTrue);
        expect(f1 == f1, isTrue);
      });
    });

    group('.cast()', () {
      test('Returns correct value', () {
        final ValueCell<Iterable<dynamic>> cell = Iterable.generate(5, (e) => e).cell;
        final ValueCell<Iterable<num>> cast = cell.cast<num>();

        expect(cast.value.toList(), equals([0, 1, 2, 3, 4]));
      });

      test('Compares == when same cell and same type', () {
        final ValueCell<Iterable<dynamic>> cell = Iterable.generate(5, (e) => e).cell;
        final ValueCell<Iterable<num>> cast1 = cell.cast<num>();
        final ValueCell<Iterable<num>> cast2 = cell.cast<num>();

        expect(cast1 == cast2, isTrue);
        expect(cast1.hashCode == cast2.hashCode, isTrue);
      });

      test('Compares != when different cells', () {
        final cell1 = MutableCell<Iterable<dynamic>>(
            Iterable.generate(5, (e) => e)
        );

        final cell2 = MutableCell<Iterable<dynamic>>(
            Iterable.generate(5, (e) => e)
        );

        final cast1 = cell1.cast<num>();
        final cast2 = cell2.cast<num>();

        expect(cast1 != cast2, isTrue);
        expect(cast1 == cast1, isTrue);
      });

      test('Compares != when different types', () {
        final ValueCell<Iterable<dynamic>> cell = Iterable.generate(5, (e) => e).cell;
        final cast1 = cell.cast<num>();
        final cast2 = cell.cast<int>();

        expect(cast1 != cast2, isTrue);
        expect(cast1 == cast1, isTrue);
      });
    });

    group('.map()', () {
      test('Returns correct value', () {
        final it = Iterable.generate(5, (e) => e).cell;
        final map = it.map((e) => e + 1);

        expect(map.value.toList(), equals([1, 2, 3, 4, 5]));
      });

      test('Reacts to changes in iterable', () {
        final it = MutableCell(
            Iterable.generate(5, (e) => e)
        );

        final map = it.map((e) => e * 2);
        expect(map.value.toList(), equals([0, 2, 4, 6, 8]));

        it.value = Iterable.generate(3, (e) => 10 + e);
        expect(map.value.toList(), equals([20, 22, 24]));
      });
    });
  });

  group('Map Cell Extensions', () {
    group('.isEmpty', () {
      test('Returns correct value', () {
        final m = MutableCell({'a': 0, 'b': 1});

        final obs = addObserver(m.isEmpty, MockValueObserver());

        m.value = {
          'b': 100
        };

        m.value = {};
        m.value = {'d': 9, 'b': 5};

        expect(obs.values, equals([false, true, false]));
      });

      test('compares == when same map cell', () {
        final map = {'a': 1}.cell;
        final e1 = map.isEmpty;
        final e2 = map.isEmpty;

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different map cells', () {
        final m1 = MutableCell({ 'a': 0 });
        final m2 = MutableCell({ 'a': 0 });

        final e1 = m1.isEmpty;
        final e2 = m2.isEmpty;

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.isNotEmpty', () {
      test('Returns correct value', () {
        final m = MutableCell({'a': 0, 'b': 1});
        final obs = addObserver(m.isNotEmpty, MockValueObserver());

        m.value = {
          'b': 100
        };

        m.value = {};
        m.value = {'d': 9, 'b': 5};

        expect(obs.values, equals([true, false, true]));
      });

      test('compares == when same map cell', () {
        final map = {'a': 1}.cell;
        final e1 = map.isNotEmpty;
        final e2 = map.isNotEmpty;

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different map cells', () {
        final m1 = MutableCell({ 'a': 0 });
        final m2 = MutableCell({ 'a': 0 });

        final e1 = m1.isNotEmpty;
        final e2 = m2.isNotEmpty;

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.length', () {
      test('Returns correct value', () {
        final m = MutableCell({'a': 0, 'b': 1});
        final obs = addObserver(m.length, MockValueObserver());

        m.value = {
          'b': 100
        };

        m.value = {};
        m.value = {'d': 9, 'b': 5};

        expect(obs.values, equals([1, 0, 2]));
      });

      test('compares == when same map cell', () {
        final map = {'a': 1}.cell;
        final e1 = map.length;
        final e2 = map.length;

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different map cells', () {
        final m1 = MutableCell({ 'a': 0 });
        final m2 = MutableCell({ 'a': 0 });

        final e1 = m1.length;
        final e2 = m2.length;

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.keys', () {
      test('ValueCell.keys retrieves map keys', () {
        final m = {'k1': 1, 'k2': 2, 'k3': 3}.cell;
        final keys = m.keys;

        expect(keys.value.toSet(), equals({'k1', 'k2', 'k3'}));
      });

      test('ValueCell.keys reacts to changes in map', () {
        final m = MutableCell({'k1': 1, 'k2': 2, 'k3': 3});
        final keys = m.keys;
        final keySet = keys.toSet();

        final observer = addObserver(keySet, MockValueObserver());

        m.value = {
          'a': 0,
          'b': 1,
          'c': 2,
          'd': 3
        };

        expect(observer.values, equals([{'a', 'b', 'c', 'd'}]));
      });

      test('ValueCell.keys compare == if same map cell', () {
        final m = {'a': 1}.cell;
        final keys1 = m.keys;
        final keys2 = m.keys;

        expect(keys1 == keys2, isTrue);
        expect(keys1.hashCode == keys2.hashCode, isTrue);
      });

      test('ValueCell.keys compare != if different map cells', () {
        final m1 = MutableCell({'a': 1});
        final m2 = MutableCell({'a': 1});

        final keys1 = m1.keys;
        final keys2 = m2.keys;

        expect(keys1 != keys2, isTrue);
        expect(keys1 == keys1, isTrue);
      });
    });

    group('.values', () {
      test('ValueCell.values retrieves map values', () {
        final m = {'k1': 1, 'k2': 2, 'k3': 3}.cell;
        final values = m.values;

        expect(values.value.toSet(), equals({1, 2, 3}));
      });

      test('ValueCell.values reacts to changes in map', () {
        final m = MutableCell({'k1': 1, 'k2': 2, 'k3': 3});
        final values = m.values;
        final valueSet = values.toSet();

        final observer = addObserver(valueSet, MockValueObserver());

        m.value = {
          'a': 10,
          'b': 11,
          'c': 12,
          'd': 13
        };

        expect(observer.values, equals([{10, 11, 12, 13}]));
      });

      test('ValueCell.values compare == if same map cell', () {
        final m = {'a': 1}.cell;
        final values1 = m.values;
        final values2 = m.values;

        expect(values1 == values2, isTrue);
        expect(values1.hashCode == values2.hashCode, isTrue);
      });

      test('ValueCell.values compare != if different map cells', () {
        final m1 = MutableCell({'a': 1});
        final m2 = MutableCell({'a': 1});

        final values1 = m1.values;
        final values2 = m2.values;

        expect(values1 != values2, isTrue);
        expect(values1 == values1, isTrue);
      });
    });

    group('.entries', () {
      test('ValueCell.entries retrieves map values', () {
        final m = {'k1': 1, 'k2': 2, 'k3': 3}.cell;
        final entries = m.entries;

        expect(entries.value.map((e) => e.key).toSet(), equals({
          'k1', 'k2', 'k3'
        }));

        expect(entries.value.map((e) => e.value).toSet(), equals({
          1, 2, 3
        }));
      });

      test('ValueCell.entries reacts to changes in map', () {
        final m = MutableCell({'k1': 1, 'k2': 2, 'k3': 3});
        final entries = m.entries;
        final entrySet = entries.toSet();

        final observer = addObserver(entrySet, MockValueObserver());

        m.value = {
          'a': 10,
          'b': 11,
          'c': 12,
          'd': 13
        };

        expect(observer.values[0].map((e) => e.key).toSet(), equals({'a', 'b', 'c', 'd'}));
        expect(observer.values[0].map((e) => e.value).toSet(), equals({10, 11, 12, 13}));
      });

      test('ValueCell.entries compare == if same map cell', () {
        final m = {'a': 1}.cell;
        final entries1 = m.entries;
        final entries2 = m.entries;

        expect(entries1 == entries2, isTrue);
        expect(entries1.hashCode == entries2.hashCode, isTrue);
      });

      test('ValueCell.entries compare != if different map cells', () {
        final m1 = MutableCell({'a': 1});
        final m2 = MutableCell({'a': 1});

        final entries1 = m1.entries;
        final entries2 = m2.entries;

        expect(entries1 != entries2, isTrue);
        expect(entries1 == entries1, isTrue);
      });
    });

    group('.containsKey()', () {
      test('Returns correct value', () {
        final m = MutableCell({'a': 0, 'b': 1});
        final k = m.containsKey('b'.cell);

        final obs = addObserver(k, MockValueObserver());

        m.value = {
          'b': 100
        };

        expect(k.value, true);

        m.value = {'d': 9};
        m.value = {'d': 9, 'b': 5};

        expect(obs.values, equals([false, true]));
      });

      test('compares == when same map and key cells', () {
        final map = {}.cell;
        final e1 = map.containsKey('key1'.cell);
        final e2 = map.containsKey('key1'.cell);

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different map cells', () {
        final m1 = {}.cell;
        final m2 = { 'a': 0 }.cell;

        final e1 = m1.containsKey('key1'.cell);
        final e2 = m2.containsKey('key1'.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('compares != when different key cells', () {
        final map = {}.cell;
        final e1 = map.containsKey('key1'.cell);
        final e2 = map.containsKey('key2'.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.containsValue()', () {
      test('Returns correct value', () {
        final m = MutableCell({'a': 0, 'b': 1});
        final k = m.containsValue(5.cell);

        final obs = addObserver(k, MockValueObserver());

        m.value = {
          'f': 5
        };

        m.value = {'d': 9};
        m.value = {'d': 9, 'b': 5};
        m.value = {};

        expect(obs.values, equals([true, false, true, false]));
      });

      test('compares == when same map and value cells', () {
        final map = {}.cell;
        final e1 = map.containsValue(100.cell);
        final e2 = map.containsValue(100.cell);

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different map cells', () {
        final m1 = {}.cell;
        final m2 = { 'a': 0 }.cell;

        final e1 = m1.containsValue(100.cell);
        final e2 = m2.containsValue(100.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('compares != when different value cells', () {
        final map = {}.cell;
        final e1 = map.containsValue(1.cell);
        final e2 = map.containsValue(2.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.operator[]', () {
      test('ValueCell.operator[] retrieves entry value', () {
        const m = ValueCell.value({
          'a': 10,
          'b': 4,
          'c': 1
        });
        final v = m['b'.cell];

        expect(v.value, 4);
      });

      test('MutableCell.operator[] retrieves entry value', () {
        final m = MutableCell({
          'a': 10,
          'b': 4,
          'c': 1
        });
        final v = m['b'.cell];

        expect(v.value, 4);
      });

      test('ValueCell.operator[] notifies observers when entry changes', () {
        final m1 = MutableCell({
          'a': 10,
          'b': 4,
          'c': 1
        });

        final ValueCell<Map<String, int>> m2 = m1;

        final v = m2['b'.cell];
        final observer = addObserver(v, MockValueObserver());

        m1.value = {
          'a': 0,
          'b': 34
        };

        m1.value = {
          'b': 7
        };

        m1.value = {
          'a': 9,
          'd': 89
        };

        expect(observer.values, equals([34, 7, null]));
      });

      test('MutableCell.operator[] notifies observers when entry changes', () {
        final m = MutableCell({
          'a': 10,
          'b': 4,
          'c': 1
        });

        final v = m['b'.cell];
        final observer = addObserver(v, MockValueObserver());

        m.value = {
          'a': 0,
          'b': 34
        };

        m.value = {
          'b': 7
        };

        m.value = {
          'a': 9,
          'd': 89
        };

        expect(observer.values, equals([34, 7, null]));
      });

      test('ValueCell.operator[] does not notify observers when entry does not change', () {
        final m = MutableCell({
          'a1': 0,
          'a2': 3,
          'b3': 5,
          'c4': 10
        });

        final ValueCell<Map<String, int>> m2 = m;

        final e = m2['b3'.cell];
        final listener = addListener(e, MockSimpleListener());

        m.value = {
          'a1': -100,
          'a2': 70,
          'b3': 5
        };

        verifyNever(listener());

        m.value = {
          'b3': 5
        };

        verifyNever(listener());

        m.value = {
          'b3': 90
        };

        verify(listener()).called(1);

        m.value = {
          'b3': 90,
          'a': 180
        };

        verifyNever(listener());

        m.value = {};
        verify(listener()).called(1);
      });

      test('MutableCell.operator[] does not notify observers when entry does not change', () {
        final m = MutableCell({
          'a1': 0,
          'a2': 3,
          'b3': 5,
          'c4': 10
        });

        final e = m['b3'.cell];
        final listener = addListener(e, MockSimpleListener());

        m.value = {
          'a1': -100,
          'a2': 70,
          'b3': 5
        };

        verifyNever(listener());

        m.value = {
          'b3': 5
        };

        verifyNever(listener());

        m.value = {
          'b3': 90
        };

        verify(listener()).called(1);

        m.value = {
          'b3': 90,
          'a': 180
        };

        verifyNever(listener());

        m.value = {};
        verify(listener()).called(1);
      });

      test('Setting MutableCell.operator[].value updates map cell value', () {
        final m = MutableCell({
          'k1': 2,
          'k2': 4,
          'k3': 8
        });

        final e = m['k2'.cell];

        e.value = 64;
        expect(m.value, equals({
          'k1': 2,
          'k2': 64,
          'k3': 8
        }));

        e.value = 100;
        expect(m.value, equals({
          'k1': 2,
          'k2': 100,
          'k3': 8
        }));
      });

      test('ValueCell.operator[] notifies observers when key changed', () {
        const m = ValueCell.value({
          'a': 3,
          'b': 9,
          'c': 27
        });

        final k = MutableCell('');
        final e = m[k];

        final observer = addObserver(e, MockValueObserver());

        k.value = 'b';
        k.value = 'c';
        k.value = 'something else';
        k.value = 'a';

        expect(observer.values, equals([9, 27, null, 3]));
      });

      test('MutableCell.operator[] notifies observers when key changed', () {
        final m = MutableCell({
          'a': 3,
          'b': 9,
          'c': 27
        });

        final k = MutableCell('');
        final e = m[k];

        final observer = addObserver(e, MockValueObserver());

        k.value = 'b';
        k.value = 'c';
        k.value = 'something else';
        k.value = 'a';

        expect(observer.values, equals([9, 27, null, 3]));
      });

      test('ValueCell.operator[] gets correct value in batch update', () {
        final m = MutableCell({'1': 100, '2': 300});
        final ValueCell<Map<String, int>> m2 = m;

        final k = MutableCell('1');
        final e = m2[k];

        final observer = addObserver(e, MockValueObserver());

        MutableCell.batch(() {
          k.value = '5';
          m.value = {
            '3': 9,
            '5': 80
          };
        });

        expect(observer.values, equals([80]));
      });

      test('MutableCell.operator[] gets correct value in batch update', () {
        final m = MutableCell({'1': 100, '2': 300});
        final k = MutableCell('1');
        final e = m[k];

        final observer = addObserver(e, MockValueObserver());

        MutableCell.batch(() {
          k.value = '5';
          m.value = {
            '3': 9,
            '5': 80
          };
        });

        expect(observer.values, equals([80]));
      });

      test('ValueCell.operator[] compares == when same map and key cells', () {
        final map = {}.cell;
        final e1 = map['key1'.cell];
        final e2 = map['key1'.cell];

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('ValueCell.operator[] compares != when different map cells', () {
        final m1 = {}.cell;
        final m2 = { 'a': 0 }.cell;

        final e1 = m1['key1'.cell];
        final e2 = m2['key1'.cell];

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('ValueCell.operator[] compares != when different key cells', () {
        final map = {}.cell;
        final e1 = map['key1'.cell];
        final e2 = map['key2'.cell];

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('MutableCell.operator[] compares == when same map and key cells', () {
        final map = MutableCell({});
        final e1 = map['key1'.cell];
        final e2 = map['key1'.cell];

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('MutableCell.operator[] compares != when different map cells', () {
        final m1 = MutableCell({});
        final m2 = MutableCell({ 'a': 0 });

        final e1 = m1['key1'.cell];
        final e2 = m2['key1'.cell];

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('MutableCell.operator[] compares != when different key cells', () {
        final map = MutableCell({});
        final e1 = map['key1'.cell];
        final e2 = map['key2'.cell];

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.operator[]=', () {
      test('MutableCell.operator[]= updates map cell value', () {
        final m = MutableCell({
          'a': 4,
          'b': 16
        });

        final observer = addObserver(m, MockValueObserver());

        m['a'] = 20;
        m['b'] = 50;

        expect(observer.values, equals([
          {'a': 20, 'b': 16},
          {'a': 20, 'b': 50}
        ]));
      });
    });
  });

  group('Set Cell Extensions', () {
    group('.contains()', () {
      test('Returns correct value', () {
        final s = MutableCell({2, 4, 8, 16});
        final k = s.contains(8.cell);

        final obs = addObserver(k, MockValueObserver());

        s.value = {6, 7};

        s.value = {9, 8};
        s.value = {9, 5};

        expect(obs.values, equals([false, true, false]));
      });

      test('compares == when same set and key cells', () {
        final set = {1, 2, 3}.cell;
        final e1 = set.contains(5.cell);
        final e2 = set.contains(5.cell);

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different set cells', () {
        final s1 = MutableCell({1, 2, 3});
        final s2 = MutableCell({1, 2, 3});

        final e1 = s1.contains(5.cell);
        final e2 = s2.contains(5.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('compares != when different key cells', () {
        final set = {4, 5, 6}.cell;
        final e1 = set.contains(5.cell);
        final e2 = set.contains(6.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });

    group('.containsAll()', () {
      test('Returns correct value', () {
        final s = MutableCell({2, 4, 8, 16});
        final k = s.containsAll(const [2, 4].cell);

        final obs = addObserver(k, MockValueObserver());

        s.value = {2, 6, 8};

        s.value = {4, 8, 2};
        s.value = {4, 8};

        expect(obs.values, equals([false, true, false]));
      });

      test('compares == when same set and key cells', () {
        final set = {1, 2, 3}.cell;
        final keys = [1, 3].cell;

        final e1 = set.containsAll(keys);
        final e2 = set.containsAll(keys);

        expect(e1 == e2, isTrue);
        expect(e1.hashCode == e2.hashCode, isTrue);
      });

      test('compares != when different set cells', () {
        final keys = [1, 3].cell;

        final s1 = MutableCell({1, 2, 3});
        final s2 = MutableCell({1, 2, 3});

        final e1 = s1.containsAll(keys);
        final e2 = s2.containsAll(keys);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });

      test('compares != when different key cells', () {
        final set = {4, 5, 6}.cell;
        final e1 = set.containsAll(const {5}.cell);
        final e2 = set.containsAll(const {6}.cell);

        expect(e1 != e2, isTrue);
        expect(e1 == e1, isTrue);
      });
    });
  });

  group('HoldCellExtension', () {
    test('Cell activated when .hold() is called', () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);
      final b = ValueCell.computed(() => a());

      final hold = b.hold();
      addTearDown(() => hold.release());

      // Reference cell to initialize it
      b.value;

      verify(resource.init()).called(1);
      verifyNever(resource.dispose());
    });

    test('Cell activated when .release() is called', () {
      final resource = MockResource();
      final a = TestManagedCell(resource, 1);
      final b = ValueCell.computed(() => a());

      final hold = b.hold();
      addTearDown(() => hold.release());

      // Reference cell to initialize it
      b.value;

      hold.release();

      verify(resource.init()).called(1);
      verify(resource.dispose()).called(1);
    });
  });
}