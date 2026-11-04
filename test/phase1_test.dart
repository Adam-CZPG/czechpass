import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/exam_rules.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/features/a2/a2_mock_screen.dart';
import 'package:czech_pass/l10n/strings.dart';

Question _q(String id, String topic) =>
    Question(id: id, topic: topic, text: {'cs': id}, options: const ['a', 'b', 'c', 'd'], correctIndex: 0);

void main() {
  group('Takrorlash (spaced repetition)', () {
    test("xato javob darhol takrorlanadi, to'g'risi 1, 3 kundan keyin", () async {
      SharedPreferences.setMockInitialValues({});
      final store = await ProgressStore.load();
      final day0 = DateTime(2026, 11, 4, 10);

      await store.record(Exams.realie, 'wrong', false, now: day0);
      await store.record(Exams.realie, 'right', true, now: day0);
      expect(store.dueForReview(Exams.realie, now: day0), {'wrong'});
      expect(store.boxOf(Exams.realie, 'right'), 1);

      final day1 = day0.add(const Duration(days: 1));
      expect(store.dueForReview(Exams.realie, now: day1), {'wrong', 'right'});

      await store.record(Exams.realie, 'right', true, now: day1);
      expect(store.boxOf(Exams.realie, 'right'), 2);
      expect(store.dueForReview(Exams.realie, now: day1.add(const Duration(days: 2))), {'wrong'});
      expect(store.dueForReview(Exams.realie, now: day1.add(const Duration(days: 3))), {'wrong', 'right'});

      // Xato qilinsa, savol yana boshidan boshlanadi.
      await store.record(Exams.realie, 'right', false, now: day1);
      expect(store.boxOf(Exams.realie, 'right'), 0);

      final reloaded = await ProgressStore.load();
      expect(reloaded.boxOf(Exams.realie, 'right'), 0);
    });

    test('eski versiyadagi xatolar ham takrorlashga tushadi', () async {
      SharedPreferences.setMockInitialValues({'progress_realie': '{"old":false,"ok":true}'});
      final store = await ProgressStore.load();
      expect(store.dueForReview(Exams.realie), {'old'});
    });

    test('kunlik javoblar va ketma-ket kunlar sanaladi', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await ProgressStore.load();
      final today = DateTime(2026, 11, 4, 9);
      await store.record(Exams.realie, 'a', true, now: today.subtract(const Duration(days: 2)));
      await store.record(Exams.realie, 'b', true, now: today.subtract(const Duration(days: 1)));
      await store.record(Exams.realie, 'c', true, now: today);
      await store.record(Exams.realie, 'd', false, now: today);

      expect(store.todayCount(now: today), 2);
      expect(store.streak(now: today), 3);
      // Bugun hali mashq qilinmagan bo'lsa ham, kechagi seriya saqlanadi.
      expect(store.streak(now: today.add(const Duration(days: 1))), 3);
      expect(store.streak(now: today.add(const Duration(days: 2))), 0);
    });
  });

  group('Bepul versiya cheklovlari', () {
    test("tarif sotib olinmaguncha ro'yxat qisqartiriladi", () {
      final free = Entitlements(devUnlock: false);
      expect(free.limit([1, 2, 3, 4], Tariff.residence, 2), [1, 2]);
      expect(free.residence, isFalse);

      final paid = Entitlements(owned: {Tariff.residence}, devUnlock: false);
      expect(paid.limit([1, 2, 3, 4], Tariff.residence, 2), [1, 2, 3, 4]);
      expect(paid.citizenship, isFalse);

      final both = Entitlements(owned: {Tariff.both}, devUnlock: false);
      expect(both.residence && both.citizenship, isTrue);

      expect(Entitlements(devUnlock: true).unlocked(Tariff.both), isTrue);
    });

    test('bepul sinov imtihoni bir marta', () async {
      SharedPreferences.setMockInitialValues({});
      final e = await Entitlements.load();
      // Testlar DEV_UNLOCK'siz ishga tushiriladi.
      expect(e.devUnlock, isFalse);
      expect(e.canStartMock(Mocks.a2, Tariff.residence), isTrue);
      await e.useMock(Mocks.a2, Tariff.residence);
      expect(e.canStartMock(Mocks.a2, Tariff.residence), isFalse);
      expect(e.canStartMock(Mocks.realie, Tariff.citizenship), isTrue);
      await e.grant(Tariff.residence);
      expect(e.canStartMock(Mocks.a2, Tariff.residence), isTrue);
      final reloaded = await Entitlements.load();
      expect(reloaded.residence, isTrue);
      expect(reloaded.mocksUsed(Mocks.a2), 1);
    });

    test('České reálie: har mavzudan 3 tadan bepul savol', () {
      final all = [
        for (var i = 0; i < 5; i++) _q('g$i', 'geografie'),
        for (var i = 0; i < 2; i++) _q('h$i', 'historie'),
      ];
      final free = RealieRules.freeSubset(all, FreeLimits.realiePerTopic);
      expect(free.map((q) => q.id), ['g0', 'g1', 'g2', 'h0', 'h1']);
    });
  });

  group('Imtihon qoidalari', () {
    test("reálie sinov imtihoni 30 savol va rasmiy tuzilmada", () {
      final all = [
        for (var i = 0; i < 20; i++) _q('s$i', 'stat'),
        for (var i = 0; i < 10; i++) _q('g$i', 'geografie'),
        for (var i = 0; i < 5; i++) _q('h$i', 'historie'),
        for (var i = 0; i < 5; i++) _q('k$i', 'kultura'),
      ];
      final exam = RealieRules.pickExam(all, Random(1));
      expect(exam.length, 30);
      expect(exam.map((q) => q.id).toSet().length, 30);
      expect(exam.where((q) => q.topic == 'stat').length, 16);
      expect(exam.where((q) => q.topic == 'geografie').length, 7);
      expect(exam.where((q) => q.topic == 'historie' || q.topic == 'kultura').length, 7);

      expect(RealieRules.passFor(30), 18);
      expect(RealieRules.passFor(10), 6);
    });

    test('A2 ballari va o\'tish sharti', () {
      expect(A2Rules.scale(8, 10, 25), 20);
      expect(A2Rules.scale(0, 0, 25), 0);
      expect(A2Rules.writtenMax, 70);

      const pass = A2MockScore(reading: 15, writing: 12, listening: 15, speaking: 24);
      expect(pass.written, 42);
      expect(pass.passed, isTrue);

      const weakSpeaking = A2MockScore(reading: 25, writing: 20, listening: 25, speaking: 23);
      expect(weakSpeaking.passed, isFalse);
    });

    test('imtihongacha qolgan kunlar', () {
      final now = DateTime(2026, 11, 4, 23, 59);
      expect(daysUntil(DateTime(2026, 11, 5), now), 1);
      expect(daysUntil(DateTime(2026, 11, 4), now), 0);
      expect(daysUntil(DateTime(2026, 11, 1), now), -3);
    });

    test("kunlar soni to'g'ri ko'plik shaklida", () {
      expect(const S('cs').daysLeft(1), 'Do zkoušky: 1 den');
      expect(const S('cs').daysLeft(3), 'Do zkoušky: 3 dny');
      expect(const S('cs').daysLeft(12), 'Do zkoušky: 12 dní');
      expect(const S('ru').daysLeft(21), 'До экзамена: 21 день');
      expect(const S('ru').daysLeft(22), 'До экзамена: 22 дня');
      expect(const S('ru').daysLeft(12), 'До экзамена: 12 дней');
      expect(const S('uk').daysLeft(3), 'До іспиту: 3 дні');
      expect(const S('en').daysLeft(1), '1 day until your exam');
    });
  });
}
