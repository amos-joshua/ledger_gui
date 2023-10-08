import 'package:localstorage/localstorage.dart';
import 'persistent_storage.dart';

class WebLocalStorage implements PersistentStorage {
  final localStorage = LocalStorage('ledger_gui.json');

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> getString(String key) async {
    return localStorage.getItem(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    localStorage.setItem(key, value);
  }

  @override
  Future<void> clearKey(String key) async {
    localStorage.deleteItem(key);
  }
}