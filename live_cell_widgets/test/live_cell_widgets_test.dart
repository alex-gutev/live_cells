import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_cell_widgets/live_cell_widgets.dart';
import 'package:live_cell_widgets/live_cell_widgets_base.dart';
import 'package:live_cells_core/live_cells_core.dart';

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
      home: child,
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
class CellWidgetTest3 extends CellWidget with CellInitializer {
  const CellWidgetTest3({super.key});

  @override
  Widget build(BuildContext context) {
    final c1 = cell(() => MutableCell(0));
    final c2 = cell(() => MutableCell(10));

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
class CellWidgetTest4 extends CellWidget with CellInitializer {
  final String title;

  const CellWidgetTest4(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final c1 = cell(() => MutableCell(0));
    final c2 = cell(() => MutableCell(10));

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

void main() {
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

    testWidgets('Cells defined in build method', (tester) async {
      await tester.pumpWidget(TestApp(
        child: CellWidget.builder((context) {
          final c1 = context.cell(() => MutableCell(0));
          final c2 = context.cell(() => MutableCell(10));

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

    testWidgets('Cells defined in build method', (tester) async {
      await tester.pumpWidget(const TestApp(
        child: CellWidgetTest3(),
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

    testWidgets('Cells defined in build method persisted between builds', (tester) async {
      await tester.pumpWidget(const TestApp(
        child: CellWidgetTest4('First Build'),
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
        child: CellWidgetTest4('Second Build'),
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
  });
}