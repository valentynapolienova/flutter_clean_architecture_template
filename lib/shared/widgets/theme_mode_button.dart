import 'package:clean_architecture_template/shared/extensions/build_context_x.dart';
import 'package:clean_architecture_template/shared/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == .dark;
    return IconButton(
      tooltip: context.l10n.toggleTheme,
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () =>
          context.read<ThemeCubit>().changeThemeMode(isDark ? .light : .dark),
    );
  }
}
