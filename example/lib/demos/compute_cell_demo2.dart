import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class ComputeCellDemo2 extends StatefulWidget {
  @override
  State<ComputeCellDemo2> createState() => _ComputeCellDemo2State();
}

class _ComputeCellDemo2State extends State<ComputeCellDemo2> {
  final name = MutableCell('');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Computational Cells 2'),
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
              const Text('Enter your name'),
              TextField(
                onChanged: (value) {
                  name.value = value;
                },
              ),
              const SizedBox(height: 10),
              name.apply((value) => 'Hello $value')
                  .toWidget((context, greeting, _) => Text(greeting))
            ],
          ),
        ),
      ),
    );
  }
}