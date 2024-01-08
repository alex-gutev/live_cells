import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class ComputeCellDemo3 extends CellWidget with CellInitializer {
  @override
  Widget build(BuildContext context) {
    final a = cell(() => MutableCell(0));
    final b = cell(() => MutableCell(0));

    final sum = cell(() => ValueCell.computed(() => a() + b()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Computational Cells 3'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of computational cells with multiple argument cells',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              Row(
                  children: [
                    const Text('A:'),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        onChanged: (value) {
                          a.value = int.tryParse(value) ?? 0;
                        },
                      ),
                    )
                  ]
              ),
              Row(
                children: [
                  const Text('B:'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(signed: true),
                      onChanged: (value) {
                        b.value = int.tryParse(value) ?? 0;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text('${a()} + ${b()} = ${sum()}'))
            ],
          ),
        ),
      ),
    );
  }
}