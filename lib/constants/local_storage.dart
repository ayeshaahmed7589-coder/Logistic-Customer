import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

  final authTokenProvider = FutureProvider<String?>((ref) async {
    return await LocalStorage.getToken();
  });


  class LocalStorage {
    static const String _keyToken = "auth_token";

    static Future<void> saveToken(String token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
    }

    static Future<String?> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    }

    static Future<void> clearToken() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
    }
  }
