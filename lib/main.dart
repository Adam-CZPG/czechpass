import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/answer_feedback.dart';
import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/core/app_update.dart';
import 'package:czech_pass/core/badges.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/settings_store.dart';
import 'package:czech_pass/features/home/home_screen.dart';
import 'package:czech_pass/features/onboarding/language_screen.dart';
import 'package:czech_pass/l10n/strings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Vebda accessibility daraxtini yoqamiz: ekran o'quvchilar va Playwright testlari
  // matn va tugmalarni shu orqali topadi.
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  final settings = SettingsStore();
  final dispatcher = WidgetsBinding.instance.platformDispatcher;
  final controller = AppController(
    settings: settings,
    progress: await ProgressStore.load(),
    initialLanguage: await settings.loadLanguage(),
    // Birinchi ochilishda telefon tili (agar ilovada bo'lsa), aks holda chex tili.
    systemLanguage: AppLanguage.fromLocales(dispatcher.locales.map((l) => l.languageCode)),
    entitlements: await Entitlements.load(),
    initialExamDate: await settings.loadExamDate(),
    initialDailyGoal: await settings.loadDailyGoal(),
    initialReminder: await settings.loadReminder(),
    badges: await BadgeStore.load(),
    initialThemeMode: await settings.loadThemeMode(),
    initialAnswerSound: await settings.loadAnswerSound(),
  );
  AnswerFeedback.enabled = controller.answerSound;
  // Ilova yangilangandan keyin ham eslatma ishlashi uchun qayta rejalashtiramiz.
  controller.rescheduleReminder();
  runApp(CzechPassApp(controller: controller));
}

class CzechPassApp extends StatefulWidget {
  const CzechPassApp({super.key, required this.controller});

  final AppController controller;

  @override
  State<CzechPassApp> createState() => _CzechPassAppState();
}

/// Telefonning yorug'/qorong'i mavzusini kuzatadi.
class _CzechPassAppState extends State<CzechPassApp> with WidgetsBindingObserver {
  AppController get controller => widget.controller;
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncBrightness();
    controller.onBadge = _showBadge;
    // Ilova ochilgach Google Play'da yangi versiya bor-yo'qligini tekshiramiz.
    WidgetsBinding.instance.addPostFrameCallback((_) => AppUpdate.check(_navigatorKey, controller.language.code));
  }

  void _showBadge(AppBadge badge) {
    final s = S(controller.language.code);
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(badge.icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(s.badgeEarned(badge.titleFor(s.lang)))),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _syncBrightness();
    setState(() {});
    controller.refreshTheme();
  }

  void _syncBrightness() {
    AppColors.dark = controller.isDark(WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      // Til yoki mavzu o'zgarganda butun ilova qayta chiziladi.
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          _syncBrightness();
          return MaterialApp(
            navigatorKey: _navigatorKey,
            scaffoldMessengerKey: _messengerKey,
            title: 'CzechPass',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(Brightness.light),
            darkTheme: buildTheme(Brightness.dark),
            themeMode: AppColors.dark ? ThemeMode.dark : ThemeMode.light,
            // Tizim oynalari (masalan, sana tanlash) ham ilova tilida chiqadi.
            locale: Locale(controller.language.code),
            supportedLocales: [for (final l in AppLanguage.values) Locale(l.code)],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            // Til hali tanlanmagan bo'lsa — til tanlash ekrani, aks holda bosh sahifa.
            home: controller.selectedLanguage == null
                ? const LanguageScreen(isOnboarding: true)
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
