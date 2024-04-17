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

    // TODO: Destroy and recreate watcher when a different page cell is given.

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

  @override
  void dispose() {
    _pageWatcher.stop();
    _controller.dispose();

    super.dispose();
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
}