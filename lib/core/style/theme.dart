import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class CTheme {
  static final theme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CColors.white,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );
}
