import 'package:clean_architecture_template/core/theme/app_colors.dart';
import 'package:clean_architecture_template/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
