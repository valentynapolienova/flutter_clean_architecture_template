import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;

  ApiClient clientAnswering(
    Future<ResponseBody> Function(RequestOptions options) respond,
  ) {
    adapter = FakeHttpAdapter(respond);
    return ApiClient(
      baseUrl: 'https://api.test',
      dio: Dio()..httpClientAdapter = adapter,
    );
  }

  group('ApiClient', () {
    test('returns the decoded JSON object', () async {
      final client = clientAnswering(
        (_) async => FakeHttpAdapter.json({'id': 1}),
      );

      final json = await client.getJson('/items/1', params: {'full': true});

      expect(json, {'id': 1});
      expect(
        adapter.requests.single.uri.toString(),
        'https://api.test/items/1?full=true',
      );
    });

    test('throws UnauthorizedFailure for 401', () async {
      final client = clientAnswering(
        (_) async => FakeHttpAdapter.json({}, statusCode: 401),
      );

      await expectLater(
        client.getJson('/me'),
        throwsA(const UnauthorizedFailure()),
      );
    });

    test(
      'throws ServerFailure with the status code for other errors',
      () async {
        final client = clientAnswering(
          (_) async => FakeHttpAdapter.json({}, statusCode: 500),
        );

        await expectLater(
          client.postJson('/items', body: {'name': 'x'}),
          throwsA(const ServerFailure(statusCode: 500)),
        );
      },
    );

    test('throws ServerFailure when the body is not a JSON object', () async {
      final client = clientAnswering((_) async => FakeHttpAdapter.json([1, 2]));

      await expectLater(
        client.getJson('/items'),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('throws NoConnectionFailure when the host is unreachable', () async {
      final client = clientAnswering(
        (options) async => throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        ),
      );

      await expectLater(
        client.getJson('/items'),
        throwsA(const NoConnectionFailure()),
      );
    });
  });
}
