import 'package:flutter/widgets.dart';

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
  const StaticWidget({super.key});

  /// Create a [StaticWidget] with the [build] method defined by [builder].
  ///
  /// This allows a [StaticWidget] to be created without subclassing.
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
  factory StaticWidget.builder(WidgetBuilder builder, {Key? key}) =>
      _StaticWidgetBuilder(
          key: key,
          builder: builder
      );

  @override
  StatelessElement createElement() => _StaticWidgetElement(this);
}

/// A [StaticWidget] with the [build] method defined by [builder]
class _StaticWidgetBuilder extends StaticWidget {
  /// Widget builder function
  final WidgetBuilder builder;

  const _StaticWidgetBuilder({
    super.key,
    required this.builder
  });

  @override
  Widget build(BuildContext context) => build(context);
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