import 'package:live_cells_core/live_cells_internals.dart';

import '../compute_cell/store_cell.dart';
import '../compute_cell/mutable_compute_cell.dart';
import '../mutable_cell/mutable_cell.dart';
import '../mutable_cell/mutable_cell_view.dart';
import '../value_cell.dart';
import '../compute_cell/compute_cell.dart';

/// Utility methods for creating new cells by applying functions on their values.
extension ComputeExtension<T> on ValueCell<T> {
  /// Create a new cell, with a value which is computed by applying a function on this cell's value
  ///
  /// The value of the returned cell is the return value of [fn], a function of one argument,
  /// when applied on the this cell's value.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T value) fn, {
    key,
  }) => ComputeCell(
      compute: () => fn(value),
      arguments: {this},
      key: key
  );

  /// Create a new mutable cell, with a value that is a function of this cell's value.
  ///
  /// The value of the returned cell is computed by [fn], which is applied on
  /// the value of this cell. The [reverse] function is called when the value
  /// of the return cell is set. It should set the value of this cell accordingly
  /// such that calling [fn] again will produce the same value that was passed to
  /// [reverse].
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  /// The returned cell is identified by [key] if non-null. **NOTE**: A key
  /// argument is accepted since a [MutableCellView] is returned rather than
  /// a full mutable computed cell.
  MutableCell<U> mutableApply<U>(U Function(T) fn, void Function(U) reverse, {
    key,
    bool changesOnly = false
  }) {
    if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      arguments: {this},
      compute: () => fn(value),
      reverse: reverse,
      key: key,
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension2<T1, T2> on (ValueCell<T1>, ValueCell<T2>) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value),
      arguments: {$1, $2},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value),
        reverseCompute: reverse,
        arguments: {$1, $2},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value),
      reverse: reverse,
      arguments: {$1, $2},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension3<T1, T2, T3> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value),
      arguments: {$1, $2, $3},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3) fn, void Function(U) reverse, {
    key,
    bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value),
      reverse: reverse,
      arguments: {$1, $2, $3},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension4<T1, T2, T3, T4> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value),
      arguments: {$1, $2, $3, $4},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4) fn, void Function(U) reverse, {
    key,
    bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension5<T1, T2, T3, T4, T5> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>,
  ValueCell<T5>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4, T5) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value),
      arguments: {$1, $2, $3, $4, $5},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4, T5) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4, $5},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4, $5},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension6<T1, T2, T3, T4, T5, T6> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>,
  ValueCell<T5>,
  ValueCell<T6>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4, T5, T6) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value),
      arguments: {$1, $2, $3, $4, $5, $6},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4, T5, T6) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4, $5, $6},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4, $5, $6},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension7<T1, T2, T3, T4, T5, T6, T7> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>,
  ValueCell<T5>,
  ValueCell<T6>,
  ValueCell<T7>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4, T5, T6, T7) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value),
      arguments: {$1, $2, $3, $4, $5, $6, $7},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4, T5, T6, T7) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4, $5, $6, $7},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4, $5, $6, $7},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension8<T1, T2, T3, T4, T5, T6, T7, T8> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>,
  ValueCell<T5>,
  ValueCell<T6>,
  ValueCell<T7>,
  ValueCell<T8>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4, T5, T6, T7, T8) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value),
      arguments: {$1, $2, $3, $4, $5, $6, $7, $8},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4, T5, T6, T7, T8) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4, $5, $6, $7, $8},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4, $5, $6, $7, $8},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension9<T1, T2, T3, T4, T5, T6, T7, T8, T9> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>,
  ValueCell<T5>,
  ValueCell<T6>,
  ValueCell<T7>,
  ValueCell<T8>,
  ValueCell<T9>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4, T5, T6, T7, T8, T9) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value, $9.value),
      arguments: {$1, $2, $3, $4, $5, $6, $7, $8, $9},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4, T5, T6, T7, T8, T9) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value, $9.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4, $5, $6, $7, $8, $9},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value, $9.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4, $5, $6, $7, $8, $9},
    );
  }
}

/// Extends a record with a method for creating a [ComputeCell] by applying a
/// function on the argument cells given in the record.
extension RecordComputeExtension10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> on (
  ValueCell<T1>,
  ValueCell<T2>,
  ValueCell<T3>,
  ValueCell<T4>,
  ValueCell<T5>,
  ValueCell<T6>,
  ValueCell<T7>,
  ValueCell<T8>,
  ValueCell<T9>,
  ValueCell<T10>
) {
  /// Create a [ComputeCell] with compute function [fn] with the cells in this as the argument list.
  ///
  /// A [ValueCell] is returned of which the value is the result returned by [fn],
  /// passing the values of the cells in this as arguments.
  ///
  /// Whenever the value of one of the elements of [this] changes, [fn] is called
  /// again to compute the new value of the cell.
  ///
  /// The created cell is identified by [key] if non-null.
  ValueCell<U> apply<U>(U Function(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) fn, {
    key,
  }) => ComputeCell(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value, $9.value, $10.value),
      arguments: {$1, $2, $3, $4, $5, $6, $7, $8, $9, $10},
  );

  /// Create a [MutableComputeCell] with given compute and reverse compute functions, and the cells in this as the argument list.
  ///
  /// The [fn] function is called with the values of the cells in this
  /// passed as arguments whenever the value of at least one cell in [this]
  /// changes. It should return the cell's value.
  ///
  /// The [reverse] function is called when the [value] of the cell is
  /// set, with the new value passed as an argument to the function. It should
  /// set the values of the argument cells accordingly such that calling [fn]
  /// again will produce the same value that was passed to [reverse].
  ///
  /// [reverse] is called in a batch update, by [MutableCell.batch], so
  /// that the values of the argument cells are set simultaneously.
  ///
  /// If [changesOnly] is true, the returned cell only notifies its observers
  /// if its value has actually changed.
  ///
  ///
  /// If [key] is non-null a [MutableCellView] identified by [key] is returned.
  /// If [key] is null a [MutableComputeCell] is returned.
  MutableCell<U> mutableApply<U>(U Function(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10) fn, void Function(U) reverse, {
      key,
      bool changesOnly = false
  }) {
    if (key == null) {
      return MutableComputeCell(
        compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value, $9.value, $10.value),
        reverseCompute: reverse,
        arguments: {$1, $2, $3, $4, $5, $6, $7, $8, $9, $10},
        changesOnly: changesOnly
      );
    }
    else if (changesOnly) {
      return apply(fn, key: key != null ? _MutableApplyKey(this, key) : null)
          .store(changesOnly: true)
          .mutableApply((p0) => p0, reverse, key: key);
    }

    return MutableCellView(
      key: key,
      compute: () => fn($1.value, $2.value, $3.value, $4.value, $5.value, $6.value, $7.value, $8.value, $9.value, $10.value),
      reverse: reverse,
      arguments: {$1, $2, $3, $4, $5, $6, $7, $8, $9, $10},
    );
  }
}

class _MutableApplyKey extends CellKey2 {
  _MutableApplyKey(super.value1, super.value2);
}
