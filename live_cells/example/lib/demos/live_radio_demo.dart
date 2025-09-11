import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

enum RadioOption {
  optionA,
  optionB,
  optionC
}

extension RadioOptionExtension on RadioOption {
  String get prettyName {
    switch (this) {
      case RadioOption.optionA:
        return 'A';

      case RadioOption.optionB:
        return 'B';

      case RadioOption.optionC:
        return 'C';
    }
  }
}

/// Example showing usage of [LiveRadio]
class LiveRadioDemo extends CellWidget {
  const LiveRadioDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Cell holding the group value - the value of the selected radio button
    final option = MutableCell<RadioOption?>(RadioOption.optionB);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveRadio Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Demonstration of LiveRadioGroup widget which binds group value state to a cell.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              // Three radio buttons with the group value controlled by the
              // `option` cell
              LiveRadioGroup(
                groupValue: option,
                child: Column(
                  children: [
                    RadioListTile(
                      value: RadioOption.optionA,
                      title: const Text('Option A'),
                    ),
                    RadioListTile(
                      value: RadioOption.optionB,
                      title: const Text('Option B'),
                    ),
                    RadioListTile(
                      value: RadioOption.optionC,
                      title: const Text('Option C'),
                    ),
                  ],
                ),
              ),
              CellWidget.builder((_) => Text('Selected option: ${option()?.prettyName ?? 'None'}')),
              // The following buttons change the selected radio button by
              // assigning a value to the `option` cell.
              ElevatedButton(
                  onPressed: () => option.value = RadioOption.optionB,
                  child: const Text('Reset')
              ),
              ElevatedButton(
                  onPressed: () => option.value = null,
                  child: const Text('Clear')
              )
            ],
          ),
        ),
      ),
    );
  }
}