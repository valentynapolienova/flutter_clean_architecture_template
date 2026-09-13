import 'package:clean_architecture_template/features/posts/data/posts_repository.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/shared/result/page_slice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  late MockApiClient api;
  late PostsRepository repository;

  Map<String, dynamic> postJson(int id) => {
    'id': id,
    'userId': 7,
    'title': 'Post $id',
    'body': 'Body $id',
    'tags': ['history'],
    'reactions': {'likes': 3, 'dislikes': 0},
    'views': 10,
  };

  Post post(int id) => Post(
    id: id,
    authorId: 7,
    title: 'Post $id',
    body: 'Body $id',
    tags: const ['history'],
    likes: 3,
  );

  setUp(() {
    api = MockApiClient();
    repository = PostsRepository(api: api);
  });

  group('PostsRepository', () {
    test('fetchPosts maps a page and reports that more exist', () async {
      when(() => api.getJson('/auth/posts', params: any(named: 'params')))
          .thenAnswer(
            (_) async => {
              'posts': [postJson(1), postJson(2)],
              'total': 5,
              'skip': 0,
              'limit': 2,
            },
          );

      final page = await repository.fetchPosts(skip: 0, limit: 2);

      expect(page, PageSlice(items: [post(1), post(2)], hasMore: true));
      final params = verify(
        () => api.getJson('/auth/posts', params: captureAny(named: 'params')),
      ).captured.single;
      expect(params, {'skip': 0, 'limit': 2});
    });

    test('fetchPosts searches when a query is given', () async {
      when(
        () => api.getJson('/auth/posts/search', params: any(named: 'params')),
      ).thenAnswer(
        (_) async => {
          'posts': [postJson(4)],
          'total': 5,
          'skip': 4,
          'limit': 2,
        },
      );

      final page = await repository.fetchPosts(
        skip: 4,
        limit: 2,
        query: 'love',
      );

      expect(page, PageSlice(items: [post(4)], hasMore: false));
      final params = verify(
        () => api.getJson(
          '/auth/posts/search',
          params: captureAny(named: 'params'),
        ),
      ).captured.single;
      expect(params, {'skip': 4, 'limit': 2, 'q': 'love'});
    });

    test('fetchPost maps a single post', () async {
      when(() => api.getJson('/auth/posts/3'))
          .thenAnswer((_) async => postJson(3));

      expect(await repository.fetchPost(3), post(3));
    });
  });
}
