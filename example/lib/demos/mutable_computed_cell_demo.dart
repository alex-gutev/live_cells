import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class MutableComputedCellDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    final strA = cell(() => a.toMutableString());
    final strB = cell(() => b.toMutableString());

    final sum = cell(() => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutable Computed Cells'),
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
                    child: CellTextField(
                      content: strA,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CellTextField(
                      content: strB,
                      keyboardType: TextInputType.number,
                    ),
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
}