import 'package:equatable/equatable.dart';

final class AuthTokens extends Equatable {
  const new({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
