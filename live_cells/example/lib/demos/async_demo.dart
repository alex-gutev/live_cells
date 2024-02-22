import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// Demonstrates asynchronous cells
class AsyncDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    /// Text field content cell
    final content = cell(() => MutableCell(''));

    /// This cell holds the content of the text field but only updates after
    /// a delay of 3 seconds.
    ///
    /// The `.wait` awaits the value in the `Future` held in the cell returned
    /// by `delayed(...)`.
    ///
    /// The `.onError<UninitializedCellError>` catches the exception that is
    /// thrown when the cell's value is accessed before the Future has been
    /// resolved.
    final delayed = cell(() => content.delayed(const Duration(seconds: 3))
        .wait
        .onError<UninitializedCellError>(''.cell)
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asynchronous Cells'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // A text field with its content controlled by cell `input`
              CellTextField(content: content),
              const SizedBox(height: 10),
              const Text(
                'Whatever you write will show up below after a delay of 3 seconds.'
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
              // The content of the text field is retrieved using the `input` cell
              CellText(
                data: delayed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}