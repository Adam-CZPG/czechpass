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

/// Har bir savolga oxirgi javob to'g'ri yoki noto'g'ri bo'lganini, takrorlash jadvalini
/// (spaced repetition) va kunlik faollikni saqlaydi. Ma'lumot faqat telefonda turadi.
class ProgressStore {
  ProgressStore._(this._prefs, this._data, this._review, this._activity);

  static const _prefix = 'progress_';
  static const _reviewPrefix = 'review_';
  static const _activityKey = 'activity_days';
  static const _exams = [Exams.realie, Exams.a2Reading, Exams.a2Listening, Exams.a2Speaking, Exams.a2Writing];

  /// Takrorlash oraliqlari (kun): to'g'ri javobdan keyin savol keyingi "qutiga" o'tadi
  /// va 1, 3, 7, 14 kundan keyin yana so'raladi. Xato javob — qayta 0-quti (darhol).
  static const reviewDays = [0, 1, 3, 7, 14];

  final SharedPreferences _prefs;

  /// imtihon → (savol id → oxirgi javob to'g'rimi)
  final Map<String, Map<String, bool>> _data;

  /// imtihon → (savol id → [quti, keyingi takrorlash vaqti (ms)])
  final Map<String, Map<String, List<int>>> _review;

  /// "yyyy-mm-dd" → shu kuni berilgan javoblar soni
  final Map<String, int> _activity;

  static Future<ProgressStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, Map<String, bool>>{};
    final review = <String, Map<String, List<int>>>{};
    for (final exam in _exams) {
      final raw = prefs.getString('$_prefix$exam');
      data[exam] = raw == null ? <String, bool>{} : Map<String, bool>.from(jsonDecode(raw) as Map);
      final rawReview = prefs.getString('$_reviewPrefix$exam');
      review[exam] = rawReview == null
          ? <String, List<int>>{}
          : (jsonDecode(rawReview) as Map).map(
              (key, value) => MapEntry('$key', List<int>.from(value as List)),
            );
    }
    final rawActivity = prefs.getString(_activityKey);
    final activity = rawActivity == null ? <String, int>{} : Map<String, int>.from(jsonDecode(rawActivity) as Map);
    return ProgressStore._(prefs, data, review, activity);
  }

  Map<String, bool> _of(String exam) => _data.putIfAbsent(exam, () => <String, bool>{});

  Map<String, List<int>> _reviewOf(String exam) => _review.putIfAbsent(exam, () => <String, List<int>>{});

  /// null — hali javob berilmagan.
  bool? resultFor(String exam, String questionId) => _of(exam)[questionId];

  int answeredCount(String exam) => _of(exam).length;

  int correctCount(String exam) => _of(exam).values.where((v) => v).length;

  Set<String> mistakes(String exam) => _of(exam).entries.where((e) => !e.value).map((e) => e.key).toSet();

  /// Takrorlash vaqti kelgan savollar: xato javoblar va oraliq muddati tugagan to'g'ri javoblar.
  Set<String> dueForReview(String exam, {DateTime? now}) {
    final time = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final schedule = _reviewOf(exam);
    return {
      for (final e in schedule.entries)
        if (e.value.length == 2 && e.value[1] <= time) e.key,
      // Jadval paydo bo'lishidan oldingi xatolar ham takrorlanadi.
      for (final id in mistakes(exam))
        if (!schedule.containsKey(id)) id,
    };
  }

  /// Savolning takrorlash qutisi (0–4); hali javob berilmagan bo'lsa — null.
  int? boxOf(String exam, String questionId) => _reviewOf(exam)[questionId]?.first;

  Future<void> record(String exam, String questionId, bool correct, {DateTime? now}) async {
    final time = now ?? DateTime.now();
    _of(exam)[questionId] = correct;

    final schedule = _reviewOf(exam);
    final previous = schedule[questionId]?.first ?? 0;
    final box = correct ? (previous + 1).clamp(1, reviewDays.length - 1) : 0;
    schedule[questionId] = [box, time.add(Duration(days: reviewDays[box])).millisecondsSinceEpoch];

    final day = dayKey(time);
    _activity[day] = (_activity[day] ?? 0) + 1;

    await _prefs.setString('$_prefix$exam', jsonEncode(_of(exam)));
    await _prefs.setString('$_reviewPrefix$exam', jsonEncode(schedule));
    await _prefs.setString(_activityKey, jsonEncode(_activity));
  }

  static String dayKey(DateTime time) =>
      '${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';

  /// Barcha kunlar bo'yicha berilgan javoblar soni.
  int get totalAnswers => _activity.values.fold(0, (sum, n) => sum + n);

  /// Bugun berilgan javoblar soni.
  int todayCount({DateTime? now}) => _activity[dayKey(now ?? DateTime.now())] ?? 0;

  /// Ketma-ket mashq qilingan kunlar (bugun hali mashq qilinmagan bo'lsa, kechagidan sanaladi).
  int streak({DateTime? now}) {
    var day = now ?? DateTime.now();
    if ((_activity[dayKey(day)] ?? 0) == 0) day = day.subtract(const Duration(days: 1));
    var count = 0;
    while ((_activity[dayKey(day)] ?? 0) > 0) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  Future<void> clear() async {
    for (final exam in _exams) {
      _data[exam] = <String, bool>{};
      _review[exam] = <String, List<int>>{};
      await _prefs.remove('$_prefix$exam');
      await _prefs.remove('$_reviewPrefix$exam');
    }
    _activity.clear();
    await _prefs.remove(_activityKey);
  }
}
