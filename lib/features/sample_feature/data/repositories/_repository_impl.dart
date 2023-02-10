import 'package:clean_architecture_template/core/error/failures.dart';
import 'package:clean_architecture_template/core/error/repository_request_handler.dart';
import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/features/sample_feature/data/datasource/_datasource.dart';
import 'package:clean_architecture_template/features/sample_feature/domain/repositories/_repository.dart';

class RepositoryImpl implements Repository {
  final Datasource datasource;

  RepositoryImpl({required this.datasource});

  @override
  FutureFailable<bool> getFunction() {
    return RepositoryRequestHandler<bool>()(
      request: () => datasource.getFunction(),
      defaultFailure: Failure(),
    );
  }
}
