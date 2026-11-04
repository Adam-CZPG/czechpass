import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Tugallanmagan mashg'ulot holati: foydalanuvchi bo'limdan chiqib ketsa, keyingi safar
/// shu joydan davom etadi (Duolingo'dagi kabi). Bo'lim tugaganda holat o'chiriladi.
class SessionStore {
  static const _prefix = 'session_';

  static Future<Map<String, dynamic>?> load(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$key');
      return raw == null ? null : Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> save(String key, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$key', jsonEncode(data));
  }

  static Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$key');
  }

  /// Bo'lim davom etayotganmi (bosh sahifada "Davom ettirish" ko'rsatish uchun).
  static Future<bool> exists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('$_prefix$key');
  }

  /// Topshiriqlar bo'yicha ballar: {indeks: (to'g'ri, jami)} ↔ JSON.
  static Map<String, List<int>> encodeScores(Map<int, (int, int)> scores) => {
        for (final e in scores.entries) '${e.key}': [e.value.$1, e.value.$2],
      };

  static Map<int, (int, int)> decodeScores(Object? raw) {
    if (raw is! Map) return {};
    final result = <int, (int, int)>{};
    raw.forEach((key, value) {
      final index = int.tryParse('$key');
      if (index != null && value is List && value.length == 2) {
        result[index] = ((value[0] as num).toInt(), (value[1] as num).toInt());
      }
    });
    return result;
  }
}
