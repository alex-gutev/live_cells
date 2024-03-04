import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

class CountCell extends StatefulCell<int> {
  final int start;
  final int end;
  final Duration interval;

  CountCell(this.end, {
    this.interval = const Duration(seconds: 1),
    this.start = 0
  });

  @override
  int get value {
    final state = this.state;

    if (state == null) {
      throw UninitializedCellError();
    }

    return state.value;
  }

  @override
  @protected
  CountCellState? get state => super.state as CountCellState?;

  @override
  CellState<StatefulCell> createState() => CountCellState(
      cell: this,
      key: key
  );
}

class CountCellState extends CellState<CountCell> {
  CountCellState({
    required super.cell,
    required super.key
  }) : _value = cell.start;

  int _value;
  Timer? _timer;

  int get value => _value;

  @override
  void init() {
    super.init();

    _timer = Timer.periodic(cell.interval, _timerTick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;

    super.dispose();
  }


  void _timerTick(Timer timer) {
    if (value >= cell.end) {
      timer.cancel();
    }
    else {
      notifyWillUpdate();
      _value++;
      notifyUpdate();
    }
  }
}

class SubclassDemo2 extends CellWidget {
  @override
  Widget build(BuildContext context) {
    final counter = CountCell(10, interval: const Duration(seconds: 1));

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
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              const Text('Counting to 10'),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text(
                  '${counter()}',
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