import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/features/auth/data/auth_repository.dart';
import 'package:clean_architecture_template/features/auth/domain/auth_session.dart';
import 'package:clean_architecture_template/features/auth/domain/auth_tokens.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockApiClient publicApi;
  late MockApiClient api;
  late AuthRepository repository;

  const userJson = <String, dynamic>{
    'id': 1,
    'username': 'emilys',
    'email': 'emily@example.com',
    'firstName': 'Emily',
    'lastName': 'Johnson',
    'image': 'https://example.com/emily.png',
  };

  const user = User(
    id: 1,
    username: 'emilys',
    fullName: 'Emily Johnson',
    email: 'emily@example.com',
    avatarUrl: 'https://example.com/emily.png',
  );

  setUp(() {
    publicApi = MockApiClient();
    api = MockApiClient();
    repository = AuthRepository(publicApi: publicApi, api: api);
  });

  group('AuthRepository', () {
    test('signIn sends the credentials and maps the session', () async {
      when(() => publicApi.postJson('/auth/login', body: any(named: 'body')))
          .thenAnswer(
            (_) async => {
              ...userJson,
              'accessToken': 'access',
              'refreshToken': 'refresh',
            },
          );

      final session = await repository.signIn(
        username: 'emilys',
        password: 'secret',
      );

      expect(
        session,
        const AuthSession(
          user: user,
          tokens: AuthTokens(accessToken: 'access', refreshToken: 'refresh'),
        ),
      );
      final body = verify(
        () =>
            publicApi.postJson('/auth/login', body: captureAny(named: 'body')),
      ).captured.single;
      expect(body, {'username': 'emilys', 'password': 'secret'});
    });

    test('signIn reports wrong credentials', () async {
      when(() => publicApi.postJson('/auth/login', body: any(named: 'body')))
          .thenThrow(const ServerFailure(statusCode: 400));

      await expectLater(
        repository.signIn(username: 'emilys', password: 'wrong'),
        throwsA(const InvalidCredentialsFailure()),
      );
    });

    test('fetchCurrentUser uses the authenticated client', () async {
      when(() => api.getJson('/auth/me')).thenAnswer((_) async => userJson);

      expect(await repository.fetchCurrentUser(), user);
      verifyZeroInteractions(publicApi);
    });

    test('refreshTokens exchanges the refresh token', () async {
      when(
        () => publicApi.postJson('/auth/refresh', body: any(named: 'body')),
      ).thenAnswer(
        (_) async => {'accessToken': 'access-2', 'refreshToken': 'refresh-2'},
      );

      final tokens = await repository.refreshTokens('refresh');

      expect(
        tokens,
        const AuthTokens(accessToken: 'access-2', refreshToken: 'refresh-2'),
      );
    });
  });
}
