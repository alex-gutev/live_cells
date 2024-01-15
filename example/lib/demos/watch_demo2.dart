import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class WatchDemo2 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final counter1 = cell(() => MutableCell(0));
    final counter2 = cell(() => MutableCell(0));

    watch(() {
      print('Counters incremented to: ${counter1()}, ${counter2()}');
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watching Cells 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text('Incrementing the counters prints a message to the log'),
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
          ),
        ),
      ),
    );
  }
}