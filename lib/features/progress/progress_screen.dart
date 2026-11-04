import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// Umumiy progress: České reálie (mavzular bo'yicha) va A2 o'qish.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Future<(QuestionBank, List<ReadingTask>, List<ListeningTask>)>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repository = AppScope.read(context).repository;
    _future ??= () async {
      final bank = await repository.loadRealie();
      final reading = await repository.loadA2Reading();
      final listening = await repository.loadA2Listening();
      return (bank, reading, listening);
    }();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final progress = AppScope.of(context).progress;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<(QuestionBank, List<ReadingTask>, List<ListeningTask>)>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final (bank, reading, listening) = snapshot.data!;
            final readingQuestions = [for (final t in reading) ...t.questions];
            final listeningQuestions = [for (final t in listening) ...t.questions];
            final nothingYet = progress.answeredCount(Exams.realie) == 0 &&
                progress.answeredCount(Exams.a2Reading) == 0 &&
                progress.answeredCount(Exams.a2Listening) == 0;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                ScreenHeader(title: s.navProgress, tooltip: s.back),
                const SizedBox(height: 20),
                if (nothingYet) ...[
                  AppCard(
                    child: Text(s.noProgress, style: const TextStyle(fontSize: 15, height: 1.5)),
                  ),
                  const SizedBox(height: 14),
                ],
                _ExamProgress(
                  title: 'České reálie',
                  questions: bank.questions,
                  exam: Exams.realie,
                  progress: progress,
                  s: s,
                  topics: [
                    for (final topic in bank.topics.keys)
                      (
                        bank.topicLabel(topic, s.lang),
                        bank.questions.where((q) => q.topic == topic).toList(),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                _ExamProgress(
                  title: '${s.a2Title} · ${s.reading}',
                  questions: readingQuestions,
                  exam: Exams.a2Reading,
                  progress: progress,
                  s: s,
                  topics: const [],
                ),
                const SizedBox(height: 14),
                _ExamProgress(
                  title: '${s.a2Title} · ${s.listening}',
                  questions: listeningQuestions,
                  exam: Exams.a2Listening,
                  progress: progress,
                  s: s,
                  topics: const [],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ExamProgress extends StatelessWidget {
  const _ExamProgress({
    required this.title,
    required this.questions,
    required this.exam,
    required this.progress,
    required this.s,
    required this.topics,
  });

  final String title;
  final List<Question> questions;
  final String exam;
  final ProgressStore progress;
  final S s;
  final List<(String, List<Question>)> topics;

  @override
  Widget build(BuildContext context) {
    int correctIn(List<Question> list) =>
        list.where((q) => progress.resultFor(exam, q.id) == true).length;
    int answeredIn(List<Question> list) =>
        list.where((q) => progress.resultFor(exam, q.id) != null).length;

    final total = questions.length;
    final correct = correctIn(questions);
    final percent = total == 0 ? 0 : (correct * 100 / total).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            s.answeredOf(answeredIn(questions), total),
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          ProgressLine(value: total == 0 ? 0 : correct / total),
          const SizedBox(height: 6),
          Text(s.mastered(percent), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          for (final (label, list) in topics) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                Text(
                  '${correctIn(list)} / ${list.length}',
                  style: const TextStyle(fontSize: 14, color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ProgressLine(value: list.isEmpty ? 0 : correctIn(list) / list.length, height: 6),
          ],
        ],
      ),
    );
  }
}
