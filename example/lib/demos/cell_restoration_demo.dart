import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

enum RadioValue {
  value1,
  value2,
  value3
}

class RadioValueCoder implements CellValueCoder<RadioValue?> {
  @override
  RadioValue? decode(Object? primitive) {
    if (primitive != null) {
      final name = primitive as String;

      return RadioValue.values.byName(name);
    }

    return null;
  }

  @override
  Object? encode(RadioValue? value) {
    return value?.name;
  }
}

class CellRestorationDemo extends RestorableCellWidget {
  @override
  String get restorationId => 'cell_restoration_demo';

  @override
  Widget build(BuildContext context) {
    final sliderValue = cell(() => MutableCell(0.0));
    final switchValue = cell(() => MutableCell(false));
    final checkboxValue = cell(() => MutableCell(true));

    final radioValue = cell(
      () => MutableCell<RadioValue?>(RadioValue.value1),
      coder: RadioValueCoder.new
    );

    final textValue = cell(() => MutableCell(''));

    final numValue = cell(() => MutableCell<num>(1));
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Row(
                children: [
                  CellWidget.builder((context) => Text(sliderValue().toStringAsFixed(2))),
                  Expanded(
                      child: CellSlider(
                          min: 0.0,
                          max: 10,
                          value: sliderValue
                      ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              CellSwitchListTile(
                value: switchValue,
                title: const Text('A Switch'),
              ),
              const SizedBox(height: 5),
              CellCheckboxListTile(
                value: checkboxValue,
                title: Text('A checkbox'),
              ),
              const SizedBox(height: 5),
              const Text(
                'Radio Buttons:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),
              Column(
                children: [
                  CellRadioListTile(
                    groupValue: radioValue,
                    value: RadioValue.value1,
                    title: const Text('value1'),
                  ),
                  CellRadioListTile(
                    groupValue: radioValue,
                    value: RadioValue.value2,
                    title: const Text('value2'),
                  ),
                  CellRadioListTile(
                    groupValue: radioValue,
                    value: RadioValue.value3,
                    title: const Text('value3'),
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
                decoration: InputDecoration(
                  errorText: numError() != null
                      ? 'Not a valid number'
                      : null
                ),
              ),
              const SizedBox(height: 10),
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