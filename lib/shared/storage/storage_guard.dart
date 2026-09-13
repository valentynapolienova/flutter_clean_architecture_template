import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/logging/app_logger.dart';

const _log = AppLogger('storage');

/// Runs a platform storage call and reports platform errors as
/// [StorageFailure].
Future<T> guardStorage<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on Exception catch (error, stackTrace) {
    _log.error('Storage call failed', error: error, stackTrace: stackTrace);
    Error.throwWithStackTrace(const StorageFailure(), stackTrace);
  }
}
