import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/core/app_language.dart';

/// Foydalanuvchi sozlamalarini telefonda saqlaydi.
class SettingsStore {
  static const _languageKey = 'app_language';
  static const _examDateKey = 'exam_date';
  static const _dailyGoalKey = 'daily_goal';
  static const _reminderKey = 'reminder_minutes';
  static const _themeKey = 'theme_mode';
  static const _soundKey = 'answer_sound';

  /// Eslatma vaqti standart holatda — 17:00.
  static const defaultReminderMinutes = 17 * 60;

  /// Kunlik maqsad (javoblar soni) uchun tanlovlar.
  static const goalOptions = [10, 20, 30, 50];
  static const defaultGoal = 20;

  Future<AppLanguage?> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLanguage.fromCode(prefs.getString(_languageKey));
  }

  Future<void> saveLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }

  Future<DateTime?> loadExamDate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_examDateKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> saveExamDate(DateTime? date) async {
    final prefs = await SharedPreferences.getInstance();
    if (date == null) {
      await prefs.remove(_examDateKey);
    } else {
      await prefs.setString(_examDateKey, DateTime(date.year, date.month, date.day).toIso8601String());
    }
  }

  Future<int> loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyGoalKey) ?? defaultGoal;
  }

  Future<void> saveDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, goal);
  }

  /// Eslatma vaqti (kun boshidan daqiqalar); eslatma o'chirilgan bo'lsa — null.
  Future<int?> loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_reminderKey);
  }

  Future<void> saveReminder(int? minutes) async {
    final prefs = await SharedPreferences.getInstance();
    if (minutes == null) {
      await prefs.remove(_reminderKey);
    } else {
      await prefs.setInt(_reminderKey, minutes);
    }
  }

  /// Mavzu: tizim (telefon sozlamasi), yorug' yoki qorong'i.
  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere((m) => m.name == name, orElse: () => ThemeMode.system);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  /// Javobdan keyingi ovoz va tebranish (standart — yoqilgan).
  Future<bool> loadAnswerSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundKey) ?? true;
  }

  Future<void> saveAnswerSound(bool on) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, on);
  }
}
