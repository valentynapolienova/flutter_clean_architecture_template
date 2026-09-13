import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/logging/app_logger.dart';
import 'package:dio/dio.dart';

/// JSON-over-HTTP client for one base URL.
///
/// Methods return decoded JSON or throw an [AppFailure], so repositories never
/// deal with Dio types or status codes they don't care about.
class ApiClient {
  new({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
    bool logRequests = false,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio
      ..options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      )
      ..interceptors.addAll([
        ...interceptors,
        if (logRequests)
          LogInterceptor(
            requestBody: true,
            logPrint: (line) => _log.debug('$line'),
          ),
      ]);
  }

  static const _log = AppLogger('ApiClient');

  final Dio _dio;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, Object?>? params,
  }) => _object(() => _dio.get<Object?>(path, queryParameters: params));

  Future<List<Object?>> getJsonList(
    String path, {
    Map<String, Object?>? params,
  }) async {
    final response = await _send(
      () => _dio.get<Object?>(path, queryParameters: params),
    );
    final data = response.data;
    if (data is List<Object?>) return data;
    throw ServerFailure(statusCode: response.statusCode);
  }

  Future<Map<String, dynamic>> postJson(String path, {Object? body}) =>
      _object(() => _dio.post<Object?>(path, data: body));

  Future<Map<String, dynamic>> putJson(String path, {Object? body}) =>
      _object(() => _dio.put<Object?>(path, data: body));

  Future<Map<String, dynamic>> patchJson(String path, {Object? body}) =>
      _object(() => _dio.patch<Object?>(path, data: body));

  Future<void> delete(String path) => _send(() => _dio.delete<Object?>(path));

  Future<Map<String, dynamic>> _object(
    Future<Response<Object?>> Function() request,
  ) async {
    final response = await _send(request);
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    throw ServerFailure(statusCode: response.statusCode);
  }

  Future<Response<Object?>> _send(
    Future<Response<Object?>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(_failureFrom(error), stackTrace);
    }
  }

  static AppFailure _failureFrom(DioException error) {
    // Interceptors may fail with an AppFailure, e.g. unreadable token storage.
    if (error.error case final AppFailure failure) return failure;
    return switch (error.type) {
      .connectionTimeout ||
      .sendTimeout ||
      .receiveTimeout ||
      .transformTimeout => const TimeoutFailure(),
      .connectionError => const NoConnectionFailure(),
      .badResponse when error.response?.statusCode == 401 =>
        const UnauthorizedFailure(),
      .badResponse => ServerFailure(statusCode: error.response?.statusCode),
      .cancel || .badCertificate || .unknown => UnexpectedFailure(error),
    };
  }
}
