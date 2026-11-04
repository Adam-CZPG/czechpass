import 'dart:math';

import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/audio_clips.dart';
import 'package:czech_pass/core/badges.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/exam_rules.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/speech_service.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/core/writing_checker.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';
import 'package:czech_pass/widgets/countdown.dart';
import 'package:czech_pass/widgets/locks.dart';
import 'package:czech_pass/widgets/no_paste.dart';
import 'package:czech_pass/widgets/question_block.dart';

/// Imtihon qismlari rasmiy tartibda: avval yozma qism (o'qish, yozish, tinglash), keyin og'zaki.
enum MockPart { reading, writing, listening, speaking }

/// Sinov imtihoni natijasi (ballar rasmiy shkalada).
class A2MockScore {
  const A2MockScore({required this.reading, required this.writing, required this.listening, required this.speaking});

  final int reading;
  final int writing;
  final int listening;
  final int speaking;

  int get written => reading + writing + listening;

  bool get passed => A2Rules.passed(written: written, speaking: speaking);
}

/// To'liq A2 sinov imtihoni: 4 qism, har biri o'z vaqti bilan, oxirida taxminiy ball.
class A2MockScreen extends StatefulWidget {
  const A2MockScreen({super.key});

  // Har bir qismdan nechta topshiriq olinadi.
  static const readingTasks = 4;
  static const writingTasks = 2;
  static const listeningTasks = 4;
  static const speakingTasks = 3;

  static int minutesOf(MockPart part) => switch (part) {
        MockPart.reading => A2Rules.readingMinutes,
        MockPart.writing => A2Rules.writingMinutes,
        MockPart.listening => A2Rules.listeningMinutes,
        MockPart.speaking => A2Rules.speakingMinutes,
      };

  static int pointsOf(MockPart part) => switch (part) {
        MockPart.reading => A2Rules.readingPoints,
        MockPart.writing => A2Rules.writingPoints,
        MockPart.listening => A2Rules.listeningPoints,
        MockPart.speaking => A2Rules.speakingPoints,
      };

  @override
  State<A2MockScreen> createState() => _A2MockScreenState();
}

class _A2MockScreenState extends State<A2MockScreen> {
  Future<void>? _future;
  final _random = Random();
  final _voice = VoiceOutput();
  final _audio = ListeningAudio();
  final _input = VoiceInput();
  final _checker = const WritingChecker();

  List<ReadingTask> _reading = [];
  List<WritingTask> _writing = [];
  List<ListeningTask> _listening = [];
  List<SpeakingTask> _speaking = [];

  final Map<String, List<int>> _orders = {};
  final Map<String, int> _picked = {};
  final Map<String, TextEditingController> _texts = {};
  final Map<String, int> _playsLeft = {};

  bool _locked = false;
  bool _started = false;
  int _part = 0;
  A2MockScore? _score;
  String? _playingTask;
  String? _micTask;

  MockPart get _currentPart => MockPart.values[_part];
  bool get _isLastPart => _part == MockPart.values.length - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<void> _load() async {
    final controller = AppScope.read(context);
    if (!controller.entitlements.canStartMock(Mocks.a2, Tariff.residence)) {
      _locked = true;
      return;
    }
    final repo = controller.repository;
    List<T> pick<T>(List<T> all, int n) => ([...all]..shuffle(_random)).take(n).toList();
    _reading = pick(await repo.loadA2Reading(), A2MockScreen.readingTasks);
    _writing = pick(await repo.loadA2Writing(), A2MockScreen.writingTasks);
    _listening = pick(await repo.loadA2Listening(), A2MockScreen.listeningTasks);
    _speaking = pick(await repo.loadA2Speaking(), A2MockScreen.speakingTasks);

    for (final q in [for (final t in _reading) ...t.questions, for (final t in _listening) ...t.questions]) {
      _orders[q.id] = List<int>.generate(q.options.length, (i) => i)..shuffle(_random);
    }
    for (final t in _writing) {
      _texts[t.id] = TextEditingController();
    }
    for (final t in _speaking) {
      _texts[t.id] = TextEditingController();
    }
    for (final t in _listening) {
      _playsLeft[t.id] = 2;
    }
  }

  @override
  void dispose() {
    _voice.stop();
    _audio.dispose();
    _input.stop();
    for (final c in _texts.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _start() async {
    await AppScope.read(context).useMock(Mocks.a2, Tariff.residence);
    if (mounted) setState(() => _started = true);
  }

  Future<void> _stopAudio() async {
    await _voice.stop();
    await _audio.stop();
    await _input.stop();
    if (mounted) {
      setState(() {
        _playingTask = null;
        _micTask = null;
      });
    }
  }

  Future<void> _nextPart() async {
    await _stopAudio();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    if (_isLastPart) {
      _finish();
    } else {
      setState(() => _part++);
    }
  }

  void _timeUp() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).timeUp)));
    _nextPart();
  }

  void _finish() {
    final controller = AppScope.read(context);

    (int, int) multipleChoice(List<Question> questions, String exam) {
      var right = 0;
      for (final q in questions) {
        final correct = _picked[q.id] == q.correctIndex;
        if (correct) right++;
        if (_picked.containsKey(q.id)) controller.recordAnswer(exam, q.id, correct);
      }
      return (right, questions.length);
    }

    final (readingRight, readingTotal) =
        multipleChoice([for (final t in _reading) ...t.questions], Exams.a2Reading);
    final (listeningRight, listeningTotal) =
        multipleChoice([for (final t in _listening) ...t.questions], Exams.a2Listening);

    const passedChecks = {WritingCheck.lengthOk, WritingCheck.greetingOk, WritingCheck.closingOk};
    var writingOk = 0;
    var writingAll = 0;
    for (final t in _writing) {
      final results = _checker.check(_texts[t.id]!.text, minWords: t.minWords);
      writingOk += results.where(passedChecks.contains).length;
      writingAll += results.length;
    }

    var hits = 0;
    var keywords = 0;
    for (final t in _speaking) {
      final answer = foldCzech(_texts[t.id]!.text);
      hits += t.keywords.where((k) => answer.contains(foldCzech(k))).length;
      keywords += t.keywords.length;
    }

    final score = A2MockScore(
      reading: A2Rules.scale(readingRight, readingTotal, A2Rules.readingPoints),
      writing: A2Rules.scale(writingOk, writingAll, A2Rules.writingPoints),
      listening: A2Rules.scale(listeningRight, listeningTotal, A2Rules.listeningPoints),
      speaking: A2Rules.scale(hits, keywords, A2Rules.speakingPoints),
    );
    if (score.passed) controller.markMockPassed(Badges.a2Mock);
    setState(() => _score = score);
  }

  Future<void> _play(ListeningTask task) async {
    if (_playingTask == task.id) {
      await _voice.stop();
      await _audio.stop();
      if (mounted) setState(() => _playingTask = null);
      return;
    }
    if ((_playsLeft[task.id] ?? 0) <= 0) return;
    await _voice.stop();
    await _audio.stop();
    setState(() {
      _playingTask = task.id;
      _playsLeft[task.id] = (_playsLeft[task.id] ?? 0) - 1;
    });
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
        if (!mounted || _playingTask != task.id) break;
        await _voice.say(line.text, gender: task.genderOf(line.speaker));
      }
    }
    if (mounted && _playingTask == task.id) setState(() => _playingTask = null);
  }

  Future<void> _toggleMic(SpeakingTask task) async {
    if (_micTask == task.id) {
      await _input.stop();
      if (mounted) setState(() => _micTask = null);
      return;
    }
    final available = await _input.init(
      onStatus: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening' || status == 'error') {
          setState(() => _micTask = null);
        }
      },
    );
    if (!mounted) return;
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).sttMissing)));
      return;
    }
    await _input.stop();
    setState(() => _micTask = task.id);
    final controller = _texts[task.id]!;
    await _input.start((words) {
      if (!mounted) return;
      setState(() {
        controller.value = TextEditingValue(text: words, selection: TextSelection.collapsed(offset: words.length));
      });
    });
  }

  String _partName(S s, MockPart part) => switch (part) {
        MockPart.reading => s.reading,
        MockPart.writing => s.writing,
        MockPart.listening => s.listening,
        MockPart.speaking => s.speaking,
      };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('${s.loadError}\n${snapshot.error}', textAlign: TextAlign.center)),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (_locked) {
          return LockedScreen(title: s.mockLockedTitle, text: s.mockLockedText, tariff: Tariff.residence);
        }
        final score = _score;
        if (score != null) return _buildResult(s, score);
        if (!_started) return _buildIntro(s);
        return _buildPart(s);
      },
    );
  }

  Widget _buildIntro(S s) {
    final unlocked = AppScope.of(context).entitlements.residence;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            ScreenHeader(title: s.mockA2Title, tooltip: s.back),
            const SizedBox(height: 16),
            Text(s.mockIntro, style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.muted)),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final part in MockPart.values) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(_partName(s, part), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                        Text(
                          '${s.minutesShort(A2MockScreen.minutesOf(part))} · ${s.maxPoints(A2MockScreen.pointsOf(part))}',
                          style: TextStyle(fontSize: 14, color: AppColors.muted),
                        ),
                      ],
                    ),
                    if (part != MockPart.values.last) Divider(height: 20, color: AppColors.border),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text('${s.writtenPart} — ${s.maxPoints(A2Rules.writtenMax)}: ${s.passNeed(A2Rules.writtenPass)}',
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 4),
            Text('${s.oralPart} — ${s.maxPoints(A2Rules.speakingPoints)}: ${s.passNeed(A2Rules.speakingPass)}',
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 10),
            Text(s.failRule, style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.muted)),
            if (!unlocked) ...[
              const SizedBox(height: 10),
              Text(s.freeMockNote, style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.accent)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(onPressed: _start, child: Text(s.startExam)),
        ),
      ),
    );
  }

  Widget _buildPart(S s) {
    final part = _currentPart;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: '${_part + 1}/${MockPart.values.length} · ${_partName(s, part)}',
                tooltip: s.back,
                trailing: Countdown(
                  key: ValueKey(part),
                  duration: Duration(minutes: A2MockScreen.minutesOf(part)),
                  onFinished: _timeUp,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView(
                  children: switch (part) {
                    MockPart.reading => _readingItems(s),
                    MockPart.writing => _writingItems(s),
                    MockPart.listening => _listeningItems(s),
                    MockPart.speaking => _speakingItems(s),
                  },
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _nextPart,
                child: Text(_isLastPart ? s.finishExam : s.nextPart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskTitle(S s, int index, String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          '${s.taskN(index + 1)} · $title',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted),
        ),
      );

  List<Widget> _questions(S s, List<Question> questions) => [
        for (var qi = 0; qi < questions.length; qi++) ...[
          const SizedBox(height: 14),
          QuestionBlock(
            number: qi + 1,
            question: questions[qi],
            order: _orders[questions[qi].id]!,
            picked: _picked[questions[qi].id],
            checked: false,
            lang: s.lang,
            showTranslation: false,
            onPick: (option) => setState(() => _picked[questions[qi].id] = option),
          ),
        ],
      ];

  List<Widget> _readingItems(S s) => [
        Text(s.readingInstruction, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        for (var i = 0; i < _reading.length; i++) ...[
          _taskTitle(s, i, _reading[i].titleFor(s.lang)),
          AppCard(child: Text(_reading[i].text, style: const TextStyle(fontSize: 16, height: 1.55))),
          ..._questions(s, _reading[i].questions),
          const SizedBox(height: 24),
        ],
      ];

  List<Widget> _listeningItems(S s) => [
        Text(s.listeningInstruction, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        for (var i = 0; i < _listening.length; i++) ...[
          _taskTitle(s, i, _listening[i].titleFor(s.lang)),
          FilledButton.tonalIcon(
            onPressed: _playingTask == _listening[i].id || (_playsLeft[_listening[i].id] ?? 0) > 0
                ? () => _play(_listening[i])
                : null,
            icon: Icon(_playingTask == _listening[i].id ? Icons.stop : Icons.play_arrow),
            label: Text(
              _playingTask == _listening[i].id ? s.playing : s.playRecording(_playsLeft[_listening[i].id] ?? 0),
            ),
          ),
          ..._questions(s, _listening[i].questions),
          const SizedBox(height: 24),
        ],
      ];

  List<Widget> _writingItems(S s) => [
        for (var i = 0; i < _writing.length; i++) ...[
          _taskTitle(s, i, _writing[i].titleFor(s.lang)),
          Text(_writing[i].promptCs, style: const TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final point in _writing[i].points)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• ${point['cs'] ?? ''}', style: const TextStyle(fontSize: 14, height: 1.45)),
            ),
          const SizedBox(height: 8),
          ManualTextField(
            controller: _texts[_writing[i].id]!,
            minLines: 6,
            maxLines: 12,
            onChanged: (_) => setState(() {}),
            onPasteBlocked: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.pasteBlocked))),
            decoration: InputDecoration(hintText: s.writeHere, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 6),
          Text(
            s.wordCount(_wordCount(_texts[_writing[i].id]!.text), _writing[i].minWords),
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 24),
        ],
      ];

  List<Widget> _speakingItems(S s) => [
        Text(s.speakingInstruction, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        for (var i = 0; i < _speaking.length; i++) ...[
          _taskTitle(s, i, _speaking[i].titleFor(s.lang)),
          Text(_speaking[i].promptCs, style: const TextStyle(fontSize: 16, height: 1.45, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => _toggleMic(_speaking[i]),
            icon: Icon(_micTask == _speaking[i].id ? Icons.stop : Icons.mic_none),
            label: Text(_micTask == _speaking[i].id ? s.listeningNow : s.tapToSpeak),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _texts[_speaking[i].id]!,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(labelText: s.yourAnswer, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
        ],
      ];

  static int _wordCount(String text) => text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

  Widget _buildResult(S s, A2MockScore score) {
    final rows = [
      (s.reading, score.reading, A2Rules.readingPoints),
      (s.writing, score.writing, A2Rules.writingPoints),
      (s.listening, score.listening, A2Rules.listeningPoints),
      (s.speaking, score.speaking, A2Rules.speakingPoints),
    ];
    final writtenOk = score.written >= A2Rules.writtenPass;
    final oralOk = score.speaking >= A2Rules.speakingPass;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            ScreenHeader(title: '${s.mockA2Title} · ${s.result}', tooltip: s.close, icon: Icons.close),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: score.passed ? AppColors.successSoft : AppColors.errorSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                score.passed ? s.mockPassed : s.mockFailed,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: score.passed ? AppColors.success : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _PartTotal(
              title: s.writtenPart,
              value: s.pointsOf(score.written, A2Rules.writtenMax),
              note: s.passNeed(A2Rules.writtenPass),
              ok: writtenOk,
            ),
            const SizedBox(height: 10),
            _PartTotal(
              title: s.oralPart,
              value: s.pointsOf(score.speaking, A2Rules.speakingPoints),
              note: s.passNeed(A2Rules.speakingPass),
              ok: oralOk,
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (name, got, max) in rows) ...[
                    Row(
                      children: [
                        Expanded(child: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                        Text(s.pointsOf(got, max), style: TextStyle(fontSize: 14, color: AppColors.muted)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ProgressLine(value: max == 0 ? 0 : got / max),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(s.estimateNote, style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.muted)),
            const SizedBox(height: 6),
            Text(s.failRule, style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.muted)),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(s.navHome)),
        ),
      ),
    );
  }
}

class _PartTotal extends StatelessWidget {
  const _PartTotal({required this.title, required this.value, required this.note, required this.ok});

  final String title;
  final String value;
  final String note;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle_outline : Icons.cancel_outlined, color: ok ? AppColors.success : AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(note, style: TextStyle(fontSize: 12, color: AppColors.muted)),
              ],
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
