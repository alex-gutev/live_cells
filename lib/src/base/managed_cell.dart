import 'package:flutter/foundation.dart';

import '../value_cell.dart';

/// Provides an interface for managing resources within cells
///
/// Classes implementing this interface should override two methods:
///
/// The [init] method, which is called before the first observer is added. Code
/// which acquires resources or sets up observers of other ValueCells
/// should be located in this method.
///
/// The [dispose] method, which is called after the last observer is removed.
/// This method should be overridden to release/dispose all resources acquired in
/// the [init] method.
///
/// **NOTE:** The [value] property may be accessed before the [init] method is
/// called. Furthermore a cell may be reused and the [init] method may be called
/// again after calling [dispose], if a new observer is added to the cell,
/// therefore these methods should be implemented in such a way that the cell
/// instance can be reused.
abstract class ManagedCell<T> extends ValueCell<T> {
  /// Initialize the cell object.
  ///
  /// If the cell needs to set up any observers on other [ValueCell]'s or
  /// acquire resources it should be done in this method.
  ///
  /// **NOTE:** This method may be called after the [value] property is accessed
  @protected
  void init() {}

  /// Teardown the cell object.
  ///
  /// If the cell has set up any observers on other [ValueCell]'s or acquired
  /// resources this method should be overridden to include any teardown or
  /// cleanup logic.
  @protected
  void dispose() {}
}