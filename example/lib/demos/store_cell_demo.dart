import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class StoreCellDemo extends StatefulWidget {
  @override
  State<StoreCellDemo> createState() => _StoreCellDemoState();
}

class _StoreCellDemoState extends State<StoreCellDemo> {
  final n = MutableCell(0);

  @override
  Widget build(BuildContext context) {
    return CellBuilder(
      create: () => n.apply((n) {
        var result = 1;

        // This should only be printed once per change of value of n
        print('Computing Factorial of $n');

        for (var i = 2; i <= n; i++) {
          result *= i;
        }

        return result;
      }).store(),

      builder: (context, factorial, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Store Cells'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Demonstration of cells which store the value of cell in memory',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                    children: [
                      const Text('N:'),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(signed: true),
                          onChanged: (value) {
                            n.value = int.tryParse(value) ?? 0;
                          },
                        ),
                      )
                    ]
                ),
                const SizedBox(height: 10),
                factorial.toWidget((context, fact, _) => Text('N! = $fact')),
                factorial.toWidget((context, fact, child) => Text('The factorial of N is $fact'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}