import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Imtihon turlari (progress shu kalitlar bo'yicha saqlanadi).
class Exams {
  static const realie = 'realie';
  static const a2Reading = 'a2_reading';
  static const a2Listening = 'a2_listening';
  static const a2Speaking = 'a2_speaking';
  static const a2Writing = 'a2_writing';
}

/// Har bir savolga oxirgi javob to'g'ri yoki noto'g'ri bo'lganini saqlaydi.
/// Ma'lumot faqat telefonda turadi (serverga yuborilmaydi).
class ProgressStore {
  ProgressStore._(this._prefs, this._data);

  static const _prefix = 'progress_';
  static const _exams = [Exams.realie, Exams.a2Reading, Exams.a2Listening, Exams.a2Speaking, Exams.a2Writing];

  final SharedPreferences _prefs;

  /// imtihon → (savol id → oxirgi javob to'g'rimi)
  final Map<String, Map<String, bool>> _data;

  static Future<ProgressStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, Map<String, bool>>{};
    for (final exam in _exams) {
      final raw = prefs.getString('$_prefix$exam');
      data[exam] = raw == null
          ? <String, bool>{}
          : Map<String, bool>.from(jsonDecode(raw) as Map);
    }
    return ProgressStore._(prefs, data);
  }

  Map<String, bool> _of(String exam) => _data.putIfAbsent(exam, () => <String, bool>{});

  /// null — hali javob berilmagan.
  bool? resultFor(String exam, String questionId) => _of(exam)[questionId];

  int answeredCount(String exam) => _of(exam).length;

  int correctCount(String exam) => _of(exam).values.where((v) => v).length;

  Set<String> mistakes(String exam) =>
      _of(exam).entries.where((e) => !e.value).map((e) => e.key).toSet();

  Future<void> record(String exam, String questionId, bool correct) async {
    _of(exam)[questionId] = correct;
    await _prefs.setString('$_prefix$exam', jsonEncode(_of(exam)));
  }

  Future<void> clear() async {
    for (final exam in _exams) {
      _data[exam] = <String, bool>{};
      await _prefs.remove('$_prefix$exam');
    }
  }
}
