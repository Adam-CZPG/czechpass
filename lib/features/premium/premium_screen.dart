import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// To'liq versiya: alohida tariflar (A2, fuqarolik yoki ikkalasi). Bir martalik xarid.
/// Google Play Billing keyingi bosqichda `in_app_purchase` paketi bilan ulanadi.
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, this.initial = Tariff.residence});

  final Tariff initial;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  late Tariff _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final options = [
      (Tariff.residence, s.trackResidence, s.includesA2, null),
      (Tariff.citizenship, s.trackCitizenship, s.includesCitizenship, null),
      (Tariff.both, s.trackBoth, s.includesBoth, s.savePrice(Prices.format(Prices.bundleSaving))),
    ];

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
            Text(s.premiumSubtitle, style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.muted)),
            const SizedBox(height: 20),
            Text(s.chooseTariff, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            for (final (tariff, title, includes, badge) in options) ...[
              _TariffTile(
                title: title,
                includes: includes,
                price: Prices.of(tariff),
                badge: badge,
                selected: _selected == tariff,
                onTap: () => setState(() => _selected = tariff),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            for (final (title, text) in s.premiumFeatures.skip(1)) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.check_rounded, size: 18, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(text, style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Text(s.viaPlay, style: TextStyle(fontSize: 13, color: AppColors.muted)),
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
                child: Text(s.buyFor(Prices.of(_selected))),
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

class _TariffTile extends StatelessWidget {
  const _TariffTile({
    required this.title,
    required this.includes,
    required this.price,
    required this.badge,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String includes;
  final String price;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.accentSoft : AppColors.card,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: selected ? AppColors.accent : AppColors.border, width: 2),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: selected ? AppColors.accent : AppColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          ),
                          Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(includes, style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
                      if (badge != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
