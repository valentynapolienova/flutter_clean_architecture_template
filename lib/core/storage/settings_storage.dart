/// App settings that survive restarts.
///
/// Implementations only read and write, and throw `StorageFailure` when the
/// platform store fails.
abstract interface class SettingsStorage {
  Future<String?> readThemeMode();

  Future<void> writeThemeMode(String value);
}
