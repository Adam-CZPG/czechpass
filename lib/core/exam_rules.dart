import 'dart:math';

import 'package:czech_pass/core/question.dart';

/// Doimiy yashash uchun A2 imtihoni (2026-yil 11-apreldan yangi format).
/// Manba: cestina-pro-cizince.cz (2026-yil noyabr holatiga).
class A2Rules {
  static const fee = 3200;

  // Har bir qism uchun maksimal ball.
  static const readingPoints = 25;
  static const writingPoints = 20;
  static const listeningPoints = 25;
  static const speakingPoints = 40;

  // Daqiqalar.
  static const readingMinutes = 40;
  static const writingMinutes = 25;
  static const listeningMinutes = 40;
  static const speakingMinutes = 15;

  /// Yozma qism (o'qish + yozish + tinglash) — 70 balldan kamida 42 (60 %).
  static const writtenMax = readingPoints + writingPoints + listeningPoints;
  static const writtenPass = 42;

  /// Og'zaki qism — 40 balldan kamida 24 (60 %).
  static const speakingPass = 24;

  /// [got] / [total] natijani [max] ballik shkalaga o'tkazadi.
  static int scale(int got, int total, int max) => total <= 0 ? 0 : (got * max / total).round().clamp(0, max);

  static bool passed({required int written, required int speaking}) =>
      written >= writtenPass && speaking >= speakingPass;
}

/// Fuqarolik uchun České reálie testi.
class RealieRules {
  static const fee = 2000;
  static const questions = 30;
  static const minutes = 30;
  static const passMark = 18;

  /// Rasmiy tuzilma: 16 — fuqarolik asoslari va davlat, 7 — geografiya, 7 — tarix va madaniyat.
  static const structure = <(List<String>, int)>[
    (['stat'], 16),
    (['geografie'], 7),
    (['historie', 'kultura'], 7),
  ];

  /// Savollar soni 30 tadan kam bo'lsa, o'tish chegarasi ham 60 % qilib olinadi.
  static int passFor(int total) => total >= questions ? passMark : (total * 0.6).ceil();

  /// Sinov imtihoni uchun savollarni rasmiy tuzilmaga yaqin tanlaydi.
  static List<Question> pickExam(List<Question> all, Random random) {
    final pool = [...all]..shuffle(random);
    final picked = <Question>[];
    for (final (topics, count) in structure) {
      picked.addAll(pool.where((q) => topics.contains(q.topic) && !picked.contains(q)).take(count).toList());
    }
    // Biror mavzuda savol yetmasa, qolganini boshqa savollar bilan to'ldiramiz.
    for (final q in pool) {
      if (picked.length >= questions) break;
      if (!picked.contains(q)) picked.add(q);
    }
    return picked..shuffle(random);
  }

  /// Bepul versiya: har bir mavzudan fayldagi tartib bo'yicha birinchi [perTopic] ta savol.
  static List<Question> freeSubset(List<Question> all, int perTopic) {
    final counts = <String, int>{};
    final result = <Question>[];
    for (final q in all) {
      final n = (counts[q.topic] ?? 0) + 1;
      counts[q.topic] = n;
      if (n <= perTopic) result.add(q);
    }
    return result;
  }
}

/// Bugundan [target] sanagacha qolgan to'liq kunlar (bugun — 0, o'tib ketgan bo'lsa — manfiy).
int daysUntil(DateTime target, DateTime now) {
  final a = DateTime.utc(now.year, now.month, now.day);
  final b = DateTime.utc(target.year, target.month, target.day);
  return b.difference(a).inDays;
}
