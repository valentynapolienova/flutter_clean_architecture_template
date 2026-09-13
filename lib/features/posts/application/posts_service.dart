import 'package:clean_architecture_template/features/posts/data/authors_repository.dart';
import 'package:clean_architecture_template/features/posts/data/posts_repository.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/features/posts/domain/post_details.dart';
import 'package:clean_architecture_template/shared/result/failable.dart';
import 'package:clean_architecture_template/shared/result/page_slice.dart';
import 'package:clean_architecture_template/shared/result/repository_request_handler.dart';

class PostsService {
  const new({required this.postsRepository, required this.authorsRepository});

  final PostsRepository postsRepository;
  final AuthorsRepository authorsRepository;

  /// A page of posts. Surrounding whitespace in [query] is ignored.
  FutureFailable<PageSlice<Post>> getPosts({
    required int skip,
    required int limit,
    String query = '',
  }) {
    return RepositoryRequestHandler<PageSlice<Post>>()(
      request: () => postsRepository.fetchPosts(
        skip: skip,
        limit: limit,
        query: query.trim(),
      ),
    );
  }

  /// Combines two repositories, which is why it belongs in a service.
  FutureFailable<PostDetails> getPostDetails(int postId) {
    return RepositoryRequestHandler<PostDetails>()(
      request: () async {
        final post = await postsRepository.fetchPost(postId);
        final author = await authorsRepository.fetchAuthor(post.authorId);
        return PostDetails(post: post, author: author);
      },
    );
  }
}
