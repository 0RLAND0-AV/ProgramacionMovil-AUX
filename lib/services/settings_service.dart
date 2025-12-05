import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyAiName = 'ai_name';
  static const _keyUserName = 'user_name';

  Future<void> saveAiName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAiName, name);
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  Future<String> getAiName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAiName) ?? 'AmigoIA';
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Tú';
  }
}
