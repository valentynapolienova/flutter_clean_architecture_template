import 'package:clean_architecture_template/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFF3F51B5);

  static final ThemeData light = _build(.light, AppColors.light);

  static final ThemeData dark = _build(.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    return ThemeData(
      colorScheme: .fromSeed(seedColor: _seedColor, brightness: brightness),
      extensions: [colors],
    );
  }
}
