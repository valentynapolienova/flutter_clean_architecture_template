import 'dart:math';

import 'package:responsive_sizer/responsive_sizer.dart';

extension PixelSizerExt on num {
  // static const double designHeight = 720;
  static const double designHeight = 812;
  static const double designWidth = 375;

  double get ph => this / designHeight * Device.height;

  double get pw => this / designWidth * Device.width;

  double get pMax => max(ph, pw);
}
