import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class ErrorHandlingDemo2 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    final sum = cell(() => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error handling 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: inputField(a),
                  ),
                  const SizedBox(width: 5),
                  const Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: inputField(b),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text(
                  '${a()} + ${b()} = ${sum()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              )),
              ElevatedButton(
                child: const Text('Reset'),
                onPressed: () {
                  MutableCell.batch(() {
                    a.value = 0;
                    b.value = 0;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget inputField(MutableCell<num> cell) {
    return CellWidget.builder((context) {
      final maybe = context.cell(() => cell.maybe());
      final content = context.cell(() => maybe.mutableString());
      final error = context.cell(() => maybe.error);

      final isEmpty = context.cell(() => ValueCell.computed(() => content().isEmpty));

      return CellTextField(
        content: content,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorText: isEmpty()
              ? 'Please enter a value'
              : error() != null
              ? 'Not a valid number'
              : null
        ),
      );
    });
  }
}