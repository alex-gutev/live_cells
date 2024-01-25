import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellTextFieldDemo2 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final input = cell(() => MutableCell(''));
    final selection = cell(() => MutableCell(
        const TextSelection.collapsed(offset: 0)
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User input using CellTextField 2'),
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
                      child: CellTextField(
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
                    CellWidget.builder((_) => Text(selection().textInside(input()))),
                    ElevatedButton(
                      child: const Text('Clear Selection'),
                      onPressed: () {
                        selection.value = TextSelection.collapsed(
                          offset: selection.value.baseOffset,
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Clear'),
                      onPressed: () {
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