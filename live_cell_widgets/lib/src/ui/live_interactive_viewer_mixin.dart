part of 'live_widgets.dart';

abstract class _InteractiveViewerInterface extends StatefulWidget {
  /// Cell holding the transformation applied to the child widget
  MutableCell<Matrix4>? get transformation;

  const _InteractiveViewerInterface({super.key});
}

mixin _LiveInteractiveViewerMixin<T extends _InteractiveViewerInterface> on State<T> {
  /// Transformation controller
  late final TransformationController _controller;

  /// Watches the content and selection cells for changes
  late final CellWatcher _watcher;

  /// Should updates to the content originating from the TextField be suppressed?
  var _suppressUpdate = false;

  @override
  void initState() {
    super.initState();

    _controller = TransformationController();
    _watcher = ValueCell.watch(_onChangeCell);
    _controller.addListener(_onTransformationChange);
  }

  @override
  void dispose() {
    _watcher.stop();
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.transformation != oldWidget.transformation) {
      _watcher.stop();
      _watcher = ValueCell.watch(_onChangeCell);
    }
  }

  void _onTransformationChange() {
    _withSuppressUpdates(() {
      widget.transformation?.value = _controller.value;
    });
  }

  void _onChangeCell() {
    final transformation = widget.transformation?.call();

    if (transformation != null) {
      _withSuppressUpdates(() => _controller.value = transformation);
    }
  }

  /// Suppress events triggered by [fn].
  ///
  /// If [fn] updates [_controller.text] do not reflect the change in
  /// [widget.content]. Similarly, if [fn] updates [widget.content] do not
  /// reflect the change in [_controller.text].
  void _withSuppressUpdates(VoidCallback fn) {
    if (!_suppressUpdate) {
      try {
        _suppressUpdate = true;
        fn();
      }
      finally {
        _suppressUpdate = false;
      }
    }
  }
}