/// Keeps the session tokens.
///
/// Implementations only read and write, and throw `StorageFailure` when the
/// platform store fails.
abstract interface class TokenStorage {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> clear();
}
