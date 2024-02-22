import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// Example of ValueCell.watch
class WatchDemo1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watching Cells 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: WatchDemo1Counter(),
        ),
      ),
    );
  }
}

/// Widget which shows a Snackbar whenever a counter is incremented.
///
/// NOTE: This example uses a StatefulWidget to stop the watch function from
/// being called once the widget is removed from the tree.
class WatchDemo1Counter extends StatefulWidget {
  @override
  State<WatchDemo1Counter> createState() => _WatchDemo1CounterState();
}

class _WatchDemo1CounterState extends State<WatchDemo1Counter> {
  final counter1 = MutableCell(0);
  final counter2 = MutableCell(0);

  // Registered watch function
  late CellWatcher watcher;

  @override
  void initState() {
    super.initState();

    // Register a watch function to be called when the values of counter1 and
    // counter2 change.
    //
    // NOTE: The watch function is always called once before ValueCell.watch
    // returns.
    watcher = ValueCell.watch(() {
      final snackbar = SnackBar(
        content: Text('Counters: ${counter1()}, ${counter2()}'),
        duration: Duration(milliseconds: 500),
      );

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      });
    });
  }

  @override
  void dispose() {
    // The watch function will no longer be called for future updates of counter1
    // and counter2
    watcher.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}