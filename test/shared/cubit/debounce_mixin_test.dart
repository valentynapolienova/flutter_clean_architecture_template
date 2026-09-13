import 'dart:async';

import 'package:clean_architecture_template/shared/cubit/debounce_mixin.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _CounterCubit extends Cubit<int> with DebounceMixin<int> {
  new() : super(0);

  void bump() => debounce(const Duration(milliseconds: 300), () {
    emit(state + 1);
  });
}

void main() {
  group('DebounceMixin', () {
    test('runs only the last call, after the delay', () {
      fakeAsync((async) {
        final cubit = _CounterCubit()
          ..bump()
          ..bump();

        async.elapse(const Duration(milliseconds: 299));
        expect(cubit.state, 0);

        async.elapse(const Duration(milliseconds: 1));
        expect(cubit.state, 1);

        unawaited(cubit.close());
      });
    });

    test('drops a pending call when the cubit closes', () {
      fakeAsync((async) {
        final cubit = _CounterCubit()..bump();

        unawaited(cubit.close());
        async.elapse(const Duration(seconds: 1));

        expect(cubit.state, 0);
      });
    });
  });
}
