---
title: User Defined Types
description: Extending cells with accessors for your own classes
sidebar_position: 8
---

# User Defined Types

So far we've used cells holding strings and numbers, and an
`enum`. What about types defined by your own classes? A cell can
generally hold a value of any type. This section goes over the tools
to make working with user defined types more convenient.

## Live Cell Extension

The
[`live_cell_extension`](https://pub.dev/packages/live_cell_extension)
package provides a source code generator that allows you to extend the
core cell interfaces, `ValueCell` and `MutableCell`, with accessors
for properties of your own classes.

To understand what this means, consider the following class:

```dart title="Person class"
class Person {
    final String firstName;
    final String lastName;
    final int age;
    
    const Person({
        required this.firstName,
        required this.lastName,
        required this.age
    });
}
```

Let's say you have a cell holding a `Person`:

```dart title="Person cell"
final person = MutableCell(
    Person(
        firstName: 'John',
        lastName: 'Smith',
        age: 25
    )
);
```

To access a property of the `Person` held in the cell, you will need
to defined a computed cell:

```dart title="Accessing properties in cells"
final firstName = ValueCell.computed(() => person().firstName);
```

If you want the `firstName` cell to be settable, so that setting the
value of `firstName` updates the `person` cell, you'll need to define
a `copyWith` method and a mutable computed cell:


```dart title="Mutating properties in cells"
final firstName = MutableCell.computed(() => person().firstName, (name) {
    person.value = person.value.copyWith(
        firstName: name
    );
});
```

This is the definition of boilerplate and will quickly become tiring.

The `live_cell_extension` package automatically generates this code
for you, so that instead of the above, you can write the following:

```dart title="Generated ValueCell property accessors"
final firstName = person.firstName;
```

And to update the value of the `firstName` property:

```dart title="Generated MutableCell property accessors"
person.firstName.value = 'Jane';
```

That's it, no need to write a `copyWith` method either. This ties in
with Live Cell's design principle that cells should be
indistinguishable, as much as is possible, from the values they hold.

### Generating the Code

To make this work you'll need to add the `live_cell_extension` package
to the `dev_dependencies` of your `pubspec.yaml`:

```yaml
dev_dependencies:
    live_cell_extension: 0.6.1
    ...
```

Then annotate the classes, for which you want accessors to be
generated, with `CellExtension`. If you want mutable cell accessors to
also be generated, add `mutable: true` to the annotation arguments.

```dart title="person.dart"
part 'person.g.dart';

@CellExtension(mutable: true)
class Person {
    final String firstName;
    final String lastName;
    final int age;
    
    const Person({
        required this.firstName,
        required this.lastName,
        required this.age
    });
}
```

:::caution
Don't forget to include the `<filename>.g.dart` file. This is where
the code will be generated.
:::

Next you'll need to run the following command in the root directory of
your project:

```sh
dart run build_runner build
```

This will generate the `.g.dart` files, which contain the generated
class property accessors.

The `ValueCell` accessors are defined in an extension with the name of
the class followed by `CellExtension`. The `MutableCell` accessors are
defined in an extension with the name of the class followed by
`MutableCellExtension`.


## Binding to Properties

Using the generated property accessors, we can define a form for
populating the class properties simply by binding the property cells,
retrieved using the generated accessors, to the appropriate widgets.

```dart title="Binding directly to properties"
class PersonForm extends CellWidget {
    final MutableCell<Person> person;
    
    PersonForm(this.person);
    
    @override
    Widget build(BuildContext context) => Column(
    children: [
        Text('First Name:'),
        LiveTextField(
            content: person.firstName
        ),
        Text('Last Name:'),
        LiveTextField(
            content: person.lastName
        ),
        Text('Age:'),
        Numberfield(person.age)
    ]
)
```

We used the `Numberfield` widget, defined [earlier](error-handling), for the `age`
property.

:::info

We defined the form as a class because we intend to reuse it in other
widgets.

:::

We can then use this form as follows:

```dart
CellWidget.builder((_) {
  final person = MutableCell(
      Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
      )
  );
    
  return Column(
    children: [
      PersonForm(person),
      Text('${person.firstName()} ${person.lastName()}: ${person.age()} years'),
      ElevatedButton(
        child: Text('Save'),
        // A hypothetical savePerson function
        onPressed: () => savePerson(person.value)
      ),
      ElevatedButton(
        child: Text('Reset'),
        onPressed: () => person.value = Person(
          firstName: 'John',
          lastName: 'Smith',
          age: 25
        )
      )
    ]
  );
});
```

In this example we used the `personForm` widget defined earlier. 

* The details of the person are displayed in a `Text`, which is
  automatically updated when the person's details are changed.
* The "Save" button saves the entered details, which are held in the
  `person` cell.
* The "Reset" button resets the form fields to their defaults by
  directly assigning a default `Person` to the `person` cell.
  
The benefits of this, as opposed to using the tools already available
in Flutter, are:

* No need to write event handlers and state synchronization code for
  acquiring input from the user. This is all handled automatically.
* You can focus directly on the representation of your data and think
  in terms of your data, rather than thinking in terms of widget `State`.
* Your widgets are bound directly to your data and kept in sync. There
  is no chance of you accidentally forgetting to synchronize them with
  your data and vice versa, which eliminates a whole class of bugs.

## Equality

It is a good practice to define the `==` and `hashCode` methods on
classes which will be used as cell value types. In-fact there are two
situations, in which defining `==` and `hashCode` is essential:

1. When a constant cell holding an instance of the class is created:

   ```dart
   final person = Person(...).cell;
   ```
  
   If `Person` does not override `==` and `hashCode`, each call to
   `Person(...).cell` will create a new cell even if the same values
   are given for the `firstName`, `lastName` and `age` properties.
  
2. When `changesOnly: true` is given to a cell holding an instance of the class:

   ```dart
   final person = ValueCell.computed(() => Person(
       firstName: firstName(),
       lastName: lastName(),
       age: age()
   ), changesOnly: true)
   ```
   
   If `Person` does not override `==` and `hashCode`, the
   `changesOnly` keyword has no effect, since every time the cell is
   recomputed, a new `Person` is created that is never equal to the
   previous `Person`.

The `live_cell_extension` package also generates a comparison and hash
function for classes annotated with `CellExtension`. The name of the
comparison function is of the form `_$<class>Equals` and the name of
the hash function is of the form `_$<class>HashCode`.

Thus to override `==` and `hashCode` for the `Person` class, all that
has to be done is the following:

```dart
@CellExtension(mutable: true)
class Person {
    final String firstName;
    final String lastName;
    final int age;
    
    const Person({
        required this.firstName,
        required this.lastName,
        required this.age
    });

    @override
    bool operator ==(Object other) =>
        _$PersonEquals(this, other);
        
    @override
    int get hashCode => _$PersonHashCode(this);
}
```

`_$PersonEquals` and `_$PersonHashCode` are the generated comparison
and hash functions respectively.

:::info
If you don't want comparison and hash functions to be generated, pass
`generateEquals: false` to the `CellExtension` annotation.
:::

By default the generated comparison function compares each property
with `==` and the generated hash function computes the hash code
using the `hashCode` property of each property. To specify a different
comparison and hash function for a property, annotate it with
`DataField`.

```dart
@CellExtension()
class Point {
    @DataField(
        equals: listEquals,
        hash: Object.hashAll
    )
    final List<int> coordinates;
    
    ...
}
```

:::info
The `equals` argument specifies the comparison function to use instead
of `==` and the `hash` argument specifies the hash function to use
instead of the `hashCode` property.
:::

In this example the generated comparison function for the `Point`
class, will use `listEquals`, from the `flutter:foundation.dart`
library to compare the values of the `coordinates`
properties. Similarly, the generated hash function will use
`Object.hashAll` to compute the hash code of the `coordinates`
property.

:::tip
If you only want to generate a comparison and hash function but do not
want to generate a cell extension, annotate the class with
`@DataClass()`.
:::
