import 'package:clean_architecture_template/core/network/api_client.dart';
import 'package:clean_architecture_template/core/storage/settings_storage.dart';
import 'package:clean_architecture_template/core/storage/token_storage.dart';
import 'package:clean_architecture_template/features/auth/application/auth_service.dart';
import 'package:clean_architecture_template/features/auth/data/auth_repository.dart';
import 'package:clean_architecture_template/features/posts/application/posts_service.dart';
import 'package:clean_architecture_template/features/posts/data/authors_repository.dart';
import 'package:clean_architecture_template/features/posts/data/posts_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient;

class MockSettingsStorage extends Mock implements SettingsStorage;

class MockTokenStorage extends Mock implements TokenStorage;

class MockAuthRepository extends Mock implements AuthRepository;

class MockAuthService extends Mock implements AuthService;

class MockPostsRepository extends Mock implements PostsRepository;

class MockAuthorsRepository extends Mock implements AuthorsRepository;

class MockPostsService extends Mock implements PostsService;
