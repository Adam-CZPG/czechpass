import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/settings_store.dart';
import 'package:czech_pass/core/speech_service.dart';
import 'package:czech_pass/core/writing_checker.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/main.dart';

void main() {
  testWidgets("Til tanlanmagan bo'lsa, til tanlash ekrani chiqadi", (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppController(settings: SettingsStore(), progress: await ProgressStore.load());
    await tester.pumpWidget(CzechPassApp(controller: controller));

    expect(find.text('Vyberte jazyk'), findsOneWidget);
    // Ro'yxat boshidagi til (pastdagilari kichik test ekranida hali chizilmagan bo'ladi).
    expect(find.text('Čeština'), findsOneWidget);
  });

  testWidgets("Til saqlangan bo'lsa, bosh sahifa chiqadi", (tester) async {
    SharedPreferences.setMockInitialValues({'app_language': 'uz'});
    final controller = AppController(
      settings: SettingsStore(),
      progress: await ProgressStore.load(),
      initialLanguage: AppLanguage.uz,
    );
    await tester.pumpWidget(CzechPassApp(controller: controller));

    expect(find.text('Qaysi imtihonga tayyorlanamiz?'), findsOneWidget);
  });

  test('Matnlar tanlangan tilda chiqadi', () {
    expect(const S('cs').welcome, 'Vítejte');
    expect(const S('en').welcome, 'Welcome');
    expect(const S('uz').mastered(40), "40% o'zlashtirildi");
    expect(const S('vi').welcome, 'Xin chào');
    expect(const S('vi').courseCompleted(75), 'Đã hoàn thành 75% khóa học');
    // Noma'lum til bo'lsa — chex tili.
    expect(const S('xx').welcome, 'Vítejte');
  });

  test('Chex harflari solishtirish uchun soddalashtiriladi', () {
    expect(foldCzech('Bydlím v Plzni'), 'bydlim v plzni');
    expect(foldCzech('Bolí mě hlava').contains(foldCzech('bolí mě')), true);
  });

  test('Yozish tekshiruvi qisqa va salomlashuvsiz matnni topadi', () {
    const checker = WritingChecker();
    final bad = checker.check('jsem nemocny', minWords: 25);
    expect(bad, contains(WritingCheck.tooShort));
    expect(bad, contains(WritingCheck.greetingMissing));

    final good = checker.check(
      'Dobrý den, pane Nováku, omlouvám se, ale dnes nepřijdu do práce. Jsem nemocný, mám horečku '
      'a bolí mě v krku. Lékař mi napsal neschopenku do pátku. V pondělí už budu v práci. S pozdravem Aziz',
      minWords: 25,
    );
    expect(good, containsAll([WritingCheck.lengthOk, WritingCheck.greetingOk, WritingCheck.closingOk]));
    expect(good, isNot(contains(WritingCheck.fewDiacritics)));
  });

  test("Progress saqlanadi va xatolar ajratiladi", () async {
    SharedPreferences.setMockInitialValues({});
    final store = await ProgressStore.load();
    await store.record(Exams.realie, 'a', true);
    await store.record(Exams.realie, 'b', false);

    expect(store.answeredCount(Exams.realie), 2);
    expect(store.correctCount(Exams.realie), 1);
    expect(store.mistakes(Exams.realie), {'b'});

    // Qayta yuklanganda ham saqlanib qoladi.
    final reloaded = await ProgressStore.load();
    expect(reloaded.resultFor(Exams.realie, 'b'), false);

    await reloaded.clear();
    expect(reloaded.answeredCount(Exams.realie), 0);
  });
}
