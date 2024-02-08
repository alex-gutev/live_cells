import '../value_cell.dart';

/// Defines an interface for creating equality and inequality comparison cells.
abstract class EqualityCellFactory {
  /// Create a cell which compares whether [self] is equal to [other].
  ///
  /// The cell should notify its observers whenever either [self] or [other]
  /// change their values.
  ValueCell<bool> makeEq<T,U>(ValueCell<T> self, ValueCell<U> other);

  /// Create a cell which compares whether [self] is equal to [other].
  ///
  /// The cell should notify its observers whenever either [self] or [other]
  /// change their values.
  ValueCell<bool> makeNeq<T,U>(ValueCell<T> self, ValueCell<U> other);
}

/// Creates equality comparison cells which compare for equality/inequality using ==/!=
class DefaultCellEqualityFactory implements EqualityCellFactory {
  @override
  ValueCell<bool> makeEq<T, U>(ValueCell<T> self, ValueCell<U> other) =>
      EqCell(self, other);

  @override
  ValueCell<bool> makeNeq<T, U>(ValueCell<T> self, ValueCell<U> other) =>
      NeqCell(self, other);
}