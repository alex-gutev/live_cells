part of '../value_cell.dart';

/// A cell of which the value is dependent on the value of one or more argument cells.
/// 
/// The purpose of this class is to implement a cell of which the value is a
/// function of one or more argument cells, thus the value of this cell needs to
/// be recomputed whenever the values of the argument cells change.
///
/// This class does not provide storage for the cell's value, it is intended to
/// be computed on demand when accessed, whilst observers are added directly
/// on the argument cells.
abstract class DependentCell<T> extends ValueCell<T> {
  /// List of argument cells.
  @protected
  final List<ValueCell> arguments;

  /// Create a cell, of which the value depends on a list of argument cells.
  ///
  /// [arguments] is the list of all the argument cells on which the value
  /// of this cell depends.
  DependentCell(this.arguments);

  @override
  void addObserver(CellObserver observer) {
    for (final dependency in arguments) {
      dependency.addObserver(observer);
    }
  }

  @override
  void removeObserver(CellObserver observer) {
    for (final dependency in arguments) {
      dependency.removeObserver(observer);
    }
  }
}