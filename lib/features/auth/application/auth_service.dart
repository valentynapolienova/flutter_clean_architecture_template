import 'dart:async';

import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/repository_request_handler.dart';
import 'package:clean_architecture_template/core/storage/token_storage.dart';
import 'package:clean_architecture_template/features/auth/data/auth_repository.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';

/// Signs users in and out and owns their tokens.
class AuthService {
  new({required this.repository, required this.tokenStorage});

  final AuthRepository repository;
  final TokenStorage tokenStorage;

  final StreamController<User?> _userChanges = .broadcast();

  /// Emits the user after sign-in and `null` after sign-out, including a
  /// sign-out triggered by the network layer when a session can't be renewed.
  Stream<User?> get userChanges => _userChanges.stream;

  /// Loads the user of the session stored on this device, or `null` when no
  /// one is signed in.
  FutureFailable<User?> restoreSession() {
    return RepositoryRequestHandler<User?>()(
      request: () async {
        final token = await tokenStorage.readAccessToken();
        if (token == null) return null;
        return await repository.fetchCurrentUser();
      },
    );
  }

  FutureFailable<User> signIn({
    required String username,
    required String password,
  }) {
    return RepositoryRequestHandler<User>()(
      request: () async {
        final session = await repository.signIn(
          username: username,
          password: password,
        );
        await tokenStorage.saveTokens(
          accessToken: session.tokens.accessToken,
          refreshToken: session.tokens.refreshToken,
        );
        _userChanges.add(session.user);
        return session.user;
      },
    );
  }

  FutureFailable<void> signOut() {
    return RepositoryRequestHandler<void>()(
      request: () async {
        try {
          await tokenStorage.clear();
        } finally {
          // Sign out in the app even if the tokens couldn't be deleted.
          _userChanges.add(null);
        }
      },
    );
  }

  /// Trades the stored refresh token for new tokens and returns the new
  /// access token. Used by `AuthInterceptor` when a request gets a 401.
  FutureFailable<String> refreshAccessToken() {
    return RepositoryRequestHandler<String>()(
      request: () async {
        final refreshToken = await tokenStorage.readRefreshToken();
        if (refreshToken == null) throw const UnauthorizedFailure();
        final tokens = await repository.refreshTokens(refreshToken);
        await tokenStorage.saveTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
        return tokens.accessToken;
      },
    );
  }

  Future<void> dispose() => _userChanges.close();
}
