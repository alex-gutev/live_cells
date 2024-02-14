import '../value_cell.dart';

/// Should notify observers callback function type
///
/// [cell] is the argument cell which is about to change its value to
/// [newValue].
typedef ShouldNotifyCallback = bool Function(ValueCell cell, dynamic newValue);