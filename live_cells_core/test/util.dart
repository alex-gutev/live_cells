import 'package:live_cells_core/live_cells_core.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<CellObserver>(as: #MockSimpleObserver)])
import 'util.mocks.dart';

/// Mock class interface for recording the value of a cell at the time an observer was called
abstract class ValueObserver {
  /// Mock method called by listener to record cell value
  void gotValue(value);
}

/// Mock class implementing [ValueObserver]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance.gotValue(expected))
class MockValueObserver extends MockSimpleObserver implements ValueObserver {
  /// List of values obtained (duplicates are removed)
  final values = [];

  @override
  void update(covariant ValueCell cell, covariant bool didChange) {
    try {
      final value = cell.value;

      if (values.lastOrNull != value) {
        values.add(value);
      }

      gotValue(value);
    }
    catch (e) {
      // Prevent exception from being printed to log
    }
  }
}

/// Mock class interface for recording whether a listener was called
abstract class SimpleListener {
  /// Method added as listener function
  void call();
}

/// Mock class implementing [SimpleListener]
///
/// Usage:
///
///   - Add instance as a listener of a cell
///   - verify(instance())
class MockSimpleListener extends Mock implements SimpleListener {}

abstract class TestResource {
  void init();
  void dispose();
}

class MockResource extends Mock implements TestResource {
  @override
  void init();
  @override
  void dispose();
}

class ManagedCellState extends CellState {
  final TestResource resource;

  ManagedCellState({
    required super.cell,
    required super.key,
    required this.resource
  });

  @override
  void init() {
    super.init();
    resource.init();
  }

  @override
  void dispose() {
    resource.dispose();
    super.dispose();
  }
}

class TestManagedCell<T> extends StatefulCell<T> {
  final TestResource _resource;

  @override
  final T value;

  TestManagedCell(this._resource, this.value);

  @override
  CellState<StatefulCell> createState() => ManagedCellState(
      cell: this,
      key: key,
      resource: _resource
  );
}

enum TestEnum {
  value1,
  value2,
  value3
}

// Test utility functions

/// Add an observer to a cell so that it reacts to changes in is dependencies.
///
/// The observer is removed in a teardown function added to the current test.
void observeCell(ValueCell cell) {
  addObserver(cell, MockSimpleObserver());
}

/// Add an observer to a cell.
///
/// This function also adds a teardown to the current test which removes
/// the [observer] from [cell], after the current test runs.
T addObserver<T extends CellObserver>(ValueCell cell, T observer) {
  cell.addObserver(observer);
  addTearDown(() => cell.removeObserver(observer));

  return observer;
}

/// Add a listener to a cell, which is called whenever the cell changes.
///
/// This function adds a watch function that references [cell]. Unlike
/// [ValueCell.watch] the watch function is not called on the initial setup.
///
/// This function also adds a teardown to the current test which removes
/// the [listener] from [cell], after the current test runs.
T addListener<T extends SimpleListener>(ValueCell cell, T? listener) {
  listener ??= MockSimpleListener() as T?;

  var first = true;

  final watcher = ValueCell.watch(() {
    try {
      cell();
    }
    catch (e) {
      // Print exceptions from failing tests
      // The value is only referenced to set up the dependency. An exception
      // doesn't actually mean a test failed
    }

    if (!first) {
      listener!.call();
    }

    first = false;
  });

  addTearDown(() => watcher.stop());

  return listener!;
}