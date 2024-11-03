import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing how the pevious values of cells can be accessed
///
/// This example also demonstrates exception handling using `onError`.
class PreviousValueDemo extends CellWidget {
  const PreviousValueDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Cell holding the counter value
    final count = MutableCell(0);

    // Convert count to a string
    final countStr = ValueCell.computed(() => count().toString());

    // onError is used so that the cell has an initial value of '<none>'
    // Without the onError, `UninitializedCellError` is thrown until
    // the first time `count` changes its value.
    final prevCount = countStr
        .previous
        .initialValue('<none>'.cell);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Values'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Increment Counter'),
                onPressed: () => count.value += 1,
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text(
                  'Current Count: ${count()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              )),
              CellWidget.builder((_) => Text(
                  'Previous Count: ${prevCount()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              ))
            ],
          ),
        ),
      ),
    );
  }
}