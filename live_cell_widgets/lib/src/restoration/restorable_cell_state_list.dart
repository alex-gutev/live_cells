import 'package:flutter/widgets.dart';

/// A [RestorableProperty] holding a list of saved cell states.
class RestorableCellStateList extends RestorableProperty<List>{
  /// List of saved cell states
  List _states = [];

  /// Number of saved cell states in list
  int get length => _states.length;

  /// Retrieve the saved cell state at [index].
  operator [](int index) => _states[index];

  /// Set the saved cell state at [index].
  ///
  /// [state] must be of a type supported by [StandardMessageCodec].
  operator []=(int index, state) {
    _states[index] = state;
  }

  /// Append a new saved state to the list.
  void add(state) {
    _states.add(state);
  }

  /// Notify the observers of this property that the list of saved cell states has changd.
  void notifyChanged() {
    notifyListeners();
  }

  @override
  List createDefaultValue() {
    return [];
  }

  @override
  List fromPrimitives(Object? data) {
    return data as List;
  }

  @override
  void initWithValue(List value) {
    _states = value;
  }

  @override
  Object? toPrimitives() {
    // The list has to be copied otherwise the updated list is not saved.
    return List.from(_states);
  }
}