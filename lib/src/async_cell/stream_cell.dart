import 'dart:async';

import '../base/cell_listeners.dart';
import '../equality/cell_equality.dart';
import 'future_cell.dart';

/// Cell which gets its value from a [Stream] of values
class StreamCell<T> extends FutureCell<T> with CellEquality<T>, CellListeners<T> {
  @override
  bool get hasValue => _hasValue;

  @override
  T get value => _value;

  /// Create a cell which gets its value from [stream].
  ///
  /// If [defaultValue] is not null, or [T] is a nullable type, the
  /// cell's is initialized to [defaultValue] until the stream produces a value.
  StreamCell(this.stream, {
    T? defaultValue
  }) {
    if (defaultValue != null) {
      _hasValue = true;
      _value = defaultValue;
    }
    else if (null is T) {
      _hasValue = true;
      _value = null as T;
    }

    _initValue();
  }

  @override
  void init() {
    super.init();

    _initValue();
    _subStream = stream.listen(_onStreamData);
  }

  @override
  void dispose() {
    _subStream?.cancel();
    _subStream = null;

    super.dispose();
  }

  /// Private

  late T _value;
  var _hasValue = false;

  final Stream<T> stream;
  StreamSubscription<T>? _subStream;

  void _initValue() {
    stream.last.then((value) {
      _setValue(value);
    });
  }

  void _onStreamData(T data) {
    _setValue(data);
  }

  void _setValue(T value) {
    if (!_hasValue || _value != value) {
      _hasValue = true;
      _value = value;
      notifyListeners();
    }
  }
}