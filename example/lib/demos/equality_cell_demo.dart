import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class EqualityCellDemo extends StatefulWidget {
  @override
  State<EqualityCellDemo> createState() => _EqualityCellDemoState();
}

class _EqualityCellDemoState extends State<EqualityCellDemo> {
  final a = MutableCell(0);
  final b = MutableCell(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equality Cells'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of equality comparison cells',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  a.toWidget((context, value, _) => Text('A: $value')),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Icon(CupertinoIcons.minus),
                    onPressed: () => a.value--,
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Icon(CupertinoIcons.add),
                    onPressed: () => a.value++,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  b.toWidget((context, value, _) => Text('B: $value')),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Icon(CupertinoIcons.minus),
                    onPressed: () => b.value--,
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: const Icon(CupertinoIcons.add),
                    onPressed: () => b.value++,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              a.eq(b).toWidget((context, isEq, _) {
                if (isEq) {
                  return const Text('A is equal to B');
                }

                return const Text('A is not equal to B');
              })
            ],
          ),
        ),
      ),
    );
  }
}