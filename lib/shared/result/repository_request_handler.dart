import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/logging/app_logger.dart';
import 'package:clean_architecture_template/shared/result/failable.dart';

/// Runs a data-layer call and captures its outcome as a [Failable].
///
/// Services wrap their repository and storage calls with it, so nothing above
/// the application layer needs try/catch.
class RepositoryRequestHandler<T> {
  static const _log = AppLogger('RepositoryRequestHandler');

  FutureFailable<T> call({required Future<T> Function() request}) async {
    try {
      return Succeeded(await request());
    } on AppFailure catch (failure) {
      _log.warning('Request failed with $failure');
      return Failed(failure);
    } on Object catch (error, stackTrace) {
      // Anything that isn't an AppFailure is a bug, such as a TypeError from
      // a payload that doesn't match its DTO.
      _log.error(
        'Request failed unexpectedly',
        error: error,
        stackTrace: stackTrace,
      );
      return Failed(UnexpectedFailure(error));
    }
  }
}
