import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class SumDemo extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell(0));
    final b = cell(() => MutableCell(0));

    final sum = cell(() => a + b);

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