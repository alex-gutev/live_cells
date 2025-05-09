part of 'live_widgets.dart';

/// Defines the properties holding the cells for controlling a [PageView].
abstract class _PageViewInterface extends StatefulWidget {
  MutableCell<int> get page;
  ValueCell<bool>? get animate;
  ValueCell<Duration>? get duration;
  ValueCell<Curve>? get curve;

  ValueCell<void>? get nextPage;
  ValueCell<void>? get previousPage;

  MetaCell<bool>? get isAnimating;

  const _PageViewInterface({super.key});
}

/// Implements the functionality of cell-based [PageView]s.
mixin _CellPageViewMixin<T extends _PageViewInterface> on State<T> {
  /// Page view controller
  late final PageController _controller;

  /// Selected page cell watcher
  late CellWatcher _pageWatcher;

  /// Go to next page action cell watcher
  CellWatcher? _nextPageWatcher;

  /// Go to previous page action cell watcher
  CellWatcher? _prevPageWatcher;

  /// Should updates to the selected page originating from the page view be suppressed?
  var _suppress = false;

  /// Is a page transition currently being animated?
  final _isAnimating = MutableCell(false);
  
  @override
  void initState() {
    super.initState();

    _controller = PageController(
        initialPage: widget.page.value
    );

    _watchPage();
    _watchNextPage();
    _watchPrevPage();
    
    widget.isAnimating?.inject(_isAnimating);
  }

  @override
  void dispose() {
    _pageWatcher.stop();
    _nextPageWatcher?.stop();
    _prevPageWatcher?.stop();
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

    if (widget.nextPage != oldWidget.nextPage ||
        widget.animate != oldWidget.animate ||
        widget.duration != oldWidget.duration ||
        widget.curve != oldWidget.curve) {
      _nextPageWatcher?.stop();
      _watchNextPage();
    }

    if (widget.previousPage != oldWidget.previousPage ||
        widget.animate != oldWidget.animate ||
        widget.duration != oldWidget.duration ||
        widget.curve != oldWidget.curve) {
      _prevPageWatcher?.stop();
      _watchPrevPage();
    }
    
    if (widget.isAnimating != oldWidget.isAnimating) {
      widget.isAnimating?.inject(_isAnimating);
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
          _withAnimating(() => _controller.animateToPage(
              page,
              duration: widget.duration!.peek(),
              curve: widget.curve!.peek()
          ));
        }
        else {
          _controller.jumpToPage(page);
        }
      }
    });
  }

  void _watchNextPage() {
    if (widget.nextPage != null) {
      _nextPageWatcher = Watch((state) {
        widget.nextPage!.observe();
        
        state.afterInit();

        _withAnimating(() => _controller.nextPage(
            duration: widget.duration!.peek(),
            curve: widget.curve!.peek()
        ));
      });
    }
  }

  void _watchPrevPage() {
    if (widget.previousPage != null) {
      _prevPageWatcher = Watch((state) {
        widget.previousPage!.observe();

        state.afterInit();

        _withAnimating(() => _controller.previousPage(
            duration: widget.duration!.peek(),
            curve: widget.curve!.peek()
        ));
      });
    }
  }

  /// Call [fn] and set [_isAnimating] to true until [fn] returns.
  Future<void> _withAnimating(Future<void> Function() fn) async {
    try {
      _isAnimating.value = true;
      await fn();
    }
    finally {
      _isAnimating.value = false;
    }
  }
}