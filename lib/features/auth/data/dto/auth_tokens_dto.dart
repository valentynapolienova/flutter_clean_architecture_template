import 'package:clean_architecture_template/features/auth/domain/auth_tokens.dart';

final class AuthTokensDto {
  const new({required this.accessToken, required this.refreshToken});

  factory fromJson(Map<String, dynamic> json) {
    return AuthTokensDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  final String accessToken;
  final String refreshToken;

  AuthTokens toDomain() =>
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
}
