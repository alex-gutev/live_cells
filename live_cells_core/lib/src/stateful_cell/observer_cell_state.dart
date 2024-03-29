import 'package:meta/meta.dart';

import 'stateful_cell.dart';
import 'cell_state.dart';
import '../base/cell_observer.dart';
import '../value_cell.dart';

/// Implements the [CellObserver] interface for cells of which the value depends on other cells.
///
/// This cell provides an implementation of [CellObserver.willUpdate] and
/// [CellObserver.update] which keep track of whether the cells value should
/// be recomputed.
///
/// Classes which make use of this mixin, should check the [stale] property.
/// If [stale] is true, the cell's value should be recomputed.
mixin ObserverCellState<S extends StatefulCell> on CellState<S> implements CellObserver {
  /// Should the cell's value be recomputed
  @protected
  var stale = true;

  /// Is a cell value update currently in progress
  @protected
  var updating = false;

  /// Check whether the cell's value has changed.
  ///
  /// This method is called when calling [update] on the observers of the cell.
  /// If false is returned, false is provided as the value of the `didChange`
  /// argument, otherwise the value of `didChange` received in [update] is
  /// forwarded to the observer.
  ///
  /// This class's implementation simply returns true. Override this method in
  /// subclasses to actually compare the cell values.
  @protected
  bool didChange() => true;

  /// Called when this observer is first notified that the values of the observed cells will change.
  @protected
  void preUpdate() {}

  /// Called after the value of the cell has been updated.
  ///
  /// NOTE: This method might not be called if none of the observed cell values
  /// have actually changed.
  @protected
  void postUpdate() {}

  /// Called when [willUpdate] is called for the first time during an update cycle.
  ///
  /// The [willUpdate] method should be called on the observers of the cell.
  /// Overriding this method allows this behaviour to be changed.
  @protected
  void onWillUpdate() {
    notifyWillUpdate();
  }

  /// Called when [update] is called
  ///
  /// The [update] method should be called on the observers of the cell.
  /// Overriding this method allows this behaviour to be changed.
  @protected
  void onUpdate(bool didChange) {
    notifyUpdate(didChange: didChange && this.didChange());
  }

  @override
  void willUpdate(ValueCell cell) {
    if (!updating) {
      assert(_changedDependencies == 0, 'Number of changed dependencies not equal to zero at start of update cycle.\n\n'
          'This indicates that CellObserver.update() was not called on the '
          'observers of the cell, from which this error originates, during the '
          'previous update cycle\n\n'
          'This indicates a bug in Live Cells unless the error originates from a'
          'ValueCell subclass provided by a third party, in which case it indicates'
          "a bug in the third party's code."
      );

      preUpdate();

      updating = true;

      _didChange = false;
      _changedDependencies = 0;

      onWillUpdate();
    }

    _changedDependencies++;
  }

  @override
  void update(ValueCell cell, bool didChange) {
    if (updating) {
      assert(_changedDependencies > 0, 'CellObserver.update called more times than CellObserver.willUpdate.\n\n'
          'The number of calls to CellObserver.update must match exactly the '
          'number of calls to CellObserver.willUpdate\n\n'
          'This indicates a bug in Live Cells unless the error originates from a'
          'ValueCell subclass provided by a third party, in which case it indicates'
          "a bug in the third party's code."
      );

      _didChange = _didChange || didChange;

      if (--_changedDependencies == 0) {
        stale = stale || _didChange;
        onUpdate(_didChange && this.didChange());

        updating = false;

        if (_didChange) {
          postUpdate();
        }
      }
    }
  }

  // Private

  /// Number of times [willUpdate] was called.
  ///
  /// This indicates, the number of dependency cells that have changed. When
  /// [update] is called, this counter is decremented and the observers of the
  /// cell are only notified when its value decreases down to 0.
  var _changedDependencies = 0;

  /// Have any of the dependency cells actually changed?
  var _didChange = false;
}