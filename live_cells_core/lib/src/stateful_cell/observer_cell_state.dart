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

  /// Is the observer waiting for [update] to be called with didChange = true?
  @protected
  var waitingForChange = false;

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
      preUpdate();

      updating = true;
      waitingForChange = false;

      onWillUpdate();
      stale = true;
    }
  }

  @override
  void update(ValueCell cell, bool didChange) {
    if (updating || (didChange && waitingForChange)) {
      onUpdate(didChange && this.didChange());

      waitingForChange = !didChange;
      updating = false;

      if (didChange) {
        postUpdate();
      }
    }
  }
}