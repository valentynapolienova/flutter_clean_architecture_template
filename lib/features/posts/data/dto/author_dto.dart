import 'package:clean_architecture_template/features/posts/domain/author.dart';

/// The user fields a post screen needs, as the API sends them.
final class AuthorDto {
  const new({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory fromJson(Map<String, dynamic> json) {
    return AuthorDto(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  final int id;
  final String firstName;
  final String lastName;

  Author toDomain() => Author(id: id, fullName: '$firstName $lastName');
}
