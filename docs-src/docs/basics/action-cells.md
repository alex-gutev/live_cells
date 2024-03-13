---
title: Action Cells
description: Representing actions and events using cells
sidebar_position: 11
---

# Action Cells

An action cell is a cell that does not hold a value. In-fact, the cell
type of an action cell is `ValueCell<void>`. The purpose of an action
cell is to notify its observers when an event, such as a button press,
has taken place.

Action cells are created using the `ActionCell` constructor, and the
observers of the cell are notified with the `.trigger()` method.

```dart
final action = ActionCell();

ValueCell.watch(() {
    action();
    print('Action triggered');
});

// Prints: Action triggered
action.trigger();
```

Notice that the action cell is observed, in the watch function, just
like a regular cell. The only difference is that calling the cell does
not actually return a value, since the value type of the cell is
`void`.

To allow observing an `ActionCell` but disallow triggering it, using
the `trigger` method, it should be cast to `ValueCell<void>`:


```dart
class MyControllerClass {
    // This cell can be triggered with `_myAction.trigger()`.
    final _myAction = ActionCell();
    
    // This cell can be observed but not triggered.
    ValueCell<void> get myAction => _myAction.
}
```

## Triggering Actions

Besides being used to notify of events, action cells can be used to
trigger operations. An example is retrying a failed network request.

For example consider an asynchronous cell which performs a network
request:

```dart
import 'package:dio/dio.dart';

final dio = Dio();

final countries = ValueCell.computed(() async {
    final response = 
        await dio.get('https://api.sampleapis.com/countries/countries');
        
    return response.data;
});
```

:::note

This example uses the [dio](https://pub.dev/packages/dio) package for
HTTP requests.

:::

As the cell is defined in the example above, there is no way to retry
the network request if it fails for some reason e.g. the Internet
connection is down, the server is down, the request times
out. Observers of the cell will observe the error and can handle it by
displaying an error notice, but there is no way to offer a retry
functionality to the user.

This is where `ActionCell`s come in handy. All we need to do to add
retry functionality is to define an `ActionCell`, which will serve to
trigger the retrying of the request, and observe it in our cell defined
above.

```dart
final retry = ActionCell();

final countries = ValueCell.computed(() async {
    // Observe the retry cell.
    retry();
    
    final response = 
        await dio.get('https://api.sampleapis.com/countries/countries');
        
    return response.data;
});
```

We've observed the *retry action cell* at the start of the cell
computation function. To retry the network request all we need to do
is trigger the retry cell with:

```dart
retry.trigger();
```

This will cause the compute value function of the `countries` cell to
be run again, because `retry` is observed by `countries`.

:::tip

`ActionCell`s can be defined in the build method/function of a
`CellWidget` just like any other cell.

:::

## Practical Example

This is very handy for implementing a reusable error handling widget
that displays the child widget, which displays the result of the
request, if the request was successful or an error notice with a
button to retry the request if it failed.

To achieve this we'll need to define a widget that takes a `child`
widget as a cell, and an `ActionCell` for retrying the action.

```dart title="Reusable error handling widget"
class ErrorHandler extends CellWidget {
  final ValueCell<Widget> child;
  final ActionCell retry;
    
  const ErrorHandler({
    super.key,
    required this.child,
    required this.retry
  });
    
    
  @override
  Widget build(BuildContext context) {
    try {
      return child();
    } catch (e) {
      return Column(
        children: [
          const Text('Something went wrong!'),
          ElevatedButton(
            onPressed: retry.trigger,
            child: const Text('Retry')
          )
        ]
      );
    }
  }
}
```

A couple of things to note from this definition:

* The `child` widget is provided as a cell rather than a widget to allow
  us to handle errors using `try` and `catch`.
* The value of `child` is referenced inside a `try` block, and
  returned if the child widget is created successfully.
* If an error occurred while computing the `child` widget, an error
  notice with a retry button is displayed.
* The `onPressed` handler of the retry button calls `retry.trigger()`
  which triggers the retry action.

Before we update the definition of the `countries` cell let's define a
simple data model:

```dart
class Country {
  /// Name of the country
  final String name;

  const Country({
    required this.name
  });

  Country.fromJson(Map<String, dynamic> json) :
        name = json['name'];
}
```

This defines a model `Country` with a single field `name`, and a
constructor for creating instances of the model from JSON.

Let's place the definition of the `countries` cell inside a function
that creates the cell using a given retry cell:

```dart
FutureCell<List<Country>> countries(ValueCell<void> onRetry) => 
    ValueCell.computed(() async {
        // Observe the retry cell.
        onRetry();
    
        final response = 
            await dio.get('https://api.sampleapis.com/countries/countries');
      
      
        final results = response.data as List;
        return results.map((e) => Country.fromJson(e)).toList();
    });
```

:::tip

`FutureCell` is a shorthand for a `ValueCell` that holds a `Future`,
e.g. `FutureCell<List>` is equivalent to `ValueCell<Future<List>>`.

:::

:::note

This definition of the countries cell returns a list of `Country`s,
whereas the previous definition returns the raw parsed JSON response.

:::

The `ErrorHandler` widget can now be used as follows

```dart
class Countries extends CellWidget {
  static final _initalData = <Country>[];
  
  @override
  Widget build(BuildContext context) {
    final retry = ActionCell();
    final results = countries(retry);
  
    return ErrorHandler(
      retry: retry,
      child: ValueCell.computed(() {
        final data = results.awaited
            .initialValue(_initialData.cell);
      
        final countries = data();
      
        return ListView.builder(
            itemCount: countries.length,

            itemBuilder: (_, index) => Text(
              countries[index].name,
              textAlign: TextAlign.center,
            )
        );
      })
    );
  }
}
```

Some points to note from this example:

* The same retry action cell is passed to the *countries* cell and the
  `ErrorHandler` widget. This allows the widget to directly trigger
  the retry action.
  
* The child widget is defined in a computed cell, which awaits the
  `Future` held in the *countries* cell using `.awaited`.
  
* `.initialValue(_initialData)` is used so that the cell evaluates to the
  empty list while the response is still pending, rather than throwing
  an `UninitializedCellError`.
  
Notice we've successfuly decoupled the data loading, presentation and
error handling steps from each other and factored them out into three
reusable components:

1. The *countries* cell, which is only concerned with performing the
   HTTP request that loads the data, and doesn't care how that data is
   presented, how errors are handled nor how the operation is retried.
   
2. The `child` widget, which is only concerned with presenting the data to
   the user when the request is successful, and not handling errors.
   
3. The `ErrorHandler` widget, which is agnostic to how the data is
   loaded and presented, but is only concerned with handling errors.
  

And note we were able to achieve all of this reusability and
separation of concerns without a mess of callbacks and *controller*
objects.

We've glossed over styling and UI design in these examples, since
that's beyond the scope of this library, but we can make this example
more user friendly by providing a loading indication while the data is
loading, rather than showing an empty list. We can do this easily
using, the `.isCompleted` property of cells holding a `Future`, and
the [skeletonizer](https://pub.dev/packages/skeletonizer) package.

To do that we'll first update `_initialData` to a list of five
*placeholder* items. These wont be displayed but are required by
*skeletonizer* to display a shimmer effect:

```dart
static final _initialData = 
    List.filled(5, const Country(name: 'placeholder'));
```

Finally the `child` widget is wrapped in a `Skeletonizer` widget that
draws its child elements using a Shimmer effect when `.isCompleted()` is
false, that is while the data is still loading:

```dart title="Displaying a loading indication"
ValueCell.computed(() {
  final data = results.awaited
    .initialValue(_initialData.cell);
      
  final countries = data();
      
  return Skeletonizer(
    enabled: !results.isCompleted()
    child: ListView.builder(
        itemCount: countries.length,

        itemBuilder: (_, index) => Text(
          countries[index].name,
          textAlign: TextAlign.center,
        )
    )
  );
})
```

A summary of the changes:

* The child widget is wrapped in a `Skeletonizer`, from the
  [skeletonizer](https://pub.dev/packages/skeletonizer) package, that
  displays its children using a shimmer effect while it is enabled.

* The `Skeletonizer` is only enabled when `isCompleted()` is
  false,that is when the response is still pending.
  
* The initial data is now set to a list containing five *dummy*
  items. These items aren't actually displayed but are required by
  `Skeletonizer` to display a shimmer effect.

:::caution

When using `initialValue` directly within a `build` method or a
`ValueCell.computed`, the value passed to `initialValue` must
implement `==` and `hashCode`, such that different objects
representing the same value compare equal under `==`. If that's not
the case, then the initial value should be stored in a `static`
`final` variable on the class defining the widget, as was done in this
example.

:::
