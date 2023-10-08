import 'package:flutter/foundation.dart';

import 'web_local_storage.dart';
import 'shared_preferences_storage.dart';

abstract class PersistentStorage {
  Future<void> initialize();
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> clearKey(String key);

  factory PersistentStorage() {
    return kIsWeb ? WebLocalStorage() : SharedPreferencesStorage();
  }
}