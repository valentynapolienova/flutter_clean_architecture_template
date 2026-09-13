import 'dart:async';

import 'package:clean_architecture_template/core/cubit/debounce_mixin.dart';
import 'package:clean_architecture_template/core/cubit/emit_guard_mixin.dart';
import 'package:clean_architecture_template/core/cubit/paging_mixin.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/page_slice.dart';
import 'package:clean_architecture_template/features/posts/application/posts_service.dart';
import 'package:clean_architecture_template/features/posts/domain/post.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'posts_list_state.dart';

/// A paged, searchable list of posts.
class PostsListCubit extends Cubit<PostsListState>
    with EmitGuardMixin, DebounceMixin, PagingMixin<PostsListState, Post> {
  new(this._service) : super(const PostsListInitial());

  static const searchDelay = Duration(milliseconds: 400);

  final PostsService _service;
  String _query = '';

  /// Reloads the list for [query] once the user stops typing.
  void search(String query) {
    debounce(searchDelay, () {
      if (query == _query) return;
      _query = query;
      unawaited(loadFirstPage());
    });
  }

  @override
  FutureFailable<PageSlice<Post>> fetchPage({
    required int offset,
    required int limit,
  }) => _service.getPosts(skip: offset, limit: limit, query: _query);

  @override
  void onPageLoading({required bool isFirstPage}) {
    if (isFirstPage) {
      emitIfOpen(const PostsListLoading());
    } else if (state case final PostsListLoaded loaded) {
      emitIfOpen(loaded.copyWith(isLoadingMore: true));
    }
  }

  @override
  void onPageLoaded({required List<Post> items, required bool hasMore}) {
    emitIfOpen(PostsListLoaded(posts: items, hasMore: hasMore, query: _query));
  }

  @override
  void onPageFailed(AppFailure failure, {required bool isFirstPage}) {
    if (isFirstPage) {
      emitIfOpen(PostsListFailed(failure));
    } else if (state case final PostsListLoaded loaded) {
      emitIfOpen(
        loaded.copyWith(isLoadingMore: false, loadMoreFailure: failure),
      );
    }
  }
}
