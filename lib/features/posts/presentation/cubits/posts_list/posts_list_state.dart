part of 'posts_list_cubit.dart';

sealed class PostsListState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

final class PostsListInitial extends PostsListState {
  const new();
}

final class PostsListLoading extends PostsListState {
  const new();
}

final class PostsListLoaded extends PostsListState {
  const new({
    required this.posts,
    required this.hasMore,
    this.query = '',
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<Post> posts;
  final bool hasMore;

  /// The search the posts were loaded for; empty when not searching.
  final String query;
  final bool isLoadingMore;

  /// Why the last attempt to load more failed.
  final AppFailure? loadMoreFailure;

  /// [loadMoreFailure] isn't carried over, so each new attempt starts clean.
  PostsListLoaded copyWith({bool? isLoadingMore, AppFailure? loadMoreFailure}) {
    return PostsListLoaded(
      posts: posts,
      hasMore: hasMore,
      query: query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailure: loadMoreFailure,
    );
  }

  @override
  List<Object?> get props => [
    posts,
    hasMore,
    query,
    isLoadingMore,
    loadMoreFailure,
  ];
}

final class PostsListFailed extends PostsListState {
  const new(this.failure);

  final AppFailure failure;

  @override
  List<Object?> get props => [failure];
}
