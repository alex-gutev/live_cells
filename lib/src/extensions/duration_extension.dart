import 'compute_extension.dart';
import '../mutable_cell/mutable_cell.dart';
import '../value_cell.dart';

/// Provides accessors for [Duration] properties on cells holding a [Duration].
///
/// Each accessor returns a [ValueCell], of which the value is the value of
/// the property.
extension DurationCellExtension on ValueCell<Duration> {
  /// The duration in units of days, see [Duration.inDays]
  ///
  /// A cell is returned which accesses this property of the value held in
  /// [this] cell.
  ValueCell<int> get inDays => apply((value) => value.inDays);

  /// The duration in units of hours, see [Duration.inHours]
  ///
  /// A cell is returned which accesses this property of the value held in
  /// [this] cell.
  ValueCell<int> get inHours => apply((value) => value.inHours);

  /// The duration in units of minutes, see [Duration.inMinutes]
  ///
  /// A cell is returned which accesses this property of the value held in
  /// [this] cell.
  ValueCell<int> get inMinutes => apply((value) => value.inMinutes);

  /// The duration in units of seconds, see [Duration.inSeconds]
  ///
  /// A cell is returned which accesses this property of the value held in
  /// [this] cell.
  ValueCell<int> get inSeconds => apply((value) => value.inSeconds);

  /// The duration in units of milliseconds, see [Duration.inMilliseconds]
  ///
  /// A cell is returned which accesses this property of the value held in
  /// [this] cell.
  ValueCell<int> get inMilliseconds => apply((value) => value.inMilliseconds);

  /// The duration in units of microseconds, see [Duration.inMicroseconds]
  ///
  /// A cell is returned which accesses this property of the value held in
  /// [this] cell.
  ValueCell<int> get inMicroseconds => apply((value) => value.inMicroseconds);

  /// Returns a cell, the value of which is true if [this] is negative, see [Duration.isNegative].
  ValueCell<bool> get isNegative => apply((value) => value.isNegative);

  /// Returns a cell holding a [Duration] of the same length as this but positive, see [Duration.abs].
  ValueCell<Duration> abs() => apply((value) => value.abs());

  /// Returns a cell which holds the sum of [this] and [other].
  ValueCell<Duration> operator +(ValueCell<Duration> other) =>
      [this, other].computeCell(() => value + other.value);

  /// Returns a cell which holds the subtraction of [other] from [this].
  ValueCell<Duration> operator -(ValueCell<Duration> other) =>
      [this, other].computeCell(() => value - other.value);

  /// Returns a cell which holds the multiplication of [this] by [factor].
  ValueCell<Duration> operator *(ValueCell<num> factor) =>
      [this, factor].computeCell(() => value * factor.value);

  /// Returns a cell which holds the division of [this] by [quotient].
  ValueCell<Duration> operator ~/(ValueCell<int> quotient) =>
      [this, quotient].computeCell(() => value ~/ quotient.value);

  /// Returns a cell which holds the negation of [this].
  ValueCell<Duration> operator -() => apply((value) => -value);

  /// Returns a cell of which the value is true if [this] is less than [other]
  ValueCell<bool> operator <(ValueCell<Duration> other) =>
      [this, other].computeCell(() => value < other.value);

  /// Returns a cell of which the value is true if [this] is greater than [other]
  ValueCell<bool> operator >(ValueCell<Duration> other) =>
      [this, other].computeCell(() => value > other.value);

  /// Returns a cell of which the value is true if [this] is less than or equal to [other]
  ValueCell<bool> operator <=(ValueCell<Duration> other) =>
      [this, other].computeCell(() => value <= other.value);

  /// Returns a cell of which the value is true if [this] is greater than or equal to [other]
  ValueCell<bool> operator >=(ValueCell<Duration> other) =>
      [this, other].computeCell(() => value >= other.value);
}

/// Provides accessors for [Duration] properties on cells holding a [Duration].
///
/// Each accessor returns a [MutableCell], of which the value is the value of
/// the property. Setting the value of the cell, updates the value of the
/// [Duration] held in [this] cell.
extension MutableDurationCellExtension on MutableCell<Duration> {
  /// The duration in units of days, see [Duration.inDays]
  ///
  /// A [MutableCell] is returned which accesses this property of the value held in
  /// [this] cell. Setting the value of the returned cell updates the value of
  /// [this] by creating a new [Duration] as if by `Duration(days: value)`.
  MutableCell<int> get inDays => [this].mutableComputeCell(() => value.inDays, (value) {
    this.value = Duration(days: value);
  });

  /// The duration in units of hours, see [Duration.inHours]
  ///
  /// A [MutableCell] is returned which accesses this property of the value held in
  /// [this] cell. Setting the value of the returned cell updates the value of
  /// [this] by creating a new [Duration] as if by `Duration(hours: value)`.
  MutableCell<int> get inHours => [this].mutableComputeCell(() => value.inHours, (value) {
    this.value = Duration(hours: value);
  });

  /// The duration in units of minutes, see [Duration.inMinutes]
  ///
  /// A [MutableCell] is returned which accesses this property of the value held in
  /// [this] cell. Setting the value of the returned cell updates the value of
  /// [this] by creating a new [Duration] as if by `Duration(minutes: value)`.
  MutableCell<int> get inMinutes => [this].mutableComputeCell(() => value.inMinutes, (value) {
    this.value = Duration(minutes: value);
  });

  /// The duration in units of seconds, see [Duration.inSeconds]
  ///
  /// A [MutableCell] is returned which accesses this property of the value held in
  /// [this] cell. Setting the value of the returned cell updates the value of
  /// [this] by creating a new [Duration] as if by `Duration(seconds: value)`.
  MutableCell<int> get inSeconds => [this].mutableComputeCell(() => value.inSeconds, (value) {
    this.value = Duration(seconds: value);
  });

  /// The duration in units of milliseconds, see [Duration.inMilliseconds]
  ///
  /// A [MutableCell] is returned which accesses this property of the value held in
  /// [this] cell. Setting the value of the returned cell updates the value of
  /// [this] by creating a new [Duration] as if by `Duration(milliseconds: value)`.
  MutableCell<int> get inMilliseconds => [this].mutableComputeCell(() => value.inMilliseconds, (value) {
    this.value = Duration(milliseconds: value);
  });

  /// The duration in units of microseconds, see [Duration.inMicroseconds]
  ///
  /// A [MutableCell] is returned which accesses this property of the value held in
  /// [this] cell. Setting the value of the returned cell updates the value of
  /// [this] by creating a new [Duration] as if by `Duration(microseconds: value)`.
  MutableCell<int> get inMicroseconds => [this].mutableComputeCell(() => value.inMicroseconds, (value) {
    this.value = Duration(microseconds: value);
  });
}

/// Extends [Duration] with a [cell] property to create a [ValueCell] holding a [Duration].
extension DurationCellConstructorExtension on Duration {
  /// Create a constant [ValueCell] with value equal to [this].
  ValueCell<Duration> get cell => ValueCell.value(this);
}