import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/page_slice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Offset-based paging for cubits.
///
/// The mixin keeps the items loaded so far, ignores [loadNextPage] while a
/// page is on its way, and drops pages that arrive after [loadFirstPage]
/// started over. The cubit fetches a page and turns the callbacks into
/// states.
mixin PagingMixin<S, T> on Cubit<S> {
  final List<T> _items = [];
  bool _hasMore = true;
  bool _isLoading = false;
  int _generation = 0;

  /// Items requested per page.
  int get pageSize => 20;

  FutureFailable<PageSlice<T>> fetchPage({
    required int offset,
    required int limit,
  });

  /// Called before each request; [isFirstPage] is false when appending.
  void onPageLoading({required bool isFirstPage});

  /// Called with every item loaded so far.
  void onPageLoaded({required List<T> items, required bool hasMore});

  void onPageFailed(AppFailure failure, {required bool isFirstPage});

  /// Forgets loaded items and fetches from the start.
  Future<void> loadFirstPage() {
    _generation++;
    _items.clear();
    _hasMore = true;
    return _load(isFirstPage: true);
  }

  /// Fetches the next page, unless one is loading or none are left.
  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore || _items.isEmpty) return;
    await _load(isFirstPage: false);
  }

  Future<void> _load({required bool isFirstPage}) async {
    final generation = _generation;
    _isLoading = true;
    onPageLoading(isFirstPage: isFirstPage);

    final result = await fetchPage(offset: _items.length, limit: pageSize);
    if (isClosed || generation != _generation) return;

    _isLoading = false;
    result.when(
      success: (page) {
        _items.addAll(page.items);
        _hasMore = page.hasMore;
        onPageLoaded(items: List.unmodifiable(_items), hasMore: _hasMore);
      },
      failure: (failure) => onPageFailed(failure, isFirstPage: isFirstPage),
    );
  }
}
