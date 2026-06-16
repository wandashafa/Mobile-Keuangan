import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageCache {
  static Future<void> save(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(data));
    } catch (e) {
      // Fail silently for caching writes
    }
  }

  static Future<dynamic> get(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      if (value != null) {
        return jsonDecode(value);
      }
    } catch (e) {
      // Fail silently for caching reads
    }
    return null;
  }
}
