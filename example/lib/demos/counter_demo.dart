import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class CounterDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
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
              ElevatedButton(
                child: const Text('Increment Counter'),
                onPressed: () => counter.value += 1,
              ),
              const SizedBox(height: 10),
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