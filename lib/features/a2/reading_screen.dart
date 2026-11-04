import 'dart:math';

import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/session_store.dart';
import 'package:czech_pass/features/a2/section_result_screen.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';
import 'package:czech_pass/widgets/locks.dart';
import 'package:czech_pass/widgets/question_block.dart';

/// A2 o'qish: chexcha matn va unga oid savollar.
/// Matn tarjima qilinmaydi (bu imtihonda tekshiriladigan ko'nikma), faqat savollar.
class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  Future<List<ReadingTask>>? _future;
  final _random = Random();

  List<ReadingTask> _tasks = [];
  int _total = 0; // bazadagi barcha topshiriqlar (bepul versiyada _tasks qisqaroq)
  final Map<String, List<int>> _orders = {}; // savol id → variantlar tartibi
  final Map<String, int> _picked = {}; // savol id → tanlangan asl variant
  int _taskIndex = 0;
  final Map<int, (int, int)> _scores = {}; // topshiriq → (to'g'ri, jami)
  bool _checked = false;
  bool _showTranslation = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<List<ReadingTask>> _load() async {
    final controller = AppScope.read(context);
    final tasks = await controller.repository.loadA2Reading();
    for (final task in tasks) {
      for (final q in task.questions) {
        _orders[q.id] = List<int>.generate(q.options.length, (i) => i)..shuffle(_random);
      }
    }
    _total = tasks.length;
    _tasks = controller.entitlements.limit(tasks, Tariff.residence, FreeLimits.a2TasksPerSkill);
    // Oldingi safar to'xtatilgan joydan davom etamiz.
    final saved = await SessionStore.load(Exams.a2Reading);
    final savedIndex = saved?['index'];
    if (savedIndex is int && savedIndex > 0 && savedIndex < _tasks.length) {
      _taskIndex = savedIndex;
      _scores.addAll(SessionStore.decodeScores(saved?['scores']));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).continueWhereLeft)));
      });
    }
    return tasks;
  }

  ReadingTask get _task => _tasks[_taskIndex];
  bool get _isLast => _taskIndex == _tasks.length - 1;
  bool get _allAnswered => _task.questions.every((q) => _picked.containsKey(q.id));

  void _check() {
    final controller = AppScope.read(context);
    for (final q in _task.questions) {
      controller.recordAnswer(Exams.a2Reading, q.id, _picked[q.id] == q.correctIndex);
    }
    final right = _task.questions.where((q) => _picked[q.id] == q.correctIndex).length;
    _scores[_taskIndex] = (right, _task.questions.length);
    setState(() => _checked = true);
  }

  /// Bo'lim tugadi: barcha topshiriqlar bo'yicha natija foizini ko'rsatamiz.
  void _finish(String section, WidgetBuilder restart) {
    SessionStore.clear(Exams.a2Reading);
    final s = S(AppScope.read(context).language.code);
    var right = 0;
    var total = 0;
    for (final (r, t) in _scores.values) {
      right += r;
      total += t;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SectionResultScreen(
          title: 'A2 · ${section == 'reading' ? s.reading : section == 'listening' ? s.listening : section == 'speaking' ? s.speaking : s.writing}',
          right: right,
          total: total,
          restart: restart,
          moreLocked: _tasks.length < _total ? Tariff.residence : null,
        ),
      ),
    );
  }

  void _next() {
    if (_isLast) {
      _finish('reading', (context) => const ReadingScreen());
      return;
    }
    setState(() {
      _taskIndex++;
      _checked = false;
    });
    SessionStore.save(Exams.a2Reading, {'index': _taskIndex, 'scores': SessionStore.encodeScores(_scores)});
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FutureBuilder<List<ReadingTask>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('${s.loadError}\n${snapshot.error}', textAlign: TextAlign.center)),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return _buildTask(s);
      },
    );
  }

  Widget _buildTask(S s) {
    final task = _task;
    final right = task.questions.where((q) => _picked[q.id] == q.correctIndex).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: 'A2 · ${s.reading}',
                tooltip: s.back,
                trailing: Text(
                  '${_taskIndex + 1} / ${_tasks.length}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    if (_tasks.length < _total) ...[
                      FreeLimitBanner(shown: _tasks.length, total: _total, tariff: Tariff.residence),
                      const SizedBox(height: 14),
                    ],
                    Text(
                      '${s.taskN(_taskIndex + 1)} · ${task.titleFor(s.lang)}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted),
                    ),
                    const SizedBox(height: 6),
                    Text(s.readingInstruction, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    AppCard(
                      child: Text(
                        task.text,
                        style: const TextStyle(fontSize: 16, height: 1.55),
                      ),
                    ),
                    if (s.lang != 'cs')
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _showTranslation = !_showTranslation),
                          icon: const Icon(Icons.translate, size: 18),
                          label: Text(_showTranslation ? s.hideTranslation : s.showTranslation),
                        ),
                      ),
                    for (var qi = 0; qi < task.questions.length; qi++) ...[
                      const SizedBox(height: 14),
                      QuestionBlock(
                        number: qi + 1,
                        question: task.questions[qi],
                        order: _orders[task.questions[qi].id]!,
                        picked: _picked[task.questions[qi].id],
                        checked: _checked,
                        lang: s.lang,
                        showTranslation: _showTranslation,
                        onPick: (option) => setState(() => _picked[task.questions[qi].id] = option),
                      ),
                    ],
                    if (_checked) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: right == task.questions.length ? AppColors.successSoft : AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          s.scoreShort(right, task.questions.length),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: right == task.questions.length ? AppColors.success : AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _checked ? _next : (_allAnswered ? _check : null),
                child: Text(_checked ? (_isLast ? s.finish : s.nextTask) : s.checkAnswers),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
