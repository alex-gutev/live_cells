import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing a user defined multi-argument mutable computed cell
class MutableComputedCellDemo2 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    // Ordinarily computes the sum of a and b.
    //
    // When a value is assigned to it, cells `a` and `b` are both assigned
    // to 1/2 the value assigned to this cell.
    final sum = cell(() => MutableCell.computed(() => a() + b(), (sum) {
      final half = sum / 2;

      a.value = half;
      b.value = half;
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutable Computed Cells 2'),
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
                    // Text field for a, note the `mutableString` to convert
                    // the `num` to a `string` and vice versa
                    child: CellTextField(
                      content: cell(() => a.mutableString()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    // Text field for b, note the `mutableString` to convert
                    // the `num` to a `string` and vice versa
                    child: CellTextField(
                      content: cell(() => b.mutableString()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('='),
                  const SizedBox(width: 5),
                  Expanded(
                    // Text field for the sum, note the `mutableString` to convert
                    // the `num` to a `string` and vice versa
                    //
                    // This allows the user to directly assign a value for
                    // the sum using this field. Doing so updates the values
                    // in the fields for a and b to 1/2 the value entered in
                    // this field
                    child: CellTextField(
                      content: cell(() => sum.mutableString()),
                      keyboardType: TextInputType.number,
                    ),
                  )
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