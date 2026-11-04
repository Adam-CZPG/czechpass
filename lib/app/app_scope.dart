import 'package:flutter/widgets.dart';

import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question_repository.dart';
import 'package:czech_pass/core/settings_store.dart';
import 'package:czech_pass/core/tariff.dart';

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
    DateTime? examDate,
    int dailyGoal = SettingsStore.defaultGoal,
  })  : _language = initialLanguage,
        entitlements = entitlements ?? Entitlements(),
        _examDate = examDate,
        _dailyGoal = dailyGoal;

  final SettingsStore settings;
  final ProgressStore progress;
  final QuestionRepository repository;

  /// Sotib olingan tariflar va bepul urinishlar.
  final Entitlements entitlements;

  DateTime? _examDate;
  int _dailyGoal;

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

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    await settings.saveLanguage(language);
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
