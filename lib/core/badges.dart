import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/core/progress_store.dart';

/// Yutuq nishoni. Nishonlar sokin va jiddiy: faqat haqiqiy natija uchun beriladi.
class AppBadge {
  const AppBadge(this.id, this.icon, this.title, this.description);

  final String id;
  final IconData icon;
  final Map<String, String> title;
  final Map<String, String> description;

  String titleFor(String lang) => title[lang] ?? title['cs']!;
  String descriptionFor(String lang) => description[lang] ?? description['cs']!;
}

/// Barcha nishonlar (ko'rsatish tartibida).
class Badges {
  static const firstSteps = AppBadge('first_steps', Icons.flag_outlined, {
    'uz': 'Birinchi qadam', 'cs': 'První krok', 'en': 'First step',
    'vi': 'Bước đầu tiên', 'ru': 'Первый шаг', 'uk': 'Перший крок',
  }, {
    'uz': '10 ta javob berildi', 'cs': '10 odpovědí', 'en': '10 answers given',
    'vi': 'Đã trả lời 10 câu', 'ru': 'Дано 10 ответов', 'uk': 'Надано 10 відповідей',
  });

  static const hundred = AppBadge('answers_100', Icons.task_alt, {
    'uz': '100 ta javob', 'cs': '100 odpovědí', 'en': '100 answers',
    'vi': '100 câu trả lời', 'ru': '100 ответов', 'uk': '100 відповідей',
  }, {
    'uz': 'Jami 100 ta javob berildi', 'cs': 'Celkem 100 odpovědí', 'en': '100 answers in total',
    'vi': 'Tổng cộng 100 câu trả lời', 'ru': 'Всего 100 ответов', 'uk': 'Усього 100 відповідей',
  });

  static const goal = AppBadge('daily_goal', Icons.track_changes, {
    'uz': 'Kunlik maqsad', 'cs': 'Denní cíl', 'en': 'Daily goal',
    'vi': 'Mục tiêu hằng ngày', 'ru': 'Дневная цель', 'uk': 'Щоденна мета',
  }, {
    'uz': 'Kunlik maqsad birinchi marta bajarildi', 'cs': 'Denní cíl poprvé splněn',
    'en': 'Daily goal reached for the first time', 'vi': 'Lần đầu đạt mục tiêu hằng ngày',
    'ru': 'Дневная цель выполнена впервые', 'uk': 'Щоденну мету виконано вперше',
  });

  static const streak3 = AppBadge('streak_3', Icons.local_fire_department_outlined, {
    'uz': '3 kun ketma-ket', 'cs': '3 dny v řadě', 'en': '3-day streak',
    'vi': 'Chuỗi 3 ngày', 'ru': '3 дня подряд', 'uk': '3 дні поспіль',
  }, {
    'uz': "3 kun ketma-ket mashq qilindi", 'cs': 'Procvičování 3 dny po sobě',
    'en': 'Practised 3 days in a row', 'vi': 'Luyện tập 3 ngày liên tiếp',
    'ru': 'Занятия 3 дня подряд', 'uk': 'Заняття 3 дні поспіль',
  });

  static const streak7 = AppBadge('streak_7', Icons.calendar_month_outlined, {
    'uz': 'Bir hafta', 'cs': 'Týden', 'en': 'One week',
    'vi': 'Một tuần', 'ru': 'Неделя', 'uk': 'Тиждень',
  }, {
    'uz': '7 kun ketma-ket mashq qilindi', 'cs': 'Procvičování 7 dní po sobě',
    'en': 'Practised 7 days in a row', 'vi': 'Luyện tập 7 ngày liên tiếp',
    'ru': 'Занятия 7 дней подряд', 'uk': 'Заняття 7 днів поспіль',
  });

  static const streak30 = AppBadge('streak_30', Icons.workspace_premium_outlined, {
    'uz': 'Bir oy', 'cs': 'Měsíc', 'en': 'One month',
    'vi': 'Một tháng', 'ru': 'Месяц', 'uk': 'Місяць',
  }, {
    'uz': '30 kun ketma-ket mashq qilindi', 'cs': 'Procvičování 30 dní po sobě',
    'en': 'Practised 30 days in a row', 'vi': 'Luyện tập 30 ngày liên tiếp',
    'ru': 'Занятия 30 дней подряд', 'uk': 'Заняття 30 днів поспіль',
  });

  static const a2Skills = AppBadge('a2_all_skills', Icons.dashboard_customize_outlined, {
    'uz': "A2: to'rt ko'nikma", 'cs': 'A2: čtyři dovednosti', 'en': 'A2: four skills',
    'vi': 'A2: bốn kỹ năng', 'ru': 'A2: четыре навыка', 'uk': 'A2: чотири навички',
  }, {
    'uz': "O'qish, tinglash, yozish va gapirish sinab ko'rildi",
    'cs': 'Vyzkoušeno čtení, poslech, psaní i mluvení',
    'en': 'Tried reading, listening, writing and speaking',
    'vi': 'Đã thử đọc, nghe, viết và nói',
    'ru': 'Опробованы чтение, аудирование, письмо и устная часть',
    'uk': 'Спробувано читання, аудіювання, письмо й усне мовлення',
  });

  static const realieHalf = AppBadge('realie_50', Icons.account_balance_outlined, {
    'uz': 'Reálie: yarim yo\'l', 'cs': 'Reálie: polovina', 'en': 'Reálie: halfway',
    'vi': 'Reálie: một nửa', 'ru': 'Reálie: половина', 'uk': 'Reálie: половина',
  }, {
    'uz': "Savollarning yarmi o'zlashtirildi", 'cs': 'Zvládnuta polovina otázek',
    'en': 'Half of the questions mastered', 'vi': 'Đã nắm vững một nửa câu hỏi',
    'ru': 'Освоена половина вопросов', 'uk': 'Опановано половину питань',
  });

  static const realieReady = AppBadge('realie_90', Icons.verified_outlined, {
    'uz': 'Reálie: tayyor', 'cs': 'Reálie: připraveno', 'en': 'Reálie: ready',
    'vi': 'Reálie: sẵn sàng', 'ru': 'Reálie: готово', 'uk': 'Reálie: готово',
  }, {
    'uz': "Savollarning 90 % o'zlashtirildi", 'cs': 'Zvládnuto 90 % otázek',
    'en': '90% of the questions mastered', 'vi': 'Đã nắm vững 90% câu hỏi',
    'ru': 'Освоено 90 % вопросов', 'uk': 'Опановано 90 % питань',
  });

  static const realieMock = AppBadge('mock_realie', Icons.assignment_turned_in_outlined, {
    'uz': 'Reálie sinovi', 'cs': 'Test reálií nanečisto', 'en': 'Reálie mock passed',
    'vi': 'Đạt thi thử Reálie', 'ru': 'Пробный тест Reálie', 'uk': 'Пробний тест Reálie',
  }, {
    'uz': "Sinov testidan o'tildi", 'cs': 'Zkouška nanečisto složena', 'en': 'Passed a mock test',
    'vi': 'Đã đạt bài thi thử', 'ru': 'Пробный тест сдан', 'uk': 'Пробний тест складено',
  });

  static const a2Mock = AppBadge('mock_a2', Icons.military_tech_outlined, {
    'uz': 'A2 sinovi', 'cs': 'Zkouška A2 nanečisto', 'en': 'A2 mock passed',
    'vi': 'Đạt thi thử A2', 'ru': 'Пробный экзамен A2', 'uk': 'Пробний іспит A2',
  }, {
    'uz': "A2 sinov imtihonidan o'tildi", 'cs': 'Zkouška A2 nanečisto složena',
    'en': 'Passed the A2 mock exam', 'vi': 'Đã đạt bài thi thử A2',
    'ru': 'Пробный экзамен A2 сдан', 'uk': 'Пробний іспит A2 складено',
  });

  static const all = [
    firstSteps, hundred, goal, streak3, streak7, streak30,
    a2Skills, realieHalf, realieReady, realieMock, a2Mock,
  ];
}

/// Olingan nishonlarni saqlaydi va progress bo'yicha yangilarini aniqlaydi.
class BadgeStore {
  BadgeStore._(this._prefs, this._earned);

  static const _key = 'badges_earned';

  final SharedPreferences? _prefs;
  final Set<String> _earned;

  /// Testlar uchun: xotirada, saqlamasdan.
  BadgeStore.memory() : _prefs = null, _earned = <String>{};

  static Future<BadgeStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return BadgeStore._(prefs, (prefs.getStringList(_key) ?? const <String>[]).toSet());
  }

  bool has(AppBadge badge) => _earned.contains(badge.id);

  int get count => _earned.length;

  /// Progressga qarab qaysi nishonlar olinishi kerakligini hisoblaydi.
  static Set<AppBadge> qualified({
    required ProgressStore progress,
    required int dailyGoal,
    required int realieTotal,
    Set<String> mocksPassed = const {},
    DateTime? now,
  }) {
    final total = progress.totalAnswers;
    final streak = progress.streak(now: now);
    final realiePercent = realieTotal == 0 ? 0 : progress.correctCount(Exams.realie) * 100 / realieTotal;
    const skills = [Exams.a2Reading, Exams.a2Listening, Exams.a2Writing, Exams.a2Speaking];
    return {
      if (total >= 10) Badges.firstSteps,
      if (total >= 100) Badges.hundred,
      if (progress.todayCount(now: now) >= dailyGoal) Badges.goal,
      if (streak >= 3) Badges.streak3,
      if (streak >= 7) Badges.streak7,
      if (streak >= 30) Badges.streak30,
      if (skills.every((e) => progress.answeredCount(e) > 0)) Badges.a2Skills,
      if (realiePercent >= 50) Badges.realieHalf,
      if (realiePercent >= 90) Badges.realieReady,
      if (mocksPassed.contains(Badges.realieMock.id)) Badges.realieMock,
      if (mocksPassed.contains(Badges.a2Mock.id)) Badges.a2Mock,
    };
  }

  /// Yangi olingan nishonlarni saqlaydi va qaytaradi (oldin olinganlari qaytarilmaydi).
  Future<List<AppBadge>> award(Iterable<AppBadge> badges) async {
    final fresh = [for (final b in badges) if (!_earned.contains(b.id)) b];
    if (fresh.isEmpty) return fresh;
    _earned.addAll(fresh.map((b) => b.id));
    await _prefs?.setStringList(_key, _earned.toList());
    return fresh;
  }
}
