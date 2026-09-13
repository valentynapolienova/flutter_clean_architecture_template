import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/features/posts/presentation/cubits/posts_list/posts_list_cubit.dart';
import 'package:clean_architecture_template/features/posts/presentation/pages/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_data.dart';

class MockPostsListCubit extends MockCubit<PostsListState>
    implements PostsListCubit;

void main() {
  late MockPostsListCubit cubit;

  setUp(() {
    cubit = MockPostsListCubit();
    when(() => cubit.loadFirstPage()).thenAnswer((_) async {});
    when(() => cubit.loadNextPage()).thenAnswer((_) async {});
    when(() => cubit.search(any())).thenAnswer((_) {});
  });

  Future<void> pumpPage(WidgetTester tester, PostsListState state) {
    whenListen(
      cubit,
      const Stream<PostsListState>.empty(),
      initialState: state,
    );
    return tester.pumpApp(
      BlocProvider<PostsListCubit>.value(
        value: cubit,
        child: const PostsPage(),
      ),
    );
  }

  group('PostsPage', () {
    testWidgets('shows a loader while the first page loads', (tester) async {
      await pumpPage(tester, const PostsListLoading());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('lists posts with a loader row while more exist', (
      tester,
    ) async {
      await pumpPage(
        tester,
        const PostsListLoaded(posts: testPosts, hasMore: true),
      );

      expect(find.text('First post'), findsOneWidget);
      expect(find.text('Second post'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('explains an empty search result', (tester) async {
      await pumpPage(
        tester,
        const PostsListLoaded(posts: [], hasMore: false, query: 'zzz'),
      );

      expect(find.text('No posts match your search.'), findsOneWidget);
    });

    testWidgets('shows the failure and retries', (tester) async {
      await pumpPage(tester, const PostsListFailed(NoConnectionFailure()));

      expect(
        find.text('No internet connection. Check your network and try again.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Retry'));
      verify(() => cubit.loadFirstPage()).called(1);
    });

    testWidgets('passes search input to the cubit', (tester) async {
      await pumpPage(
        tester,
        const PostsListLoaded(posts: testPosts, hasMore: false),
      );

      await tester.enterText(find.byType(TextField), 'love');

      verify(() => cubit.search('love')).called(1);
    });
  });
}
