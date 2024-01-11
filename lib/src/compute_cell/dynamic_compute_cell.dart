import 'dart:collection';

import '../base/cell_listeners.dart';
import '../base/cell_observer.dart';
import '../base/managed_cell.dart';
import '../base/observer_cell.dart';
import '../value_cell.dart';

/// A computational cell which determines its dependencies at runtime
/// 
/// Usage:
/// 
/// Create a [DynamicComputeCell] by passing the value computation function
/// to the default constructor:
/// 
/// ```dart
/// final sum = DyanmicComputeCell(() => a() + b());
/// ```
class DynamicComputeCell<T> extends ManagedCell<T>
    with CellListeners<T>, CellEquality<T>, ObserverCell<T>
    implements CellObserver {

  /// Create a cell which computes its value using [compute].
  DynamicComputeCell(this._compute) {
    _value = ComputeArgumentsTracker.computeWithTracker(_compute, (cell) {
      _arguments.add(cell);
    });
  }

  @override
  T get value {
    if (stale) {
      _value = ComputeArgumentsTracker.computeWithTracker(_compute, (cell) {
        if (!_arguments.contains(cell)) {
          _arguments.add(cell);

          if (isInitialized) {
            cell.addObserver(this);
          }
        }
      });

      stale = !isInitialized;
    }

    return _value;
  }


  /// Private

  /// Value computation function
  final T Function() _compute;
  
  /// Set of argument cells
  final Set<ValueCell> _arguments = HashSet();
  
  /// The value
  late T _value;

  @override
  void init() {
    super.init();

    stale = true;

    for (final argument in _arguments) {
      argument.addObserver(this);
    }
  }

  @override
  void dispose() {
    stale = true;

    for (final argument in _arguments) {
      argument.removeObserver(this);
    }

    super.dispose();
  }

  @override
  bool get shouldNotifyAlways => false;
}

/// Provides static methods for tracking computational cell arguments at runtime.
extension ComputeArgumentsTracker<T> on ValueCell<T> {
  /// Inform the current argument cell listener that the value of [cell] was referenced. 
  static void trackArgument(ValueCell cell) {
    if (_onUseArgument != null) {
      _onUseArgument!(cell);
    }
  }

  /// Compute a cell value using [fn] while tracking argument cells using [tracker].
  /// 
  /// When the value of an cell is referenced in [fn], [tracker] is called with
  /// the referenced cell passed as an argument.
  /// 
  /// Returns the value computed by [fn].
  static T computeWithTracker<T>(T Function() fn, void Function(ValueCell) tracker) {
    final prevTracker = _onUseArgument;
    
    try {
      _onUseArgument = tracker;
      return fn();
    }
    finally {
      _onUseArgument = prevTracker;
    }
  }

  /// Private

  /// Callback function to call whenever a the value of a cell is referenced.
  static void Function(ValueCell dep)? _onUseArgument;
}