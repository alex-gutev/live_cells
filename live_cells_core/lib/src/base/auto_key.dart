import 'package:live_cells_core/live_cells_core.dart';

/// Signature of generate cell key function
typedef GenerateCellKey = Object? Function(ValueCell);

/// Provides functionality for automatically generating cell keys
class AutoKey {
  /// Generate a key for [cell]
  ///
  /// If a generate cell key function is in-effect (by [withAutoKeys]), it is
  /// called, on [cell], to generate a new cell key, which is returned.
  static Object? autoKey(ValueCell cell) => _generateKey?.call(cell);

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

  // Private

  /// Generate cell key callback function.
  static GenerateCellKey? _generateKey;

  /// Prevent construction
  AutoKey._internal();
}