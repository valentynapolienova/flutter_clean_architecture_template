import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/page_slice.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:clean_architecture_template/features/posts/presentation/cubits/posts_list/posts_list_cubit.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late MockPostsService service;

  const firstPage = PageSlice(items: [testPost], hasMore: true);
  const lastPage = PageSlice(items: [testSecondPost], hasMore: false);

  setUp(() {
    service = MockPostsService();
  });

  void stubPage(
    int skip,
    Failable<PageSlice<Post>> result, {
    String query = '',
  }) {
    when(() => service.getPosts(skip: skip, limit: 20, query: query))
        .thenAnswer((_) async => result);
  }

  group('PostsListCubit', () {
    blocTest<PostsListCubit, PostsListState>(
      'loads the first page',
      setUp: () => stubPage(0, const Succeeded(firstPage)),
      build: () => PostsListCubit(service),
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => const [
        PostsListLoading(),
        PostsListLoaded(posts: [testPost], hasMore: true),
      ],
    );

    blocTest<PostsListCubit, PostsListState>(
      'appends the next page',
      setUp: () {
        stubPage(0, const Succeeded(firstPage));
        stubPage(1, const Succeeded(lastPage));
      },
      build: () => PostsListCubit(service),
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      expect: () => const [
        PostsListLoading(),
        PostsListLoaded(posts: [testPost], hasMore: true),
        PostsListLoaded(posts: [testPost], hasMore: true, isLoadingMore: true),
        PostsListLoaded(posts: testPosts, hasMore: false),
      ],
    );

    blocTest<PostsListCubit, PostsListState>(
      'shows the failure when the first page fails',
      setUp: () => stubPage(0, const Failed(NoConnectionFailure())),
      build: () => PostsListCubit(service),
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => const [
        PostsListLoading(),
        PostsListFailed(NoConnectionFailure()),
      ],
    );

    blocTest<PostsListCubit, PostsListState>(
      'keeps the loaded posts when the next page fails',
      setUp: () {
        stubPage(0, const Succeeded(firstPage));
        stubPage(1, const Failed(TimeoutFailure()));
      },
      build: () => PostsListCubit(service),
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      skip: 2,
      expect: () => const [
        PostsListLoaded(posts: [testPost], hasMore: true, isLoadingMore: true),
        PostsListLoaded(
          posts: [testPost],
          hasMore: true,
          loadMoreFailure: TimeoutFailure(),
        ),
      ],
    );

    test('search waits for typing to pause, then reloads', () {
      fakeAsync((async) {
        stubPage(0, const Succeeded(firstPage), query: 'love');
        final cubit = PostsListCubit(service)
          ..search('lo')
          ..search('love');

        async.elapse(
          PostsListCubit.searchDelay - const Duration(milliseconds: 1),
        );
        verifyNever(
          () => service.getPosts(
            skip: any(named: 'skip'),
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          ),
        );

        async
          ..elapse(const Duration(milliseconds: 1))
          ..flushMicrotasks();
        verify(() => service.getPosts(skip: 0, limit: 20, query: 'love'))
            .called(1);
        expect(
          cubit.state,
          const PostsListLoaded(
            posts: [testPost],
            hasMore: true,
            query: 'love',
          ),
        );

        unawaited(cubit.close());
      });
    });
  });
}
