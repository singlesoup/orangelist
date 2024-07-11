import 'package:flutter/widgets.dart' show BuildContext, MediaQuery, Size;

class GlobalMediaQuerySize {
  static Size? size;
  static double? screenWidth;
  static double? screenHeight;

  /// Since ` MediaQuery.sizeOf()` will only notify when the size changes
  /// so use this instead of `MediaQuery.of(context),size`
  void init(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    screenWidth = size!.width;
    screenHeight = size!.height;
  }
}
