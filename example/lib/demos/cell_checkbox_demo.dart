import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellCheckboxDemo extends CellWidget {
  @override
  Widget build(BuildContext context) {
    final state = cell(() => MutableCell<bool?>(true));

    return Scaffold(
      appBar: AppBar(
        title: const Text('CellCheckbox Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of CellCheckbox widget which binds checkbox state to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              CellCheckbox(
                value: state,
                tristate: true,
              ),
              WidgetCell.builder((_) {
                if (state() != null) {
                  return Text('The checkbox is ${state()! ? 'checked' : 'unchecked'}');
                }
                else {
                  return Text('The checkbox is in the null state');
                }
              }),
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