/// Exception used to indicate that the cell's value should not be computed.
///
/// When this exception is thrown inside the a cell's value computation function,
/// the cell's value is not updated. Instead the cell's current value is
/// preserved.
class StopComputeException implements Exception {
  final dynamic defaultValue;

  /// Create an exception to stop the computation of the cell's value.
  ///
  /// If this exception is thrown during the computation of the cell's initial
  /// value, the cell's initial value is set to [defaultValue].
  const StopComputeException(this.defaultValue);

  @override
  String toString() => 'StopComputeException() throw. '
      'If you are seeing this you most likely used ValueCell.none() outside a '
      'cell value computation function.';
}

/// Used to cancel an asynchronous computation
class CancelComputeException implements Exception {
}