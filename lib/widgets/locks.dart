import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/features/premium/premium_screen.dart';
import 'package:czech_pass/l10n/strings.dart';

/// Tariflar ekranini ochadi.
void openPremium(BuildContext context, Tariff tariff) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PremiumScreen(initial: tariff)));
}

/// Bepul versiyada ko'rsatiladigan ogohlantirish: "Bepul versiya: 2 / 12".
class FreeLimitBanner extends StatelessWidget {
  const FreeLimitBanner({super.key, required this.shown, required this.total, required this.tariff});

  final int shown;
  final int total;
  final Tariff tariff;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Material(
      color: AppColors.accentSoft,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openPremium(context, tariff),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.lock_outline, size: 20, color: AppColors.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.freeVersionNote(shown, total),
                  style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.ink),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bepul urinish tugaganda yoki bepul qism tugaganda ko'rsatiladigan ekran.
class LockedScreen extends StatelessWidget {
  const LockedScreen({super.key, required this.title, required this.text, required this.tariff});

  final String title;
  final String text;
  final Tariff tariff;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.lock_outline, size: 56, color: AppColors.accent),
              const SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.muted)),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PremiumScreen(initial: tariff)),
                ),
                child: Text(s.unlockButton),
              ),
              const SizedBox(height: 10),
              TextButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(s.back)),
            ],
          ),
        ),
      ),
    );
  }
}
