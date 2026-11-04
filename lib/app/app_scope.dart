import 'package:flutter/widgets.dart';

import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question_repository.dart';
import 'package:czech_pass/core/settings_store.dart';

/// Ilovaning umumiy holati: til, progress va savollar manbasi.
/// O'zgarganda (til almashsa, javob saqlansa) ekranlar avtomatik yangilanadi.
class AppController extends ChangeNotifier {
  AppController({
    required this.settings,
    required this.progress,
    this.repository = const QuestionRepository(),
    AppLanguage? initialLanguage,
    this.systemLanguage,
  }) : _language = initialLanguage;

  final SettingsStore settings;
  final ProgressStore progress;
  final QuestionRepository repository;

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
