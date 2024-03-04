import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing a CellTextField for numeric input.
///
/// The example demonstrates using `mutableString` to convert a `num` value to
/// a `string` and vice versa.
class MutableComputedCellDemo extends CellWidget {
  @override
  Widget build(BuildContext context) {
    // Cells holding the parsed `num` values from fields `a` and `b`
    // These can also be used to reset the content of the fields
    final a = MutableCell<num>(0);
    final b = MutableCell<num>(0);

    // Cells holding string representations of `a` and `b`.
    //
    // When a `num` value is assigned to `a`/`b`, the value of `strA`/`strB`
    // becomes the string representation of the `num` value.
    //
    // When a string value is assigned to `strA`/`strB`, a num is parsed from it
    // and assigned to `a`/`b`.
    //
    // These are given as the content cell in the CellTextField constructor
    final strA = a.mutableString();
    final strB = b.mutableString();

    // A computed cell demonstrating that `a` and `b` can be used as any other
    // cell
    final sum = a + b;

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
                      keyboardType: TextInputType.number.cell,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CellTextField(
                      content: strB,
                      keyboardType: TextInputType.number.cell,
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
              // Reset the values of the fields to 0
              ElevatedButton(
                child: const Text('Reset'),
                onPressed: () {
                  // Note the content of the fields is set directly by assigning
                  // a `num` to cells `a` and `b`.
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