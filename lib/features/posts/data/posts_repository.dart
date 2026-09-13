import 'package:clean_architecture_template/features/posts/data/dto/post_dto.dart';
import 'package:clean_architecture_template/features/posts/data/dto/posts_response_dto.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/shared/network/api_client.dart';
import 'package:clean_architecture_template/shared/result/page_slice.dart';

class PostsRepository {
  const new({required this.api});

  final ApiClient api;

  /// Fetches a page of posts, filtered by [query] when it isn't empty.
  Future<PageSlice<Post>> fetchPosts({
    required int skip,
    required int limit,
    String query = '',
  }) async {
    final json = await api.getJson(
      query.isEmpty ? '/auth/posts' : '/auth/posts/search',
      params: {'skip': skip, 'limit': limit, if (query.isNotEmpty) 'q': query},
    );
    return PostsResponseDto.fromJson(json).toDomain();
  }

  Future<Post> fetchPost(int postId) async {
    final json = await api.getJson('/auth/posts/$postId');
    return PostDto.fromJson(json).toDomain();
  }
}
