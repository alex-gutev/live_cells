part of 'meta_cell.dart';

/// A [MetaCell] pointing to a [MutableCell]
///
/// This class provides a setter for the [value] property, which allows setting
/// the value of the referenced cell from this [MetaCell].
class MutableMetaCell<T> extends MetaCell<T> implements MutableCell<T> {
  MutableMetaCell({super.key});

  /// Get/Set the value of the referenced [MutableCell].
  ///
  /// **NOTE**: This cell must have at least one observer before setting this
  /// property, otherwise [InactiveMetaCellError] is thrown.
  ///
  /// **NOTE**: If this property is set before the referenced cell is set
  /// an [EmptyMetaCellError] exception is thrown.
  @override
  set value(T value) => _mutableCell.value = value;

  @override
  void inject(covariant MutableCell<T> cell) {
    super.inject(cell);
  }

  @override
  void setCell(covariant MutableCell<T> cell) {
    super.setCell(cell);
  }

  // Private

  /// The referenced [MutableCell].
  MutableCell<T> get _mutableCell {
    final cell = _ensureState.refCell;

    if (cell == null) {
      throw EmptyMetaCellError();
    }

    return cell as MutableCell<T>;
  }
}