import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Save data
  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value); // You can also use setInt, setBool, etc.
  }

  // Retrieve data
  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key); // Returns null if the key doesn't exist
  }

  // Delete data
  Future<void> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
