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
method provided by action cells (`ValueCell<void>`), with the side
effect defined in the function provided to `effect`.

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
triggered. Notice that the value of `submitForm()` is returned in the
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
that the effect cell guarantees that the effect defined in the value
computation function will only be run once per trigger of the action
to which it is tied. On the other hand a computed cell is intended to
be used with a pure function that computes a value but has no side
effect, and thus makes no guarantees about how many times its compute
function is called.

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
class Example extends CellWidget {
  @override
  Widget build(BuildContext context) {
    final submit = ActionCell();
    
    return LiveFilledButton(
      press: submit
      child: Text('Submit')
    );
  }
}
```

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
  
  return LiveFilledButton(
    press: submit,
    enabled: submission.isComplete,
    child: isLoading ? CircularProgressIndicator() : Text('Submit')
  );
}
```

:::note

`LiveFilledButton` accepts an `enabled` argument, which takes a
boolean cell that controls whether the button is enabled or disabled.

:::

When `submission.isComplete()` is false, a progress indicator is
displayed in the button and the button is disabled.

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
watch function:

```dart
Widget build(BuildContext context) {
  final submission = ...;
    
  ValueCell.watch(() {
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
  
  ...
}
```

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
[`.whenReady`](https://pub.dev/documentation/live_cells/latest/live_cells/ErrorCellExtension/whenReady.html). This
has the same effect of terminating the watch function, but prevents
unhandled `UninitializedCellError` and `PendingAsyncValueError`
exception notices from being printed to the console.

```dart title="Silencing unhandled exception notices with .whenReady"
ValueCell.watch(() {
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
on, the submission succeeds and when it is off the submission
fails. We'll use `LiveSwitch` to bind the state of the switch directly
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
      LiveSwitch(
          value: succeed,
          enabled: submission.isComplete;
      ),
      LiveFilledButton(
          press: submit,
          enabled: submission.isComplete,
          child: isLoading ? CircularProgressIndicator() : Text('Submit')
      );
    ]
  );
}
```

Toggling the switch will now change the result of the `submission`
cell, though as mentioned earlier the side effect defined by the
`submission` cell is only run when the button is
pressed. Additionally, `submission.isComplete` is bound to the
`enabled` property of the `LiveSwitch`. As a result, the switch is
disabled while the submission is still in progress.

## Code Organization

So far not much thought has been given to the organization of our
code. Instead we've directly placed all the cell definitions in the
`build` method of the widget. For this simple example its not an issue
but for larger applications its best to separate the cell definitions
from the UI.

A recommended approach for achieving separation of concerns is to use
cell factory functions. This is a fancy term for a function which
creates a cell. For example, the `submission` effect cell can be
defined in a factory function that takes the action cell (`action`),
for triggering the effect, and the cell holding the result
(`succeed`):

```dart title="Cell Factory Function"
final FutureCell<bool> submissionCell({
    required ValueCell<void> action,
    required ValueCell<bool> succeed
}) => submit.effect(() async {
    final result = succeed();
    return await Future.delayed(Duration(seconds: 3), () => result);
});
```

The factory function can then be used in the widget build method as
follows:

```dart
@override
Widget build(BuildContext context) {
  final submit = ActionCell();
  final succeed = MutableCell(true);
  
  final submission = submissionCell(
    action: submit,
    succeed: succeed
  );
  
  ...
}
```

The significance of this is that the code defining the cells is now
moved out of the widget body, and can be reused throughout the app.

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

FilledButton(
    onPressed: isLoading() ? null : () async {
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
