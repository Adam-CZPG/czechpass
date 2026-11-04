import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// To'liq versiya (bir martalik xarid).
/// Google Play Billing keyingi bosqichda `in_app_purchase` paketi bilan ulanadi.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  /// Vaqtinchalik narx. Haqiqiy narx Google Play Console'dan olinadi.
  static const price = '299 Kč';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.filledTonal(
                tooltip: s.close,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.premiumTitle,
              style: const TextStyle(fontSize: 30, height: 1.15, fontWeight: FontWeight.w800, letterSpacing: -0.6),
            ),
            const SizedBox(height: 10),
            Text(s.premiumSubtitle, style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.muted)),
            const SizedBox(height: 24),
            for (final (title, text) in s.premiumFeatures) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.check_rounded, size: 18, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(text, style: const TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(s.fullVersion, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      ),
                      const Text(price, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(s.viaPlay, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () => showComingSoon(context, s.billingSoon),
                child: Text(s.buyFor(price)),
              ),
              TextButton(
                onPressed: () => showComingSoon(context, s.billingSoon),
                child: Text(s.restore),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
