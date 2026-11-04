import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/core/app_language.dart';

/// Foydalanuvchi sozlamalarini telefonda saqlaydi.
class SettingsStore {
  static const _languageKey = 'app_language';

  Future<AppLanguage?> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLanguage.fromCode(prefs.getString(_languageKey));
  }

  Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }
}
