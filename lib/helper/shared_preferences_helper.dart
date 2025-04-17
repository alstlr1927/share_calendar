import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  String _rememberEmail = 'remember_email';

  /// 이메일 기억
  /// [getRememberEmail]
  /// [setRememberEmail]
  Future<String> getRememberEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberEmail) ?? '';
  }

  Future setRememberEmail(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_rememberEmail, value);
  }
}
