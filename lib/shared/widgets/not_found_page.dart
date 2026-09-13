import 'package:clean_architecture_template/shared/extensions/build_context_x.dart';
import 'package:clean_architecture_template/shared/theme/spacing.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const new({required this.onGoHome, super.key});

  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(context.l10n.pageNotFound),
            const SizedBox(height: Spacing.m),
            FilledButton(onPressed: onGoHome, child: Text(context.l10n.goHome)),
          ],
        ),
      ),
    );
  }
}
