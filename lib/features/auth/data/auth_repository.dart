import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/network/api_client.dart';
import 'package:clean_architecture_template/features/auth/data/dto/auth_tokens_dto.dart';
import 'package:clean_architecture_template/features/auth/data/dto/user_dto.dart';
import 'package:clean_architecture_template/features/auth/domain/auth_session.dart';
import 'package:clean_architecture_template/features/auth/domain/auth_tokens.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';

/// Talks to the auth endpoints of DummyJSON (https://dummyjson.com/docs/auth).
/// Replace the paths and DTOs to connect your own backend.
class AuthRepository {
  const new({required this.publicApi, required this.api});

  /// Sends requests without a token: sign-in and token refresh.
  final ApiClient publicApi;

  /// Sends requests with the current token.
  final ApiClient api;

  Future<AuthSession> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final json = await publicApi.postJson(
        '/auth/login',
        body: {'username': username, 'password': password},
      );
      return AuthSession(
        user: UserDto.fromJson(json).toDomain(),
        tokens: AuthTokensDto.fromJson(json).toDomain(),
      );
    } on ServerFailure catch (failure) {
      // This API answers wrong credentials with 400.
      if (failure.statusCode == 400) throw const InvalidCredentialsFailure();
      rethrow;
    }
  }

  Future<AuthTokens> refreshTokens(String refreshToken) async {
    final json = await publicApi.postJson(
      '/auth/refresh',
      body: {'refreshToken': refreshToken},
    );
    return AuthTokensDto.fromJson(json).toDomain();
  }

  Future<User> fetchCurrentUser() async {
    final json = await api.getJson('/auth/me');
    return UserDto.fromJson(json).toDomain();
  }
}
