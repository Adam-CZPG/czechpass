import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/answer_feedback.dart';
import 'package:czech_pass/core/audio_clips.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/session_store.dart';
import 'package:czech_pass/core/speech_service.dart';
import 'package:czech_pass/features/a2/section_result_screen.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';
import 'package:czech_pass/widgets/locks.dart';
import 'package:czech_pass/widgets/question_block.dart';

/// A2 tinglash: matnni telefonning chexcha ovozi o'qib beradi (2 martagacha),
/// keyin savollarga javob beriladi. Tekshirilgach, yozuv matni ko'rsatiladi.
class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  static const maxPlays = 2;

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  Future<List<ListeningTask>>? _future;
  final _random = Random();
  final _voice = VoiceOutput();
  final _audio = ListeningAudio();

  List<ListeningTask> _tasks = [];
  int _total = 0; // bazadagi barcha topshiriqlar (bepul versiyada _tasks qisqaroq)
  final Map<String, List<int>> _orders = {};
  final Map<String, int> _picked = {};
  int _taskIndex = 0;
  final Map<int, (int, int)> _scores = {}; // topshiriq → (to'g'ri, jami)
  int _playsLeft = ListeningScreen.maxPlays;
  bool _playing = false;
  bool _checked = false;
  bool _showTranslation = true;
  bool _czechVoice = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<List<ListeningTask>> _load() async {
    final controller = AppScope.read(context);
    final tasks = await controller.repository.loadA2Listening();
    for (final task in tasks) {
      for (final q in task.questions) {
        _orders[q.id] = List<int>.generate(q.options.length, (i) => i)..shuffle(_random);
      }
    }
    _total = tasks.length;
    _tasks = controller.entitlements.limit(tasks, Tariff.residence, FreeLimits.a2TasksPerSkill);
    // Oldingi safar to'xtatilgan joydan davom etamiz.
    final saved = await SessionStore.load(Exams.a2Listening);
    final savedIndex = saved?['index'];
    if (savedIndex is int && savedIndex > 0 && savedIndex < _tasks.length) {
      _taskIndex = savedIndex;
      _scores.addAll(SessionStore.decodeScores(saved?['scores']));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).continueWhereLeft)));
      });
    }
    final available = await _voice.init();
    final clips = await ListeningAudio.clips();
    // Tayyor MP3 yozuvlar bo'lsa, telefonda chexcha ovoz bo'lmasa ham tinglash ishlaydi.
    if (mounted) setState(() => _czechVoice = available || clips.isNotEmpty);
    return tasks;
  }

  @override
  void dispose() {
    _voice.stop();
    _audio.dispose();
    super.dispose();
  }

  ListeningTask get _task => _tasks[_taskIndex];
  bool get _isLast => _taskIndex == _tasks.length - 1;
  bool get _allAnswered => _task.questions.every((q) => _picked.containsKey(q.id));

  Future<void> _togglePlay() async {
    if (_playing) {
      await _voice.stop();
      await _audio.stop();
      if (mounted) setState(() => _playing = false);
      return;
    }
    if (_playsLeft == 0 && !_checked) return;
    setState(() {
      _playing = true;
      if (!_checked) _playsLeft--;
    });
    final task = _task;
    var played = false;
    if (await ListeningAudio.has(task.id)) {
      try {
        await _audio.play(task.id);
        played = true;
      } catch (_) {
        // Yozuvni o'ynab bo'lmasa — telefonning nutq sintezi.
      }
    }
    if (!played) {
      for (final line in task.lines) {
        if (!mounted || !_playing) break;
        await _voice.say(line.text, gender: task.genderOf(line.speaker));
      }
    }
    if (mounted) setState(() => _playing = false);
  }

  void _check() {
    final controller = AppScope.read(context);
    for (final q in _task.questions) {
      controller.recordAnswer(Exams.a2Listening, q.id, _picked[q.id] == q.correctIndex);
    }
    final right = _task.questions.where((q) => _picked[q.id] == q.correctIndex).length;
    _scores[_taskIndex] = (right, _task.questions.length);
    AnswerFeedback.of(right == _task.questions.length);
    setState(() => _checked = true);
  }

  /// Bo'lim tugadi: barcha topshiriqlar bo'yicha natija foizini ko'rsatamiz.
  void _finish(String section, WidgetBuilder restart) {
    SessionStore.clear(Exams.a2Listening);
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

  Future<void> _next() async {
    await _voice.stop();
    await _audio.stop();
    if (!mounted) return;
    if (_isLast) {
      _finish('listening', (context) => const ListeningScreen());
      return;
    }
    setState(() {
      _taskIndex++;
      _checked = false;
      _playing = false;
      _playsLeft = ListeningScreen.maxPlays;
    });
    SessionStore.save(Exams.a2Listening, {'index': _taskIndex, 'scores': SessionStore.encodeScores(_scores)});
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FutureBuilder<List<ListeningTask>>(
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
    final canPlay = _playing || _checked || _playsLeft > 0;
    final playLabel = _playing
        ? s.playing
        : (_checked ? s.listenAgain : s.playRecording(_playsLeft));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: 'A2 · ${s.listening}',
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
                    Text(s.listeningInstruction, style: const TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    if (!_czechVoice) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppColors.errorSoft, borderRadius: BorderRadius.circular(14)),
                        child: Text(
                          kIsWeb ? s.ttsMissingPc : s.ttsMissing,
                          style: const TextStyle(fontSize: 14, height: 1.45),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _PlayButton(
                      label: playLabel,
                      playing: _playing,
                      onTap: canPlay ? _togglePlay : null,
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
                      const SizedBox(height: 14),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.transcript, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(task.transcript, style: const TextStyle(fontSize: 15, height: 1.55)),
                          ],
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

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.label, required this.playing, required this.onTap});

  final String label;
  final bool playing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: enabled ? AppColors.banner : AppColors.border,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                playing ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                size: 32,
                color: enabled ? AppColors.onBanner : AppColors.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: enabled ? AppColors.onBanner : AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
