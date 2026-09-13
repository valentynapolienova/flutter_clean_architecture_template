import 'package:clean_architecture_template/features/auth/domain/user.dart';

/// User fields as the API sends them.
final class UserDto {
  const new({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  factory fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      image: json['image'] as String?,
    );
  }

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;

  User toDomain() => User(
    id: id,
    username: username,
    fullName: '$firstName $lastName',
    email: email,
    avatarUrl: image,
  );
}
