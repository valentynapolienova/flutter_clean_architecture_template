import 'package:equatable/equatable.dart';

final class User extends Equatable {
  const new({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  final int id;
  final String username;
  final String fullName;
  final String email;
  final String? avatarUrl;

  @override
  List<Object?> get props => [id, username, fullName, email, avatarUrl];
}
