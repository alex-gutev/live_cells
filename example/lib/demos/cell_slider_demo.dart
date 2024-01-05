import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

class CellSliderDemo extends CellWidget {
  @override
  Widget buildChild(BuildContext context) {
    final n = cell(() => MutableCell(2.0));

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
              CellSlider(
                value: n,
                min: 0,
                max: 5,
              ),
              n.toWidget((_, value, __) => Text('Slider value is: ${value.toStringAsFixed(2)}')),
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