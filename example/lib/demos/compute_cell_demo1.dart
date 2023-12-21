import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class ComputeCellDemo1 extends StatefulWidget {
  @override
  State<ComputeCellDemo1> createState() => _ComputeCellDemo1State();
}

class _ComputeCellDemo1State extends State<ComputeCellDemo1> {
  final counter = MutableCell(0);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Computational Cells 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of cells which compute a value dependent on the value of another cell',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              counter.apply((x) => x * x).toWidget((context, value, _) =>
                  Text('The value of the cell is $value')
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