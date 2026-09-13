import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/extensions/build_context_x.dart';
import 'package:clean_architecture_template/shared/extensions/failure_message.dart';
import 'package:clean_architecture_template/shared/theme/spacing.dart';
import 'package:flutter/material.dart';

/// Full-area message for a failed load, with a retry button.
class ErrorView extends StatelessWidget {
  const new({required this.failure, required this.onRetry, super.key});

  final AppFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(Spacing.l),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: Spacing.m),
            Text(failure.toMessage(context.l10n), textAlign: .center),
            const SizedBox(height: Spacing.m),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
