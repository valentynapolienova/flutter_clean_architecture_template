enum Environment { dev, prod }

/// Settings that differ per environment.
///
/// Built in `main_<environment>.dart` from `env/<environment>.json`, which is
/// passed with `--dart-define-from-file`. URLs and keys belong here, never in
/// feature code.
class AppConfig {
  const new({required this.environment, required this.apiBaseUrl});

  final Environment environment;
  final String apiBaseUrl;

  bool get isProd => environment == .prod;

  /// Throws when a required value is missing, which usually means the app
  /// was launched without its env file.
  void ensureValid() {
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is missing. Launch with '
        '--dart-define-from-file=env/${environment.name}.json',
      );
    }
  }
}
