import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class CountCell extends NotifierCell<int> {
  final int end;
  final Duration interval;

  Timer? _timer;

  CountCell(this.end, {
    this.interval = const Duration(seconds: 1)
  }) : super(0);

  @override
  void init() {
    super.init();

    _timer = Timer.periodic(interval,_timerTick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    super.dispose();
  }

  void _timerTick(Timer timer) {
    if (value >= end) {
      timer.cancel();
      _timer = null;
    }
    else {
      value++;
    }
  }
}

class SubclassDemo2 extends StatefulWidget {
  @override
  State<SubclassDemo2> createState() => _SubclassDemo2State();
}

class _SubclassDemo2State extends State<SubclassDemo2> {
  final counter = CountCell(10, interval: const Duration(seconds: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValueCell Subclass Demo 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of subclass of ValueCell using resource management methods',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              Text('Counting to 10'),
              const SizedBox(height: 10),
              counter.toWidget((context, value, _) => Text(
                '$value',
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