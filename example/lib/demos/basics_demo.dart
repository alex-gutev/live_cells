import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class BasicsDemo extends StatefulWidget {
  @override
  State<BasicsDemo> createState() => _BasicsDemoState();
}

class _BasicsDemoState extends State<BasicsDemo> {
  final cell = ValueCell.value(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Basic demonstration of widgets dependent on cell values',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              cell.toWidget((context, value, _) => Text('Value of cell is $value'))
            ],
          ),
        ),
      ),
    );
  }
}