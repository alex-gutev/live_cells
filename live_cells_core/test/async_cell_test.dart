import 'package:fake_async/fake_async.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  group('WaitCell', () {
    group('.wait', () {
      test('One FutureCell with constant value', () {
        fakeAsync((self) {
          final cell = Future(() => 12).cell.wait;
          observeCell(cell);

          // .flushMicrotasks doesn't work
          self.elapse(Duration(seconds: 1));

          expect(cell.value, 12);
        });
      });

      test('One FutureCell with Mutable value', () {
        fakeAsync((self) {
          final future = MutableCell(Future(() => 12));
          final cell = future.wait;

          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 12);

          future.value = Future.value(100);
          expect(cell.value, 12);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 100);
        });
      });

      test('Notifies observers when value is ready', () {
        fakeAsync((self) {
          final future = MutableCell(Future(() => 12));
          final cell = future.wait;

          final observer = addObserver(cell, MockValueObserver());

          future.value = Future.value(100);
          future.value = Future.value(20);
          future.value = Future.value(30);

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([12, 100, 20, 30]));
        });
      });

      test('Computed FutureCell', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.wait;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 3);

          cellA.value = Future.value(5);
          expect(cell.value, 3);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 7);

          cellB.value = Future.value(10);
          expect(cell.value, 7);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 15);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(cell.value, 15);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 50);
        });
      });

      test('Computed FutureCell with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.wait;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 3);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(cell.value, 3);

          self.elapse(Duration(seconds: 5));
          expect(cell.value, 3);

          self.elapse(Duration(seconds: 6));
          expect(cell.value, 50);
        });
      });

      test('Futures with varying delays queued correctly', () {
        fakeAsync((self) {
          final f = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final w = f.wait;

          final observer = addObserver(w, MockValueObserver());

          f.value = Future.value(2);
          f.value = Future.delayed(Duration(seconds: 30), () => 3);
          f.value = Future.value(4);

          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 5));
          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, 2);
          expect(observer.values, equals([1, 2]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 2);
          expect(observer.values, equals([1, 2]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 4);
          expect(observer.values, equals([1, 2, 3, 4]));
        });
      });

      test('Two constant cells', () {
        fakeAsync((self) {
          final cellA = Future.value(1).cell;
          final cellB = Future.value(2).cell;

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).wait();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);
        });
      });

      test('Two mutable cells', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).wait();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);

          cellA.value = Future.value(5);
          expect(sum.value, 3);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 7);

          cellB.value = Future.value(10);
          expect(sum.value, 7);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 15);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(sum.value, 15);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 50);
        });
      });

      test('Two mutable cells notifies observers', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).wait();
            return a + b;
          });

          final observer = addObserver(sum, MockValueObserver());

          cellA.value = Future.value(15);
          cellB.value = Future.value(20);

          MutableCell.batch(() {
            cellA.value = Future.value(100);
            cellB.value = Future.value(320);
          });

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([3, 17, 35, 420]));
        });
      });

      test('Two mutable cells with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).wait();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(sum.value, 3);

          self.elapse(Duration(seconds: 5));
          expect(sum.value, 3);

          self.elapse(Duration(seconds: 6));
          expect(sum.value, 50);
        });
      });

      test('Two cells: Futures with varying delays queued correctly', () {
        fakeAsync((self) {
          final c1 = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final c2 = MutableCell(Future.value(2));
          final w = ValueCell.computed(() {
            final (v1, v2) = (c1, c2).wait();

            return v1 + v2;
          });

          final observer = addObserver(w, MockValueObserver());

          c1.value = Future.value(10);

          MutableCell.batch(() {
            c1.value = Future.delayed(Duration(seconds: 30), () => 20);
            c2.value = Future.value(7);
          });

          c1.value = Future.value(100);

          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 5));
          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, 12);
          expect(observer.values, equals([3, 12]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 12);
          expect(observer.values, equals([3, 12]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 107);
          expect(observer.values, equals([3, 12, 27, 107]));
        });
      });

      test('Returns value given by .loadingValue() while pending', () {
        fakeAsync((async) {
          final cell = MutableCell(Future.delayed(const Duration(seconds: 5), () => 1));
          final wait = cell.wait.loadingValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, 1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('.loadingValue() passes rethrows UninitializedCellError exception', () {
        fakeAsync((async) {
          final cell = MutableCell(Future<int>.delayed(const Duration(seconds: 5), () => throw UninitializedCellError()));
          final wait = cell.wait.loadingValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(() => wait.value, throwsA(isA<UninitializedCellError>()));

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('Returns value given by .initialValue() while pending', () {
        fakeAsync((async) {
          final cell = MutableCell(Future.delayed(const Duration(seconds: 5), () => 1));
          final wait = cell.wait.initialValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, 1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('.initialValue() handles UninitializedCellError exception', () {
        fakeAsync((async) {
          final cell = MutableCell(Future<int>.delayed(const Duration(seconds: 5), () => throw UninitializedCellError()));
          final wait = cell.wait.initialValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('Compares equal if same future cells', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.wait;
        final w2 = f.wait;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compares not equal if different future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = f1.wait;
        final w2 = f2.wait;

        expect(w1 != w2, isTrue);
        expect(w1 == w1, isTrue);
      });

      test('Compare equal if same 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).wait;
        final w2 = (f1, f2).wait;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compare not equal if different 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));
        final f3 = MutableCell(Future.value(5));

        final w1 = (f1, f2).wait;
        final w2 = (f1, f3).wait;
        final w3 = (f3, f2).wait;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
        expect(w2 != w3, isTrue);
      });

      /// Test WaitCellExtension 3-9

      test('Three constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3) = (c1, c2, c3).wait();
            return '$v1,$v2,$v3';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3');
        });
      });

      test('Four constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4) = (c1, c2, c3, c4).wait();
            return '$v1,$v2,$v3,$v4';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4');
        });
      });

      test('Five constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5) = (c1, c2, c3, c4, c5).wait();
            return '$v1,$v2,$v3,$v4,$v5';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5');
        });
      });

      test('Six constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6) = (c1, c2, c3, c4, c5, c6).wait();
            return '$v1,$v2,$v3,$v4,$v5,$v6';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6');
        });
      });

      test('Seven constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7) = (c1, c2, c3, c4, c5, c6, c7).wait();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7');
        });
      });

      test('Eight constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7, v8) = (c1, c2, c3, c4, c5, c6, c7, c8).wait();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7,8');
        });
      });

      test('Nine constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;
          final c9 = Future.value(9).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7, v8, v9) = (c1, c2, c3, c4, c5, c6, c7, c8, c9).wait();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8,$v9';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7,8,9');
        });
      });
    });

    group('.waitLast', () {
      test('One FutureCell with constant value', () {
        fakeAsync((self) {
          final cell = Future.value(12).cell.waitLast;
          observeCell(cell);

          // .flushMicrotasks doesn't work
          self.elapse(Duration(seconds: 1));

          expect(cell.value, 12);
        });
      });

      test('One FutureCell with Mutable value', () {
        fakeAsync((self) {
          final future = MutableCell(Future.value(12));
          final cell = future.waitLast;

          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 12);

          future.value = Future.value(100);
          expect(cell.value, 12);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 100);
        });
      });

      test('Notifies observers when value is ready', () {
        fakeAsync((self) {
          final future = MutableCell(Future.value(12));
          final cell = future.waitLast;

          final observer = addObserver(cell, MockValueObserver());

          future.value = Future.value(100);
          future.value = Future.value(20);
          future.value = Future.value(30);

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([30]));
        });
      });

      test('Computed FutureCell', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.waitLast;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 3);

          cellA.value = Future.value(5);
          expect(cell.value, 3);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 7);

          cellB.value = Future.value(10);
          expect(cell.value, 7);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 15);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(cell.value, 15);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 50);
        });
      });

      test('Computed FutureCell with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.waitLast;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 3);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(cell.value, 3);

          self.elapse(Duration(seconds: 5));
          expect(cell.value, 3);

          self.elapse(Duration(seconds: 6));
          expect(cell.value, 50);
        });
      });

      test('Latest value only kept with Futures with varying delays', () {
        fakeAsync((self) {
          final f = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final w = f.waitLast;

          final observer = addObserver(w, MockValueObserver());

          f.value = Future.value(2);
          f.value = Future.delayed(Duration(seconds: 30), () => 3);
          f.value = Future.value(4);

          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 5));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          f.value = Future.value(100);
          self.elapse(Duration(seconds: 1));
          expect(w.value, 100);
          expect(observer.values, equals([4, 100]));
        });
      });

      test('Two constant cells', () {
        fakeAsync((self) {
          final cellA = Future.value(1).cell;
          final cellB = Future.value(2).cell;

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).waitLast();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);
        });
      });

      test('Two mutable cells', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).waitLast();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);

          cellA.value = Future.value(5);
          expect(sum.value, 3);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 7);

          cellB.value = Future.value(10);
          expect(sum.value, 7);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 15);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(sum.value, 15);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 50);
        });
      });

      test('Two mutable cells notifies observers', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).waitLast();
            return a + b;
          });

          final observer = addObserver(sum, MockValueObserver());

          cellA.value = Future.value(15);
          cellB.value = Future.value(20);

          MutableCell.batch(() {
            cellA.value = Future.value(100);
            cellB.value = Future.value(320);
          });

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([420]));
        });
      });

      test('Two mutable cells with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).waitLast();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(sum.value, 3);

          self.elapse(Duration(seconds: 5));
          expect(sum.value, 3);

          self.elapse(Duration(seconds: 6));
          expect(sum.value, 50);
        });
      });

      test('Two cells: last value kept with Futures with varying delays', () {
        fakeAsync((self) {
          final c1 = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final c2 = MutableCell(Future.value(2));
          final w = ValueCell.computed(() {
            final (v1, v2) = (c1, c2).waitLast();

            return v1 + v2;
          });

          final observer = addObserver(w, MockValueObserver());

          c1.value = Future.value(10);

          MutableCell.batch(() {
            c1.value = Future.delayed(Duration(seconds: 30), () => 20);
            c2.value = Future.value(7);
          });

          c1.value = Future.value(100);

          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 5));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          c1.value = Future.value(1000);
          self.elapse(Duration(seconds: 1));
          expect(w.value, 1007);
          expect(observer.values, equals([107, 1007]));
        });
      });

      test('Returns value given by .loadingValue() while pending', () {
        fakeAsync((async) {
          final cell = MutableCell(Future.delayed(const Duration(seconds: 5), () => 1));
          final wait = cell.waitLast.loadingValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('.loadingValue() passes rethrows UninitializedCellError exception', () {
        fakeAsync((async) {
          final cell = MutableCell(Future<int>.delayed(const Duration(seconds: 5), () => throw UninitializedCellError()));
          final wait = cell.waitLast.loadingValue((-1).cell);

          observeCell(wait);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(() => wait.value, throwsA(isA<UninitializedCellError>()));
        });
      });

      test('Returns value given by .initialValue() while pending', () {
        fakeAsync((async) {
          final cell = MutableCell(Future.delayed(const Duration(seconds: 5), () => 1));
          final wait = cell.waitLast.initialValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('.initialValue() handles UninitializedCellError exception', () {
        fakeAsync((async) {
          final cell = MutableCell(Future<int>.delayed(const Duration(seconds: 5), () => throw UninitializedCellError()));
          final wait = cell.waitLast.initialValue((-1).cell);

          observeCell(wait);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);
        });
      });

      test('Compares equal if same future cells', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.waitLast;
        final w2 = f.waitLast;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compares not equal if different future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = f1.waitLast;
        final w2 = f2.waitLast;

        expect(w1 != w2, isTrue);
        expect(w1 == w1, isTrue);
      });

      test('Compares not equal with .wait cell', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.wait;
        final w2 = f.waitLast;

        expect(w1 != w2, isTrue);
        expect(w1 == w1, isTrue);
      });

      test('Compare equal if same 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).waitLast;
        final w2 = (f1, f2).waitLast;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compare not equal if different 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));
        final f3 = MutableCell(Future.value(5));

        final w1 = (f1, f2).waitLast;
        final w2 = (f1, f3).waitLast;
        final w3 = (f3, f2).waitLast;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
        expect(w2 != w3, isTrue);
      });

      test('Compares not equal with .wait cell', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).waitLast;
        final w2 = (f1, f2).wait;

        expect(w1 != w2, isTrue);
        expect(w1 == w1, isTrue);
      });

      /// Test WaitCellExtension 3-9

      test('Three constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3) = (c1, c2, c3).waitLast();
            return '$v1,$v2,$v3';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3');
        });
      });

      test('Four constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4) = (c1, c2, c3, c4).waitLast();
            return '$v1,$v2,$v3,$v4';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4');
        });
      });

      test('Five constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5) = (c1, c2, c3, c4, c5).waitLast();
            return '$v1,$v2,$v3,$v4,$v5';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5');
        });
      });

      test('Six constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6) = (c1, c2, c3, c4, c5, c6).waitLast();
            return '$v1,$v2,$v3,$v4,$v5,$v6';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6');
        });
      });

      test('Seven constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7) =
            (c1, c2, c3, c4, c5, c6, c7).waitLast();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7');
        });
      });

      test('Eight constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7, v8) =
            (c1, c2, c3, c4, c5, c6, c7, c8).waitLast();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7,8');
        });
      });

      test('Nine constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;
          final c9 = Future.value(9).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7, v8, v9) =
            (c1, c2, c3, c4, c5, c6, c7, c8, c9).waitLast();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8,$v9';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7,8,9');
        });
      });
    });

    group('.awaited', () {
      test('One FutureCell with constant value', () {
        fakeAsync((self) {
          final cell = Future.value(12).cell.awaited;
          observeCell(cell);

          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          // .flushMicrotasks doesn't work
          self.elapse(Duration(seconds: 1));

          expect(cell.value, 12);
        });
      });

      test('One FutureCell with Mutable value', () {
        fakeAsync((self) {
          final future = MutableCell(Future.value(12));
          final cell = future.awaited;

          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 12);

          future.value = Future.value(100);
          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 100);
        });
      });

      test('Notifies observers when value is ready', () {
        fakeAsync((self) {
          final future = MutableCell(Future.value(12));
          final cell = future.awaited;

          final observer = addObserver(cell, MockValueObserver());

          future.value = Future.value(100);
          future.value = Future.value(20);
          future.value = Future.value(30);

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([30]));
        });
      });

      test('Computed FutureCell', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.awaited;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 3);

          cellA.value = Future.value(5);
          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 7);

          cellB.value = Future.value(10);
          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 15);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 50);
        });
      });

      test('Computed FutureCell with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.awaited;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, 3);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 5));
          expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 6));
          expect(cell.value, 50);
        });
      });

      test('Latest value only kept with Futures with varying delays', () {
        fakeAsync((self) {
          final f = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final w = f.awaited;

          final observer = addObserver(w, MockValueObserver());

          f.value = Future.value(2);
          f.value = Future.delayed(Duration(seconds: 30), () => 3);
          f.value = Future.value(4);

          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 5));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 4);
          expect(observer.values, equals([4]));

          f.value = Future.value(100);
          self.elapse(Duration(seconds: 1));
          expect(w.value, 100);
          expect(observer.values, equals([4, 100]));
        });
      });

      test('Two constant cells', () {
        fakeAsync((self) {
          final cellA = Future.value(1).cell;
          final cellB = Future.value(2).cell;

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).awaited();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);
        });
      });

      test('Two mutable cells', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).awaited();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);

          cellA.value = Future.value(5);
          expect(() => sum.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 7);

          cellB.value = Future.value(10);
          expect(() => sum.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 15);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(() => sum.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 50);
        });
      });

      test('Two mutable cells notify observers', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).awaited();
            return a + b;
          });

          final observer = addObserver(sum, MockValueObserver());

          cellA.value = Future.value(15);
          cellB.value = Future.value(20);

          MutableCell.batch(() {
            cellA.value = Future.value(100);
            cellB.value = Future.value(320);
          });

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([420]));
        });
      });

      test('Two mutable cells with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() {
            final (a, b) = (cellA, cellB).awaited();
            return a + b;
          });

          observeCell(sum);

          self.elapse(Duration(seconds: 1));
          expect(sum.value, 3);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(() => sum.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 5));
          expect(() => sum.value, throwsA(isA<PendingAsyncValueError>()));

          self.elapse(Duration(seconds: 6));
          expect(sum.value, 50);
        });
      });

      test('Two cells: last value kept with Futures with varying delays', () {
        fakeAsync((self) {
          final c1 = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final c2 = MutableCell(Future.value(2));
          final w = ValueCell.computed(() {
            final (v1, v2) = (c1, c2).awaited();

            return v1 + v2;
          });

          final observer = addObserver(w, MockValueObserver());

          c1.value = Future.value(10);

          MutableCell.batch(() {
            c1.value = Future.delayed(Duration(seconds: 30), () => 20);
            c2.value = Future.value(7);
          });

          c1.value = Future.value(100);

          expect(() => w.value, throwsA(isA<PendingAsyncValueError>()));
          expect(observer.values, equals([]));

          self.elapse(Duration(seconds: 5));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, 107);
          expect(observer.values, equals([107]));

          c1.value = Future.value(1000);
          self.elapse(Duration(seconds: 1));
          expect(w.value, 1007);
          expect(observer.values, equals([107, 1007]));
        });
      });

      test('Returns value given by .loadingValue() while pending', () {
        fakeAsync((async) {
          final cell = MutableCell(Future.delayed(const Duration(seconds: 5), () => 1));
          final wait = cell.awaited.loadingValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('.loadingValue() passes rethrows UninitializedCellError exception', () {
        fakeAsync((async) {
          final cell = MutableCell(Future<int>.delayed(const Duration(seconds: 5), () => throw UninitializedCellError()));
          final wait = cell.awaited.loadingValue((-1).cell);

          observeCell(wait);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(() => wait.value, throwsA(isA<UninitializedCellError>()));
        });
      });

      test('Returns value given by .initialValue() while pending', () {
        fakeAsync((async) {
          final cell = MutableCell(Future.delayed(const Duration(seconds: 5), () => 1));
          final wait = cell.awaited.initialValue((-1).cell);

          observeCell(wait);

          cell.value = Future.delayed(const Duration(seconds: 10), () => 2);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 5));
          expect(wait.value, 2);
        });
      });

      test('.initialValue() handles UninitializedCellError exception', () {
        fakeAsync((async) {
          final cell = MutableCell(Future<int>.delayed(const Duration(seconds: 5), () => throw UninitializedCellError()));
          final wait = cell.awaited.initialValue((-1).cell);

          observeCell(wait);
          expect(wait.value, -1);

          async.elapse(Duration(seconds: 6));
          expect(wait.value, -1);
        });
      });

      test('.whenReady Stops execution of watch function while Future is pending', () {
        fakeAsync((async) {
          final a = MutableCell(Future.delayed(const Duration(seconds: 5)));
          final cell = a.awaited;

          final listener = MockSimpleListener();
          final watch = ValueCell.watch(() {
            cell.whenReady();
            listener();
          });

          addTearDown(() => watch.stop());
          verifyNever(listener());

          async.elapse(Duration(seconds: 6));
          verify(listener()).called(1);

          a.value = Future.delayed(const Duration(seconds: 1));
          verifyNever(listener());

          async.elapse(Duration(seconds: 2));
          verify(listener()).called(1);
        });
      });

      test('Compares equal if same future cells', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.awaited;
        final w2 = f.awaited;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compares not equal if different future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = f1.awaited;
        final w2 = f2.awaited;

        expect(w1 != w2, isTrue);
        expect(w1 == w1, isTrue);
      });

      test('Compares not equal with .wait and .waitLast cells', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.awaited;
        final w2 = f.wait;
        final w3 = f.waitLast;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
      });

      test('Compare equal if same 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).awaited;
        final w2 = (f1, f2).awaited;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compare not equal if different 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));
        final f3 = MutableCell(Future.value(5));

        final w1 = (f1, f2).awaited;
        final w2 = (f1, f3).awaited;
        final w3 = (f3, f2).awaited;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
        expect(w2 != w3, isTrue);
      });

      test('Compares not equal with .wait and .waitLast cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).awaited;
        final w2 = (f1, f2).wait;
        final w3 = (f1, f2).waitLast;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
      });

      /// Test WaitCellExtension 3-9

      test('Three constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3) = (c1, c2, c3).awaited();
            return '$v1,$v2,$v3';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3');
        });
      });

      test('Four constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4) = (c1, c2, c3, c4).awaited();
            return '$v1,$v2,$v3,$v4';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4');
        });
      });

      test('Five constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5) = (c1, c2, c3, c4, c5).awaited();
            return '$v1,$v2,$v3,$v4,$v5';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5');
        });
      });

      test('Six constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6) = (c1, c2, c3, c4, c5, c6).awaited();
            return '$v1,$v2,$v3,$v4,$v5,$v6';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6');
        });
      });

      test('Seven constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7) =
            (c1, c2, c3, c4, c5, c6, c7).awaited();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7');
        });
      });

      test('Eight constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7, v8) =
            (c1, c2, c3, c4, c5, c6, c7, c8).awaited();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7,8');
        });
      });

      test('Nine constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;
          final c9 = Future.value(9).cell;

          final conc = ValueCell.computed(() {
            final (v1, v2, v3, v4, v5, v6, v7, v8, v9) =
            (c1, c2, c3, c4, c5, c6, c7, c8, c9).awaited();
            return '$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8,$v9';
          });

          observeCell(conc);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, '1,2,3,4,5,6,7,8,9');
        });
      });
    });

    group('.isCompleted', () {
      test('One FutureCell with constant value', () {
        fakeAsync((self) {
          final cell = Future.value(12).cell.isCompleted;
          observeCell(cell);

          expect(cell.value, false);

          // .flushMicrotasks doesn't work
          self.elapse(Duration(seconds: 1));

          expect(cell.value, true);
        });
      });

      test('One FutureCell with Mutable value', () {
        fakeAsync((self) {
          final future = MutableCell(Future.value(12));
          final cell = future.isCompleted;

          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          future.value = Future.value(100);
          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);
        });
      });

      test('Notifies observers when value is ready', () {
        fakeAsync((self) {
          final future = MutableCell(Future.value(12));
          final cell = future.isCompleted;

          final observer = addObserver(cell, MockValueObserver());

          future.value = Future.value(100);
          future.value = Future.value(20);
          future.value = Future.value(30);

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([false, true]));
        });
      });

      test('Computed FutureCell', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.isCompleted;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          cellA.value = Future.value(5);
          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          cellB.value = Future.value(10);
          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);
        });
      });

      test('Computed FutureCell with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final sum = ValueCell.computed(() async {
            final (a, b) = await (cellA(), cellB()).wait;
            return a + b;
          });

          final cell = sum.isCompleted;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(cell.value, false);

          self.elapse(Duration(seconds: 5));
          expect(cell.value, false);

          self.elapse(Duration(seconds: 6));
          expect(cell.value, true);
        });
      });

      test('Latest value only kept with Futures with varying delays', () {
        fakeAsync((self) {
          final f = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final w = f.isCompleted;

          final observer = addObserver(w, MockValueObserver());

          f.value = Future.value(2);
          f.value = Future.delayed(Duration(seconds: 30), () => 3);
          f.value = Future.value(4);

          expect(w.value, false);
          expect(observer.values, equals([false]));

          self.elapse(Duration(seconds: 5));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          f.value = Future.value(100);
          self.elapse(Duration(seconds: 1));
          expect(w.value, true);
          expect(observer.values, equals([false, true, false, true]));
        });
      });

      test('Does not propagate exceptions in Future', () {
        fakeAsync((async) {
          final f = Future.error(Exception('An exception')).cell;
          final complete = f.isCompleted;

          observeCell(complete);

          expect(complete.value, false);

          async.elapse(Duration(seconds: 1));
          expect(complete.value, true);
        });
      });

      test('Is true when UninitializedCellError is thrown', () {
        fakeAsync((async) {
          final f = Future.error(UninitializedCellError()).cell;
          final complete = f.isCompleted;

          observeCell(complete);

          expect(complete.value, false);

          async.elapse(Duration(seconds: 1));
          expect(complete.value, true);
        });
      });

      test('Two constant cells', () {
        fakeAsync((self) {
          final cellA = Future.value(1).cell;
          final cellB = Future.value(2).cell;

          final cell = (cellA, cellB).isCompleted;

          observeCell(cell);
          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);
        });
      });

      test('Two mutable cells', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final cell = (cellA, cellB).isCompleted;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          cellA.value = Future.value(5);
          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          cellB.value = Future.value(10);
          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.value(30);
          });

          expect(cell.value, false);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);
        });
      });

      test('Two mutable cells notify observers', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final cell = (cellA, cellB).isCompleted;
          final observer = addObserver(cell, MockValueObserver());

          cellA.value = Future.value(15);
          cellB.value = Future.value(20);

          MutableCell.batch(() {
            cellA.value = Future.value(100);
            cellB.value = Future.value(320);
          });

          self.elapse(Duration(seconds: 1));
          expect(observer.values, equals([false, true]));
        });
      });

      test('Two mutable cells with delay', () {
        fakeAsync((self) {
          final cellA = MutableCell(Future.value(1));
          final cellB = MutableCell(Future.value(2));

          final cell = (cellA, cellB).isCompleted;
          observeCell(cell);

          self.elapse(Duration(seconds: 1));
          expect(cell.value, true);

          MutableCell.batch(() {
            cellA.value = Future.value(20);
            cellB.value = Future.delayed(Duration(seconds: 10), () => 30);
          });

          expect(cell.value, false);

          self.elapse(Duration(seconds: 5));
          expect(cell.value, false);

          self.elapse(Duration(seconds: 6));
          expect(cell.value, true);
        });
      });

      test('Two cells: last value kept with Futures with varying delays', () {
        fakeAsync((self) {
          final c1 = MutableCell(Future.delayed(Duration(seconds: 10), () => 1));
          final c2 = MutableCell(Future.value(2));

          final w = (c1, c2).isCompleted;
          final observer = addObserver(w, MockValueObserver());

          c1.value = Future.value(10);

          MutableCell.batch(() {
            c1.value = Future.delayed(Duration(seconds: 30), () => 20);
            c2.value = Future.value(7);
          });

          c1.value = Future.value(100);

          expect(w.value, false);
          expect(observer.values, equals([false]));

          self.elapse(Duration(seconds: 5));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          self.elapse(Duration(seconds: 6));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          self.elapse(Duration(seconds: 10));
          expect(w.value, true);
          expect(observer.values, equals([false, true]));

          c1.value = Future.value(1000);
          self.elapse(Duration(seconds: 1));
          expect(w.value, true);
          expect(observer.values, equals([false, true, false, true]));
        });
      });

      test('Does not propagate exceptions in two Future cells', () {
        fakeAsync((async) {
          final f1 = Future.error(Exception('An exception')).cell;
          final f2 = Future.error('An error').cell;
          final f3 = Future.value(1).cell;

          final c1 = (f1, f2).isCompleted;
          final c2 = (f2, f3).isCompleted;

          observeCell(c1);
          observeCell(c2);

          expect(c1.value, false);
          expect(c2.value, false);

          async.elapse(Duration(seconds: 1));

          expect(c1.value, true);
          expect(c2.value, true);
        });
      });

      test('Is true when UninitializedCellError thrown in two Future cells', () {
        fakeAsync((async) {
          final f1 = Future.error(UninitializedCellError()).cell;
          final f2 = Future.value(1).cell;

          final c1 = (f1, f2).isCompleted;

          observeCell(c1);
          expect(c1.value, false);

          async.elapse(Duration(seconds: 1));
          expect(c1.value, true);
        });
      });

      test('Compares equal if same future cells', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.isCompleted;
        final w2 = f.isCompleted;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compares not equal if different future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = f1.isCompleted;
        final w2 = f2.isCompleted;

        expect(w1 != w2, isTrue);
        expect(w1 == w1, isTrue);
      });

      test('Compares not equal with .wait, .waitLast and .awaited cells', () {
        final f = MutableCell(Future.value(1));

        final w1 = f.isCompleted;
        final w2 = f.wait;
        final w3 = f.waitLast;
        final w4 = f.awaited;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
        expect(w1 != w4, isTrue);
      });

      test('Compare equal if same 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).isCompleted;
        final w2 = (f1, f2).isCompleted;

        expect(w1 == w2, isTrue);
        expect(w1.hashCode == w2.hashCode, isTrue);
      });

      test('Compare not equal if different 2 future cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));
        final f3 = MutableCell(Future.value(5));

        final w1 = (f1, f2).isCompleted;
        final w2 = (f1, f3).isCompleted;
        final w3 = (f3, f2).isCompleted;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
        expect(w2 != w3, isTrue);
      });

      test('Compares not equal with .wait and .waitLast cells', () {
        final f1 = MutableCell(Future.value(1));
        final f2 = MutableCell(Future.value(3));

        final w1 = (f1, f2).isCompleted;
        final w2 = (f1, f2).wait;
        final w3 = (f1, f2).waitLast;
        final w4 = (f1, f2).awaited;

        expect(w1 == w1, isTrue);
        expect(w1 != w2, isTrue);
        expect(w1 != w3, isTrue);
        expect(w1 != w4, isTrue);
      });

      /// Test WaitCellExtension 3-9

      test('Three constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;

          final conc =  (c1, c2, c3).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });

      test('Four constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;

          final conc = (c1, c2, c3, c4).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });

      test('Five constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;

          final conc = (c1, c2, c3, c4, c5).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });

      test('Six constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;

          final conc = (c1, c2, c3, c4, c5, c6).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });

      test('Seven constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;

          final conc = (c1, c2, c3, c4, c5, c6, c7).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });

      test('Eight constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;

          final conc = (c1, c2, c3, c4, c5, c6, c7, c8).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });

      test('Nine constant cells', () {
        fakeAsync((self) {
          final c1 = Future.value(1).cell;
          final c2 = Future.value(2).cell;
          final c3 = Future.value(3).cell;
          final c4 = Future.value(4).cell;
          final c5 = Future.value(5).cell;
          final c6 = Future.value(6).cell;
          final c7 = Future.value(7).cell;
          final c8 = Future.value(8).cell;
          final c9 = Future.value(9).cell;

          final conc = (c1, c2, c3, c4, c5, c6, c7, c8, c9).isCompleted;

          observeCell(conc);
          expect(conc.value, false);

          self.elapse(Duration(seconds: 1));
          expect(conc.value, true);
        });
      });
    });
  });

  group('Delayed Cell', () {
    test('Uninitialized before delay has elapsed', () {
      fakeAsync((async) {
        final cell = 1.cell.delayed(Duration(seconds: 5)).wait;
        observeCell(cell);

        expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));
      });
    });

    test('Initialized after delay has elapsed', () {
      fakeAsync((async) {
        final cell = 1.cell.delayed(Duration(seconds: 5)).wait;
        observeCell(cell);

        expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

        async.elapse(Duration(seconds: 3));
        expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

        async.elapse(Duration(seconds: 3));
        expect(cell.value, 1);
      });
    });

    test('Updated after setting argument cell value', () {
      fakeAsync((async) {
        final src = MutableCell(1);
        final cell = src.delayed(Duration(seconds: 10)).wait;
        observeCell(cell);

        expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

        async.elapse(Duration(seconds: 6));
        expect(() => cell.value, throwsA(isA<PendingAsyncValueError>()));

        async.elapse(Duration(seconds: 5));
        expect(cell.value, 1);

        src.value = 2;
        async.elapse(Duration(seconds: 6));
        expect(cell.value, 1);

        async.elapse(Duration(seconds: 5));
        expect(cell.value, 2);
      });
    });

    test('Notifies observers after delay elapses', () {
      fakeAsync((async) {
        final src = MutableCell(1);
        final cell = src.delayed(Duration(seconds: 20)).wait;
        final observer = addObserver(cell, MockValueObserver());

        expect(observer.values, equals([]));

        async.elapse(Duration(seconds: 11));
        expect(observer.values, equals([]));

        async.elapse(Duration(seconds: 10));
        expect(observer.values, equals([1]));

        src.value = 2;
        async.elapse(Duration(seconds: 11));
        expect(observer.values, equals([1]));

        async.elapse(Duration(seconds: 10));
        expect(observer.values, equals([1, 2]));
      });
    });
  });
}