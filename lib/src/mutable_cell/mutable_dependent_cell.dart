import 'package:flutter/foundation.dart';

import '../base/exceptions.dart';
import '../base/observer_cell.dart';
import '../base/cell_listeners.dart';
import '../base/cell_observer.dart';
import '../base/managed_cell.dart';
import '../restoration/restoration.dart';
import '../value_cell.dart';
import 'mutable_cell.dart';

/// Base class for a computational cell which can have its value set.
///
/// The use of this class is similar to [DependentCell] however the [compute]
/// method, rather than the [value] property setter, has to be overriden with
/// the implementation of the cell computation function.
///
/// Constructors of this class must call the [MutableDependentCell] constructor
/// with the list of argument cells which are referenced in the [compute]
/// function. The value of the cell will be recomputed whenever the value of
/// one of the argument cells changes.
///
/// Additionally, subclasses must also implement the [reverseCompute] method,
/// which is called whenever the value of the cell is set. This method should
/// update the values of the argument cells.
abstract class MutableDependentCell<T> extends ManagedCell<T>
    with CellEquality<T>, CellListeners<T>, ObserverCell<T>
    implements CellObserver, MutableCell<T>, RestorableCell<T> {

  /// List of argument cells.
  @protected
  final Set<ValueCell> arguments;

  /// Construct a [MutableDependentCell] which depends on the cells in [arguments]
  ///
  /// Every cell of which the value is referenced in [compute] must be
  /// included in [arguments].
  MutableDependentCell(this.arguments) {
    _value = compute();
  }

  /// Compute the value of the cell.
  ///
  /// Implementations of this method may reference the values of cells included
  /// in [arguments].
  ///
  /// The new cell value should be returned.
  T compute();

  /// Set the value of the argument cells in response to the value of the cell being set.
  ///
  /// Implementations of this method should be update the values of the cells in
  /// [arguments] based on [value], which is the new value of the cell.
  ///
  /// This method is executed in a [MutableCell.batch] call.
  void reverseCompute(T value);

  @override
  T get value {
    if (stale) {
      try {
        _value = compute();
      }
      on StopComputeException {
        // Keep previous value and reset stale and _computed
      }

      stale = false;
      _computed = true;
    }

    return _value;
  }

  @override
  set value(T value) {
    final isEqual = _value == value;

    _reverse = true;
    notifyWillUpdate(isEqual);

    updating = false;
    stale = false;
    _computed = false;
    _value = value;

    MutableCell.batch(() {
      try {
        reverseCompute(value);
      }
      catch (e, st) {
        if (kDebugMode) {
          print('Exception in MutableDependentCell reverse computation function: $e - $st');
        }
      }
    });

    if (MutableCell.isBatchUpdate) {
      MutableCell.addToBatch(this, isEqual);
    }
    else {
      notifyUpdate(isEqual);
    }

    _reverse = false;
  }

  /// Private

  late T _value;

  /// Is a reverse computation being performed?
  var _reverse = false;

  /// Is the current value computed or assigned using the [value] property.
  var _computed = true;

  @override
  void init() {
    super.init();

    if (_computed) {
      stale = true;
    }

    for (final dependency in arguments) {
      dependency.addObserver(this);
    }
  }

  @override
  void dispose() {
    for (final dependency in arguments) {
      dependency.removeObserver(this);
    }

    super.dispose();
  }

  @override
  void willUpdate(ValueCell cell) {
    if (!_reverse) {
      super.willUpdate(cell);
    }
  }
  
  @override
  bool get shouldNotifyAlways => true;

  @override
  Object? dumpState(CellValueCoder coder) {
    final currentValue = value;

    return {
      'computed': _computed,
      'value': coder.encode(currentValue)
    };
  }

  @override
  void restoreState(Object? state, CellValueCoder coder) {
    final map = state as Map;

    if (map['computed']) {
      _computed = true;
      _value = coder.decode(map['value']);
    }
    else {
      value = coder.decode(map['value']);
    }
  }
}