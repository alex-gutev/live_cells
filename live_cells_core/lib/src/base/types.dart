/// Contains type definitions used throughout the package
library;

/// Cell watch function type
typedef WatchCallback = void Function();

/// Prints [msg] to the console only in a debug build.
void debugPrint(String msg) {
  assert(() {
    print(msg);
    return true;
  }());
}