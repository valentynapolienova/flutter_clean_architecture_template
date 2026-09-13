import 'package:clean_architecture_template/features/auth/domain/auth_tokens.dart';
import 'package:clean_architecture_template/features/auth/domain/user.dart';
import 'package:equatable/equatable.dart';

/// What a successful sign-in returns.
final class AuthSession extends Equatable {
  const new({required this.user, required this.tokens});

  final User user;
  final AuthTokens tokens;

  @override
  List<Object?> get props => [user, tokens];
}
