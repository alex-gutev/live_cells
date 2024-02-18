/// Base classes for creating cell keys
library;

/// A key which is distinguished from other keys by a single [value].
class ValueKey1<T> {
  /// The value distinguishing the key from other keys of the same type.
  final T value;

  ValueKey1(this.value);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is ValueKey1<T> &&
      value == other.value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

/// A key which is distinguished from other keys by two values.
class ValueKey2<T1, T2> {
  /// The 1st value distinguishing the key from other keys of the same type.
  final T1 value1;

  /// The 2nd value distinguishing the key from other keys of the same type.
  final T2 value2;

  ValueKey2(this.value1, this.value2);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is ValueKey2<T1, T2> &&
      value1 == other.value1 &&
      value2 == other.value2;

  @override
  int get hashCode => Object.hash(runtimeType, value1, value2);
}

/// A key which is distinguished from other keys by three values.
class ValueKey3<T1, T2, T3> {
  /// The 1st value distinguishing the key from other keys of the same type.
  final T1 value1;

  /// The 2nd value distinguishing the key from other keys of the same type.
  final T2 value2;

  /// The 3rd value distinguishing the key from other keys of the same type.
  final T3 value3;

  ValueKey3(this.value1, this.value2, this.value3);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is ValueKey3<T1, T2, T3> &&
      value1 == other.value1 &&
      value2 == other.value2 &&
      value3 == other.value3;

  @override
  int get hashCode => Object.hash(runtimeType, value1, value2, value3);
}