import 'package:clean_architecture_template/app/config/app_config.dart';
import 'package:clean_architecture_template/core/network/api_client.dart';
import 'package:clean_architecture_template/core/network/auth_interceptor.dart';
import 'package:clean_architecture_template/core/storage/secure_token_storage.dart';
import 'package:clean_architecture_template/core/storage/settings_storage.dart';
import 'package:clean_architecture_template/core/storage/shared_prefs_settings_storage.dart';
import 'package:clean_architecture_template/core/storage/token_storage.dart';
import 'package:clean_architecture_template/core/theme/theme_cubit.dart';
import 'package:clean_architecture_template/features/auth/application/auth_service.dart';
import 'package:clean_architecture_template/features/auth/data/auth_repository.dart';
import 'package:clean_architecture_template/features/auth/presentation/cubits/session/session_cubit.dart';
import 'package:clean_architecture_template/features/posts/application/posts_service.dart';
import 'package:clean_architecture_template/features/posts/data/authors_repository.dart';
import 'package:clean_architecture_template/features/posts/data/posts_repository.dart';
import 'package:get_it/get_it.dart';

/// The service locator. Read it only here, in `bootstrap.dart` and in route
/// builders; everything else receives dependencies through constructors.
final GetIt sl = GetIt.instance;

/// Instance name of the [ApiClient] that sends requests without a token.
const publicApiName = 'publicApi';

Future<void> registerDependencies(AppConfig config) async {
  _registerCore(config);
  _registerAuth();
  _registerPosts();
  await sl.allReady();
}

void _registerCore(AppConfig config) {
  sl
    ..registerSingleton<AppConfig>(config)
    ..registerLazySingleton<SettingsStorage>(SharedPrefsSettingsStorage.new)
    ..registerLazySingleton<TokenStorage>(SecureTokenStorage.new)
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(baseUrl: config.apiBaseUrl, logRequests: !config.isProd),
      instanceName: publicApiName,
    )
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(
        baseUrl: config.apiBaseUrl,
        logRequests: !config.isProd,
        interceptors: [
          // The callbacks resolve AuthService lazily because AuthService
          // itself depends on the API clients.
          AuthInterceptor(
            readAccessToken: () => sl<TokenStorage>().readAccessToken(),
            refreshAccessToken: () => sl<AuthService>().refreshAccessToken(),
            onSessionExpired: () => sl<AuthService>().signOut(),
          ),
        ],
      ),
    )
    ..registerLazySingleton(
      () => ThemeCubit(sl()),
      dispose: (cubit) => cubit.close(),
    );
}

void _registerAuth() {
  sl
    ..registerLazySingleton(
      () => AuthRepository(
        publicApi: sl(instanceName: publicApiName),
        api: sl(),
      ),
    )
    ..registerLazySingleton(
      () => AuthService(repository: sl(), tokenStorage: sl()),
      dispose: (service) => service.dispose(),
    )
    ..registerLazySingleton(
      () => SessionCubit(sl()),
      dispose: (cubit) => cubit.close(),
    );
}

void _registerPosts() {
  sl
    ..registerLazySingleton(() => PostsRepository(api: sl()))
    ..registerLazySingleton(() => AuthorsRepository(api: sl()))
    ..registerLazySingleton(
      () => PostsService(postsRepository: sl(), authorsRepository: sl()),
    );
}
