import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  const new({
    required this.id,
    required this.authorId,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
  });

  final int id;
  final int authorId;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;

  @override
  List<Object?> get props => [id, authorId, title, body, tags, likes];
}
