import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

import 'package:dio/dio.dart';
import 'package:skeletonizer/skeletonizer.dart';

final dio = Dio();

/// Demonstrates network requests and action cells.
class ActionCellDemo extends CellWidget {
  // Placeholder data to display while loading for "shimmer" effect
  //
  // NOTE: Since lists do not compare == if they are different objects, this
  // is placed in a static final variable to ensure the same list is always
  // passed to initialValue.
  static final _initialData = List.filled(5, { 'name': 'Placeholder' });

  /// Cell that retrieves the list of countries.
  ///
  /// The returned cell observers [onRetry] therefore triggering [onRetry],
  /// will result in the list of countries being reloaded.
  FutureCell<List> countries(ValueCell<void> onRetry) =>
      ValueCell.computed(() async {
        // Observe the retry cell.
        onRetry();

        final response =
        await dio.get('https://api.sampleapis.com/countries/countries');

        return response.data;
      });

  @override
  Widget build(BuildContext context) {
    final retry = ActionCell();
    final results = countries(retry);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Cells'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Use ErrorHandler to handle errors thrown while creating [child].
              ErrorHandler(
                  retry: retry,

                  // NOTE: child is a cell so that errors thrown within it are
                  // captured and handled by the [ErrorHandler] widget.
                  child: ValueCell.computed(() {
                    // Await future list. Use [_initialData] while loading.
                    final data = results.awaited
                        .initialValue(_initialData.cell);

                    return Skeletonizer(
                      // Enable shimmer effect only when result is pending.
                      enabled: !results.isCompleted(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: (([
                            // Display loaded data.
                            //
                            // NOTE: if an error occurred while loading the data,
                            // timeout, server not found, etc. `data()` will
                            // rethrow the exception at this point. The
                            // exception is then handled by [ErrorHandler].
                            for (final country in data())
                              Text(
                                '${country['name']}',
                                textAlign: TextAlign.center,
                              )
                          ]))
                      ),
                    );
                  })
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays errors during the creation of [child] to the user, with a retry button.
class ErrorHandler extends CellWidget {
  /// Child widget to display
  final ValueCell<Widget> child;

  /// Action cell to trigger when the retry button is displayed
  final ActionCell retry;

  const ErrorHandler({
    super.key,
    required this.child,
    required this.retry
  });


  @override
  Widget build(BuildContext context) {
    try {
      // Return the child widget if successful
      return child();
    }
    catch (e) {
      // Return an error message with a retry button if the child widget cell
      // returned an error.
      return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Something went wrong!'),
              ElevatedButton(
                  // Trigger the retry action cell when pressed
                  onPressed: retry.trigger,
                  child: const Text('Retry')
              )
            ]
        ),
      );
    }
  }
}