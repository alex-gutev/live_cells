import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_cells/live_cells.dart';

import 'package:dio/dio.dart';
import 'package:skeletonizer/skeletonizer.dart';

final dio = Dio();

/// Country model object
class Country {
  /// Name of the country
  final String name;

  const Country({
    required this.name
  });

  const Country.blank({
    this.name = 'placeholder'
  });

  Country.fromJson(Map<String, dynamic> json) :
        name = json['name'];
}

/// Demonstrates network requests and action cells using live_cell_widgets and live_cell_extension.
class ActionCellDemo1 extends CellWidget {
  // Placeholder data to display while loading for "shimmer" effect
  //
  // NOTE: Since lists do not compare == if they are different objects, this
  // is placed in a static final variable to ensure the same list is always
  // passed to initialValue.
  static final _initialData = List.filled(5, const Country.blank());

  /// Cell that retrieves the list of countries.
  ///
  /// The returned cell observes [onRetry]. Therefore, triggering [onRetry]
  /// will result in the list of countries being reloaded.
  FutureCell<List<Country>> countries(ValueCell<void> onRetry) =>
      ValueCell.computed(() async {
        // Observe the retry cell.
        onRetry();

        final response =
        await dio.get('https://api.sampleapis.com/countries/countries');

        final results = response.data as List;

        return results.map((e) => Country.fromJson(e)).toList();
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
        child: ErrorHandler(
            retry: retry,

            // NOTE: child is a cell so that errors thrown within it are
            // captured and handled by the [ErrorHandler] widget.
            child: ValueCell.computed(() {
              // Await future list. Use [_initialData] while loading.
              final data = results.awaited
                  .initialValue(_initialData.cell);

              // NOTE: if an error occurred while loading the data,
              // timeout, server not found, etc. `data.length()` will
              // rethrow the exception at this point. The
              // exception is then handled by [ErrorHandler].
              final countries = data();

              return Column(
                children: [
                  ElevatedButton(
                      onPressed: results.isCompleted() ? retry.trigger : null,
                      child: const Text('Reload')
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Skeletonizer(
                      // Enable shimmer effect only when result is pending.
                      enabled: !results.isCompleted(),
                      child: ListView.builder(
                        // Display loaded data.
                        itemCount: countries.length,

                        itemBuilder: (_, index) => Text(
                          countries[index].name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })
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