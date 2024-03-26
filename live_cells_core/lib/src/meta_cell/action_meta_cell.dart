part of 'meta_cell.dart';

/// A [MetaCell] pointing to an [ActionCell]
///
/// This class provides the [trigger] method for triggering the referenced
/// [ActionCell] from this [MetaCell].
class ActionMetaCell extends MetaCell<void> implements ActionCell {
  ActionMetaCell({super.key});

  /// Trigger the referenced [ActionCell].
  ///
  /// **NOTE**: This cell must have at least one observer before calling this
  /// method, otherwise [InactiveMetaCelLError] is thrown.
  ///
  /// **NOTE**: If this method is called before the referenced cell is set
  /// an [EmptyMetaCellError] exception is thrown.
  @override
  void trigger() => _actionCell.trigger();

  @override
  void inject(covariant ActionCell cell) {
    super.inject(cell);
  }

  @override
  void setCell(covariant ActionCell cell) {
    super.setCell(cell);
  }

  // Private

  /// Retrieve the referenced [ActionCell]
  ActionCell get _actionCell {
    final cell = _ensureState.refCell;

    if (cell == null) {
      throw EmptyMetaCellError();
    }

    return cell as ActionCell;
  }
}