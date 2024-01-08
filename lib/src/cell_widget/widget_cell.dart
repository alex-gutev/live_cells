import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../base/cell_observer.dart';
import '../compute_cell/dynamic_compute_cell.dart';
import '../mutable_cell/mutable_cell.dart';
import '../value_cell.dart';
import 'proxy_cell.dart';

part 'cell_initializer.dart';

/// A widget which is rebuilt in response to changes in the values of [ValueCell]'s.
///
/// When the value of a [ValueCell] is referenced within the [build] method,
/// using [ValueCell.call], the widget is automatically rebuilt whenever the
/// value of the referenced cell changes.
///
/// Example:
///
/// ```dart
/// class Example extends WidgetCell {
///   final ValueCell<int> a;
///
///   Example({
///     super.key
///     required this.a
///   });
///
///   @override
///   Widget build(BuildContext context) {
///     return Text('The value of cell a is ${a()}');
///   }
/// }
/// ```
///
/// In the above example, the widget is rebuilt automatically whenever the
/// value of cell `a` is changed.
abstract class CellWidget extends StatelessWidget {
  CellWidget({super.key});

  /// Create a [CellWidget] with the [build] method defined by [builder].
  ///
  /// This allows a widget, which is dependent on the values of one or more cells,
  /// to be defined without subclassing.
  ///
  /// The returned widget includes the [CellInitializer] mixin, which allows the
  /// [CellWidgetContextExtension.cell] method to be called on the [BuildContext]
  /// passed to [builder].
  ///
  /// Example:
  ///
  /// ```dart
  /// WidgetCell.builder((context) => Text('The value of cell a is ${a()}'))
  /// ```
  factory CellWidget.builder(WidgetBuilder builder) =>
      _WidgetCellBuilder(builder);

  @override
  StatelessElement createElement() => _CellWidgetElement(this);
}

/// [CellWidget] with the [build] method defined by [builder].
class _WidgetCellBuilder extends CellWidget with CellInitializer {
  /// Widget builder function
  final WidgetBuilder builder;

  /// Create a [CellWidget] with [build] defined by [builder].
  _WidgetCellBuilder(this.builder);

  @override
  Widget build(BuildContext context) => builder(context);
}

/// Element for [CellWidget].
///
/// Keeps track of cells that were referenced during the [build] method and
/// automatically marks the widget for rebuilding if the value of a referenced
/// cell changes.
class _CellWidgetElement extends StatelessElement {
  _CellWidgetElement(super.widget) {
    _observer = _WidgetCellObserver(markNeedsBuild);
  }

  final Set<ValueCell> _arguments = HashSet();
  late _WidgetCellObserver _observer;

  @override
  Widget build() {
    return ComputeArgumentsTracker.computeWithTracker(() => super.build(), (cell) {
      if (!_arguments.contains(cell)) {
        _arguments.add(cell);
        cell.addObserver(_observer);
      }
    });
  }

  @override
  void unmount() {
    for (final cell in _arguments) {
      cell.removeObserver(_observer);
    }

    _arguments.clear();

    super.unmount();
  }
}

/// [CellObserver] that calls a callback when all argument cells have updated
/// their values.
class _WidgetCellObserver extends CellObserver {
  /// Callback function to call
  final VoidCallback listener;

  /// Are the argument cells in the process of updating their values?
  var _isUpdating = false;

  _WidgetCellObserver(this.listener);

  @override
  void update(ValueCell cell) {
    if (_isUpdating) {
      listener();
      _isUpdating = false;
    }
  }

  @override
  void willUpdate(ValueCell cell) {
    _isUpdating = true;
  }
}