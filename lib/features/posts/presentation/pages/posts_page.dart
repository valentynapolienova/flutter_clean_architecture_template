import 'dart:async';

import 'package:clean_architecture_template/app/router/routes.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/extensions/build_context_x.dart';
import 'package:clean_architecture_template/core/theme/spacing.dart';
import 'package:clean_architecture_template/core/widgets/error_view.dart';
import 'package:clean_architecture_template/core/widgets/page_loader.dart';
import 'package:clean_architecture_template/core/widgets/theme_mode_button.dart';
import 'package:clean_architecture_template/features/auth/presentation/widgets/sign_out_button.dart';
import 'package:clean_architecture_template/features/posts/presentation/cubits/posts_list/posts_list_cubit.dart';
import 'package:clean_architecture_template/features/posts/presentation/widgets/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostsListCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.postsTitle),
        actions: const [ThemeModeButton(), SignOutButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.m,
              Spacing.s,
              Spacing.m,
              Spacing.s,
            ),
            child: SearchBar(
              hintText: context.l10n.searchPostsHint,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: cubit.search,
            ),
          ),
          Expanded(
            child: BlocBuilder<PostsListCubit, PostsListState>(
              builder: (context, state) => switch (state) {
                PostsListInitial() || PostsListLoading() => const PageLoader(),
                PostsListFailed(:final failure) => ErrorView(
                  failure: failure,
                  onRetry: cubit.loadFirstPage,
                ),
                PostsListLoaded(:final posts, :final query)
                    when posts.isEmpty =>
                  Center(
                    child: Text(
                      query.isEmpty
                          ? context.l10n.noPostsYet
                          : context.l10n.noPostsFound,
                    ),
                  ),
                final PostsListLoaded loaded => _PostsList(state: loaded),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PostsList extends StatelessWidget {
  const new({required this.state});

  final PostsListLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostsListCubit>();
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Start the next page shortly before the end of the list. After a
        // failure, the footer's retry button takes over.
        if (notification.metrics.extentAfter < 400 &&
            state.loadMoreFailure == null) {
          unawaited(cubit.loadNextPage());
        }
        return false;
      },
      child: ListView.separated(
        itemCount: state.posts.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == state.posts.length) {
            return _LoadMoreFooter(
              failure: state.loadMoreFailure,
              onRetry: cubit.loadNextPage,
            );
          }
          final post = state.posts[index];
          return PostTile(
            post: post,
            onTap: () => context.go(Routes.postDetails(post.id)),
          );
        },
      ),
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const new({required this.failure, required this.onRetry});

  final AppFailure? failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(Spacing.m),
      child: Center(
        child: failure == null
            ? const CircularProgressIndicator()
            : TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
      ),
    );
  }
}
