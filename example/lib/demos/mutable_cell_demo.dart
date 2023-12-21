import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class MutableCellDemo extends StatefulWidget {
  @override
  State<MutableCellDemo> createState() => _MutableCellDemoState();
}

class _MutableCellDemoState extends State<MutableCellDemo> {
  final counter = MutableCell(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutable Cells'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Demonstration show how changing a cell's value rebuilds all widgets dependent on the cell",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              counter.toWidget((context, count, _) =>
                  Text('You clicked the button $count times')
              ),
              ElevatedButton(
                child: const Text('Increment Counter'),
                onPressed: () => counter.value += 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}