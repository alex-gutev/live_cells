import 'dart:async';

import '../base/notifier_cell.dart';

/// Cell which gets its value from a [Stream]
class StreamCell<T> extends NotifierCell<T> {
  /// Create a cell which gets its value from [stream].
  ///
  /// The initial value of the cell is [initialValue].
  StreamCell({
    required this.stream,
    required T initialValue
  }) : super(initialValue);

  @override
  void init() {
    super.init();

    _subStream = stream.listen(_onStreamData);
  }

  @override
  void dispose() {
    _subStream?.cancel();
    _subStream = null;

    super.dispose();
  }

  /// Private

  final Stream<T> stream;
  StreamSubscription<T>? _subStream;

  void _onStreamData(T data) {
    value = data;
  }
}