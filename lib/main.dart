import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/settings_store.dart';
import 'package:czech_pass/features/home/home_screen.dart';
import 'package:czech_pass/features/onboarding/language_screen.dart';

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
  );
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncBrightness();
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
    AppColors.dark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: MaterialApp(
        title: 'CzechPass',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        themeMode: AppColors.dark ? ThemeMode.dark : ThemeMode.light,
        // Til hali tanlanmagan bo'lsa — til tanlash ekrani, aks holda bosh sahifa.
        home: controller.selectedLanguage == null
            ? const LanguageScreen(isOnboarding: true)
            : const HomeScreen(),
      ),
    );
  }
}
