import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/network/auth_interceptor.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  // Tokens returned by successive reads; the last one repeats.
  late List<String?> storedTokens;
  late FutureFailable<String> Function() refresh;
  late int refreshCalls;
  late int expiredCalls;
  late FakeHttpAdapter adapter;
  late Dio dio;

  setUp(() {
    storedTokens = ['valid'];
    refresh = () async => const Failed(UnauthorizedFailure());
    refreshCalls = 0;
    expiredCalls = 0;
    // The fake server accepts only the token "valid".
    adapter = FakeHttpAdapter(
      (options) async => options.headers['Authorization'] == 'Bearer valid'
          ? FakeHttpAdapter.json({'ok': true})
          : FakeHttpAdapter.json({'message': 'expired'}, statusCode: 401),
    );
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          readAccessToken: () async => storedTokens.length > 1
              ? storedTokens.removeAt(0)
              : storedTokens.single,
          refreshAccessToken: () {
            refreshCalls++;
            return refresh();
          },
          onSessionExpired: () async {
            expiredCalls++;
          },
          retryDio: Dio()..httpClientAdapter = adapter,
        ),
      );
  });

  group('AuthInterceptor', () {
    test('sends the stored token', () async {
      final response = await dio.get<Object?>('/me');

      expect(response.data, {'ok': true});
      expect(refreshCalls, 0);
    });

    test('refreshes an expired token and retries the request', () async {
      storedTokens = ['expired'];
      refresh = () async {
        storedTokens = ['valid'];
        return const Succeeded('valid');
      };

      final response = await dio.get<Object?>('/me');

      expect(response.data, {'ok': true});
      expect(refreshCalls, 1);
      expect(adapter.requests, hasLength(2));
    });

    test('reuses a token that another request already refreshed', () async {
      storedTokens = ['expired', 'valid'];

      final response = await dio.get<Object?>('/me');

      expect(response.data, {'ok': true});
      expect(refreshCalls, 0);
    });

    test('ends the session when the token cannot be refreshed', () async {
      storedTokens = ['expired'];

      await expectLater(
        dio.get<Object?>('/me'),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'status code',
            401,
          ),
        ),
      );
      expect(refreshCalls, 1);
      expect(expiredCalls, 1);
    });
  });
}
