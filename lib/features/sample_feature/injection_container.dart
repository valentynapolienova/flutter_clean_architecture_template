import 'package:clean_architecture_template/features/sample_feature/presentation/flow_1/cubit/_cubit.dart';
import 'package:clean_architecture_template/injection_container.dart';
import 'package:dio/dio.dart';

import 'data/datasource/_datasource.dart';
import 'data/repositories/_repository_impl.dart';
import 'domain/repositories/_repository.dart';

mixin SampleInjector on Injector {
  @override
  Future<void> init() async {
    await super.init();
    final Dio dio = sl<Dio>(instanceName: globalDio);

    // cubits
    sl.registerLazySingleton(() => SampleCubit(repository: sl()));

    // use cases

    // repositories
    sl.registerLazySingleton<Repository>(
        () => RepositoryImpl(datasource: sl()));

    // data sources
    sl.registerLazySingleton<Datasource>(() => DatasourceImpl(dio: dio));
  }
}
