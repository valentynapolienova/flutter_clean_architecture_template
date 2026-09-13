import 'package:clean_architecture_template/shared/result/failable.dart';
import 'package:dio/dio.dart';

/// Adds the bearer token to requests and recovers from expired tokens.
///
/// On a 401 it obtains a newer token, retries the request once, and calls
/// [onSessionExpired] when no newer token can be obtained. As a
/// [QueuedInterceptor] it handles concurrent 401s one at a time, so a burst
/// of expired requests triggers a single refresh.
class AuthInterceptor extends QueuedInterceptor {
  new({
    required this.readAccessToken,
    required this.refreshAccessToken,
    required this.onSessionExpired,
    Dio? retryDio,
  }) : _retryDio = retryDio ?? Dio();

  final Future<String?> Function() readAccessToken;
  final FutureFailable<String> Function() refreshAccessToken;
  final Future<void> Function() onSessionExpired;

  /// Sends retries without this interceptor, so a retry can't loop.
  final Dio _retryDio;

  static const _authorization = 'Authorization';
  static const _retriedFlag = 'authInterceptorRetried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await readAccessToken();
      if (token != null) options.headers[_authorization] = 'Bearer $token';
      handler.next(options);
    } on Object catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final canRecover =
        err.response?.statusCode == 401 && options.extra[_retriedFlag] != true;
    if (!canRecover) {
      handler.next(err);
      return;
    }

    try {
      final token = await _newerToken(options);
      if (token == null) {
        await onSessionExpired();
        handler.next(err);
        return;
      }
      options
        ..headers[_authorization] = 'Bearer $token'
        ..extra[_retriedFlag] = true;
      handler.resolve(await _retryDio.fetch<Object?>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    } on Object catch (error, stackTrace) {
      handler.next(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Returns the stored token when another request already refreshed it,
  /// otherwise refreshes; `null` means the session can't be renewed.
  Future<String?> _newerToken(RequestOptions options) async {
    final stored = await readAccessToken();
    if (stored != null && options.headers[_authorization] != 'Bearer $stored') {
      return stored;
    }
    final refreshed = await refreshAccessToken();
    return refreshed.valueOrNull;
  }
}
