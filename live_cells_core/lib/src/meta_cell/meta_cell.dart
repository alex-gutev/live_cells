import '../mutable_cell/action_cell.dart';
import '../mutable_cell/mutable_cell.dart';
import '../stateful_cell/cell_state.dart';
import '../stateful_cell/observer_cell_state.dart';
import '../stateful_cell/stateful_cell.dart';
import '../value_cell.dart';

part 'mutable_meta_cell.dart';
part 'action_meta_cell.dart';

/// Thrown when accessing the value of a MetaCell that is not pointing to any cell
class EmptyMetaCellError implements Exception {
  @override
  String toString() => 'The value of a MetaCell was accessed, while it is '
      'not pointing to any cell.';
}

/// Thrown when accessing the value of a MetaCell that is inactive.
///
/// A meta cell is inactive when it has no observers.
class InactiveMetaCellError implements Exception {
  @override
  String toString() => 'A MetaCell was used while it is inactive (has no observers).';
}

/// A cell that points to another cell.
///
/// This cell points to another, which the value of this cell is the value of
/// the cell it points to and the observers of this cell are notified when
/// the value of the cell it points to changes.
///
/// The pointed to cell is set after construction and can be changed multiple
/// times. **NOTE**: The observers of this cell are not notified when the
/// pointed to cell changes.
///
/// If [value] is accessed before the cell, to which this cell points to, is set
/// an [EmptyMetaCellError] exception is thrown. Note, also this cell must
/// have at least one observer before setting the cell to which it points to.
///
/// Usage:
///
/// ```dart
/// final a = MutableCell(0);
/// final b = MutableCell(10);
///
/// final meta = MetaCell<int>();
///
/// ValueCell.watch(() => print(meta()));
///
/// // `meta` now points to `a`
/// meta.setCell(a);
///
/// print(meta.value); // Prints: 0
///
/// // The following causes the watch function defiend above
/// // to be called
///
/// a.value = 1; // Prints: 1
/// a.value = 2; // Prints: 2
///
/// // `meta` now points to `b`
/// meta.setCell(b);
///
/// b.value = 11; // Prints: 11
/// b.value = 12; // Prints: 12
/// ```
class MetaCell<T> extends StatefulCell<T> {
  /// The initial cell that the [MetaCell] points to.
  ///
  /// If [null] the [MetaCell] initially doesn't point to any cell.
  final ValueCell<T>? initial;

  /// Create a cell that points to another cell.
  ///
  /// The created cell is identified by [key] if it is non-null.
  ///
  /// The cell initially points to [initial] if it is not null.
  MetaCell({
    super.key,
    this.initial
  });

  /// Create a [MetaCell] that points to a [MutableCell].
  ///
  /// The created cell is identified by [key] if it is non-null.
  ///
  /// The cell initially points to [initial] if it is not null.
  static MutableMetaCell<T> mutable<T>({
    key,
    MutableCell<T>? initial
  }) => MutableMetaCell(
      key: key,
      initial: initial
  );

  /// Create a [MetaCell] that points to an [ActionCell].
  ///
  /// The created cell is identified by [key] if it is non-null.
  ///
  /// The cell initially points to [initial] if it is not null.
  static ActionMetaCell action({
    key,
    ActionCell? initial
  }) => ActionMetaCell(
      key: key,
      initial: initial
  );

  /// Set the cell to which this cell points to.
  ///
  /// After this is called, [value] returns the value of [cell] and the
  /// observers of [this] are notified when the value of [cell] changes.
  ///
  /// **NOTE**: This cell must have at least one observer before calling this
  /// method, otherwise [InactiveMetaCellError] is thrown.
  void setCell(ValueCell<T> cell) {
    _ensureState.refCell = cell;
  }

  /// Alias of [setCell].
  void inject(ValueCell<T> cell) => setCell(cell);

  @override
  CellState<StatefulCell> createState() => MetaCellState<T>(
      cell: this,
      key: key
  );

  @override
  T get value {
    final state = _ensureState;
    final refCell = state.refCell;

    if (refCell == null) {
      throw EmptyMetaCellError();
    }

    return refCell.value;
  }

  // Private

  MetaCellState<T> get _ensureState => state != null
      ? (state as MetaCellState<T>)
      : throw InactiveMetaCellError();
}

class MetaCellState<T> extends CellState<MetaCell<T>> with ObserverCellState<MetaCell<T>> {
  MetaCellState({
    required super.cell, 
    required super.key
  });

  /// Pointed to cell
  ValueCell<T>? get refCell => _refCell;

  /// Set the cell to which the [MetaCell] points to
  set refCell(ValueCell<T>? cell) {
    if (_refCell == cell) {
      return;
    }

    _refCell?.removeObserver(this);
    _refCell = cell;

    if (_refCell != null && isActive) {
      _refCell!.addObserver(this);
      _refernceValue();
    }
  }
  
  @override
  bool get shouldNotifyAlways => false;

  @override
  void init() {
    super.init();

    _refCell ??= cell.initial;

    _refCell?.addObserver(this);
    _refernceValue();
  }

  @override
  void dispose() {
    _refCell?.removeObserver(this);
    super.dispose();
  }

  // Private

  ValueCell<T>? _refCell;

  /// Reference the value of the injected cell, to ensure that it is tracking its dependencies.
  void _refernceValue() {
    try {
      _refCell?.value;
    }
    catch (e) {
      // Prevent exceptions from propagating outwards
    }
  }
}
