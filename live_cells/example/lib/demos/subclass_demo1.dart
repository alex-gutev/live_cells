import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells_core/live_cells_internals.dart';

class ClampCell<T extends num> extends DependentCell<T> {
  final ValueCell<T> argValue;
  final ValueCell<T> argMin;
  final ValueCell<T> argMax;

  ClampCell(this.argValue, this.argMin, this.argMax) :
        super({argValue, argMin, argMax});

  @override
  T get value => min(argMax.value, max(argMin.value, argValue.value));
}

class SubclassDemo1 extends CellWidget {
  @override
  Widget build(BuildContext context) {
    final a = MutableCell(5);
    final aMax = 10.cell;
    final aMin = 2.cell;

    final clamped = ClampCell(a, aMin, aMax);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueCell Subclass Demo 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of subclass of ValueCell',
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
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text('ClampCell(${a()}, 2, 10) value is ${clamped()}'))
            ],
          ),
        ),
      ),
    );
  }
}