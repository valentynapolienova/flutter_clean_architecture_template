import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class PlatformParser {
  static String get platformToJson {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (kIsWeb) {
      return 'web';
    }

    throw UnimplementedError();
  }
}
