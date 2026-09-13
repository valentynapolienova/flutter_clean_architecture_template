import 'package:clean_architecture_template/app/bootstrap.dart';
import 'package:clean_architecture_template/app/config/app_config.dart';

Future<void> main() => bootstrap(
  const AppConfig(
    environment: .prod,
    apiBaseUrl: .fromEnvironment('API_BASE_URL'),
  ),
);
