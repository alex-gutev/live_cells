import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

/// Example showing usage of [LiveCheckox]
class LiveCheckboxDemo extends CellWidget {
  const LiveCheckboxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Cell holding the state of the checkbox.
    final state = MutableCell<bool?>(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveCheckbox Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of LiveCheckbox widget which binds checkbox state to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              // A checkbox with its state controlled by the cell `state`
              LiveCheckbox(
                value: state,
                tristate: true,
              ),
              CellWidget.builder((_) {
                if (state() != null) {
                  return Text('The checkbox is ${state()! ? 'checked' : 'unchecked'}');
                }
                else {
                  return const Text('The checkbox is in the null state');
                }
              }),
              // The following buttons set the state of the checkbox by
              // assigning a value to the `state` cell.
              ElevatedButton(
                  onPressed: () => state.value = true,
                  child: const Text('Reset')
              ),
              ElevatedButton(
                  onPressed: () => state.value = null,
                  child: const Text('Null state')
              )
            ],
          ),
        ),
      ),
    );
  }
}