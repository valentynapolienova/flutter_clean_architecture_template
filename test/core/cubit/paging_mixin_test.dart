import 'dart:async';

import 'package:clean_architecture_template/core/cubit/paging_mixin.dart';
import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/page_slice.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records the mixin callbacks as readable strings.
class _NumbersCubit extends Cubit<List<String>>
    with PagingMixin<List<String>, int> {
  new(this._fetch) : super(const []);

  final FutureFailable<PageSlice<int>> Function(int offset) _fetch;

  @override
  int get pageSize => 2;

  @override
  FutureFailable<PageSlice<int>> fetchPage({
    required int offset,
    required int limit,
  }) => _fetch(offset);

  @override
  void onPageLoading({required bool isFirstPage}) =>
      emit([...state, 'loading first:$isFirstPage']);

  @override
  void onPageLoaded({required List<int> items, required bool hasMore}) =>
      emit([...state, 'loaded $items more:$hasMore']);

  @override
  void onPageFailed(AppFailure failure, {required bool isFirstPage}) =>
      emit([...state, 'failed first:$isFirstPage']);
}

void main() {
  group('PagingMixin', () {
    test('appends pages until no more are left', () async {
      final offsets = <int>[];
      final cubit = _NumbersCubit((offset) async {
        offsets.add(offset);
        return Succeeded(
          PageSlice(items: [offset, offset + 1], hasMore: offset == 0),
        );
      });
      addTearDown(cubit.close);

      await cubit.loadFirstPage();
      await cubit.loadNextPage();
      await cubit.loadNextPage();

      expect(offsets, [0, 2]);
      expect(cubit.state.last, 'loaded [0, 1, 2, 3] more:false');
    });

    test('ignores loadNextPage while a page is loading', () async {
      final nextPage = Completer<Failable<PageSlice<int>>>();
      var requests = 0;
      final cubit = _NumbersCubit((offset) {
        requests++;
        if (offset == 0) {
          return Future.value(
            const Succeeded(PageSlice(items: [0, 1], hasMore: true)),
          );
        }
        return nextPage.future;
      });
      addTearDown(cubit.close);

      await cubit.loadFirstPage();
      final firstCall = cubit.loadNextPage();
      await cubit.loadNextPage();
      nextPage.complete(const Succeeded(PageSlice(items: [2], hasMore: false)));
      await firstCall;

      expect(requests, 2);
    });

    test('drops a page that arrives after the list started over', () async {
      final stalePage = Completer<Failable<PageSlice<int>>>();
      var firstPageRequests = 0;
      final cubit = _NumbersCubit((offset) {
        if (offset == 2) return stalePage.future;
        firstPageRequests++;
        final isInitial = firstPageRequests == 1;
        return Future.value(
          Succeeded(
            PageSlice(items: isInitial ? [0, 1] : [10, 11], hasMore: isInitial),
          ),
        );
      });
      addTearDown(cubit.close);

      await cubit.loadFirstPage();
      final staleCall = cubit.loadNextPage();
      await cubit.loadFirstPage();
      stalePage.complete(
        const Succeeded(PageSlice(items: [2, 3], hasMore: false)),
      );
      await staleCall;

      expect(cubit.state.last, 'loaded [10, 11] more:false');
    });

    test('reports a failed page', () async {
      final cubit = _NumbersCubit(
        (_) async => const Failed(NoConnectionFailure()),
      );
      addTearDown(cubit.close);

      await cubit.loadFirstPage();

      expect(cubit.state, ['loading first:true', 'failed first:true']);
    });
  });
}
