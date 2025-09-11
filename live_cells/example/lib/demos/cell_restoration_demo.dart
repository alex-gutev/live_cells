import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

// Example of cell state restoration using [RestorableCellWidget]:
//
// This example also shows an example of a [CellValueCoder] implementation, to
// allow the state of cells, which do not store a dart primitive value, to be
// saved.

enum RadioValue {
  value1,
  value2,
  value3
}

/// CellValueCoder subclass which encodes [RadioValue] to a representation using
/// dart primitive values. This allows the state of a cell holding a [RadioValue]
/// to be restored.
class RadioValueCoder implements CellValueCoder {
  @override
  RadioValue? decode(Object? primitive) {
    if (primitive != null) {
      final name = primitive as String;

      return RadioValue.values.byName(name);
    }

    return null;
  }

  @override
  Object? encode(covariant RadioValue? value) {
    return value?.name;
  }
}

class CellRestorationDemo extends CellWidget {
  const CellRestorationDemo({super.key}) :
    super(restorationId: 'cell_restoration_demo');

  @override
  Widget build(BuildContext context) {
    // The state of the following cells is restored without additional steps
    final sliderValue = MutableCell(0.0).restore();
    final switchValue = MutableCell(false).restore();
    final checkboxValue = MutableCell(true).restore();

    // This cell requires a [CellValueCoder] to have its state restored.
    // In this case the [RadioValueCoder] constructor is provided since the
    // cell holds a [RadioValue].
    final radioValue = MutableCell<RadioValue?>(RadioValue.value1)
        .restore(coder: RadioValueCoder());

    // This cell is restored automatically
    final textValue = MutableCell('').restore();

    // This cell is restored automatically
    final numValue = MutableCell<num>(1).restore();

    // The state of this cannot be saved since it holds a [Maybe] which is
    // not a value that can be saved.
    //
    // Although its state cannot be saved, its state is recomputed on state
    // restoration and effectively restored
    final numMaybe = numValue.maybe();
    final numError = numMaybe.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cell State Restoration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Text('This example demonstrates state restoration using cells'),
              const SizedBox(height: 5),
              const Text('To test this out:'),
              const SizedBox(height: 5),
              const Text('1. Go to developer mode and enable "Don\'t keep activities"'),
              const Text('2. Play around with the widgets below'),
              const Text('3. Switch to another app'),
              const Text('4. Return to this app'),
              const Text('5. The widgets should be as you left them'),
              const SizedBox(height: 10),
              const Text(
                'A Slider',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Row(
                children: [
                  CellWidget.builder((context) => Text(sliderValue().toStringAsFixed(2))),
                  Expanded(
                      child: LiveSlider(
                          min: 0.0,
                          max: 10.0,
                          value: sliderValue
                      ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              LiveSwitchListTile(
                value: switchValue,
                title: const Text('A Switch'),
              ),
              const SizedBox(height: 5),
              LiveCheckboxListTile(
                value: checkboxValue,
                title: const Text('A checkbox'),
              ),
              const SizedBox(height: 5),
              const Text(
                'Radio Buttons:',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),
              LiveRadioGroup(
                groupValue: radioValue,
                child: Column(
                  children: [
                    RadioListTile(
                      value: RadioValue.value1,
                      title: const Text('value1'),
                    ),
                    RadioListTile(
                      value: RadioValue.value2,
                      title: const Text('value2'),
                    ),
                    RadioListTile(
                      value: RadioValue.value3,
                      title: const Text('value3'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text('Enter some text:'),
              LiveTextField(content: textValue),
              const SizedBox(height: 10),
              CellWidget.builder((context) => Text('You wrote: ${textValue()}')),
              const SizedBox(height: 10),
              const Text('Text field for numeric input:'),
              LiveTextField(
                content: numMaybe.mutableString().restore(),
                decoration: InputDecoration(
                  errorText: numError() != null
                      ? 'Not a valid number'
                      : null
                ),
              ),
              const SizedBox(height: 10),

              // The state of the a1 cell defined below is not saved. However,
              // it's state is restored because it is recomputed from `numValue`.
              CellWidget.builder((context) {
                final a1 = numValue + 1.cell;
                return Text('${numValue()} + 1 = ${a1()}');
              }),
            ],
          ),
        ),
      ),
    );
  }
}