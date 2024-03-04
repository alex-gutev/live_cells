import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing usage of [CellSlider]
class CellSliderDemo extends CellWidget {
  @override
  Widget build(BuildContext context) {
    // Cell holding the slider value
    final n = MutableCell(2.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CellSlider Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of CellSlider widget which binds slider value to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              // A slider with a value controlled by the `n` cell.
              CellSlider(
                value: n,
                min: 0.0.cell,
                max: 5.0.cell,
              ),
              CellWidget.builder((_) => Text('Slider value is: ${n().toStringAsFixed(2)}')),
              // The following button resets the value of the slider to 2
              // by setting the value of cell `n`
              ElevatedButton(
                  onPressed: () => n.value = 2,
                  child: const Text('Reset')
              )
            ],
          ),
        ),
      ),
    );
  }
}