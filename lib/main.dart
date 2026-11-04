import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
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
  final controller = AppController(
    settings: settings,
    progress: await ProgressStore.load(),
    initialLanguage: await settings.loadLanguage(),
  );
  runApp(CzechPassApp(controller: controller));
}

class CzechPassApp extends StatelessWidget {
  const CzechPassApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: MaterialApp(
        title: 'CzechPass',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        // Til hali tanlanmagan bo'lsa — til tanlash ekrani, aks holda bosh sahifa.
        home: controller.selectedLanguage == null
            ? const LanguageScreen(isOnboarding: true)
            : const HomeScreen(),
      ),
    );
  }
}
