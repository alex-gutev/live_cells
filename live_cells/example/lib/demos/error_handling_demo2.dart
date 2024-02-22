import 'package:flutter/material.dart';
import 'package:live_cells/live_cell_widgets.dart';
import 'package:live_cells/live_cells.dart';

/// Example showing usage of *maybe cells* for handling errors in two-way data
/// flow.
///
/// The example demonstrates the same functionality as `error_handling_demo1.dart`
/// with the only difference being that the error message is more informative.
///
/// The purpose of this example is to demonstrate how the text field validation
/// functionality can be packaged in a reusable function.
class ErrorHandlingDemo2 extends StaticWidget {
  @override
  Widget build(BuildContext context) {
    final a = MutableCell<num>(0);
    final b = MutableCell<num>(0);

    final sum = a + b;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error handling 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: NumberField(a),
                  ),
                  const SizedBox(width: 5),
                  const Text('+'),
                  const SizedBox(width: 5),
                  Expanded(
                    child: NumberField(b),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CellWidget.builder((_) => Text(
                  '${a()} + ${b()} = ${sum()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  )
              )),
              ElevatedButton(
                child: const Text('Reset'),
                onPressed: () {
                  MutableCell.batch(() {
                    a.value = 0;
                    b.value = 0;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Creates a text field for numeric input with error checking.
///
/// NOTE: [cell] is a `num` cell to which the parsed numeric input is assigned,
/// whenever text is entered in the field. Similarly changing the value of
/// [cell] results in that value being displayed in the field.
///
/// The field also displays an error message if it is empty or the entered
/// text is not a valid number
class NumberField extends StaticWidget {
  /// The `num` cell to which the content of the field is bound
  final MutableCell<num> n;

  /// Create text field with its content bound to the `num` cell `n`
  ///
  /// NOTE: Given that the field is defined using a [StaticWidget], which is only
  /// built once when it is added to the tree, this cannot be changed while the
  /// widget is in the tree, i.e. you cannot do the following:
  ///
  /// ```dart
  /// NumberField(cond ? n : m);
  /// ```
  const NumberField(this.n, { super.key });

  @override
  Widget build(BuildContext context) {
    final maybe = n.maybe();
    final content = maybe.mutableString();
    final error = maybe.error;

    final isEmpty = ValueCell.computed(() => content().isEmpty);

    return CellTextField(
      content: content,
      keyboardType: TextInputType.number.cell,
      decoration: ValueCell.computed(() => InputDecoration(
          errorText: isEmpty()
              ? 'Cannot be empty'
              : error() != null
              ? 'Not a valid number'
              : null
      )),
    );
  }
}