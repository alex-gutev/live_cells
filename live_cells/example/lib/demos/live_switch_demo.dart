import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

/// Example usage of [LiveSwitch]
class LiveSwitchDemo extends CellWidget {
  const LiveSwitchDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Cell holding the switch state
    final state = MutableCell(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveSwitch Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of LiveSwitch widget which binds switch state to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              // A switch with its state controlled by cell `state`
              LiveSwitch(
                value: state,
              ),
              CellWidget.builder((_) => Text('The switch is ${state() ? 'on' : 'off'}')),
              // The button resets the switch to on by assign a value to the
              // `state` cell
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