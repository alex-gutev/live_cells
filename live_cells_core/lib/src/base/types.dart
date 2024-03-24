/// Contains type definitions used throughout the package
library;

/// Cell watch function signature
typedef WatchCallback = void Function();

/// Post update callback function signature
typedef PostUpdateCallback = void Function();

/// Signature of compute value function
typedef ComputeValue<T> = T Function();

/// Signature of [SelfCell] compute value function
///
/// [self] is a [ComputeValue] function that when called returns the current
/// value of the [SelfCell].
typedef SelfCompute<T> = T Function(ComputeValue<T> self);

/// Prints [msg] to the console only in a debug build.
void debugPrint(String msg) {
  assert(() {
    print(msg);
    return true;
  }());
}