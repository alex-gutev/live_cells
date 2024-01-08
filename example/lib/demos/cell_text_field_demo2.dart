import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellTextFieldDemo2 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell(0));

    final content = cell(() => MutableCell.computed(() => a().toString(), (content) {
      a.value = int.tryParse(content) ?? 0;
    }));

    final square = cell(() => a * a);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CellTextField Demo 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of CellTextField widget which binds its value to a mutable computation cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              const Text('Enter a number:'),
              CellTextField(
                content: content,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text('${a()} squared is ${square()}')),
              ElevatedButton(
                  onPressed: () => a.value = 0,
                  child: const Text('Clear')
              )
            ],
          ),
        ),
      ),
    );
  }
}