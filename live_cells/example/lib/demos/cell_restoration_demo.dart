import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

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

class CellRestorationDemo extends RestorableCellWidget {
  @override
  String get restorationId => 'cell_restoration_demo';

  @override
  Widget build(BuildContext context) {
    // The state of the following cells is restored without additional steps
    final sliderValue = cell(() => MutableCell(0.0));
    final switchValue = cell(() => MutableCell(false));
    final checkboxValue = cell(() => MutableCell(true));

    // This cell requires a [CellValueCoder] to have its state restored.
    // In this case the [RadioValueCoder] constructor is provided since the
    // cell holds a [RadioValue].
    final radioValue = cell(
      () => MutableCell<RadioValue?>(RadioValue.value1),
      coder: RadioValueCoder.new
    );

    // This cell is restored automatically
    final textValue = cell(() => MutableCell(''));

    // This cell is restored automatically
    final numValue = cell(() => MutableCell<num>(1));

    // The state of this cannot be saved since it holds a [Maybe] which is
    // not a value that can be saved, hence the `restorable: false`.
    //
    // Although its state cannot be saved, its state is recomputed on state
    // restoration and effectively restored
    final numMaybe = cell(() => numValue.maybe(), restorable: false);
    final numError = cell(() => numMaybe.error);

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
                      child: CellSlider(
                          min: 0.0.cell,
                          max: 10.0.cell,
                          value: sliderValue
                      ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              CellSwitchListTile(
                value: switchValue,
                title: const Text('A Switch').cell,
              ),
              const SizedBox(height: 5),
              CellCheckboxListTile(
                value: checkboxValue,
                title: const Text('A checkbox').cell,
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
              Column(
                children: [
                  CellRadioListTile(
                    groupValue: radioValue,
                    value: RadioValue.value1.cell,
                    title: const Text('value1').cell,
                  ),
                  CellRadioListTile(
                    groupValue: radioValue,
                    value: RadioValue.value2.cell,
                    title: const Text('value2').cell,
                  ),
                  CellRadioListTile(
                    groupValue: radioValue,
                    value: RadioValue.value3.cell,
                    title: const Text('value3').cell,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Enter some text:'),
              CellTextField(content: textValue),
              const SizedBox(height: 10),
              CellWidget.builder((context) => Text('You wrote: ${textValue()}')),
              const SizedBox(height: 10),
              const Text('Text field for numeric input:'),
              CellTextField(
                content: cell(() => numMaybe.mutableString()),
                decoration: cell(() => ValueCell.computed(() => InputDecoration(
                  errorText: numError() != null
                      ? 'Not a valid number'
                      : null
                )), restorable: false),
              ),
              const SizedBox(height: 10),

              // Notice the use of CellWidget here.
              // The state of the a1 cell defined below is not saved,
              // since it is defined within a CellWidget's context. However,
              // it's state is restored because it is recomputed from `numValue`.
              CellWidget.builder((context) {
                final a1 = context.cell(() => numValue + 1.cell);
                return Text('${numValue()} + 1 = ${a1()}');
              }),
            ],
          ),
        ),
      ),
    );
  }
}