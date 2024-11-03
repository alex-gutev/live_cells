import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

/// Example showing using of [LiveTextField]
class LiveTextFieldDemo1 extends CellWidget {
  const LiveTextFieldDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    // Cell holding the content of the field
    final input = MutableCell('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('User input using LiveTextField'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // A text field with its content controlled by cell `input`
              LiveTextField(content: input),
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
              Text(input()),
              // This button clears the text field by assigning the empty string
              // to the `input` cell
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