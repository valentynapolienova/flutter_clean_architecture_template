import 'package:clean_architecture_template/shared/storage/settings_storage.dart';
import 'package:clean_architecture_template/shared/storage/storage_guard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsSettingsStorage implements SettingsStorage {
  new({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _themeModeKey = 'theme_mode';

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> readThemeMode() =>
      guardStorage(() => _preferences.getString(_themeModeKey));

  @override
  Future<void> writeThemeMode(String value) =>
      guardStorage(() => _preferences.setString(_themeModeKey, value));
}
