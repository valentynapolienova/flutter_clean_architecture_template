import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/page_slice.dart';
import 'package:clean_architecture_template/features/posts/application/posts_service.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/features/posts/domain/post_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';
import '../../../helpers/test_data.dart';

void main() {
  late MockPostsRepository postsRepository;
  late MockAuthorsRepository authorsRepository;
  late PostsService service;

  const page = PageSlice(items: testPosts, hasMore: false);

  setUp(() {
    postsRepository = MockPostsRepository();
    authorsRepository = MockAuthorsRepository();
    service = PostsService(
      postsRepository: postsRepository,
      authorsRepository: authorsRepository,
    );
  });

  group('PostsService', () {
    test('getPosts ignores whitespace around the query', () async {
      when(() => postsRepository.fetchPosts(skip: 0, limit: 20, query: 'love'))
          .thenAnswer((_) async => page);

      final result = await service.getPosts(
        skip: 0,
        limit: 20,
        query: '  love ',
      );

      expect(result, const Succeeded(page));
    });

    test('getPosts returns the failure the repository throws', () async {
      when(
        () => postsRepository.fetchPosts(
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
          query: any(named: 'query'),
        ),
      ).thenThrow(const NoConnectionFailure());

      final result = await service.getPosts(skip: 0, limit: 20);

      expect(result, const Failed<PageSlice<Post>>(NoConnectionFailure()));
    });

    test('getPostDetails combines the post with its author', () async {
      when(() => postsRepository.fetchPost(testPost.id))
          .thenAnswer((_) async => testPost);
      when(() => authorsRepository.fetchAuthor(testPost.authorId))
          .thenAnswer((_) async => testAuthor);

      final result = await service.getPostDetails(testPost.id);

      expect(result, const Succeeded<PostDetails>(testPostDetails));
    });
  });
}
