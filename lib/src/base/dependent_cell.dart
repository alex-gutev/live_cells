part of '../value_cell.dart';

/// A cell of which the value is dependent on the value of one or more dependency cells.
/// 
/// The purpose of this class is to implement a cell of which the value is a
/// function of one or more argument cells, thus the value of this cell needs to
/// be recomputed whenever the values of the argument cells change.
///
/// This class does not provide storage for the cell's value, it is intended to
/// be computed on demand when accessed, whilst observers are added directly
/// on the dependent cells.
abstract class DependentCell<T> extends ValueCell<T> {
  /// [Listenable] which notifies its listeners whenever the values of the dependent cells change.
  ///
  /// Observers are added directly to this [Listenable].
  @protected
  final Listenable dependencies;

  /// Create a cell, of which the value depends on a list of argument cells.
  ///
  /// [dependencies] is the list of all the argument cells on which the value
  /// of this cell depends.
  DependentCell(List<Listenable> dependencies) :
    dependencies = dependencies.singleOrNull ?? Listenable.merge(dependencies);

  /// Create a cell, of which the value depends on a single argument cells.
  ///
  /// [dependencies] is the list of all the argument cells on which the value
  /// of this cell depends.
  DependentCell.fromListenable(this.dependencies);

  @override
  void addListener(VoidCallback listener) {
    dependencies.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    dependencies.removeListener(listener);
  }
}