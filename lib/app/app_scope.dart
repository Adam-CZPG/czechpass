import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';

import 'package:czech_pass/core/answer_feedback.dart';
import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/core/badges.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question_repository.dart';
import 'package:czech_pass/core/reminder_service.dart';
import 'package:czech_pass/core/settings_store.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/l10n/strings.dart';

/// Ilovaning umumiy holati: til, progress va savollar manbasi.
/// O'zgarganda (til almashsa, javob saqlansa) ekranlar avtomatik yangilanadi.
class AppController extends ChangeNotifier {
  AppController({
    required this.settings,
    required this.progress,
    this.repository = const QuestionRepository(),
    AppLanguage? initialLanguage,
    this.systemLanguage,
    Entitlements? entitlements,
    DateTime? initialExamDate,
    int initialDailyGoal = SettingsStore.defaultGoal,
    int? initialReminder,
    BadgeStore? badges,
    ThemeMode initialThemeMode = ThemeMode.system,
    bool initialAnswerSound = true,
  })  : _language = initialLanguage,
        _answerSound = initialAnswerSound,
        _themeMode = initialThemeMode,
        badges = badges ?? BadgeStore.memory(),
        _reminder = initialReminder,
        entitlements = entitlements ?? Entitlements(),
        _examDate = initialExamDate,
        _dailyGoal = initialDailyGoal;

  final SettingsStore settings;
  final ProgressStore progress;
  final QuestionRepository repository;

  /// Sotib olingan tariflar va bepul urinishlar.
  final Entitlements entitlements;

  /// Olingan nishonlar.
  final BadgeStore badges;

  /// Yangi nishon olinganda chaqiriladi (ekranda qisqa xabar ko'rsatish uchun).
  void Function(AppBadge badge)? onBadge;

  int? _realieTotal;

  Future<void> _checkBadges() async {
    _realieTotal ??= (await repository.loadRealie()).questions.length;
    final fresh = await badges.award(BadgeStore.qualified(
      progress: progress,
      dailyGoal: dailyGoal,
      realieTotal: _realieTotal!,
    ));
    _announce(fresh);
  }

  void _announce(List<AppBadge> fresh) {
    if (fresh.isEmpty) return;
    notifyListeners();
    for (final badge in fresh) {
      onBadge?.call(badge);
    }
  }

  /// Sinov imtihonidan o'tilganda.
  Future<void> markMockPassed(AppBadge badge) async => _announce(await badges.award([badge]));

  DateTime? _examDate;
  int _dailyGoal;
  int? _reminder;

  /// Kunlik eslatma vaqti (kun boshidan daqiqalar); o'chirilgan bo'lsa — null.
  int? get reminderMinutes => _reminder;

  static String formatMinutes(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

  /// Eslatmani yoqadi (yoki vaqtini o'zgartiradi). Ruxsat berilmasa — false.
  Future<bool> enableReminder(int minutes) async {
    if (!await ReminderService.requestPermission()) return false;
    _reminder = minutes;
    notifyListeners();
    await settings.saveReminder(minutes);
    await rescheduleReminder();
    return true;
  }

  Future<void> disableReminder() async {
    _reminder = null;
    notifyListeners();
    await settings.saveReminder(null);
    await ReminderService.cancel();
  }

  /// Eslatma matni tanlangan tilda bo'lishi uchun til o'zgarganda ham qayta rejalashtiriladi.
  Future<void> rescheduleReminder() async {
    final minutes = _reminder;
    if (minutes == null) return;
    final s = S(language.code);
    try {
      await ReminderService.scheduleDaily(
        hour: minutes ~/ 60,
        minute: minutes % 60,
        title: 'CzechPass',
        body: s.reminderBody(formatMinutes(minutes)),
        channelName: s.reminderTitle,
      );
    } catch (_) {
      // Eslatmani rejalashtirib bo'lmasa, ilova ishlashda davom etadi.
    }
  }

  /// Foydalanuvchi belgilagan imtihon sanasi (belgilanmagan bo'lsa — null).
  DateTime? get examDate => _examDate;

  /// Kunlik maqsad: bir kunda beriladigan javoblar soni.
  int get dailyGoal => _dailyGoal;

  /// Telefon tili, agar u ilovadagi tillardan biri bo'lsa (aks holda null).
  final AppLanguage? systemLanguage;

  AppLanguage? _language;

  /// Foydalanuvchi hali til tanlamagan bo'lsa — null.
  AppLanguage? get selectedLanguage => _language;

  /// Interfeys tili: foydalanuvchi tanlagan til → telefon tili → chex tili.
  AppLanguage get language => _language ?? systemLanguage ?? AppLanguage.cs;

  /// Telefon mavzusi (yorug'/qorong'i) o'zgarganda ekranlarni qayta chizish uchun.
  void refreshTheme() => notifyListeners();

  ThemeMode _themeMode;

  /// Foydalanuvchi tanlagan mavzu: tizim (standart), yorug' yoki qorong'i.
  ThemeMode get themeMode => _themeMode;

  /// Hozir qorong'i ranglar ishlatiladimi (tanlov + telefonning yorqinlik sozlamasi).
  bool isDark(Brightness platform) =>
      _themeMode == ThemeMode.dark || (_themeMode == ThemeMode.system && platform == Brightness.dark);

  bool _answerSound;

  /// Javobdan keyingi ovoz va tebranish yoqilganmi.
  bool get answerSound => _answerSound;

  Future<void> setAnswerSound(bool on) async {
    _answerSound = on;
    AnswerFeedback.enabled = on;
    notifyListeners();
    await settings.saveAnswerSound(on);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await settings.saveThemeMode(mode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    await settings.saveLanguage(language);
    await rescheduleReminder();
  }

  Future<void> setExamDate(DateTime? date) async {
    _examDate = date;
    notifyListeners();
    await settings.saveExamDate(date);
  }

  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal;
    notifyListeners();
    await settings.saveDailyGoal(goal);
  }

  /// Bepul sinov imtihoni urinishini hisobga oladi.
  Future<void> useMock(String mock, Tariff tariff) async {
    await entitlements.useMock(mock, tariff);
    notifyListeners();
  }

  Future<void> recordAnswer(String exam, String questionId, bool correct) async {
    await progress.record(exam, questionId, correct);
    notifyListeners();
    try {
      await _checkBadges();
    } catch (_) {
      // Nishonlarni hisoblab bo'lmasa ham mashg'ulot davom etadi.
    }
  }

  Future<void> resetProgress() async {
    await progress.clear();
    notifyListeners();
  }
}

/// `AppScope.of(context)` orqali istalgan ekrandan AppController'ga yetish.
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({super.key, required AppController controller, required super.child})
      : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope topilmadi');
    return scope!.notifier!;
  }

  /// Tugma bosilganda va boshqa build'dan tashqari joylarda ishlatiladi
  /// (ekranni o'zgarishlarga obuna qilmaydi).
  static AppController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope topilmadi');
    return scope!.notifier!;
  }
}
