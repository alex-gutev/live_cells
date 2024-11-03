import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

/// Example showing usage of a [CellTextField] with both a content and selection cell provided.
class LiveTextFieldDemo2 extends CellWidget {
  const LiveTextFieldDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    // Cell holding the content of the text field
    final input = MutableCell('');

    // Cell holding the field's selection
    final selection = MutableCell(
        const TextSelection.collapsed(offset: 0)
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('User input using LiveTextField 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,

                      // A text field with its content and selection controlled
                      // by cells `input` and `selection`.
                      child: LiveTextField(
                        content: input,
                        selection: selection,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'You wrote:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        )
                    ),
                    const SizedBox(height: 10),
                    // The content of the field is retrieved using the `input` cell.
                    CellWidget.builder((_) => Text(input())),
                    const SizedBox(height: 10),
                    const Text(
                        'You selected:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        )
                    ),
                    const SizedBox(height: 10),
                    // The selection is retrieved using the `selection` cell
                    CellWidget.builder((_) => Text(selection().textInside(input()))),
                    // Clears the selection by assign a 'collapsed' selection
                    // to the `selection` cell
                    ElevatedButton(
                      child: const Text('Clear Selection'),
                      onPressed: () {
                        selection.value = TextSelection.collapsed(
                          offset: selection.value.baseOffset,
                        );
                      },
                    ),
                    // Clears the content of the field by assigning the empty
                    // string to the `input` cell
                    ElevatedButton(
                      child: const Text('Clear'),
                      onPressed: () {
                        // NOTE: Since a `selection` cell is provided to the
                        // [CellTextField] constructor, the selection has to be
                        // reset along with the content of the field by
                        // assigning a balue to both `input` and `selection`.
                        //
                        // If only a value to `input` is assigned, the current
                        // selection will be retained which could result in
                        // issues.
                        MutableCell.batch(() {
                          input.value = '';
                          selection.value = const TextSelection.collapsed(offset: 0);
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}