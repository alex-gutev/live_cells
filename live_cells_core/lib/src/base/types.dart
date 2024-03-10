/// Contains type definitions used throughout the package
library;

/// Cell watch function signature
typedef WatchCallback = void Function();

/// Post update callback function signature
typedef PostUpdateCallback = void Function();

/// Prints [msg] to the console only in a debug build.
void debugPrint(String msg) {
  assert(() {
    print(msg);
    return true;
  }());
}