import 'package:flutter/material.dart';

/// Brand colours that `ColorScheme` has no slot for.
///
/// Read them with `context.colors.subtleText`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const new({required this.subtleText, required this.positive});

  static const light = AppColors(
    subtleText: Color(0xFF5F6368),
    positive: Color(0xFF2E7D32),
  );

  static const dark = AppColors(
    subtleText: Color(0xFFA0A4AB),
    positive: Color(0xFF81C784),
  );

  final Color subtleText;
  final Color positive;

  @override
  AppColors copyWith({Color? subtleText, Color? positive}) {
    return AppColors(
      subtleText: subtleText ?? this.subtleText,
      positive: positive ?? this.positive,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      subtleText: Color.lerp(subtleText, other.subtleText, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
    );
  }
}
