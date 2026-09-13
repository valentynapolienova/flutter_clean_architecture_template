import 'package:clean_architecture_template/features/posts/domain/post.dart';

/// A post as the API sends it. Only repositories use it.
final class PostDto {
  const new({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
  });

  factory fromJson(Map<String, dynamic> json) {
    final reactions = json['reactions'] as Map<String, dynamic>;
    return PostDto(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      tags: List<String>.from(json['tags'] as List<dynamic>),
      likes: reactions['likes'] as int,
    );
  }

  final int id;
  final int userId;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;

  Post toDomain() => Post(
    id: id,
    authorId: userId,
    title: title,
    body: body,
    tags: tags,
    likes: likes,
  );
}
