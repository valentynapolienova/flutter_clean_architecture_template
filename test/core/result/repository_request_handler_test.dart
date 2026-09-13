import 'package:clean_architecture_template/core/errors/app_failure.dart';
import 'package:clean_architecture_template/core/result/failable.dart';
import 'package:clean_architecture_template/core/result/repository_request_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RepositoryRequestHandler', () {
    test('wraps the returned value in Succeeded', () async {
      final result = await RepositoryRequestHandler<int>()(
        request: () async => 42,
      );

      expect(result, const Succeeded(42));
      expect(result.valueOrNull, 42);
    });

    test('returns a thrown AppFailure as Failed', () async {
      final result = await RepositoryRequestHandler<int>()(
        request: () async => throw const ServerFailure(statusCode: 503),
      );

      expect(result, const Failed<int>(ServerFailure(statusCode: 503)));
      expect(result.valueOrNull, isNull);
    });

    test('turns any other error into UnexpectedFailure', () async {
      final result = await RepositoryRequestHandler<int>()(
        request: () async => ('not a number' as Object) as int,
      );

      expect(result, const Failed<int>(UnexpectedFailure()));
    });

    test('when calls the callback that matches the outcome', () {
      const Failable<int> success = Succeeded(1);
      const Failable<int> failure = Failed(TimeoutFailure());

      String describe(Failable<int> result) => result.when(
        success: (value) => 'value $value',
        failure: (failure) => 'failure $failure',
      );

      expect(describe(success), 'value 1');
      expect(describe(failure), 'failure TimeoutFailure()');
    });
  });
}
