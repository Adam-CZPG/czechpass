import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// Barcha bo'limlar bo'yicha savol yoki topshiriq id'lari.
class _CourseData {
  const _CourseData({
    required this.bank,
    required this.reading,
    required this.listening,
    required this.speaking,
    required this.writing,
  });

  final QuestionBank bank;
  final List<String> reading;
  final List<String> listening;
  final List<String> speaking;
  final List<String> writing;
}

/// Umumiy kurs natijasi va har bir bo'lim bo'yicha progress.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Future<_CourseData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repository = AppScope.read(context).repository;
    _future ??= () async {
      final bank = await repository.loadRealie();
      final reading = await repository.loadA2Reading();
      final listening = await repository.loadA2Listening();
      final speaking = await repository.loadA2Speaking();
      final writing = await repository.loadA2Writing();
      return _CourseData(
        bank: bank,
        reading: [for (final t in reading) for (final q in t.questions) q.id],
        listening: [for (final t in listening) for (final q in t.questions) q.id],
        speaking: [for (final t in speaking) t.id],
        writing: [for (final t in writing) t.id],
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final progress = AppScope.of(context).progress;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<_CourseData>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final data = snapshot.data!;
            final bank = data.bank;
            final realieIds = [for (final q in bank.questions) q.id];

            final sections = <(String, String, List<String>)>[
              ('České reálie', Exams.realie, realieIds),
              ('A2 · ${s.reading}', Exams.a2Reading, data.reading),
              ('A2 · ${s.listening}', Exams.a2Listening, data.listening),
              ('A2 · ${s.speaking}', Exams.a2Speaking, data.speaking),
              ('A2 · ${s.writing}', Exams.a2Writing, data.writing),
            ];

            // Umumiy kurs: barcha bo'limlarda to'g'ri bajarilgan savol/topshiriqlar ulushi.
            var done = 0;
            var all = 0;
            for (final (_, exam, ids) in sections) {
              all += ids.length;
              done += ids.where((id) => progress.resultFor(exam, id) == true).length;
            }
            final coursePercent = all == 0 ? 0 : (done * 100 / all).round();
            final nothingYet = sections.every((sec) => progress.answeredCount(sec.$2) == 0);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                ScreenHeader(title: s.navProgress, tooltip: s.back),
                const SizedBox(height: 20),
                _CourseCard(percent: coursePercent, done: done, all: all, s: s),
                const SizedBox(height: 14),
                if (nothingYet) ...[
                  AppCard(child: Text(s.noProgress, style: const TextStyle(fontSize: 15, height: 1.5))),
                  const SizedBox(height: 14),
                ],
                for (final (title, exam, ids) in sections) ...[
                  _SectionProgress(
                    title: title,
                    exam: exam,
                    ids: ids,
                    progress: progress,
                    s: s,
                    topics: exam == Exams.realie
                        ? [
                            for (final topic in bank.topics.keys)
                              (
                                bank.topicLabel(topic, s.lang),
                                [for (final q in bank.questions.where((q) => q.topic == topic)) q.id],
                              ),
                          ]
                        : const [],
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.percent, required this.done, required this.all, required this.s});

  final int percent;
  final int done;
  final int all;
  final S s;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Semantics(
              label: s.courseCompleted(percent),
              excludeSemantics: true,
              child: SizedBox(
                width: 84,
                height: 84,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: all == 0 ? 0 : done / all,
                      strokeWidth: 9,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(0xFF2E3F58),
                      color: Colors.white,
                    ),
                    Center(
                      child: Text(
                        '$percent%',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.courseTotal,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.courseCompleted(percent),
                    style: const TextStyle(fontSize: 14, color: Color(0xFFC9D2E0)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$done / $all',
                    style: const TextStyle(fontSize: 13, color: Color(0xFFC9D2E0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionProgress extends StatelessWidget {
  const _SectionProgress({
    required this.title,
    required this.exam,
    required this.ids,
    required this.progress,
    required this.s,
    required this.topics,
  });

  final String title;
  final String exam;
  final List<String> ids;
  final ProgressStore progress;
  final S s;
  final List<(String, List<String>)> topics;

  @override
  Widget build(BuildContext context) {
    int correctIn(List<String> list) => list.where((id) => progress.resultFor(exam, id) == true).length;
    int answeredIn(List<String> list) => list.where((id) => progress.resultFor(exam, id) != null).length;

    final total = ids.length;
    final correct = correctIn(ids);
    final percent = total == 0 ? 0 : (correct * 100 / total).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
              Text('$percent%', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.accent)),
            ],
          ),
          const SizedBox(height: 4),
          Text(s.answeredOf(answeredIn(ids), total), style: const TextStyle(fontSize: 13, color: AppColors.muted)),
          const SizedBox(height: 12),
          ProgressLine(value: total == 0 ? 0 : correct / total),
          for (final (label, list) in topics) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                Text('${correctIn(list)} / ${list.length}', style: const TextStyle(fontSize: 14, color: AppColors.muted)),
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
