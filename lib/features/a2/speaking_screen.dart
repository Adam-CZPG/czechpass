import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/speech_service.dart';
import 'package:czech_pass/features/a2/section_result_screen.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// A2 gapirish: foydalanuvchi chex tilida gapiradi, telefon nutqni matnga aylantiradi,
/// ilova kerakli iboralar aytilganini tekshiradi va namunaviy javobni ko'rsatadi.
/// Nutqni aniqlash ishlamasa, javobni yozib kiritish mumkin.
class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  Future<List<SpeakingTask>>? _future;
  final _input = VoiceInput();
  final _voice = VoiceOutput();
  final _text = TextEditingController();

  List<SpeakingTask> _tasks = [];
  int _taskIndex = 0;
  final Map<int, (int, int)> _scores = {}; // topshiriq → (topilgan iboralar, jami)
  bool _sttAvailable = true;
  bool _listening = false;
  bool _checked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<List<SpeakingTask>> _load() async {
    _tasks = await AppScope.read(context).repository.loadA2Speaking();
    return _tasks;
  }

  @override
  void dispose() {
    _input.stop();
    _voice.stop();
    _text.dispose();
    super.dispose();
  }

  SpeakingTask get _task => _tasks[_taskIndex];
  bool get _isLast => _taskIndex == _tasks.length - 1;

  void _onStatus(String status) {
    if (!mounted) return;
    if (status == 'done' || status == 'notListening' || status == 'error') {
      setState(() => _listening = false);
    }
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await _input.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final available = await _input.init(onStatus: _onStatus);
    if (!mounted) return;
    if (!available) {
      setState(() => _sttAvailable = false);
      return;
    }
    await _voice.stop();
    setState(() {
      _listening = true;
      _checked = false;
    });
    await _input.start((words) {
      if (!mounted) return;
      setState(() {
        _text.value = TextEditingValue(
          text: words,
          selection: TextSelection.collapsed(offset: words.length),
        );
      });
    });
  }

  Future<void> _check() async {
    if (_listening) await _input.stop();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final answer = foldCzech(_text.text);
    final hits = _task.keywords.where((k) => answer.contains(foldCzech(k))).length;
    _scores[_taskIndex] = (hits, _task.keywords.length);
    // Iboralarning kamida 2/3 qismi aytilgan bo'lsa — topshiriq bajarilgan hisoblanadi.
    AppScope.read(context).recordAnswer(Exams.a2Speaking, _task.id, hits * 3 >= _task.keywords.length * 2);
    setState(() {
      _listening = false;
      _checked = true;
    });
  }

  /// Bo'lim tugadi: barcha topshiriqlar bo'yicha natija foizini ko'rsatamiz.
  void _finish(String section, WidgetBuilder restart) {
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
        ),
      ),
    );
  }

  void _next() {
    _voice.stop();
    if (_isLast) {
      _finish('speaking', (context) => const SpeakingScreen());
      return;
    }
    setState(() {
      _taskIndex++;
      _checked = false;
      _text.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FutureBuilder<List<SpeakingTask>>(
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
    final answer = foldCzech(_text.text);
    final found = {for (final k in task.keywords) k: answer.contains(foldCzech(k))};

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScreenHeader(
                title: 'A2 · ${s.speaking}',
                tooltip: s.back,
                trailing: Text(
                  '${_taskIndex + 1} / ${_tasks.length}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      '${s.taskN(_taskIndex + 1)} · ${task.titleFor(s.lang)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.muted),
                    ),
                    const SizedBox(height: 6),
                    Text(s.speakingInstruction, style: const TextStyle(fontSize: 15, height: 1.45, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.promptCs, style: const TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.w800)),
                          if (translation != null) ...[
                            const SizedBox(height: 6),
                            Text(translation, style: const TextStyle(fontSize: 14, height: 1.45, color: AppColors.muted)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_sttAvailable)
                      Center(
                        child: Column(
                          children: [
                            Semantics(
                              button: true,
                              label: _listening ? s.listeningNow : s.tapToSpeak,
                              child: InkResponse(
                                onTap: _toggleMic,
                                radius: 48,
                                child: Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _listening ? AppColors.error : AppColors.accent,
                                  ),
                                  child: Icon(
                                    _listening ? Icons.stop_rounded : Icons.mic_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _listening ? s.listeningNow : s.tapToSpeak,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                        child: Text(s.sttMissing, style: const TextStyle(fontSize: 14, height: 1.45)),
                      ),
                    const SizedBox(height: 16),
                    Text(s.yourAnswer, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _text,
                      minLines: 3,
                      maxLines: 8,
                      onChanged: (_) => setState(() => _checked = false),
                      decoration: InputDecoration(
                        hintText: s.writeHere,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    if (_checked) ...[
                      const SizedBox(height: 16),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.keyPhrases, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            for (final entry in found.entries)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      entry.value ? Icons.check_circle : Icons.radio_button_unchecked,
                                      size: 20,
                                      color: entry.value ? AppColors.success : AppColors.muted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(entry.key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.modelAnswer, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(task.model, style: const TextStyle(fontSize: 15, height: 1.55)),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => _voice.say(task.model, gender: 'm'),
                              icon: const Icon(Icons.volume_up_outlined),
                              label: Text(s.listenModel),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(s.speakingPrivacy, style: const TextStyle(fontSize: 12, height: 1.5, color: AppColors.muted)),
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
