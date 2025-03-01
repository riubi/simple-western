import 'package:flutter/foundation.dart';

class Platforms {
  static bool isMobile() {
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }
}
