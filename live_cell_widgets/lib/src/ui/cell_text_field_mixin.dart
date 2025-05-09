part of 'live_widgets.dart';

/// Defines the properties holding the cells for controlling a [TextField].
abstract class _TextFieldInterface extends StatefulWidget {
  MutableCell<String> get content;
  MutableCell<TextSelection>? get selection;

  const _TextFieldInterface({super.key});
}

/// Implements the functionality of cell-based [TextField]s.
mixin _CellTextFieldMixin<T extends _TextFieldInterface> on State<T> {
  /// Text field controller
  late final TextEditingController _controller;

  /// Watches the content and selection cells for changes
  late final CellWatcher _watcher;

  /// Should updates to the content originating from the TextField be suppressed?
  var _suppressUpdate = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _watcher = ValueCell.watch(_onChangeCellContent);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _watcher.stop();
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.content != oldWidget.content ||
        widget.selection != oldWidget.selection) {
      _watcher.stop();
      _watcher = ValueCell.watch(_onChangeCellContent);
    }
  }

  void _onTextChange() {
    _withSuppressUpdates(() {
      MutableCell.batch(() {
        widget.content.value = _controller.text;
        widget.selection?.value = _controller.selection;
      });
    });
  }

  void _onChangeCellContent() {
    final text = widget.content();
    final selection = widget.selection?.call();

    _withSuppressUpdates(() {
      if (selection != null) {
        _controller.value = _controller.value.copyWith(
            text: text,
            selection: selection
        );
      }
      else {
        _controller.text = widget.content.value;
      }
    });
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