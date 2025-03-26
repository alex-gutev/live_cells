/// Base classes for creating cell keys
library;

/// A key which is distinguished from other keys by a single [value].
class CellKey1<T> {
  /// The value distinguishing the key from other keys of the same type.
  final T value;

  CellKey1(this.value);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is CellKey1<T> &&
      value == other.value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

/// A key which is distinguished from other keys by two values.
class CellKey2<T1, T2> {
  /// The 1st value distinguishing the key from other keys of the same type.
  final T1 value1;

  /// The 2nd value distinguishing the key from other keys of the same type.
  final T2 value2;

  CellKey2(this.value1, this.value2);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is CellKey2<T1, T2> &&
      value1 == other.value1 &&
      value2 == other.value2;

  @override
  int get hashCode => Object.hash(runtimeType, value1, value2);
}

/// A key which is distinguished from other keys by three values.
class CellKey3<T1, T2, T3> {
  /// The 1st value distinguishing the key from other keys of the same type.
  final T1 value1;

  /// The 2nd value distinguishing the key from other keys of the same type.
  final T2 value2;

  /// The 3rd value distinguishing the key from other keys of the same type.
  final T3 value3;

  CellKey3(this.value1, this.value2, this.value3);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is CellKey3<T1, T2, T3> &&
      value1 == other.value1 &&
      value2 == other.value2 &&
      value3 == other.value3;

  @override
  int get hashCode => Object.hash(runtimeType, value1, value2, value3);
}

/// A key which is distinguished from other keys by four values.
class CellKey4<T1, T2, T3, T4> {
  /// The 1st value distinguishing the key from other keys of the same type.
  final T1 value1;

  /// The 2nd value distinguishing the key from other keys of the same type.
  final T2 value2;

  /// The 3rd value distinguishing the key from other keys of the same type.
  final T3 value3;

  /// The 4th value distinguishing the key from other keys of the same type.
  final T4 value4;

  CellKey4(this.value1, this.value2, this.value3, this.value4);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is CellKey4<T1, T2, T3, T4> &&
      value1 == other.value1 &&
      value2 == other.value2 &&
      value3 == other.value3 &&
      value4 == other.value4;

  @override
  int get hashCode => Object.hash(runtimeType, value1, value2, value3, value4);
}

/// A key which is distinguished from other keys by five values.
class CellKey5<T1, T2, T3, T4, T5> {
  /// The 1st value distinguishing the key from other keys of the same type.
  final T1 value1;

  /// The 2nd value distinguishing the key from other keys of the same type.
  final T2 value2;

  /// The 3rd value distinguishing the key from other keys of the same type.
  final T3 value3;

  /// The 4th value distinguishing the key from other keys of the same type.
  final T4 value4;

  /// The 5th value distinguishing the key from other keys of the same type.
  final T5 value5;

  CellKey5(this.value1, this.value2, this.value3, this.value4, this.value5);

  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType &&
      other is CellKey5<T1, T2, T3, T4, T5> &&
      value1 == other.value1 &&
      value2 == other.value2 &&
      value3 == other.value3 &&
      value4 == other.value4 &&
      value5 == other.value5;

  @override
  int get hashCode => Object.hash(runtimeType, value1, value2, value3, value4, value5);
}

/// A cell key identifying a single cell.
///
/// A cell with a key that is a [UniqueCellKey] is not functionally equivalent
/// to any other cell.
///
/// This key should not be created with the const constructor.
class UniqueCellKey {
}