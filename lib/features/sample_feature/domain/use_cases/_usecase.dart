import 'package:clean_architecture_template/core/helper/type_aliases.dart';
import 'package:clean_architecture_template/core/usecase/usecase.dart';
import 'package:clean_architecture_template/features/sample_feature/domain/repositories/_repository.dart';

class GetFunctionUsecase extends Usecase<bool, NoParams> {
  GetFunctionUsecase({
    required this.repository,
  });

  final Repository repository;

  @override
  FutureFailable<bool> call(NoParams param) {
    return repository.getFunction();
  }
}