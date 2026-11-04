import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/features/quiz/quiz_screen.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.answers,
    required this.bank,
    required this.mode,
  });

  final List<AnswerRecord> answers;
  final QuestionBank bank;
  final QuizMode mode;

  void _restart(BuildContext context, QuizMode next) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => QuizScreen(mode: next)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final total = answers.length;
    final right = answers.where((a) => a.correct).length;
    final wrong = total - right;
    final ratio = total == 0 ? 0.0 : right / total;
    final percent = (ratio * 100).round();

    // Mavzular bo'yicha hisob (JSON'dagi tartibda).
    final topicStats = <String, (int, int)>{};
    for (final topic in bank.topics.keys) {
      final items = answers.where((a) => a.topic == topic).toList();
      if (items.isEmpty) continue;
      topicStats[topic] = (items.where((a) => a.correct).length, items.length);
    }

    String? weakest;
    var weakestRatio = 1.0;
    topicStats.forEach((topic, stat) {
      final r = stat.$1 / stat.$2;
      if (r < weakestRatio) {
        weakestRatio = r;
        weakest = topic;
      }
    });

    final title = ratio >= 0.8
        ? s.resultGreat
        : ratio >= 0.5
            ? s.resultGood
            : s.resultLow;
    final advice = weakest == null ? s.adviceAll : s.adviceTopic(bank.topicLabel(weakest!, s.lang));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            ScreenHeader(title: 'České reálie · ${s.result}', tooltip: s.close, icon: Icons.close),
            const SizedBox(height: 20),
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Semantics(
                    label: s.scoreLabel(right, total, percent),
                    excludeSemantics: true,
                    child: SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: ratio,
                            strokeWidth: 12,
                            strokeCap: StrokeCap.round,
                            backgroundColor: AppColors.border,
                            color: AppColors.accent,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('$right/$total', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                                Text('$percent%', style: const TextStyle(fontSize: 13, color: AppColors.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    advice,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(s.byTopic, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  for (final entry in topicStats.entries) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bank.topicLabel(entry.key, s.lang),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${entry.value.$1} / ${entry.value.$2}',
                          style: const TextStyle(fontSize: 14, color: AppColors.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ProgressLine(
                      value: entry.value.$1 / entry.value.$2,
                      color: entry.value.$1 / entry.value.$2 < 0.7 ? const Color(0xFFD9822B) : AppColors.accent,
                    ),
                  ],
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
              if (wrong > 0)
                FilledButton(
                  onPressed: () => _restart(context, QuizMode.mistakes),
                  child: Text(s.reviewMistakes(wrong)),
                )
              else
                FilledButton(
                  onPressed: () => _restart(context, mode == QuizMode.mistakes ? QuizMode.practice : mode),
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
