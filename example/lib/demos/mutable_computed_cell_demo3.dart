import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class MutableComputedCellDemo3 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    final errorA = cell(() => MutableCell<dynamic>(null));
    final errorB = cell(() => MutableCell<dynamic>(null));

    final strA = cell(() => a.mutableString(
      error: errorA,
      errorValue: null
    ));

    final strB = cell(() => b.mutableString(
      error: errorB,
      errorValue: null
    ));

    final sum = cell(() => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error handling with mutableString()'),
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
                      decoration: InputDecoration(
                        errorText: errorA() != null
                            ? 'Please enter a valid number'
                            : null
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CellTextField(
                      content: strB,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          errorText: errorB() != null
                              ? 'Please enter a valid number'
                              : null
                      ),
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