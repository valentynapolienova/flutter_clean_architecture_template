import 'package:clean_architecture_template/core/storage/storage_guard.dart';
import 'package:clean_architecture_template/core/storage/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores tokens in the Keychain on iOS and in encrypted storage on Android.
class SecureTokenStorage implements TokenStorage {
  new({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readAccessToken() =>
      guardStorage(() => _storage.read(key: _accessTokenKey));

  @override
  Future<String?> readRefreshToken() =>
      guardStorage(() => _storage.read(key: _refreshTokenKey));

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) => guardStorage(() async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  });

  @override
  Future<void> clear() => guardStorage(() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  });
}
