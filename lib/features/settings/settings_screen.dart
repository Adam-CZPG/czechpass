import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/features/onboarding/language_screen.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const appVersion = '0.1.0';

  Future<void> _confirmReset(BuildContext context, S s) async {
    final controller = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.resetProgress),
        content: Text(s.resetConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(s.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 44), backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(s.reset),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await controller.resetProgress();
    messenger.showSnackBar(SnackBar(content: Text(s.progressCleared)));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final language = AppScope.of(context).language;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            ScreenHeader(title: s.navSettings, tooltip: s.back),
            const SizedBox(height: 20),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(s.appLanguage),
                    subtitle: Text(language.nativeName),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    ),
                  ),
                  Divider(height: 1, color: AppColors.border),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(s.privacyPolicy),
                    trailing: const Icon(Icons.chevron_right),
                    // TODO: maxfiylik siyosati sahifasi tayyor bo'lgach, havolani oching.
                    onTap: () => showComingSoon(context, s.comingSoon),
                  ),
                  Divider(height: 1, color: AppColors.border),
                  ListTile(
                    leading: Icon(Icons.restart_alt, color: AppColors.error),
                    title: Text(s.resetProgress, style: TextStyle(color: AppColors.error)),
                    onTap: () => _confirmReset(context, s),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.about, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(s.aboutText, style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted)),
                  const SizedBox(height: 12),
                  Text('${s.version} $appVersion', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
