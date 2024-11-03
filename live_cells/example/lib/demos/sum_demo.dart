import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing computed cells
class SumDemo extends CellWidget {
  const SumDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final a = MutableCell(0);
    final b = MutableCell(0);

    // Computed cell holding the sum of `a` and `b`
    //
    // The value of this cell is updated whenever the values of `a` or `b` change.
    final sum = a + b;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Computed Cells'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        a.value = int.tryParse(value) ?? 0;
                      },

                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        b.value = int.tryParse(value) ?? 0;
                      },

                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Show the sum (a + b) and the values of `a` and `b`.
              // Note the value of `sum` is automatically recomputed whenever
              // `a` or `b` change.
              CellWidget.builder((_) => Text(
                  '${a()} + ${b()} = ${sum()}',
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