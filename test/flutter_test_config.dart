import 'dart:async';

import 'package:clean_architecture_template/core/logging/app_logger.dart';

/// Runs before every test file; keeps log records out of test output.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  AppLogger.minLevel = .off;
  await testMain();
}
