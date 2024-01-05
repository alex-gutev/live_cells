import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellSwitchDemo extends CellWidget {
  @override
  Widget buildChild(BuildContext context) {
    final state = cell(() => MutableCell(true));

    return Scaffold(
      appBar: AppBar(
        title: const Text('CellSwitch Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of CellSwitch widget which binds switch state to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              CellSwitch(
                value: state,
              ),
              state.toWidget((_, state, __) => Text('The switch is ${state ? 'on' : 'off'}')),
              ElevatedButton(
                  onPressed: () => state.value = true,
                  child: const Text('Reset')
              ),
            ],
          ),
        ),
      ),
    );
  }
}