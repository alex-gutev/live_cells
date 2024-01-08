import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cell_widgets.dart';

class CellTextFieldDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final name = cell(() => MutableCell(''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('CellTextField Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of CellTextField widget which binds its value to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              const Text('Enter your name:'),
              CellTextField(
                content: name,
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text('Hello ${name()}')),
              ElevatedButton(
                  onPressed: () => name.value = '',
                  child: const Text('Clear')
              )
            ],
          ),
        ),
      ),
    );
  }
}