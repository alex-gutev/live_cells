import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellTextFieldDemo1 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final input = cell(() => MutableCell(''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User input using CellTextField'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CellTextField(content: input),
              const SizedBox(height: 10),
              const Text(
                  'You wrote:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text(input())),
              ElevatedButton(
                child: const Text('Clear'),
                onPressed: () {
                    input.value = '';
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}