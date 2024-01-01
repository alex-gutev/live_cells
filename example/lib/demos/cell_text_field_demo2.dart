import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellTextFieldDemo2 extends StatefulWidget {
  @override
  State<CellTextFieldDemo2> createState() => _CellTextFieldDemo2State();
}

class _CellTextFieldDemo2State extends State<CellTextFieldDemo2> {
  final a = MutableCell(0);

  late final content = [a].mutableComputeCell(
          () => a.value.toString(),
          (content) {
            a.value = int.tryParse(content) ?? 0;
          }
  );

  late final square = a * a;

  @override
  Widget build(BuildContext context) {
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
                keyboardType: TextInputType.number,
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