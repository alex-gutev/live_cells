import 'package:live_cells_core/live_cells_core.dart';

/// Signature of generate cell key function
typedef GenerateCellKey = Object? Function(ValueCell);

/// Signature of function for generating watch function keys
typedef GenerateWatchKey = Object? Function(CellWatcher);

/// Provides functionality for automatically generating cell keys
class AutoKey {
  /// Generate a key for [cell]
  ///
  /// If a generate cell key function is in-effect (by [withAutoKeys]), it is
  /// called, on [cell], to generate a new cell key, which is returned.
  static Object? autoKey(ValueCell cell) => _generateKey?.call(cell);

  /// Generate a key for cell watch function [watcher]
  ///
  /// If a generate watch key function is in-effect (by [withAutoWatchKeys]), 
  /// it is called, on [watcher], to generate a new key, which is returned.
  static Object? autoWatchKey(CellWatcher watcher) =>
      _generateWatchKey?.call(watcher);

  /// Register a callback used to generate keys for cells.
  ///
  /// The function [fn] is called with [generateCellKey] in-effect as the
  /// generate cell key function, which is called whenever [autoKey]
  /// is called within [fn].
  static void withAutoKeys(GenerateCellKey? generateCellKey, void Function() fn) {
    final previous = _generateKey;

    try {
      _generateKey = generateCellKey;
      fn();
    }
    finally {
      _generateKey = previous;
    }
  }

  /// Register a callback used to generate keys for watch functions.
  ///
  /// The function [fn] is called with [generateWatchKey] in-effect as the
  /// generate watch key function, which is called whenever [autoWatchKey]
  /// is called within [fn].
  static void withAutoWatchKeys(GenerateWatchKey generateWatchKey, void Function() fn) {
    final previous = _generateWatchKey;

    try {
      _generateWatchKey = generateWatchKey;
      fn();
    }
    finally {
      _generateWatchKey = previous;
    }
  }

  // Private

  /// Generate cell key callback function.
  static GenerateCellKey? _generateKey;

  /// Generate watch key callback function.
  static GenerateWatchKey? _generateWatchKey;

  /// Prevent construction
  AutoKey._internal();
}