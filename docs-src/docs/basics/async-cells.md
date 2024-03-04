---
title: Asynchronous Cells
description: Handling asynchronous data using cells
sidebar_position: 10
---

# Asynchronous Cells

Live Cells provides a number of tools for handling data that is
fetched / computed asynchronously.

## Futures in Cells

A cell can hold and perform computations on a `Future`, which
represents an asynchronously computed value in Dart, just like any
other value. Thus, to perform a computation on asynchronous data,
simply define a computed cell with an `async` computation function and
use `await` to wait for the values in the argument cells to be
computed.

```dart title="Example of an asynchronous cell"
final n = MutableCell(Future.value(1));

final next = ValueCell.computed(() async => await n() + 1);
```

* `n` is a mutable cell holding a `Future`
* `next` is a computed cell that returns a `Future`, which applies a
  computation on the `Future` value held in `n`.

When a `Future` is assigned to the value of `n`, the value of `next`
is updated with the new `Future` held in `n`.

It's important to note that the values of asynchronous cells, which
remember are `Future`s, are updated synchronously as soon as a value
is assigned to a mutable cell. It's only the computations represented
by the `Future`s that are asynchronous. This is best explained by the
following example:

```dart
n.value = Future.delayed(Duration(seconds: 5), () => 2);
n.value = Future.value(3);

print(await next.value); // Prints 3
```

### Multiple Arguments

An asynchronous cell can reference multiple argument cells, however
the argument cells should all be referenced before the first `await`
expression. Argument cells that are only referenced after the first
`await` expression will not be observed by the computed cell.

Multiple asynchronous argument cells should either be referenced first
and then awaited, such as in the following example:

```dart title="An asynchronous computed cell with multiple arguments"
final arg1 = MutableCell(Future.value(0));
final arg2 = MutableCell(Future.value(1));

final sum = ValueCell.computed(() async {
    final a = arg1();
    final b = arg2();
    
    return (await a) + (await b);
});
```

Or awaited at once using the following:

```dart
final arg1 = MutableCell(Future.value(0));
final arg2 = MutableCell(Future.value(1));

final sum = ValueCell.computed(() async {
    final (a, b) = await (arg1(), arg2()).wait;
    
    return a + b;
});
```

:::danger

The following is wrong as it will result in `arg2` not being observed
by `sum`, since it is only referenced after the first `await`
expression:

```dart
final arg1 = MutableCell(Future.value(0));
final arg2 = MutableCell(Future.value(1));

final sum = ValueCell.computed(() async {
    final a = await arg1();
    
    // This wont be observed by `sum`
    final b = await arg2();
    
    return a + b;
});
```

:::

## Wait Cells

What we've seen till this point is cells taking in a `Future`, from
one or more argument cells, `await`ing the `Future`, applying a
computation on the value and producing another `Future`. However there
is no way for a cell to take in a `Future` from an argument cell,
`await` that `Future` and produce an immediate (non-future)
value. That's where *wait cells* come in.

A *wait cell* waits for a `Future`, held in another cell, to complete
before notifying its observers. Once the `Future` completes, the value
of the *wait cell* is updated to the completed value of the
`Future`. A wait cell is created from a cell holding a `Future` using
the `.wait` property:

```dart title="Using .wait cells"
final asyncN = MutableCell(Future.value(1));
final n = asyncN.wait;

final next = ValueCell.computed(() => n() + 1);
```

Notice in this definition of `next`, the computation function is not
an `async` function and the value of `n` is not `awaited`. Since
`wait` is a property it returns a keyed cell, like all properties
that return cells. This means the `n` variable above can be omitted
and the above example can be simplified to the following:


```dart
final n = MutableCell(Future.value(1));

final next = ValueCell.computed(() => n.wait() + 1);
```

:::note

`asyncN` has been renamed to `n`.

:::

When a value is assigned to `n`, the value of `next` is not updated
immediately. Instead it is only updated when the `Future` held in `n`
completes. That's the effect of the `n.wait` cell.

Until the `Future` awaited by a `.wait` cell completes, accessing the
cell's value will result in an `UninitializedCellError` exception
being thrown. Once the `Future` completes, it will retain its value
until the next `Future` completes.

For example accessing the value of `next` above before the first value
update of `n.wait`, will result in an `UninitializedCellError`
exception being thrown. This can be handled with `onError` to give an
initial value to a wait cell:

```dart
final waitN = n.wait.onError<UninitializedCellError>(0.cell);
print(waitN.value); // Prints: 0

final next = ValueCell.computed(() => waitN() + 1);
```

:::important

The `.wait` cell only *awaits* `Future`s when it has at least one
observer.

:::

### Order of Updates

The value of `.wait` is updated whenever a `Future` that is assigned
to the cell completes. The value updates are delivered in the same
order as the `Future`s are assigned to the cell, and not the order in
which the `Future`s actually complete. This means that if a `Future`
**a** is assigned to a cell followed by a `Future` **b**, the value of
the `.wait` cell is always first set to the completed value of **a**
and then the completed value of **b**, even if **b** completes before
**a**.

For example with the following:

```dart title="Ordering of .wait cell updates"
final n = MutableCell(Future.value(1));

ValueCell.watch(() => print('${n.wait()}'));

// This future completes after 30 seconds
n.value = Future.delayed(Duration(seconds: 30), () => 2);

// This future completes before the previous future
// that was assigned to `n`
n.value = Future.value(3);
```

The following will be printed to the console:

```
1
2
3
```

The second and third lines will both be printed after the second
`Future` that was assigned to `n` completes, which is after a delay of
30 seconds. If the updates were delivered in the order of completion,
`3` would have been printed to the console before `2`.

:::caution

If a `Future` that never completes is assigned to a cell, the value of
the `.wait` cell will never be updated again. If there's a chance of
that happening, add a *timeout* on the `Future` before assigning it to
a cell or use `.waitLast`, more on this later.

:::

### Multiple Arguments

The correct way to reference multiple wait cells in a computed cell is
using the `.wait` property on a record holding all the argument cells:

```dart title="Multiple argument wait cells"
final arg1 = MutableCell(Future.value(1));
final arg2 = MutableCell(Future.value(2));

final sum = ValueCell.compute(() {
    final (a, b) = (arg1, arg2).wait();
    
    return a + b;
});
```

:::note

The function call syntax is used on `.wait` and not on `arg1` and
`arg2`. Also there is no `await`. This is intentional.

:::

The `.wait` property of the record `(arg1, arg2)` returns a cell that
holds a record of the completed values of the `Futures` held in cells
`arg1` and `arg2`. In the example above the elements of the record are
immediately assigned to the local variables `a` and `b`.

You might be asking why not just do this:

```dart
final arg1 = MutableCell(Future.value(1));
final arg2 = MutableCell(Future.value(2));

final sum = ValueCell.compute(() => arg1.wait() + arg2.wait());
```

There is an issue with this approach. If the `Future`s held in `arg1`
and `arg2` complete at different times (which they most certainly
will), the value of `sum` will be recomputed twice, once when the
first future completes, and again when the second future
completes. This is probably not what you want especially if the values
of `arg1` and `arg2` are set at the same time.

To demonstrate the difference, consider the following watch function:

```dart
ValueCell.watch(() {
    print('${sum()}');
});
```

And consider the following `Future`s assigned to `arg1` and `arg2` in a batch:

```dart
MutableCell.batch(() {
    arg1.value = Future.delayed(Duration(seconds: 5), () => 20);
    arg2.value = Future.delayed(Duration(seconds: 10), () => 30);
});
```

With the first (correct) definition of `sum` the following will be
printed to the console, by the watch function, after the values are
assigned to `arg1` and `arg2`:

```
50
```

This is probably what you expect.

With the first definition the following will be printed:

```
22
50
```

The first line is printed when the `Future` held in `arg1` completes
after five seconds. The second line is printed when the `Future` held
in `arg2` completes after ten seconds.

If this isn't an issue for your application logic then you can go
ahead and use the second definition.

:::caution

Avoid mixing `.wait` with cells holding immediate values:

```dart
final sum = ValueCell.computed(() => a.wait() + b());
```

The value of `a.wait` is only updated when the `Future` held in `a`
completes. Whilst not strictly wrong, this can lead to some surprising
behaviour if `a` and `b` both update their values at the same time.

The following is recommended instead:

```dart
final sum = ValueCell.computed(() async => await a() + b).wait;
```

:::

## Latest Futures Only

The `.waitLast` property is like `.wait` however with one important
difference. If the value of the cell is updated before the `Future`
that was previously held in the cell completes, the previous `Future`
is ignored and the value of `.waitLast` is not updated when it
completes.

```dart title="Example of .waitLast"

final n = MutableCell(Future.value(1));

ValueCell.watch(() {
    print('${n.waitLast()}');
});

n.value = Future.delayed(Duration(seconds: 30), () => 2);
n.value = Future.value(3);
n.value = Future.delayed(Duration(seconds: 10), () => 4);
```

The only value printed to the console is:

```
4
```

This is because it was the last value that was assigned to `n` and it
was assigned before any of the preceding `Future`s had a chance to
complete. Even when the second `Future` completes after thirty
seconds, the value of `n.waitLast` will not be updated to `2`.

This is useful in two scenarios:

* To "cancel" a `Future` that is taking too long to complete, by
  assigning a new `Future` to the cell.
* Debouncing (we'll see how to do this in the next section).

The `.awaited` cell is similar to `.waitLast`, however it does not
retain the completed value of the previous `Future`. If the current
`Future` has completed, the value of the `.awaited` cell is the
completed value of the `Future`. If the `Future` has not completed, an
`UninitializedCellError` exception is thrown when accessing the value
of `.awaited`.

:::tip

The `.initialValue(...)` method, on all cells can be used to handle
`UninitializedCellError`, by returning the value of another cell:

```dart
final f = Future.delayed(Duration(seconds: 10), 1)
    .cell
    .awaited
    .initialValue(0.cell);
    
// The value of f is `0` until its value is initialized,
// which happens when the Future completes.
print(f.value) // Prints: 0
```

:::

Here's an example demonstrating the difference between `.waitLast` and
`.awaited`:

```dart example="Difference between .waitLast and .awaited"
final f = MutableCell(Future.value(1));

final waitLast = f.waitLast.initialValue(0.cell);
final awaited = f.awaited.initialValue(0.cell);

ValueCell.watch(() {
    print('.waitLast: ${waitLast()}');
});

ValueCell.watch(() {
    print('.awaited: ${awaited()}');
});

await Future.delayed(Duration(seconds: 1));

```

This will result in the following values being printed to the console,
which is the initial value provided with `initialValue(0.cell)`:

```
.waitLast: 0
.awaited: 0
```

:::note

The exact order in which the lines are printed may vary, since they
are printed from different watch functions.

:::

When the initial future completes, the following is printed:

```
.waitLast: 1
.awaited: 1
```

So far the two are identical, however when a new `Future` is assigned
to `f`:

```dart
f.value = Future.value(2);
```

The following is printed immediately when setting `f.value`:

```dart
.awaited: 0
```

The value of `.awaited` is reset to the initial value, given with
`initialValue(0.cell)`, whereas the current value of `.waitLast` is
retained.

When the `Future` completes, the following is printed:

```dart
.awaited: 2
.waitLast: 2
```

## Checking if Complete

All cells holding a `Future` provide an `isCompleted` property which
returns a cell that is `true` when the `Future` is complete, and
`false` while it is still pending.

This allows other cells to check if, and be notified of, an
asynchronous operation has completed or whether its still in
progress.

```dart
final complete = Future.delayed(Duration(seconds: 10))
    .cell
    .isCompleted
    
ValueCell.watch(() {
    if (complete()) {
        print('Complete');
    }
    else {
        print('Loading...');
    }
});
```

Initially "Loading..." is printed to the console. When the `Future`
completes, after ten seconds, "Complete" is printed.

When the cell holding the `Future` is updated, the value of
`isCompleted` is also updated to reflect the state of the new
`Future`.

## Delays and Debouncing

Live Cells provides a `delayed(...)` method on cells. This method
returns a cell that holds a `Future` that completes with the same
value as the value of the cell, on which `delayed` was called, but
after a given delay.

```dart title="Example of .delayed(...)"
final n = MutableCell(0);

ValueCell.watch(() {
    final value = n.delayed(Duration(seconds: 3)).wait;
    print('$value');
});

n.value = 1;
n.value = 2;
n.value = 3;
```

This will result in the following being printed to the console after a delay of three seconds:

```
1
2
3
```

:::important

The delay is from the time the value is assigned to the cell, and not
since the last time the `delayed` cell was updated. This means that in
the above example all three values are printed at once, since they are
assigned to the cell at approximately the same time.

:::

:::tip

`delayed(...)` returns a keyed cell which is why we were able to use
it directly in the watch function without assigning the returned cell
to a local variable first.

:::

When `delayed(...)` is used with `.waitLast`, the result is
effectively a *debouncing* of the cell's value. Debouncing is a
technique for preventing a task, in this case updating the value of a
cell, from running too frequently. This is especially useful for
implementing a "search as you type" functionality.

We can demonstrate the effect of `delayed(...)` followed by `waitLast`
with the following widget:


```dart
CellWidget.builder((_) {
  final content = MutableCell('');
  final debounced = content
      .delayed(Duration(seconds: 3)
      .waitLast
      .initialValue(''.cell);
    
  return Column(
    children: [
      CellTextField(
        content: content
      ),
      Text('You wrote:'),
      CellText(
        data: debounced
      )
    ]
  );
});
```

In this example, we've bound a cell to the content of a
`CellTextField`. We've *debounced* the cell with
`delayed(...).waitLast` and bound the debounced cell to the data of a
`CellText`. Whatever you write in the text field is echoed in the
`CellText` below it but only after a three second delay after you
stop typing.

Practically, to implement a search as you type functionality, you'd
reference the `debounced` cell in an asynchronous computed cell which
loads the search results from a backend server:

```dart
final search = MutableCell('');
final debounced = search
    .delayed(Duration(seconds: 3))
    .waitLast;
    
final results = ValueCell.computed(() async {
    // A hypothetical searchItems function which
    // performs the HTTP request
    return await searchItems(debounced());
});
```

This would be used with a UI definition similar to the following:

```dart
Column(
  children: [
    // A text field for the search term
    CellTextField(content: search),
    
    // Display results
    CellWidget.builder((_) {
      items = results.waitLast
            .initialValue([].cell);
            
      Column(
        children: items()
            .map((e) => ItemWidget(e))
            .toList()
      );
    });
  ]
);
```
