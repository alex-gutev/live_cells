import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class ClampCell<T extends num> extends DependentCell<T> with CellEquality<T> {
  final ValueListenable<T> argValue;
  final ValueListenable<T> argMin;
  final ValueListenable<T> argMax;

  ClampCell(this.argValue, this.argMin, this.argMax) :
        super([argValue, argMin, argMax]);

  @override
  T get value => min(argMax.value, max(argMin.value, argValue.value));
}

class SubclassDemo1 extends StatefulWidget {
  @override
  State<SubclassDemo1> createState() => _SubclassDemo1State();
}

class _SubclassDemo1State extends State<SubclassDemo1> {
  final a = MutableCell(5);
  final aMax = ValueCell.value(10);
  final aMin = ValueCell.value(2);

  late final clamped = ClampCell(a, aMin, aMax);

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(
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
                    child: Icon(CupertinoIcons.minus),
                    onPressed: () => a.value--,
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    child: Icon(CupertinoIcons.add),
                    onPressed: () => a.value++,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              clamped.toWidget((context, value, _) => Text('ClampCell(a, 2, 10) value is $value'))
            ],
          ),
        ),
      ),
    );
  }
}