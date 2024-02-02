import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

// Basic example demonstrating how `CellWidget` rebuilds when the values of
// cells referenced within it change.
class CounterDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    // Cell holding the counter value
    final counter = cell(() => MutableCell(0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Increments the counter value when pressed
              ElevatedButton(
                child: const Text('Increment Counter'),
                onPressed: () => counter.value += 1,
              ),
              const SizedBox(height: 10),
              // Displays the counter value. The following widget is rebuilt
              // whenever the value of `counter` changes
              //
              // NOTE: The value of counter is accessed with the function
              // call syntax `counter()` and not `counter.value`.
              CellWidget.builder((_) => Text(
                  '${counter()}',
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