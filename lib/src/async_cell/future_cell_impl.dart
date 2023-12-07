part of 'future_cell.dart';

/// Implementation of FutureCell which takes value directly from a Future
class _FutureCellImpl<T> extends FutureCell<T> with CellEquality<T>, CellListeners<T> {
  /// Create a FutureCell which takes its value from [future]
  ///
  /// If [defaultValue] is not null, or [T] is a nullable type, the
  /// cell's is initialized to [defaultValue] until the future completes and
  /// [hasValue] is true.
  _FutureCellImpl(Future<T> future, {
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

    future.then((value) {
      _hasValue = true;
      _value = value;

      notifyListeners();
    });
  }


  @override
  bool get hasValue => _hasValue;

  @override
  T get value {
    if (!_hasValue) {
      throw NoCellValueError();
    }

    return _value;
  }

  /// Private

  var _hasValue = false;
  late T _value;
}