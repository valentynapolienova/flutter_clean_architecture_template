import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:dartz/dartz.dart';

import 'exceptions.dart';
import 'failures.dart';

class RepositoryRequestHandler<T> {
  FutureFailable<T> call({
    Failure? defaultFailure,
    required Future<T> Function() request,
  }) async {
    try {
      return Right(await request());
    } catch (error) {
      final failure = await errorHandler(error, defaultFailure);
      //var _errorMessage = '[ERROR] Failure: ${failure.toString()}; Error: ${error.toString()};';
      return Left(failure);
    }
  }
}
