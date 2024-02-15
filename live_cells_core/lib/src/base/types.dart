import '../value_cell.dart';

/// Will cell value change callback function type.
///
/// [cell] is the argument cell which is about to change its value to
/// [newValue].
///
/// The function should return true if the cell's value may change and
/// false if it is known with certainty that it wont.
typedef WillChangeCallback<T> = bool Function(ValueCell cell, T newValue);