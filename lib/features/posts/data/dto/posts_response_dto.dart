import 'package:clean_architecture_template/features/posts/data/dto/post_dto.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/shared/result/page_slice.dart';

/// A page of posts with the API's paging fields.
final class PostsResponseDto {
  const new({required this.posts, required this.total, required this.skip});

  factory fromJson(Map<String, dynamic> json) {
    return PostsResponseDto(
      posts: (json['posts'] as List<dynamic>)
          .map((item) => PostDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] as int,
    );
  }

  final List<PostDto> posts;
  final int total;
  final int skip;

  PageSlice<Post> toDomain() => PageSlice(
    items: posts.map((post) => post.toDomain()).toList(),
    hasMore: skip + posts.length < total,
  );
}
