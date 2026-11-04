import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// A2 bo'limi (o'qish, tinglash, gapirish, yozish) tugaganda ko'rsatiladigan natija.
class SectionResultScreen extends StatelessWidget {
  const SectionResultScreen({
    super.key,
    required this.title,
    required this.right,
    required this.total,
    required this.restart,
  });

  final String title;
  final int right;
  final int total;

  /// "Qayta urinish" bosilganda ochiladigan ekran.
  final WidgetBuilder restart;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final ratio = total == 0 ? 0.0 : right / total;
    final percent = (ratio * 100).round();
    final verdict = ratio >= 0.8
        ? s.resultGreat
        : ratio >= 0.5
            ? s.resultGood
            : s.resultLow;
    final color = ratio >= 0.8
        ? AppColors.success
        : ratio >= 0.5
            ? AppColors.accent
            : const Color(0xFFD9822B);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            ScreenHeader(title: '$title · ${s.result}', tooltip: s.close, icon: Icons.close),
            const SizedBox(height: 28),
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Semantics(
                    label: s.scoreLabel(right, total, percent),
                    excludeSemantics: true,
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: ratio,
                            strokeWidth: 14,
                            strokeCap: StrokeCap.round,
                            backgroundColor: AppColors.border,
                            color: color,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('$percent%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
                                Text('$right / $total', style: const TextStyle(fontSize: 14, color: AppColors.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(verdict, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    s.sectionScore(percent),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: AppColors.muted),
                  ),
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
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: restart)),
                child: Text(s.retry),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(s.navHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
