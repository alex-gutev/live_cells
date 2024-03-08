/// This library provides internal definitions used by other live cells packages.
///
/// Users of the library generally wouldn't import this library unless they are
/// extending live cells with new ValueCell subclasses.
library live_cells_internals;

export 'src/value_cell.dart' show DependentCell;

export 'src/compute_cell/dynamic_compute_cell.dart' show ComputeArgumentsTracker;
export 'src/base/auto_key.dart' show AutoKey;
export 'src/base/keys.dart';

export 'src/base/cell_equality_factory.dart'
    show EqualityCellFactory, DefaultCellEqualityFactory;

export 'src/base/cell_observer.dart' show CellObserver;

export 'src/stateful_cell/cell_state.dart' show CellState;
export 'src/stateful_cell/observer_cell_state.dart' show ObserverCellState;
export 'src/stateful_cell/stateful_cell.dart' show StatefulCell;

export 'src/mutable_cell/mutable_dependent_cell.dart' show MutableDependentCell;