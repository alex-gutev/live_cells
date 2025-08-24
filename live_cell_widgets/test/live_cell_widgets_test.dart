import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_cell_widgets/live_cell_widgets_base.dart';
import 'package:live_cell_widgets/live_cells_ui.dart';
import 'package:live_cells_core/live_cells_core.dart';
import 'package:live_cells_core/live_cells_internals.dart';
import 'package:mockito/mockito.dart';

/// Mock class interface for recording whether a listener was called
abstract class SimpleListener {
  /// Method added as listener function
  void call();
}

/// Mock class implementing [SimpleListener]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance())
class MockSimpleListener extends Mock implements SimpleListener {}

/// Track calls to [init] and [dispose] of a [ManagedCellState]
abstract class CellStateTracker {
  void init();
  void dispose();
}

class MockCellStateTracker extends Mock implements CellStateTracker {
  @override
  void init();
  @override
  void dispose();
}

/// A state which calls [init] and [dispose] on [tracker].
///
/// This is used to check that the lifecycle methods of the cell state are
/// being called.
class ManagedCellState extends CellState {
  final CellStateTracker tracker;

  ManagedCellState({
    required super.cell,
    required super.key,
    required this.tracker
  });

  @override
  void init() {
    super.init();
    tracker.init();
  }

  @override
  void dispose() {
    tracker.dispose();
    super.dispose();
  }
}

/// A [StatefulCell] with a constant value for testing cell lifecycle.
///
/// This cell's state calls [CellStateTracker.init] and [CellStateTracker.dispose] on a
/// [CellStateTracker] when the corresponding [CellState] methods are called.
class TestManagedCell<T> extends StatefulCell<T> {
  final CellStateTracker _tracker;

  @override
  final T value;

  TestManagedCell(this._tracker, this.value);

  @override
  CellState<StatefulCell> createState() => ManagedCellState(
      cell: this,
      key: key,
      tracker: _tracker
  );
}

/// Wraps a widget in a [MaterialApp] for testing
class TestApp extends StatelessWidget {
  /// Child widget to test
  final Widget child;

  const TestApp({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'root',
      home: Scaffold(body: child),
    );
  }
}

/// Tests CellWidget subclass observing one cell
class CellWidgetTest1 extends CellWidget {
  final ValueCell<int> count;

  const CellWidgetTest1({
    super.key,
    required this.count
  });

  @override
  Widget build(BuildContext context) {
    return Text('${count()}');
  }
}

/// Tests CellWidget subclass observing two cells
class CellWidgetTest2 extends CellWidget {
  final ValueCell<num> a;
  final ValueCell<num> b;
  final ValueCell<num> sum;

  const CellWidgetTest2({
    super.key,
    required this.a,
    required this.b,
    required this.sum
  });

  @override
  Widget build(BuildContext context) {
    return Text('${a()} + ${b()} = ${sum()}');
  }
}

/// Tests CellWidget subclass with cells defined in build method
class CellWidgetTest5 extends CellWidget {
  const CellWidgetTest5({super.key, super.restorationId});

  @override
  Widget build(BuildContext context) {
    final c1 = MutableCell(0);
    final c2 = MutableCell(10);

    return Column(
      children: [
        ElevatedButton(
            onPressed: () => c1.value++,
            child: Text('${c1()}')
        ),
        ElevatedButton(
            onPressed: () => c2.value++,
            child: Text('${c2()}')
        )
      ],
    );
  }
}

/// Tests that cells defined in build method are persisted across builds.
class CellWidgetTest6 extends CellWidget {
  final String title;

  const CellWidgetTest6(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final c1 = MutableCell(0);
    final c2 = MutableCell(10);

    return Column(
      children: [
        Text(title),
        ElevatedButton(
            onPressed: () => c1.value++,
            child: Text('${c1()}')
        ),
        ElevatedButton(
            onPressed: () => c2.value++,
            child: Text('${c2()}')
        )
      ],
    );
  }
}


/// Test state restoration of cells defined in build method
class CellWidgetTest7 extends CellWidget {
  const CellWidgetTest7({super.key, super.restorationId});

  @override
  Widget build(BuildContext context) {
    final c1 = MutableCell(0).restore();
    final c2 = MutableCell(10).restore();

    return Column(
      children: [
        ElevatedButton(
            onPressed: () => c1.value++,
            child: Text('${c1()}')
        ),
        ElevatedButton(
            onPressed: () => c2.value++,
            child: Text('${c2()}')
        )
      ],
    );
  }
}

/// Tests that the widget stops observing cells when it is unmounted
class CellWidgetTest8 extends CellWidget {
  final ValueCell<int> a;

  const CellWidgetTest8(this.a, {super.key});

  @override
  Widget build(BuildContext context) {
    final b = MutableCell(1);
    final c = ValueCell.computed(() => a() + b());
    final d = MutableCell.computed(() => a() + b(), (value) => b.value = value);

    return Text('C = ${c()}, D = ${d()}');
  }
}

/// Tests using ValueCell.watch in build method
class CellWidgetTest9 extends CellWidget {
  final ValueCell<void> cell;
  final Function() listener1;
  final Function() listener2;

  const CellWidgetTest9(this.cell, this.listener1, this.listener2, {super.key});

  @override
  Widget build(BuildContext context) {
    ValueCell.watch(() {
      cell.observe();
      listener1();
    });

    ValueCell.watch(() {
      cell.observe();
      listener2();
    });

    return const SizedBox();
  }
}

/// Tests using Watch in build method
class CellWidgetTest10 extends CellWidget {
  final ValueCell<void> cell;
  final Function() listener1;
  final Function() listener2;

  const CellWidgetTest10(this.cell, this.listener1, this.listener2, {super.key});

  @override
  Widget build(BuildContext context) {
    Watch((_) {
      cell.observe();
      listener1();
    });

    Watch((_) {
      cell.observe();
      listener2();
    });

    return const SizedBox();
  }
}

// Group Value enum for unit tests
enum RadioTestValue {
  value1,
  value2
}

void main() {
  group('ValueCell.listenable', () {
    test('Listeners called when value of cell changes', () {
      final cell = MutableCell(10);
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.value = 30;

      verify(listener1()).called(1);
      verify(listener2()).called(1);
    });

    test('Listeners not called after they are removed', () {
      final cell = MutableCell(10);
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.value = 30;
      cell.listenable.removeListener(listener1);

      cell.value = 40;

      verify(listener1()).called(1);
      verify(listener2()).called(2);
    });

    test('init() called when first listener is added', () {
      final tracker = MockCellStateTracker();
      final cell = TestManagedCell(tracker, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      verify(tracker.init()).called(1);
    });

    test('dispose() called when all listeners are removed', () {
      final tracker = MockCellStateTracker();
      final cell = TestManagedCell(tracker, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.listenable.removeListener(listener2);
      cell.listenable.removeListener(listener1);

      verify(tracker.dispose()).called(1);
    });

    test('dispose() not called when not all listeners are removed', () {
      final tracker = MockCellStateTracker();
      final cell = TestManagedCell(tracker, 1);

      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();

      cell.listenable.addListener(listener1);
      cell.listenable.addListener(listener2);

      cell.listenable.removeListener(listener1);

      verifyNever(tracker.dispose());
    });
  });

  group('CellWidget.builder', () {
    testWidgets('Rebuilt when referenced cell changes', (tester) async {
      final count = MutableCell(0);
      await tester.pumpWidget(TestApp(
          child: CellWidget.builder((context) => Text('${count()}'))
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      count.value++;
      await tester.pump();

      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);

      count.value++;
      await tester.pump();

      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Rebuilt when multiple referenced cells changed', (tester) async {
      final a = MutableCell(0);
      final b = MutableCell(1);
      final sum = (a + b).store();

      await tester.pumpWidget(TestApp(
          child: CellWidget.builder((context) => Text('${a()} + ${b()} = ${sum()}'))
      ));

      expect(find.text('0 + 1 = 1'), findsOneWidget);

      a.value = 2;
      await tester.pump();
      expect(find.text('2 + 1 = 3'), findsOneWidget);

      MutableCell.batch(() {
        a.value = 5;
        b.value = 8;
      });
      await tester.pump();
      expect(find.text('5 + 8 = 13'), findsOneWidget);
    });

    testWidgets('Cells defined in build method without .cell', (tester) async {
      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          final c1 = MutableCell(0);
          final c2 = MutableCell(10);

          return Column(
            children: [
              ElevatedButton(
                  onPressed: () => c1.value++,
                  child: Text('${c1()}')
              ),
              ElevatedButton(
                  onPressed: () => c2.value++,
                  child: Text('${c2()}')
              )
            ],
          );
        }),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.text('0'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.text('10'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      await tester.tap(find.text('1'));
      await tester.tap(find.text('11'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Cells defined in build method without .cell persisted between builds', (tester) async {
      await tester.pumpWidget(TestApp(
        child: Column(
          children: [
            const Text('First Build'),
            CellWidget.builder((context) {
              final c1 = MutableCell(0);
              final c2 = MutableCell(10);

              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () => c1.value++,
                      child: Text('${c1()}')
                  ),
                  ElevatedButton(
                      onPressed: () => c2.value++,
                      child: Text('${c2()}')
                  )
                ],
              );
            }),
          ],
        ),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('First Build'), findsOneWidget);

      // Press first button
      await tester.tap(find.text('0'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Rebuild widget hierarchy
      await tester.pumpWidget(TestApp(
        child: Column(
          children: [
            const Text('Second Build'),
            CellWidget.builder((context) {
              final c1 = MutableCell(0);
              final c2 = MutableCell(10);

              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () => c1.value++,
                      child: Text('${c1()}')
                  ),
                  ElevatedButton(
                      onPressed: () => c2.value++,
                      child: Text('${c2()}')
                  )
                ],
              );
            }),
          ],
        ),
      ));

      // Check that counters still have the same values
      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Check that the hierarchy has been rebuilt
      expect(find.text('Second Build'), findsOneWidget);
      expect(find.text('First Build'), findsNothing);

      // Press first button
      await tester.tap(find.text('1'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('11'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Cells defined in build method without .cell restored', (tester) async {
      await tester.pumpWidget(TestApp(
        child: Column(
          children: [
            CellWidget.builder((context) {
              final c1 = MutableCell(0).restore();
              final c2 = MutableCell(10).restore();

              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () => c1.value++,
                      child: Text('${c1()}')
                  ),
                  ElevatedButton(
                      onPressed: () => c2.value++,
                      child: Text('${c2()}')
                  )
                ],
              );
            }, restorationId: 'test_restoration_id'),
          ],
        ),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Press first button
      await tester.tap(find.text('0'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Restart and restore
      await tester.restartAndRestore();

      // Check that counters still have the same values
      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Press first button
      await tester.tap(find.text('1'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('11'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Conditional dependencies tracked correctly', (tester) async {
      final a = MutableCell(0);
      final b = MutableCell(1);
      final cond = MutableCell(true);

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          final value = cond() ? a() : b();
          return Text(value.toString());
        }),
      ));

      expect(find.text('0'), findsOneWidget);

      a.value = 10;
      await tester.pump();
      expect(find.text('10'), findsOneWidget);

      cond.value = false;
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      b.value = 100;
      await tester.pump();
      expect(find.text('100'), findsOneWidget);

      cond.value = true;
      await tester.pump();
      expect(find.text('10'), findsOneWidget);

      a.value = 20;
      await tester.pump();
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('New dependencies tracked correctly', (tester) async {
      final a = MutableCell(0);
      final b = MutableCell('hello');

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) => Text('A = ${a()}')),
      ));

      expect(find.text('A = 0'), findsOneWidget);

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) => Text('B = ${b()}')),
      ));

      expect(find.text('B = hello'), findsOneWidget);

      b.value = 'bye';
      await tester.pump();

      expect(find.text('B = bye'), findsOneWidget);
    });

    testWidgets('Unused dependencies untracked', (tester) async {
      final tracker = MockCellStateTracker();
      final a = TestManagedCell(tracker, 0);
      final b = MutableCell('hello');

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) => Text('A = ${a()}')),
      ));

      expect(find.text('A = 0'), findsOneWidget);

      // Test that the dependency cell state was initialized
      verify(tracker.init()).called(1);
      verifyNever(tracker.dispose());

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) => Text('B = ${b()}')),
      ));

      expect(find.text('B = hello'), findsOneWidget);

      // Test that the dependency cell state was disposed
      verifyNever(tracker.init());
      verify(tracker.dispose()).called(1);
    });

    testWidgets('Dependencies untracked when unmounted', (tester) async {
      final tracker = MockCellStateTracker();
      final a = TestManagedCell(tracker, 0);

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) => Text('A = ${a()}')),
      ));

      expect(find.text('A = 0'), findsOneWidget);

      // Test that the dependency cell state was initialized
      verify(tracker.init()).called(1);
      verifyNever(tracker.dispose());

      await tester.pumpWidget(TestApp(
        child: Container(),
      ));

      // Test that the dependency cell state was disposed
      verifyNever(tracker.init());
      verify(tracker.dispose()).called(1);
    });

    testWidgets('Does not leak resources when unmounted', (tester) async {
      final tracker = MockCellStateTracker();
      final a = TestManagedCell(tracker, 0);

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          final b = MutableCell(1);
          final c = ValueCell.computed(() => a() + b());
          final d = MutableCell.computed(() => a() + b(), (value) => b.value = value);

          return Text('C = ${c()}, D = ${d()}');
        }),
      ));

      expect(find.text('C = 1, D = 1'), findsOneWidget);

      // Test that the dependency cell state was initialized
      verify(tracker.init()).called(1);
      verifyNever(tracker.dispose());

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          final b = MutableCell(1);
          final c = ValueCell.computed(() => a() + b());
          final d = MutableCell.computed(() => a() + b(), (value) => b.value = value);

          return Text('C = ${c()}, D = ${d()}');
        }),
      ));

      await tester.pumpWidget(TestApp(
        child: Container(),
      ));

      // Test that the dependency cell state was disposed
      verifyNever(tracker.init());
      verify(tracker.dispose()).called(1);
    });

    testWidgets('Using ValueCell.watch in build method', (tester) async {
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();
      final cell = ActionCell();

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          ValueCell.watch(() {
            cell.observe();
            listener1();
          });

          ValueCell.watch(() {
            cell.observe();
            listener2();
          });

          return Container();
        }),
      ));

      verify(listener1()).called(1);
      verify(listener2()).called(1);

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          ValueCell.watch(() {
            cell.observe();
            listener1();
          });

          ValueCell.watch(() {
            cell.observe();
            listener2();
          });

          return const SizedBox();
        }),
      ));

      verifyNever(listener1());
      verifyNever(listener2());

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(
          const TestApp(child: SizedBox())
      );

      cell.trigger();
      cell.trigger();

      verifyNever(listener1());
      verifyNever(listener2());
    });

    testWidgets('Using Watch in build method', (tester) async {
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();
      final cell = ActionCell();

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          Watch((_) {
            cell.observe();
            listener1();
          });

          Watch((_) {
            cell.observe();
            listener2();
          });

          return Container();
        }),
      ));

      verify(listener1()).called(1);
      verify(listener2()).called(1);

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          Watch((_) {
            cell.observe();
            listener1();
          });

          Watch((_) {
            cell.observe();
            listener2();
          });

          return const SizedBox();
        }),
      ));

      verifyNever(listener1());
      verifyNever(listener2());

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(
          const TestApp(child: SizedBox())
      );

      cell.trigger();
      cell.trigger();

      verifyNever(listener1());
      verifyNever(listener2());
    });
  });

  group('CellWidget subclass', () {
    testWidgets('Rebuilt when referenced cell changes', (tester) async {
      final count = MutableCell(0);
      await tester.pumpWidget(TestApp(
          child: CellWidgetTest1(count: count)
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      count.value++;
      await tester.pump();

      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);

      count.value++;
      await tester.pump();

      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Rebuilt when multiple referenced cells changed', (tester) async {
      final a = MutableCell(0);
      final b = MutableCell(1);
      final sum = (a + b).store();

      await tester.pumpWidget(TestApp(
          child: CellWidgetTest2(
            a: a,
            b: b,
            sum: sum,
          )
      ));

      expect(find.text('0 + 1 = 1'), findsOneWidget);

      a.value = 2;
      await tester.pump();
      expect(find.text('2 + 1 = 3'), findsOneWidget);

      MutableCell.batch(() {
        a.value = 5;
        b.value = 8;
      });
      await tester.pump();
      expect(find.text('5 + 8 = 13'), findsOneWidget);
    });

    testWidgets('Cells defined in build method without .cell', (tester) async {
      await tester.pumpWidget(const TestApp(
        child: CellWidgetTest5(),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.text('0'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.text('10'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      await tester.tap(find.text('1'));
      await tester.tap(find.text('11'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Cells defined in build method without .cell persisted between builds', (tester) async {
      await tester.pumpWidget(const TestApp(
        child: CellWidgetTest6('First Build'),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('First Build'), findsOneWidget);

      // Press first button
      await tester.tap(find.text('0'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Rebuild widget hierarchy
      await tester.pumpWidget(const TestApp(
        child: CellWidgetTest6('Second Build'),
      ));

      // Check that counters still have the same values
      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Check that the hierarchy has been rebuilt
      expect(find.text('Second Build'), findsOneWidget);
      expect(find.text('First Build'), findsNothing);

      // Press first button
      await tester.tap(find.text('1'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('11'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Cells defined in build method without .cell restored', (tester) async {
      await tester.pumpWidget(const TestApp(
        child: CellWidgetTest7(
          restorationId: 'test_restoration_id',
        ),
      ));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Press first button
      await tester.tap(find.text('0'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Restart and restore
      await tester.restartAndRestore();

      // Check that counters still have the same values
      expect(find.text('1'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Press first button
      await tester.tap(find.text('1'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);

      // Press second button
      await tester.tap(find.text('11'));
      await tester.pump();

      expect(find.text('2'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('Does not leak resources when unmounted', (tester) async {
      final tracker = MockCellStateTracker();
      final a = TestManagedCell(tracker, 0);

      await tester.pumpWidget(TestApp(
        child: CellWidgetTest8(a),
      ));

      expect(find.text('C = 1, D = 1'), findsOneWidget);

      // Test that the dependency cell state was initialized
      verify(tracker.init()).called(1);
      verifyNever(tracker.dispose());

      await tester.pumpWidget(TestApp(
        child: CellWidgetTest8(a),
      ));

      await tester.pumpWidget(TestApp(
        child: Container(),
      ));

      // Test that the dependency cell state was disposed
      verifyNever(tracker.init());
      verify(tracker.dispose()).called(1);
    });

    testWidgets('Using ValueCell.watch in build method', (tester) async {
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();
      final cell = ActionCell();

      await tester.pumpWidget(TestApp(
        child: CellWidgetTest9(cell, listener1, listener2),
      ));

      verify(listener1()).called(1);
      verify(listener2()).called(1);

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(TestApp(
        child: CellWidgetTest9(cell, listener1, listener2),
      ));

      verifyNever(listener1());
      verifyNever(listener2());

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(
          const TestApp(child: SizedBox())
      );

      cell.trigger();
      cell.trigger();

      verifyNever(listener1());
      verifyNever(listener2());
    });

    testWidgets('Using Watch in build method', (tester) async {
      final listener1 = MockSimpleListener();
      final listener2 = MockSimpleListener();
      final cell = ActionCell();

      await tester.pumpWidget(TestApp(
        child: CellWidgetTest10(cell, listener1, listener2),
      ));

      verify(listener1()).called(1);
      verify(listener2()).called(1);

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(TestApp(
        child: CellWidgetTest10(cell, listener1, listener2),
      ));

      verifyNever(listener1());
      verifyNever(listener2());

      cell.trigger();
      verify(listener1()).called(1);
      verify(listener2()).called(1);

      await tester.pumpWidget(
          const TestApp(child: SizedBox())
      );

      cell.trigger();
      cell.trigger();

      verifyNever(listener1());
      verifyNever(listener2());
    });
  });

  // The following tests will test some of the generated widget wrappers

  group('LiveSwitch', () {
    testWidgets('Switch initialized to on', (tester) async {
      final state = MutableCell(true);

      await tester.pumpWidget(TestApp(
        child: LiveSwitch(value: state),
      ));

      final onFinder = find.byWidgetPredicate((widget) => widget is Switch && widget.value);
      final offFinder = find.byWidgetPredicate((widget) => widget is Switch && !widget.value);

      expect(onFinder, findsOneWidget);
      expect(offFinder, findsNothing);
    });

    testWidgets('Switch initialized to off', (tester) async {
      final state = MutableCell(false);

      await tester.pumpWidget(TestApp(
        child: LiveSwitch(value: state),
      ));

      final onFinder = find.byWidgetPredicate((widget) => widget is Switch && widget.value);
      final offFinder = find.byWidgetPredicate((widget) => widget is Switch && !widget.value);

      expect(onFinder, findsNothing);
      expect(offFinder, findsOneWidget);
    });

    testWidgets('Switch state reflects value of cell', (tester) async {
      final state = MutableCell(true);

      await tester.pumpWidget(TestApp(
        child: LiveSwitch(value: state),
      ));

      final onFinder = find.byWidgetPredicate((widget) => widget is Switch && widget.value);
      final offFinder = find.byWidgetPredicate((widget) => widget is Switch && !widget.value);

      // Check that the switch is initially on
      expect(onFinder, findsOneWidget);
      expect(offFinder, findsNothing);

      state.value = false;
      await tester.pump();

      // Check that the switch is now off
      expect(onFinder, findsNothing);
      expect(offFinder, findsOneWidget);
    });

    testWidgets('Value of cell reflects the switch state', (tester) async {
      final state = MutableCell(true);

      await tester.pumpWidget(TestApp(
        child: LiveSwitch(value: state),
      ));

      final onFinder = find.byWidgetPredicate((widget) => widget is Switch && widget.value);
      final offFinder = find.byWidgetPredicate((widget) => widget is Switch && !widget.value);

      // Check that the switch is initially on
      expect(onFinder, findsOneWidget);
      expect(offFinder, findsNothing);

      // Toggle the switch
      await tester.tap(onFinder);

      expect(state.value, isFalse);
    });
  });

  group('LiveRadioListTile', () {
    testWidgets('group value initialized correctly', (tester) async {
      final groupValue = MutableCell<RadioTestValue?>(RadioTestValue.value1);

      await tester.pumpWidget(TestApp(
        child: Column(
          children: [
            LiveRadioListTile(
              value: RadioTestValue.value1,
              groupValue: groupValue,
              title: const Text('value1'),
            ),
            LiveRadioListTile(
              value: RadioTestValue.value2,
              groupValue: groupValue,
              title: const Text('value2'),
            )
          ],
        )
      ));

      final value1Finder = find.byWidgetPredicate((widget) => widget is RadioListTile &&
          widget.value == RadioTestValue.value1 &&
          widget.groupValue == RadioTestValue.value1
      );

      final value2Finder = find.byWidgetPredicate((widget) => widget is RadioListTile &&
          widget.value == RadioTestValue.value2 &&
          widget.groupValue == RadioTestValue.value1
      );

      expect(value1Finder, findsOneWidget);
      expect(value2Finder, findsOneWidget);
    });

    testWidgets('group value initialized correctly when null', (tester) async {
      final groupValue = MutableCell<RadioTestValue?>(null);

      await tester.pumpWidget(TestApp(
          child: Column(
            children: [
              LiveRadioListTile(
                value: RadioTestValue.value1,
                groupValue: groupValue,
                title: const Text('value1'),
              ),
              LiveRadioListTile(
                value: RadioTestValue.value2,
                groupValue: groupValue,
                title: const Text('value2'),
              )
            ],
          )
      ));

      final value1Finder = find.byWidgetPredicate((widget) => widget is RadioListTile &&
          widget.value == RadioTestValue.value1 &&
          widget.groupValue == null
      );

      final value2Finder = find.byWidgetPredicate((widget) => widget is RadioListTile &&
          widget.value == RadioTestValue.value2 &&
          widget.groupValue == null
      );

      expect(value1Finder, findsOneWidget);
      expect(value2Finder, findsOneWidget);
    });

    testWidgets('group value reflects value of cell', (tester) async {
      final groupValue = MutableCell<RadioTestValue?>(null);

      await tester.pumpWidget(TestApp(
          child: Column(
            children: [
              LiveRadioListTile(
                value: RadioTestValue.value1,
                groupValue: groupValue,
                title: const Text('value1'),
              ),
              LiveRadioListTile(
                value: RadioTestValue.value2,
                groupValue: groupValue,
                title: const Text('value2'),
              )
            ],
          )
      ));

      finder(RadioTestValue? groupValue, RadioTestValue value) =>
          find.byWidgetPredicate((widget) => widget is RadioListTile &&
              widget.value == value &&
              widget.groupValue == groupValue
          );

      expect(finder(null, RadioTestValue.value1), findsOneWidget);
      expect(finder(null, RadioTestValue.value2), findsOneWidget);

      groupValue.value = RadioTestValue.value1;
      await tester.pump();

      // Check that the group value is updated in both radio buttons
      expect(finder(RadioTestValue.value1, RadioTestValue.value1), findsOneWidget);
      expect(finder(RadioTestValue.value1, RadioTestValue.value2), findsOneWidget);
    });

    testWidgets('value of cell reflects group value', (tester) async {
      final groupValue = MutableCell<RadioTestValue?>(null);

      await tester.pumpWidget(TestApp(
          child: Column(
            children: [
              LiveRadioListTile(
                value: RadioTestValue.value1,
                groupValue: groupValue,
                title: const Text('value1'),
              ),
              LiveRadioListTile(
                value: RadioTestValue.value2,
                groupValue: groupValue,
                title: const Text('value2'),
              )
            ],
          )
      ));

      finder(RadioTestValue? groupValue, RadioTestValue value) =>
          find.byWidgetPredicate((widget) => widget is RadioListTile &&
              widget.value == value &&
              widget.groupValue == groupValue
          );

      expect(finder(null, RadioTestValue.value1), findsOneWidget);
      expect(finder(null, RadioTestValue.value2), findsOneWidget);

      // Tap first radio button
      await tester.tap(find.text('value1'));
      expect(groupValue.value, equals(RadioTestValue.value1));

      // Tap second radio button
      await tester.tap(find.text('value2'));
      expect(groupValue.value, equals(RadioTestValue.value2));
    });
  });

  group('LiveTextField', () {
    testWidgets('Content of field reflects value of content cell', (tester) async {
      final content = MutableCell('init');

      await tester.pumpWidget(TestApp(
        child: LiveTextField(content: content),
      ));

      finder(String text) => find.byWidgetPredicate((widget) => widget is TextField &&
          widget.controller?.text == text
      );

      expect(finder('init'), findsOneWidget);
      expect(finder('new'), findsNothing);

      // Change value of content cell
      content.value = 'new';
      await tester.pump();

      expect(finder('new'), findsOneWidget);
      expect(finder('init'), findsNothing);
    });

    testWidgets('Value of cell reflects text field content', (tester) async {
      final content = MutableCell('init');

      await tester.pumpWidget(TestApp(
        child: LiveTextField(content: content),
      ));

      finder(String text) => find.byWidgetPredicate((widget) => widget is TextField &&
          widget.controller?.text == text
      );

      final fieldFinder = finder('init');

      expect(fieldFinder, findsOneWidget);
      expect(finder('new'), findsNothing);

      // Enter new text in the field
      await tester.enterText(fieldFinder, 'new text');

      expect(finder('new text'), findsOneWidget);
      expect(finder('init'), findsNothing);
    });
  });

  group('LiveElevatedButton', () {
    testWidgets('onPressed observers notified when button is tapped.', (tester) async {
      final onPressed = ActionCell();
      final listener = MockSimpleListener();

      onPressed.listenable.addListener(listener);
      addTearDown(() => onPressed.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LiveElevatedButton(
            press: onPressed,
            child: const Text('Click Me')
        ),
      ));

      verifyNever(listener());

      final finder = find.text('Click Me');

      expect(finder, findsOneWidget);

      await tester.tap(finder);
      await tester.tap(finder);

      verify(listener()).called(2);

      await tester.pumpWidget(TestApp(
        child: LiveElevatedButton(
            press: onPressed,
            child: const Text('Click Me')
        ),
      ));

      await tester.tap(finder);

      verify(listener()).called(1);
    });

    testWidgets('onLongPress observers notified when button is long pressed.', (tester) async {
      final onLongPress = ActionCell();
      final listener = MockSimpleListener();

      onLongPress.listenable.addListener(listener);
      addTearDown(() => onLongPress.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LiveElevatedButton(
            longPress: onLongPress,
            child: const Text('Click Me')
        ),
      ));

      verifyNever(listener());

      final finder = find.text('Click Me');

      expect(finder, findsOneWidget);

      await tester.longPress(finder);
      await tester.longPress(finder);
      verify(listener()).called(2);

      await tester.pumpWidget(TestApp(
        child: LiveElevatedButton(
            longPress: onLongPress,
            child: const Text('Click Me')
        ),
      ));

      await tester.longPress(finder);
      verify(listener()).called(1);

      await tester.tap(finder);
      verifyNoMoreInteractions(listener);
    });
  });

  group('LiveInkWell', () {
    testWidgets('tap observers notified when widget is tapped.', (tester) async {
      final onTap = ActionCell();
      final listener = MockSimpleListener();

      onTap.listenable.addListener(listener);
      addTearDown(() => onTap.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          tap: onTap,
          child: const Text('Click Me'),
        ),
      ));

      verifyNever(listener());

      final finder = find.text('Click Me');

      expect(finder, findsOneWidget);

      await tester.tap(finder);
      await tester.tap(finder);

      verify(listener()).called(2);

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          tap: onTap,
          child: const Text('Click Me'),
        ),
      ));

      await tester.tap(finder);

      verify(listener()).called(1);
    });

    testWidgets('longPress observers notified when widget is long pressed.', (tester) async {
      final onLongPress = ActionCell();
      final listener = MockSimpleListener();

      onLongPress.listenable.addListener(listener);
      addTearDown(() => onLongPress.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          longPress: onLongPress,
          child: const Text('Click Me'),
        ),
      ));

      verifyNever(listener());

      final finder = find.text('Click Me');

      expect(finder, findsOneWidget);

      await tester.longPress(finder);
      await tester.longPress(finder);

      verify(listener()).called(2);

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          longPress: onLongPress,
          child: const Text('Click Me'),
        ),
      ));

      await tester.longPress(finder);
      verify(listener()).called(1);

      await tester.tap(finder);
      verifyNoMoreInteractions(listener);
    });

    testWidgets('doubleTap observers notified when widget is tapped.', (tester) async {
      final onDoubleTap = ActionCell();
      final listener = MockSimpleListener();

      onDoubleTap.listenable.addListener(listener);
      addTearDown(() => onDoubleTap.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          doubleTap: onDoubleTap,
          child: const Text('Click Me'),
        ),
      ));

      verifyNever(listener());

      final finder = find.text('Click Me');

      expect(finder, findsOneWidget);

      await tester.tap(finder);
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(finder);
      await tester.pumpAndSettle();

      verify(listener()).called(1);

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          doubleTap: onDoubleTap,
          child: const Text('Click Me'),
        ),
      ));

      await tester.tap(finder);
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(finder);
      await tester.pumpAndSettle();

      verify(listener()).called(1);

      await tester.tap(finder);
      await tester.pumpAndSettle();
      verifyNoMoreInteractions(listener);
    });

    testWidgets('secondaryTap observers notified when widget is tapped.', (tester) async {
      final onTap = ActionCell();
      final listener = MockSimpleListener();

      onTap.listenable.addListener(listener);
      addTearDown(() => onTap.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          secondaryTap: onTap,
          child: const Text('Click Me'),
        ),
      ));

      verifyNever(listener());

      final finder = find.text('Click Me');

      expect(finder, findsOneWidget);

      await tester.tap(finder, buttons: kSecondaryButton);
      await tester.tap(finder, buttons: kSecondaryButton);
      await tester.tap(finder);

      verify(listener()).called(2);

      await tester.pumpWidget(TestApp(
        child: LiveInkWell(
          secondaryTap: onTap,
          child: const Text('Click Me'),
        ),
      ));

      await tester.tap(finder, buttons: kSecondaryButton);

      verify(listener()).called(1);
    });
  });

  group('LivePageView', () {
    testWidgets('Current page reflects value of page cell', (tester) async {
      final page = MutableCell(0);

      await tester.pumpWidget(TestApp(
        child: LivePageView(
          page: page,
          children: const [
            Text('Page 1'),
            Text('Page 2'),
            Text('Page 3')
          ],
        ),
      ));

      expect(find.text('Page 1'), findsOneWidget);

      page.value = 2;
      await tester.pump();
      expect(find.text('Page 3'), findsOneWidget);

      page.value = 1;
      await tester.pump();
      expect(find.text('Page 2'), findsOneWidget);
    });

    testWidgets('Value of page cell reflects current page', (tester) async {
      final page = MutableCell(0);

      await tester.pumpWidget(TestApp(
        child: LivePageView(
          page: page,
          children: const [
            Text('Page 1'),
            Text('Page 2'),
            Text('Page 3')
          ],
        ),
      ));

      expect(find.text('Page 1'), findsOneWidget);
      await tester.fling(find.text('Page 1'), const Offset(-100, 0), 900);
      await tester.pumpAndSettle();

      expect(find.text('Page 2'), findsOneWidget);
      expect(page.value, 1);

      await tester.fling(find.text('Page 2'), const Offset(-100, 0), 900);
      await tester.pumpAndSettle();

      expect(find.text('Page 3'), findsOneWidget);
      expect(page.value, 2);

      await tester.fling(find.text('Page 3'), const Offset(100, 0), 900);
      await tester.pumpAndSettle();

      expect(find.text('Page 2'), findsOneWidget);
      expect(page.value, 1);
    });

    testWidgets('Values of animate and duration cells are honored', (tester) async {
      final page = MutableCell(0);
      final animate = MutableCell(true);
      final duration = MutableCell(const Duration(seconds: 100));

      await tester.pumpWidget(TestApp(
        child: LivePageView(
          page: page,
          animate: animate,
          duration: duration,
          curve: Curves.easeIn.cell,

          children: const [
            Text('Page 1'),
            Text('Page 2'),
            Text('Page 3')
          ],
        ),
      ));

      expect(find.text('Page 1'), findsOneWidget);

      page.value = 2;
      await tester.pump();
      expect(find.text('Page 1'), findsOneWidget);
      expect(await tester.pumpAndSettle(const Duration(seconds: 10)), allOf(
          greaterThanOrEqualTo(10),
          lessThan(15)
      ));
      expect(find.text('Page 3'), findsOneWidget);

      animate.value = false;
      page.value = 1;
      await tester.pump();
      expect(find.text('Page 2'), findsOneWidget);


      animate.value = true;
      duration.inSeconds.value = 200;
      page.value = 2;

      await tester.pump();
      expect(find.text('Page 2'), findsOneWidget);
      expect(await tester.pumpAndSettle(const Duration(seconds: 10)), allOf(
          greaterThanOrEqualTo(20),
          lessThan(25)
      ));
      expect(find.text('Page 3'), findsOneWidget);
    });

    testWidgets('Triggering nextPage advances actual page.', (tester) async {
      final page = MutableCell(0);
      final next = ActionCell();

      await tester.pumpWidget(TestApp(
        child: LivePageView(
          page: page,
          nextPage: next,
          duration: const Duration(seconds: 100).cell,
          curve: Curves.easeIn.cell,
          children: const [
            Text('Page 1'),
            Text('Page 2'),
            Text('Page 3')
          ],
        ),
      ));

      expect(find.text('Page 1'), findsOneWidget);

      next.trigger();
      await tester.pumpAndSettle();
      expect(find.text('Page 2'), findsOneWidget);

      next.trigger();
      await tester.pumpAndSettle();
      expect(find.text('Page 3'), findsOneWidget);
    });

    testWidgets('Triggering previousPage changes actual page.', (tester) async {
      final page = MutableCell(2);
      final prev = ActionCell();

      await tester.pumpWidget(TestApp(
        child: LivePageView(
          page: page,
          previousPage: prev,
          duration: const Duration(seconds: 100).cell,
          curve: Curves.easeIn.cell,
          children: const [
            Text('Page 1'),
            Text('Page 2'),
            Text('Page 3')
          ],
        ),
      ));

      expect(find.text('Page 3'), findsOneWidget);

      prev.trigger();
      await tester.pumpAndSettle();
      expect(find.text('Page 2'), findsOneWidget);

      prev.trigger();
      await tester.pumpAndSettle();
      expect(find.text('Page 1'), findsOneWidget);
    });

    testWidgets('isAnimating is updated when page is changed', (tester) async {
      final page = MutableCell(0);
      final animate = MutableCell(true);
      final duration = MutableCell(const Duration(seconds: 100));

      final next = ActionCell();
      final prev = ActionCell();

      final isAnimating = MetaCell<bool>();
      final listener = MockSimpleListener();

      isAnimating.listenable.addListener(listener);
      addTearDown(() => isAnimating.listenable.removeListener(listener));

      await tester.pumpWidget(TestApp(
        child: LivePageView(
          page: page,
          animate: animate,
          duration: duration,
          curve: Curves.easeIn.cell,
          isAnimating: isAnimating,
          nextPage: next,
          previousPage: prev,

          children: const [
            Text('Page 1'),
            Text('Page 2'),
            Text('Page 3')
          ],
        ),
      ));

      expect(find.text('Page 1'), findsOneWidget);
      expect(isAnimating.value, false);

      page.value = 2;
      expect(isAnimating.value, true);
      await tester.pumpAndSettle();
      expect(isAnimating.value, false);
      expect(find.text('Page 3'), findsOneWidget);

      prev.trigger();
      expect(isAnimating.value, true);
      await tester.pumpAndSettle();
      expect(isAnimating.value, false);
      expect(find.text('Page 2'), findsOneWidget);

      next.trigger();
      expect(isAnimating.value, true);
      await tester.pumpAndSettle();
      expect(isAnimating.value, false);
      expect(find.text('Page 3'), findsOneWidget);
    });
  });

  group('LiveTextFormField', () {
    testWidgets('content cell updates field value', (tester) async {
      final content = MutableCell('Initial');

      await tester.pumpWidget(TestApp(
        child: LiveTextFormField(
          content: content,
          decoration: const InputDecoration(labelText: 'Test Field'),
        ),
      ));

      // Initial value
      final textField = find.byType(TextFormField);
      expect(tester.widget<TextFormField>(textField).controller!.text, 'Initial');

      // Update content cell
      content.value = 'Updated';
      await tester.pump();
      
      expect(tester.widget<TextFormField>(textField).controller!.text, 'Updated');
    });

    testWidgets('text input updates content cell', (tester) async {
      final content = MutableCell('');

      await tester.pumpWidget(TestApp(
        child: LiveTextFormField(
          content: content,
          decoration: const InputDecoration(labelText: 'Test Field'),
        ),
      ));

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(content(), 'Hello');
    });

    testWidgets('enabled state controls field interaction', (tester) async {
      final enabled = MutableCell(true);
      final content = MutableCell('Test');

      await tester.pumpWidget(TestApp(
        child: LiveTextFormField(
          content: content,
          enabled: enabled,
          decoration: const InputDecoration(labelText: 'Test Field'),
        ),
      ));

      // Initially enabled
      final textField = find.byType(TextFormField);
      expect(tester.widget<TextFormField>(textField).enabled, isTrue);

      // Disable the field
      enabled.value = false;
      await tester.pump();
      
      expect(tester.widget<TextFormField>(textField).enabled, isFalse);
    });


    testWidgets('validator shows error message', (tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();
      final content = MutableCell('');
      
      await tester.pumpWidget(TestApp(
        child: Form(
          key: formKey,
          child: LiveTextFormField(
            content: content,
            validator: (value) => value!.isEmpty ? 'Field is required' : null,
            decoration: const InputDecoration(labelText: 'Required Field'),
          ),
        ),
      ));

      // Initially no error
      final textFieldFinder = find.byType(TextFormField);
      var inputDecoration = tester.widget<InputDecorator>(
        find.descendant(
          of: textFieldFinder,
          matching: find.byType(InputDecorator),
        )
      ).decoration;
      expect(inputDecoration.errorText, isNull);

      // Trigger validation
      final result = formKey.currentState!.validate();
      
      expect(result, false);

      await tester.pumpAndSettle();

      // Should show error after validation
      inputDecoration = tester.widget<InputDecorator>(
        find.descendant(
          of: textFieldFinder,
          matching: find.byType(InputDecorator),
        )
      ).decoration;
      expect(inputDecoration.errorText, 'Field is required');
    });
  });
}