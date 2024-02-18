import 'package:flutter/widgets.dart';

import '../restoration/cell_restoration_manager.dart';

/// A widget that is only built once.
///
/// This [build] method of this widget is only called during the first build.
/// When the widget is rebuilt the same widget is returned that was returned
/// when [build] was called for the first time.
///
/// This allows stateful objects, such as [ValueCell]'s to be defined directly
/// in the build method:
///
/// ```dart
/// class Counter extends StaticWidget {
///   @override
///   Widget build(BuildContext context) {
///     final count = MutableCell(0);
///     final strCount = ValueCell.computed(() => count().toString());
///
///     return ElevatedButton(
///       child: CellText(data: strCount),
///       onPressed: () => count++
///     );
///   }
/// }
/// ```
abstract class StaticWidget extends StatelessWidget {
  /// Restoration ID to use for restoring the cell state
  ///
  /// If null state restoration is not performed.
  final String? restorationId;

  const StaticWidget({
    super.key,
    this.restorationId
  });

  /// Create a [StaticWidget] with the [build] method defined by [builder].
  ///
  /// This allows a [StaticWidget] to be created without subclassing.
  ///
  /// If [restorationId] is non-null [ValueCell.restore] may be called immediately
  /// within [builder] to restore the state of cells.
  ///
  /// Example:
  ///
  /// ```dart
  /// StaticWidget.builder((context) {
  ///     final count = MutableCell(0);
  ///     final strCount = ValueCell.computed(() => count().toString());
  ///
  ///     return ElevatedButton(
  ///       child: CellText(data: strCount),
  ///       onPressed: () => count++
  ///     );
  /// });
  /// ```
  factory StaticWidget.builder(WidgetBuilder builder, {
    Key? key,
    String? restorationId
  }) => _StaticWidgetBuilder(
      key: key,
      restorationId: restorationId,
      builder: builder
  );

  @override
  StatelessElement createElement() => restorationId != null
      ? _RestorableStaticWidgetElement(this, restorationId!)
      : _StaticWidgetElement(this);
}

/// A [StaticWidget] with the [build] method defined by [builder]
class _StaticWidgetBuilder extends StaticWidget {
  /// Widget builder function
  final WidgetBuilder builder;

  const _StaticWidgetBuilder({
    super.key,
    super.restorationId,
    required this.builder
  });

  @override
  Widget build(BuildContext context) => builder(context);
}

/// Element for [StaticWidget].
class _StaticWidgetElement extends StatelessElement {
  _StaticWidgetElement(super.widget);
  
  Widget? _builtWidget;
  
  @override
  Widget build() {
    return _builtWidget ??= super.build();
  }
}

/// [_StaticWidgetElement] that restores the state of cells within it.
class _RestorableStaticWidgetElement extends _StaticWidgetElement {
  final String _restorationId;

  _RestorableStaticWidgetElement(super.widget, this._restorationId);

  @override
  Widget build() => CellRestorationManager(
      builder: super.build,
      restorationId: _restorationId
  );
}