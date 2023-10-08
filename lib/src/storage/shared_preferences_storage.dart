import 'package:shared_preferences/shared_preferences.dart';
import 'persistent_storage.dart';

class SharedPreferencesStorage implements PersistentStorage {
  late final SharedPreferences sharedPreferences;
  bool initialized = false;

  @override
  Future<void> initialize() async {
    if (initialized) return;
    sharedPreferences = await SharedPreferences.getInstance();
    initialized = true;
  }

  @override
  Future<String?> getString(String key) async {
    await initialize();
    if (!sharedPreferences.containsKey(key)) return null;
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
     sharedPreferences.setString(key, value);
  }

  @override
  Future<void> clearKey(String key) async {
    sharedPreferences.remove(key);
  }
}