import 'dart:math';

import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/exam_rules.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/features/quiz/result_screen.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';
import 'package:czech_pass/widgets/countdown.dart';
import 'package:czech_pass/widgets/locks.dart';

/// practice — har javobdan keyin izoh;
/// exam — haqiqiy test kabi, izohsiz, natija oxirida;
/// mistakes — takrorlash: xato javoblar va takrorlash vaqti kelgan savollar (spaced repetition).
enum QuizMode { practice, exam, mistakes }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.mode = QuizMode.practice});

  final QuizMode mode;

  /// Sinov imtihonidagi savollar soni (bazada kamroq bo'lsa — hammasi).
  static const examLength = RealieRules.questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Future<QuestionBank>? _future;
  final _random = Random();

  List<Question> _questions = [];
  List<List<int>> _orders = [];

  int _index = 0;
  int? _picked; // `options` ichidagi asl tartib raqami
  bool _checked = false;
  bool _showTranslation = true;
  final List<AnswerRecord> _answers = [];

  /// Bepul versiyada ko'rsatilmaydigan savollar ham bor bo'lsa — bazadagi jami savollar soni.
  int _total = 0;

  /// Bepul sinov imtihoni ishlatib bo'lingan.
  bool _locked = false;

  bool get _isExam => widget.mode == QuizMode.exam;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<QuestionBank> _load() async {
    final controller = AppScope.read(context);
    final entitlements = controller.entitlements;
    final bank = await controller.repository.loadRealie();
    var questions = [...bank.questions];
    _total = questions.length;

    switch (widget.mode) {
      case QuizMode.practice:
        if (!entitlements.citizenship) {
          questions = RealieRules.freeSubset(questions, FreeLimits.realiePerTopic);
        }
        questions.shuffle(_random);
      case QuizMode.mistakes:
        final due = controller.progress.dueForReview(Exams.realie);
        questions = questions.where((q) => due.contains(q.id)).toList()..shuffle(_random);
        _total = questions.length;
      case QuizMode.exam:
        if (!entitlements.canStartMock(Mocks.realie, Tariff.citizenship)) {
          _locked = true;
          return bank;
        }
        await controller.useMock(Mocks.realie, Tariff.citizenship);
        questions = RealieRules.pickExam(questions, _random);
        _total = questions.length;
    }

    _questions = questions;
    _orders = [
      for (final q in questions) List<int>.generate(q.options.length, (i) => i)..shuffle(_random),
    ];
    return bank;
  }

  Question get _current => _questions[_index];
  bool get _isLast => _index == _questions.length - 1;

  void _saveAnswer() {
    final correct = _picked == _current.correctIndex;
    _answers.add(AnswerRecord(questionId: _current.id, topic: _current.topic, correct: correct));
    AppScope.read(context).recordAnswer(Exams.realie, _current.id, correct);
  }

  void _check() {
    if (_picked == null) return;
    _saveAnswer();
    setState(() => _checked = true);
  }

  void _showResult(QuestionBank bank) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          answers: List.unmodifiable(_answers),
          bank: bank,
          mode: widget.mode,
        ),
      ),
    );
  }

  void _next(QuestionBank bank) {
    // Sinov imtihonida javob "Keyingi" bosilganda saqlanadi (izoh ko'rsatilmaydi).
    if (_isExam) _saveAnswer();

    if (_isLast) {
      _showResult(bank);
      return;
    }
    setState(() {
      _index++;
      _picked = null;
      _checked = false;
    });
  }

  /// Vaqt tugadi: tanlangan javob saqlanadi, javob berilmagan savollar xato hisoblanadi.
  void _timeUp(QuestionBank bank) {
    if (!mounted) return;
    if (_picked != null) _saveAnswer();
    final answered = _answers.map((a) => a.questionId).toSet();
    for (final q in _questions) {
      if (!answered.contains(q.id)) {
        _answers.add(AnswerRecord(questionId: q.id, topic: q.topic, correct: false));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).timeUp)));
    _showResult(bank);
  }

  String _modeLabel(S s) => switch (widget.mode) {
        QuizMode.practice => s.navPractice,
        QuizMode.exam => s.mockExam,
        QuizMode.mistakes => s.reviewTitle,
      };

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return FutureBuilder<QuestionBank>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _MessageScaffold(
            title: s.loadError,
            text: '${snapshot.error}',
            closeLabel: s.back,
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (_locked) {
          return LockedScreen(title: s.mockLockedTitle, text: s.mockLockedText, tariff: Tariff.citizenship);
        }
        if (_questions.isEmpty) {
          return _MessageScaffold(
            title: s.noReviewTitle,
            text: s.noReviewText,
            closeLabel: s.back,
          );
        }
        return _buildQuiz(snapshot.data!, s);
      },
    );
  }

  Widget _buildQuiz(QuestionBank bank, S s) {
    final lang = s.lang;
    final question = _current;
    final order = _orders[_index];
    final translation = question.translation(lang);
    final correctLetter = optionLetter(order.indexOf(question.correctIndex));
    final isRight = _picked == question.correctIndex;
    final explanation = question.explanationFor(lang);

    final String buttonLabel;
    final VoidCallback? onButton;
    if (_isExam) {
      buttonLabel = _isLast ? s.seeResult : s.nextQuestion;
      onButton = _picked == null ? null : () => _next(bank);
    } else if (_checked) {
      buttonLabel = _isLast ? s.seeResult : s.nextQuestion;
      onButton = () => _next(bank);
    } else {
      buttonLabel = s.check;
      onButton = _picked == null ? null : _check;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: s.back,
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'České reálie · ${_modeLabel(s)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted),
                              ),
                            ),
                            if (_isExam) ...[
                              Countdown(
                                duration: const Duration(minutes: RealieRules.minutes),
                                onFinished: () => _timeUp(bank),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              '${_index + 1} / ${_questions.length}',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ProgressLine(value: (_index + 1) / _questions.length, height: 6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    if (widget.mode == QuizMode.practice && _questions.length < _total) ...[
                      FreeLimitBanner(shown: _questions.length, total: _total, tariff: Tariff.citizenship),
                      const SizedBox(height: 14),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(999)),
                        child: Text(
                          bank.topicLabel(question.topic, lang),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      question.czech,
                      style: const TextStyle(fontSize: 22, height: 1.3, fontWeight: FontWeight.w800),
                    ),
                    if (translation != null) ...[
                      if (_showTranslation) ...[
                        const SizedBox(height: 8),
                        Text(translation, style: TextStyle(fontSize: 15, height: 1.45, color: AppColors.muted)),
                      ],
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _showTranslation = !_showTranslation),
                          icon: const Icon(Icons.translate, size: 18),
                          label: Text(_showTranslation ? s.hideTranslation : s.showTranslation),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    for (var i = 0; i < order.length; i++) ...[
                      OptionTile(
                        letter: optionLetter(i),
                        text: question.options[order[i]],
                        state: _stateFor(order[i], question.correctIndex),
                        onTap: _checked ? null : () => setState(() => _picked = order[i]),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_checked)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isRight ? AppColors.successSoft : AppColors.errorSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isRight ? s.correct : s.wrongAnswer(correctLetter),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isRight ? AppColors.success : AppColors.error,
                              ),
                            ),
                            if (explanation.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(explanation, style: const TextStyle(fontSize: 14, height: 1.5)),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: onButton, child: Text(buttonLabel)),
            ],
          ),
        ),
      ),
    );
  }

  OptionState _stateFor(int optionIndex, int correctIndex) {
    if (_checked) {
      if (optionIndex == correctIndex) return OptionState.correct;
      if (optionIndex == _picked) return OptionState.wrong;
      return OptionState.idle;
    }
    return optionIndex == _picked ? OptionState.picked : OptionState.idle;
  }
}

class _MessageScaffold extends StatelessWidget {
  const _MessageScaffold({required this.title, required this.text, required this.closeLabel});

  final String title;
  final String text;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.check_circle_outline, size: 56, color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5, color: AppColors.muted),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(closeLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
