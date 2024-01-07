import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellTextFieldDemo2 extends CellWidget {
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
              a.toWidget((context, value, _) => Text('The square of ${a.value} is:')),
              const SizedBox(height: 5),
              square.toWidget((context, value, child) => Text('${square.value}')),
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