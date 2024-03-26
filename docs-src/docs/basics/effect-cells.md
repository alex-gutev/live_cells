---
title: Effect Cells
description: Observing the result of side effects using cells
sidebar_position: 13
---

# Effect Cells

An *effect cell* is a cell that performs a side effect and allows the
result/status of the effect to be observed by observing a cell.

An effect cell is tied to an [action cell](action-cells). This means
that the side effect, which is defined in the value computation
function of the effect cell, only runs when the action cell is
triggered, and only once per trigger.

Effect cells are created using the
[`.effect`](https://pub.dev/documentation/live_cells/latest/live_cells/ActionCellEffectExtension/effect.html)
method provided by action cells (`ValueCell<void>`). The side effect
is defined in the function provided to `effect`.

```dart title="Creating an effect cell"
final ValueCell<void> action;

...

final effect = action.effect(() {
    // A hypothetical form submission
    return submitForm();
});
```

In the example above, an effect cell (`effect`) is created that is
tied to an `action` cell. The side effect, defined by `effect` is a
form submission effected by the (hypothetical) `submitForm()`
function. The `submitForm` function is run whenever `action` is
triggered. Notice the value of `submitForm()` is returned in the
effect function. This becomes the value of the effect cell which
allows us to observe the result/status of the effect by observing the
`effect` cell.

This is different from `ValueCell.watch` in the following ways:

* The result of the side effect can be observed by observing the
  effect cell `effect`, in this case. This is useful for displaying a
  loading indicator while the side effect is in progress.
* The side effect function is only run when the action cell is
  triggered, whereas `ValueCell.watch` is run once initially when it
  is defined in order to discover its dependencies.

The difference between an effect cell and a regular computed cell is
that the effect cell guarantees that the compute value function will
only be run once per trigger of the action to which it is tied. On the
other hand a computed cells is intended to be used with a pure function
that computes a value, and thus makes no guarantees about how many times
its compute function is called.

:::important

An effect cell has to be observed, and its value referenced, in order
for the side effect to be run. If the action cell is triggered, but
the effect cell has no observers, the side effect is not run.

:::

## Observing Side Effects

As mentioned earlier, effect cells are useful for observing the
result/status of a side effect. In the following examples, we'll
define an effect cell that simulates a form submission, and observe it
to display a loading indicator while the submission is ongoing.

First let's define a widget, with an action cell that is triggered by
a button.

```dart
class Example extends CellWidget with CellHooks {
  @override
  Widget build(BuildContext context) {
    final submit = ActionCell();
    
    return ElevatedButton(
      onPressed: submit.trigger
      child: Text('Submit')
    );
  }
}
```
:::note

We've included the
[`CellHooks`](https://pub.dev/documentation/live_cells/latest/live_cells/CellHooks-mixin.html)
mixin since we'll be using the
[`watch`](https://pub.dev/documentation/live_cells/latest/live_cells/CellHooks/watch.html)
method.

:::

Now let's define the effect that is run when the `submit` action cell
is triggered, which happens when the button is pressed.

```dart
Widget build(BuildContext context) {
  final submit = ActionCell();
    
  final submission = submit.effect(() async {
    return await Future.delayed(Duration(seconds: 3), () => true);
  });
    
  ...
}
```

We've used `Future.delayed` to simulate a network request, with
`true`, indicating success, returned after three seconds. In a real
application, you would substitute `Future.delayed` with an actual
HTTP request.

There are two things we want to achieve:

1. Display a loading indicator while the submission is in progress.
2. Display a dialog with a message indicating whether the request
   succeeded or failed.

### Loading Indicator

To display the loading indicator we can simply observe the
`submission` effect cell, and use `isComplete`, from [Asynchronous
Cells](async-cells#checking-if-complete), to conditionally display the
indicator.

```dart
Widget build(BuildContext context) {
  ...
  
  final isLoading = !submission.isComplete();
  
  return ElevatedButton(
    onPressed: isLoading ? null : submit.trigger
    child: isLoading ? CircularProgressIndicator() : Text('Submit')
  );
}
```

When `submission.isComplete()` is false, a progress indicator is
displayed in the button and the `onPressed` callback is `null`, which
disables the button while the submission is in progress.

When the `submission` effect cell is accessed before the effect has
run for the first time, an `UninitializedCellError` exception is
thrown. In this case `submission.isComplete()` is true since the value
of `submission` is not a `Future` that is pending, therefore the
progress indicator is not shown until the button is pressed.

Pressing the button results in the progress indicator being shown
until the `Future` held in `submission` completes, which in this
"simulated" example happens after three seconds.

### Performing Actions

To show the dialog we can observe the `submission` effect cell in a
cell watch function:

```dart
Widget build(BuildContext context) {
  final submission = ...;
    
  watch(() {
    final result = effect.awaited();
    
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(result 
              ? 'Success' 
              : 'Error'
          ),
          content: Text(result
              ? 'The submission was successful'
              : 'Please try again'
          ),
          
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK')
            )
          ]
        )
      );
    }
  });
}
```

:::note

We've used the `watch` method provided by `CellHooks` rather than
`ValueCell.watch` since watch functions defined using the former are
registered once during the first build and automatically stopped when
the widget is unmounted.

:::

A watch function is defined that observes the result of the side
effect using `submission.awaited`. The watch function, which displays
a dialog showing the status of the submission, is only run when the
`submit` action cell is triggered and the `Future` held in
`submission` is completed. This is because `submission.awaited` throws
an exception until the effect is run and the `Future`, returned by the
effect function, has completed. The exception prevents the remainder
of the function from being run.

Success is indicated by a return value of `true` in the effect
function and failure by a return value of `false`. The value returned
by the `submission` effect is checked inside the watch function to
choose which dialog to display.

You'll notice a number of unhandled exception notices being printed to
the console when running in debug mode. These are expected because
`submission.awaited` throws an exception until it has a result, and
these are not handled inside the watch function. To silence the
`UninitializedCellError` and `PendingAsyncValueError` exceptions, use
`.whenReady`. This has the same effect of terminating the watch
function, but prevents unhandled `UninitializedCellError` and
`PendingAsyncValueError` exception notices from being printed to the
console.

```dart title="Silencing unhandled exception notices with .whenReady"
watch(() {
  final result = effect.awaited.whenReady();
    
  if (context.mounted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result 
            ? 'Success' 
            : 'Error'
        ),
        content: Text(result
            ? 'The submission was successful'
            : 'Please try again'
        ),
        
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK')
          )
        ]
      )
    );
  }
});
```

## Observing Cells in Effect Cells

The value of another cell can be referenced inside an effect cell
function using the same function call syntax used within
`ValueCell.computed`. However, the difference is that changes in the
value of the referenced cell will not cause the effect function to be
run again. The effect function is only run when the action cell, to
which it is tied to, is triggered.

Let's add some data to the submission. We'll add a switch, which when
it is on the submission succeeds and when it is off the submission
fails. We'll use `CellSwitch` to bind the state of the switch directly
to a cell.

```dart
Widget build(BuildContext context) {
  final submit = ActionCell();

  final succeed = MutableCell(true);

  final submission = submit.effect(() async {
    final result = succeed();
    
    return await Future.delayed(Duration(seconds: 3), () => result);
  });

  ...
  
  return Column(
    children: [
      CellSwitch(
          value: succeed,
          enabled: submission.isComplete;
      ),
      ElevatedButton(
          onPressed: isLoading ? null : submit.trigger
          child: isLoading 
             ? CircularProgressIndicator() 
             : Text('Submit')
      )
    ]
  );
}
```

Toggling the switch will now change the result of the `submission`
cell, though as mentioned earlier the side effect defined by the
`submission` cell is only run when the button is
pressed. Additionally, `submission.isComplete` is bound to the
`enabled` property of the `CellSwitch`. As a result, the switch is
disabled while the submission is still in progress.

## Cell Buttons

So far we've used a callback function to handle the button press
events, which does nothing other than trigger an action cell. This
library provides a
[`CellElevatedButton`](https://pub.dev/documentation/live_cells/latest/live_cell_widgets/CellElevatedButton-class.html)
which allows you to directly specify an action cell that is triggered
by button press events without having to provide a callback.

`CellElevatedButton` takes a `press` argument rather than an
`onPressed` argument, which takes a `MetaCell<void>` rather than a
callback. When the button is constructed an action cell is injected
into the meta cell passed to `press` and is triggered whenever the
button is pressed.

:::note

The action button takes a `MetaCell` rather than an `ActionCell` since
triggering the action outside the button will not result in any
changes to the button. This is different from `CellSwitch` which takes
a `MutableCell`. When the cell is set from outside the switch, the
state of the switch changes.

:::

To replace `ElevatedButton` with `CellElevatedButton` we first have to
change the definition of `submit` to the following:

```dart
final submit = MetaCell<void>();
...
CellElevatedButton(
    press: submit,
    enabled: submission.isComplete,
    child: isLoading 
        ? CircularProgressIndicator().cell
        : Text('Submit').cell
)
```

Note, the `submit` cell is passed to the `press` argument of
`CellElevatedButton`. This button also takes an `enabled` argument,
unlike `ElevatedButton`, for which we've supplied
`submission.isComplete`. As a result the button is enabled before the
effect has run and after it has completed, but is disabled while the
result is still pending.

:::tip

`CellElevatedButton` also accepts meta cells for `longPress`,
`onHover` and `onFocusChange` for handling long press, hover and focus
change events.

:::

## Code Organization

So far not much thought has been given to the organization of our
code. Instead we've directly placed all the cell definitions in the
`build` method of the widget. For this simple example its not an issue
but for larger applications its best to separate the cell definitions
from the UI.

A recommended approach for achieving separation of concerns is to use
cell factory functions. This is a fancy term for a function which
creates a cell. For example, the `submit` action cell and `submission`
effect cell can be defined in a factory function:

```dart title="Cell Factory Function"
final (ActionCell, ValueCell<bool>) submissionCells(ValueCell<bool> succeed) {
  final submit = ActionCell();

  final submission = submit.effect(() async {
    final result = succeed();
    
    return await Future.delayed(Duration(seconds: 3), () => result);
  });
  
  return (submit, submission);
}
```

The `submissionCells` function creates the `submit` and `submission`
cells and returns them in a record containing the action cell in the
first element, and the effect cell in the second element. The factory
function can then be used in the widget build method as follows:

```dart
@override
Widget build(BuildContext context) {
  final succeed = MutableCell(true);
  
  final (submit, submission) = submissionCells(succeed);
  
  ...
}
```

The significance of this is that the code defining the cells is now
moved out of the widget body, and can be reused throughout the app.

For more than two related cells, it is better to opt for a more
structured return type such as class that holds all the related cells:

```dart
@immutable
class Submission {
  final ActionCell action;
  final ValueCell<bool> result;
    
  factory Submission(ValueCell<bool> succeed) {
    final submit = ActionCell();

    final submission = submit.effect(() async {
      final result = succeed();
    
      return await Future.delayed(Duration(seconds: 3), () => result);
    });
  
    return Submission._internal(
      action: submit,
      result: submission
    );
  }
    
  const Submission._internal({
    this.action,
    this.result
  });
}
```

:::note

The `@immutable` annotation is not required but is recommended so that
a warning is emitted if you end up storing state directly in the
`Submission` class rather than inside the cells.

:::

This class can then be used in the build method as follows:

```dart
@override
Widget build(BuildContext context) {
  final succeed = MutableCell(true);
  final submission = Submission(succeed);
  ...
}
```

## Why use Effect Cells?

You may be wondering what's the value in using effect cells, when you
can achieve the same result without them? The main benefit of using an
effect cell is that the result / status of the effect, in this case a
(simulated) form submission, can be observed just like any cell. It
can be used in a computed cell / watch function or bound to a widget
property. The alternative would be to manually synchronize the state
of the side effect with the state of your widgets.

For example you would need to do something similar to the following:

```dart
final isLoading = MutableCell(false);

ElevatedButton(
    onPressed isLoading() ? null : () async {
        isLoading.value = true;
        await submitForm();
        isLoading.value = false;
    }
    
    child: isLoading()
      ? CircularProgressIndicator()
      : Text('Submit')
);
```

This leaves room for bugs. If, for example, `submitForm()` throws an
exception, `isLoading` will not be reset to false, which means your UI
will now be stuck in the loading state and your user will not be able
to retry the request. Using effect cells helps to eliminate bugs such
as these, which are caused when the state of your UI is not properly
synchronized with the state of the side effect.

Of course this doesn't mean you should rush to use effect cells
everywhere. If effect cells don't make sense for your specific case,
then don't use them.
