part of 'widgets.dart';

/// Defines the properties holding the cells for controlling a [PageView].
abstract class _PageViewInterface extends StatefulWidget {
  MutableCell<int> get page;
  ValueCell<bool>? get animate;
  ValueCell<Duration>? get duration;
  ValueCell<Curve>? get curve;

  const _PageViewInterface({super.key});
}

/// Implements the functionality of cell-based [PageView]s.
mixin _CellPageViewMixin<T extends _PageViewInterface> on State<T> {
  /// Page view controller
  final _controller = PageController();

  /// Selected page cell watcher
  late CellWatcher _pageWatcher;

  /// Should updates to the selected page originating from the page view be suppressed?
  var _suppress = false;

  @override
  void initState() {
    super.initState();
    _watchPage();
  }

  @override
  void dispose() {
    _pageWatcher.stop();
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.page != oldWidget.page ||
        widget.animate != oldWidget.animate ||
        widget.duration != oldWidget.duration ||
        widget.curve != oldWidget.curve) {
      _pageWatcher.stop();
      _watchPage();
    }
  }

  /// Call [fn] while preventing changes to the page cell from affecting the page view.
  void _withSuppressed(void Function() fn) {
    try {
      _suppress = true;
      fn();
    }
    finally {
      _suppress = false;
    }
  }

  void _watchPage() {
    _pageWatcher = Watch((state) {
      final page = widget.page();

      state.afterInit();

      if (!_suppress) {
        if (widget.animate?.peek() ?? false) {
          _controller.animateToPage(
              page,
              duration: widget.duration!.peek(),
              curve: widget.curve!.peek()
          );
        }
        else {
          _controller.jumpToPage(page);
        }
      }
    });
  }
}