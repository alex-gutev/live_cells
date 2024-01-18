import '../value_cell.dart';

/// Interface for saving and restoring the state of a cell after initialization.
abstract class RestorableCell<T> extends ValueCell<T> {
  /// Dump the state of the cell to a value.
  ///
  /// The value returned by this method must be a primitive value, encodable by
  /// [StandardMessageCodec], which can later be passed to [restoreState] to
  /// restore the state of the cell to the state at the time of calling this
  /// method.
  ///
  /// [coder] is the [CellValueCoder] object which should be used for encoding
  /// the cell's value.
  Object? dumpState(CellValueCoder coder);

  /// Restore the state of the cell.
  ///
  /// [state] is a value, previously returned by [dumpState], encoding the state
  /// of the cell. This method should restored the state of the cell to the
  /// state described by [state]
  ///
  /// [coder] is the [CellValueCoder] object which should be used for decoding
  /// the cell's value.
  void restoreState(Object? state, CellValueCoder coder);
}

/// Cell value encoder and decoder interface.
///
/// The base implementation simply passes through the values both in [encode]
/// and [decode], thus it can only be used to encode and decode values
/// supported by [StandardMessageCodec].
///
/// This class should be subclassed to support cell restoration of cells holding
/// values not supported by [StandardMessageCodec].
class CellValueCoder {
  const CellValueCoder();

  /// Convert [value] to a primitive value.
  Object? encode(value) {
    return value;
  }

  /// Decoder the value from [primitive]
  decode(Object? primitive) {
    return primitive;
  }
}