import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/session_store.dart';
import 'package:czech_pass/core/writing_checker.dart';
import 'package:czech_pass/features/a2/section_result_screen.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';
import 'package:czech_pass/widgets/locks.dart';
import 'package:czech_pass/widgets/no_paste.dart';

/// A2 yozish: foydalanuvchi chexcha matn yozadi, ilova uzunlik, salomlashuv,
/// xayrlashuv va chex harflarini tekshiradi; bandlarni foydalanuvchi o'zi belgilaydi.
/// Grammatikani AI bilan tuzatish keyingi versiyada (core/ai_writing_service.dart).
class WritingScreen extends StatefulWidget {
  const WritingScreen({super.key});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  Future<List<WritingTask>>? _future;
  final _text = TextEditingController();
  final _checker = const WritingChecker();

  List<WritingTask> _tasks = [];
  int _total = 0; // bazadagi barcha topshiriqlar (bepul versiyada _tasks qisqaroq)
  int _taskIndex = 0;
  final Map<int, (int, int)> _scores = {}; // topshiriq → (o'tgan tekshiruvlar, jami)
  bool _checked = false;
  bool _showModel = false;
  final Set<int> _ticked = {};
  List<WritingCheck> _results = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<List<WritingTask>> _load() async {
    final controller = AppScope.read(context);
    final tasks = await controller.repository.loadA2Writing();
    _total = tasks.length;
    _tasks = controller.entitlements.limit(tasks, Tariff.residence, FreeLimits.a2TasksPerSkill);
    // Oldingi safar to'xtatilgan joydan davom etamiz.
    final saved = await SessionStore.load(Exams.a2Writing);
    final savedIndex = saved?['index'];
    if (savedIndex is int && savedIndex > 0 && savedIndex < _tasks.length) {
      _taskIndex = savedIndex;
      _scores.addAll(SessionStore.decodeScores(saved?['scores']));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).continueWhereLeft)));
      });
    }
    return _tasks;
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  WritingTask get _task => _tasks[_taskIndex];
  bool get _isLast => _taskIndex == _tasks.length - 1;

  void _check() {
    FocusScope.of(context).unfocus();
    final results = _checker.check(_text.text, minWords: _task.minWords);
    const passed = {WritingCheck.lengthOk, WritingCheck.greetingOk, WritingCheck.closingOk};
    final ok = results.where(passed.contains).length;
    _scores[_taskIndex] = (ok, results.length);
    AppScope.read(context).recordAnswer(Exams.a2Writing, _task.id, ok == results.length);
    setState(() {
      _results = results;
      _checked = true;
    });
  }

  /// Bo'lim tugadi: barcha topshiriqlar bo'yicha natija foizini ko'rsatamiz.
  void _finish(String section, WidgetBuilder restart) {
    SessionStore.clear(Exams.a2Writing);
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
      _finish('writing', (context) => const WritingScreen());
      return;
    }
    setState(() {
      _taskIndex++;
      _checked = false;
      _showModel = false;
      _ticked.clear();
      _results = [];
      _text.clear();
    });
    SessionStore.save(Exams.a2Writing, {'index': _taskIndex, 'scores': SessionStore.encodeScores(_scores)});
  }

  (bool, String) _describe(WritingCheck check, S s, int minWords) => switch (check) {
        WritingCheck.lengthOk => (true, s.lengthOk),
        WritingCheck.tooShort => (false, s.tooShort(minWords)),
        WritingCheck.greetingOk => (true, s.greetingOk),
        WritingCheck.greetingMissing => (false, s.greetingMissing),
        WritingCheck.closingOk => (true, s.closingOk),
        WritingCheck.closingMissing => (false, s.closingMissing),
        WritingCheck.fewDiacritics => (false, s.fewDiacritics),
      };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FutureBuilder<List<WritingTask>>(
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
    final translation = task.promptTranslation(s.lang);
    final words = WritingChecker.wordCount(_text.text);
    final enough = words >= task.minWords;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: 'A2 · ${s.writing}',
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
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.promptCs, style: const TextStyle(fontSize: 17, height: 1.4, fontWeight: FontWeight.w800)),
                          if (translation != null) ...[
                            const SizedBox(height: 6),
                            Text(translation, style: TextStyle(fontSize: 14, height: 1.45, color: AppColors.muted)),
                          ],
                          const SizedBox(height: 12),
                          Text(s.mustInclude, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          for (final point in task.points)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                s.lang == 'cs' || point[s.lang] == null
                                    ? '• ${point['cs']}'
                                    : '• ${point['cs']} — ${point[s.lang]}',
                                style: const TextStyle(fontSize: 14, height: 1.45),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Imtihondagidek faqat qo'lda yoziladi: nusxa qo'yish bloklangan.
                    ManualTextField(
                      controller: _text,
                      minLines: 8,
                      maxLines: 16,
                      onPasteBlocked: () => showComingSoon(context, s.pasteBlocked),
                      onChanged: (_) => setState(() => _checked = false),
                      decoration: InputDecoration(
                        hintText: s.writeHere,
                        filled: true,
                        fillColor: AppColors.card,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        s.wordCount(words, task.minWords),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: enough ? AppColors.success : AppColors.muted,
                        ),
                      ),
                    ),
                    if (_checked) ...[
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final check in _results)
                              Builder(builder: (context) {
                                final (ok, message) = _describe(check, s, task.minWords);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        ok ? Icons.check_circle : Icons.error_outline,
                                        size: 20,
                                        color: ok ? AppColors.success : AppColors.error,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(message, style: const TextStyle(fontSize: 14, height: 1.45)),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            const SizedBox(height: 10),
                            Text(s.selfCheckPoints, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            for (var i = 0; i < task.points.length; i++)
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                value: _ticked.contains(i),
                                onChanged: (value) => setState(() {
                                  if (value == true) {
                                    _ticked.add(i);
                                  } else {
                                    _ticked.remove(i);
                                  }
                                }),
                                title: Text(task.points[i][s.lang] ?? task.points[i]['cs'] ?? ''),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_awesome_outlined, size: 20, color: AppColors.muted),
                                const SizedBox(width: 8),
                                Text(s.aiCheck, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(s.aiSoon, style: TextStyle(fontSize: 14, height: 1.45, color: AppColors.muted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_showModel)
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.modelAnswer, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Text(task.model, style: const TextStyle(fontSize: 15, height: 1.55)),
                            ],
                          ),
                        )
                      else
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => setState(() => _showModel = true),
                            icon: const Icon(Icons.visibility_outlined),
                            label: Text(s.showModel),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _checked ? _next : (_text.text.trim().isEmpty ? null : _check),
                child: Text(_checked ? (_isLast ? s.finish : s.nextTask) : s.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
