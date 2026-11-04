import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/app_language.dart';
import 'package:czech_pass/features/home/home_screen.dart';
import 'package:czech_pass/l10n/strings.dart';

/// Til tanlash. Birinchi ochilishda (onboarding) va Sozlamalardan ochiladi.
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key, this.isOnboarding = false});

  final bool isOnboarding;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  AppLanguage? _selected;
  bool _saving = false;

  Future<void> _continue() async {
    final controller = AppScope.read(context);
    final navigator = Navigator.of(context);
    setState(() => _saving = true);
    await controller.setLanguage(_selected ?? controller.language);
    if (!mounted) return;
    if (widget.isOnboarding) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context);
    final selected = _selected ?? controller.language;
    // Tanlanayotgan til bo'yicha matnlar darhol o'zgaradi.
    final s = S(selected.code);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isOnboarding)
                const _Logo()
              else
                IconButton.filledTonal(
                  tooltip: s.back,
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              const SizedBox(height: 28),
              Text(
                s.chooseLanguage,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.6),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vyberte jazyk · Choose language · Выберите язык · Оберіть мову · Tilni tanlang',
                style: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.5),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: AppLanguage.values.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final language = AppLanguage.values[index];
                    return _LanguageTile(
                      language: language,
                      selected: language == selected,
                      onTap: () => setState(() => _selected = language),
                    );
                  },
                ),
              ),
              Text(
                s.languageNote,
                style: const TextStyle(fontSize: 13, color: AppColors.muted, height: 1.5),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _continue,
                  child: Text(s.continueBtn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Text('CzechPass', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.language, required this.selected, required this.onTap});

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.accentSoft : Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? AppColors.accent : AppColors.border, width: 2),
        ),
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      language.badge,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      language.nativeName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.accent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
