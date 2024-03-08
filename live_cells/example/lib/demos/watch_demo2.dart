import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// Example of cell watch functions
///
/// NOTE: This example uses CellWidget and the watch method instead of
/// ValueCell.watch.
class WatchDemo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watching Cells 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: CellWidget.builder((context) {
            final counter1 = MutableCell(0);
            final counter2 = MutableCell(0);

            // Register a watch function to be called when the values of counter1 and
            // counter2 change.
            //
            // NOTE: Unlike in the previous example, this watch function is automatically
            // removed once the widget is removed from the tree.
            context.watch(() {
              final snackbar = SnackBar(
                content: Text('Counters: ${counter1()}, ${counter2()}'),
                duration: Duration(milliseconds: 500),
              );

              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              });
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Increment Counter 1'),
                  onPressed: () => counter1.value += 1,
                ),
                const SizedBox(height: 10),
                CellWidget.builder((_) => Text(
                    '${counter1()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                )),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Increment Counter 2'),
                  onPressed: () => counter2.value += 1,
                ),
                const SizedBox(height: 10),
                CellWidget.builder((_) => Text(
                    '${counter2()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )
                ))
              ],
            );
          }),
        ),
      ),
    );
  }
}