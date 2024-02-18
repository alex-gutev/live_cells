import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_cell_widgets/live_cell_widgets_base.dart';
import 'package:live_cells_core/live_cells_core.dart';

class TestApp extends StatelessWidget {
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

class CellWidgetCounter extends CellWidget {
  final ValueCell<int> count;

  const CellWidgetCounter({
    super.key,
    required this.count
  });

  @override
  Widget build(BuildContext context) {
    return Text('${count()}');
  }
}

class CellWidgetSum extends CellWidget {
  final ValueCell<num> a;
  final ValueCell<num> b;
  final ValueCell<num> sum;

  const CellWidgetSum({
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
  });

  group('CellWidget subclass', () {
    testWidgets('Rebuilt when referenced cell changes', (tester) async {
      final count = MutableCell(0);
      await tester.pumpWidget(TestApp(
          child: CellWidgetCounter(count: count)
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
          child: CellWidgetSum(
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
  });
}