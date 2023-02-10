import 'package:clean_architecture_template/core/helper/type_aliases.dart';

abstract class Repository {
  FutureFailable<bool> getFunction();
}
