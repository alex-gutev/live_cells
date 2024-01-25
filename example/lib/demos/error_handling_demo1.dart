import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing usage of *maybe cells* for handling errors in two-way data
/// flow.
///
/// Specifically the example uses `mutableString` and `CellTextField` to
/// retrieve numeric input from a text field whilst handling invalid input by
/// displaying and error message under the field.
class ErrorHandlingDemo1 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    // Cells holding the parsed `num` values from fields `a` and `b`
    // These can also be used to reset the content of the fields
    final a = cell(() => MutableCell<num>(0));
    final b = cell(() => MutableCell<num>(0));

    // Maybe cells for cells `a` and `b`.
    //
    // The purpose of the Maybe is to capture any errors which occur during
    // parsing of `a` and `b` and store these cells so they can be handled.
    final maybeA = cell(() => a.maybe());
    final maybeB = cell(() => b.maybe());

    // String cells for fields `a` and b`.
    //
    // When a string is assigned to these cells, a `num` value is parsed and
    // assigned, wrapped in a Maybe, and assigned to `maybeA`/`maybeB`. The
    // Maybe also allows errors during parsing to be assigned to cells `maybeA`/
    // `maybeB`.
    //
    // These cells are passed to the `content` parameter of the [CellTextField]
    // constructor.
    final strA = cell(() => maybeA.mutableString());
    final strB = cell(() => maybeB.mutableString());

    // Cells holding the errors assigned to `maybeA` and `maybeB`. If there
    // was no error during parsing, these cells hold `null`.
    final errorA = cell(() => maybeA.error);
    final errorB = cell(() => maybeB.error);

    // A computed cell demonstrating that `a` and `b` can be used as any other
    // cell
    final sum = cell(() => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error handling 1'),
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
              // Resets the content of the two fields to 0.
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