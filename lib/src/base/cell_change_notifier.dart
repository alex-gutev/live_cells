import 'package:flutter/cupertino.dart';

/// Subclass of [ChangeNotifier] which exposes the [hasListeners] method
class CellChangeNotifier extends ChangeNotifier {
  /// Public alias for [ChangeNotifier.hasListeners]
  bool get isActive => hasListeners;
}