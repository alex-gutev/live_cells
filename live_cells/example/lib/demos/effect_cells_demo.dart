import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';
import 'package:live_cells/live_cells_ui.dart';

/// Demonstrates handling button press events using meta cells and effect cells
class EffectCellDemo extends CellWidget with CellHooks {
  const EffectCellDemo({super.key});

  @override
  Widget build(BuildContext context) {
    /// A meta cell for an ActionCell that is triggered when the button is
    /// pressed.
    ///
    /// A meta cell is a cell that points to another cell. Initially the meta
    /// cell is empty but when passed to the button it is initialized to
    /// point to the button's action cell.
    final onPress = MetaCell<void>();

    /// An effect cell which is triggered when the `onPress` cell is triggered.
    ///
    /// An effect cell is just like a normal computed cell (`ValueCell.computed`),
    /// but it is guaranteed to run only when the action cell, on which `effect`
    // is called, is triggered.
    final effect = onPress.effect(() async {
      /// We use Future.delayed to simulate a network request
      ///
      /// In your own code, you would substitute this with a network request,
      /// or whatever side effect you want to perform on the button press.
      await Future.delayed(const Duration(seconds: 3));

      /// You can return anything from an effect cell. Observers can observe
      /// this cell just like a normal computed cell.
      return true;
    });

    /// Display a dialog when the result completes.
    watch(() {
      /// Here we observe the result of the 'side effect', defined in the `effect`
      /// cell.
      ///
      /// The trick here is that `effect` throws an `UninitializedCellError`,
      /// until the `onPress` action is triggered, which prevents the
      /// remainder of this watch function from running when the side effect
      /// has not actually run.
      ///
      /// .whenReady() simply silences the exception notices that are printed
      /// to the console when an unhandled exception is thrown in a watch function.
      final result = effect.awaited.whenReady();

      /// Ensure that this widget is still mounted in the widget hierarchy
      if (context.mounted) {
        if (result) {
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: const Text('Success'),
                    content: const Text('The submission was successful.'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK')
                      )
                    ],
                  )
          );
        }
        else {
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: const Text('Submission Failed'),
                    content: const Text('Please try again.'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK')
                      )
                    ],
                  )
          );
        }
      }
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Effect Cells'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: [
                  const Text('This demonstrates handling button presses using effect cells.'),
                  const SizedBox(height: 5),
                  const Text('Pressing the button below will simulate a form submission request.'),
                  const SizedBox(height: 5),

                  /// Button which simulates a network request when pressed.
                  LiveElevatedButton(
                    /// `onPress` is the meta cell, which will be set to point
                    /// to an action cell that is triggered when the button is
                    /// pressed.
                    press: onPress,
                    child: const Text('Simulate Submit'),
                  )
                ],
              ),
            ),
          ),
        ),

        /// Observe the state of the 'effect'. If it is loading, display a
        /// loading indicator over the current screen.
        ///
        /// Note: This will only evaluate to true while the async result of the
        /// side effect is still pending, AFTER it has been triggered by the
        /// `onPress` action cell.
        if (!effect.isCompleted())
          Positioned.fill(
            child: Container(
              color: Colors.grey.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
      ],
    );
  }
}
