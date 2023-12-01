import 'package:flutter/foundation.dart';

/// Base value cell interface.
///
/// Extends the [ValueListenable] interface with equality operators.
abstract class ValueCell<T> implements ValueListenable<T> {
  /// Returns a new [ValueCell] which compares the value of this cell to another cell for equality.
  ///
  /// The returned [ValueCell] has a value of true when this cell and [other] have the same
  /// value according to the equality relation, and a value of false otherwise.
  ///
  /// The observers of the returned [ValueCell] are notified when either the value of this cell
  /// or [other] changes.
  ValueCell<bool> eq<U>(ValueCell<U> other);

  /// Returns a new [ValueCell] which compares the value of this cell to another cell for inequality.
  ///
  /// The returned [ValueCell] has a value of false when this cell and [other] have the same
  /// value according to the equality relation, and a value of true otherwise.
  ///
  /// The observers of the returned [ValueCell] are notified when either the value of this cell
  /// or [other] changes.
  ValueCell<bool> neq<U>(ValueCell<U> other);
}