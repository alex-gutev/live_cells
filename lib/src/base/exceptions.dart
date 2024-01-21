/// Exception used to indicate that the cell's value should not be computed.
///
/// When this exception is thrown inside the a cell's value computation function,
/// the cell's value is not updated. Instead the cell's current value is
/// preserved.
class StopComputeException implements Exception {
  @override
  String toString() => 'The cell does not have a new value';
}