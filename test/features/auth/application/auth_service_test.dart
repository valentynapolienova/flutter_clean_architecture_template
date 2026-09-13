import 'package:clean_architecture_template/features/auth/application/auth_service.dart';
import 'package:clean_architecture_template/features/auth/domain/auth_session.dart';
import 'package:clean_architecture_template/features/auth/domain/auth_tokens.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:clean_architecture_template/shared/errors/app_failure.dart';
import 'package:clean_architecture_template/shared/result/failable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockAuthRepository repository;
  late MockTokenStorage tokenStorage;
  late AuthService service;

  setUp(() {
    repository = MockAuthRepository();
    tokenStorage = MockTokenStorage();
    service = AuthService(repository: repository, tokenStorage: tokenStorage);
    when(
      () => tokenStorage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => service.dispose());

  group('signIn', () {
    test('saves the tokens and announces the user', () async {
      when(() => repository.signIn(username: 'emilys', password: 'secret'))
          .thenAnswer(
            (_) async => const AuthSession(user: testUser, tokens: testTokens),
          );

      final announced = expectLater(service.userChanges, emits(testUser));
      final result = await service.signIn(
        username: 'emilys',
        password: 'secret',
      );

      expect(result, const Succeeded(testUser));
      await announced;
      verify(
        () => tokenStorage.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
    });

    test('returns the failure and stores nothing', () async {
      when(
        () => repository.signIn(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const InvalidCredentialsFailure());

      final result = await service.signIn(username: 'emilys', password: 'x');

      expect(result, const Failed<User>(InvalidCredentialsFailure()));
      verifyNever(
        () => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      );
    });
  });

  group('restoreSession', () {
    test(
      'returns null without calling the API when no token is stored',
      () async {
        when(() => tokenStorage.readAccessToken())
            .thenAnswer((_) async => null);

        final result = await service.restoreSession();

        expect(result, const Succeeded<User?>(null));
        verifyNever(() => repository.fetchCurrentUser());
      },
    );

    test('loads the user when a token is stored', () async {
      when(() => tokenStorage.readAccessToken())
          .thenAnswer((_) async => 'access');
      when(() => repository.fetchCurrentUser())
          .thenAnswer((_) async => testUser);

      expect(await service.restoreSession(), const Succeeded<User?>(testUser));
    });
  });

  test('signOut clears the tokens and announces null', () async {
    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    final announced = expectLater(service.userChanges, emits(isNull));
    final result = await service.signOut();

    expect(result, isA<Succeeded<void>>());
    await announced;
    verify(() => tokenStorage.clear()).called(1);
  });

  group('refreshAccessToken', () {
    test('saves the new tokens and returns the access token', () async {
      when(() => tokenStorage.readRefreshToken())
          .thenAnswer((_) async => 'refresh');
      when(() => repository.refreshTokens('refresh')).thenAnswer(
        (_) async => const AuthTokens(
          accessToken: 'access-2',
          refreshToken: 'refresh-2',
        ),
      );

      final result = await service.refreshAccessToken();

      expect(result, const Succeeded('access-2'));
      verify(
        () => tokenStorage.saveTokens(
          accessToken: 'access-2',
          refreshToken: 'refresh-2',
        ),
      ).called(1);
    });

    test('fails when no refresh token is stored', () async {
      when(() => tokenStorage.readRefreshToken()).thenAnswer((_) async => null);

      final result = await service.refreshAccessToken();

      expect(result, const Failed<String>(UnauthorizedFailure()));
      verifyNever(() => repository.refreshTokens(any()));
    });
  });
}
