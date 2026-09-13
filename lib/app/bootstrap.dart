import 'dart:async';
import 'dart:ui';

import 'package:clean_architecture_template/app/app.dart';
import 'package:clean_architecture_template/app/config/app_config.dart';
import 'package:clean_architecture_template/app/di/service_locator.dart';
import 'package:clean_architecture_template/app/router/app_router.dart';
import 'package:clean_architecture_template/core/logging/app_logger.dart';
import 'package:clean_architecture_template/core/theme/theme_cubit.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/session/session_cubit.dart';
import 'package:flutter/widgets.dart';

const _log = AppLogger('bootstrap');

/// Prepares logging, error capture and dependencies, then starts the app.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  config.ensureValid();
  AppLogger.minLevel = config.isProd ? .warning : .debug;
  _captureUncaughtErrors();

  await registerDependencies(config);

  final themeCubit = sl<ThemeCubit>();
  await themeCubit.restoreThemeMode();

  final sessionCubit = sl<SessionCubit>();
  unawaited(sessionCubit.restore());

  runApp(
    App(
      themeCubit: themeCubit,
      sessionCubit: sessionCubit,
      router: createRouter(sessionCubit: sessionCubit),
    ),
  );
}

void _captureUncaughtErrors() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    _log.error(
      'Uncaught Flutter error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    _log.error('Uncaught platform error', error: error, stackTrace: stackTrace);
    return true;
  };
}
