import 'package:clean_architecture_template/features/posts/domain/author.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:equatable/equatable.dart';

/// A post with its author, put together by `PostsService`.
final class PostDetails extends Equatable {
  const new({required this.post, required this.author});

  final Post post;
  final Author author;

  @override
  List<Object?> get props => [post, author];
}
