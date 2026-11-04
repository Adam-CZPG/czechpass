import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/tariff.dart';
import 'package:czech_pass/features/a2/listening_screen.dart';
import 'package:czech_pass/features/a2/reading_screen.dart';
import 'package:czech_pass/features/a2/speaking_screen.dart';
import 'package:czech_pass/features/a2/writing_screen.dart';
import 'package:czech_pass/features/premium/premium_screen.dart';
import 'package:czech_pass/features/progress/progress_screen.dart';
import 'package:czech_pass/features/quiz/quiz_screen.dart';
import 'package:czech_pass/features/settings/settings_screen.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// Bo'limlardagi savol va topshiriqlar soni (progress foizi uchun).
class _Totals {
  const _Totals({required this.realie, required this.a2});

  final int realie;

  /// A2: imtihon turi → savol/topshiriq soni.
  final Map<String, int> a2;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<_Totals>? _totals;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = AppScope.read(context).repository;
    _totals ??= () async {
      final realie = await repo.loadRealie();
      final reading = await repo.loadA2Reading();
      final listening = await repo.loadA2Listening();
      final speaking = await repo.loadA2Speaking();
      final writing = await repo.loadA2Writing();
      return _Totals(
        realie: realie.questions.length,
        a2: {
          Exams.a2Reading: reading.fold(0, (n, t) => n + t.questions.length),
          Exams.a2Listening: listening.fold(0, (n, t) => n + t.questions.length),
          Exams.a2Speaking: speaking.length,
          Exams.a2Writing: writing.length,
        },
      );
    }();
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final progress = AppScope.of(context).progress;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Qotirilgan sarlavha: ro'yxat aylantirilganda ham joyida turadi.
            Material(
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.welcome, style: TextStyle(fontSize: 14, color: AppColors.muted)),
                    const SizedBox(height: 4),
                    Text(
                      s.homeTitle,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.2),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.border),
            Expanded(
              child: FutureBuilder<_Totals>(
                future: _totals,
                builder: (context, snapshot) {
                  final totals = snapshot.data;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      _residenceBlock(s, progress, totals),
                      const SizedBox(height: 22),
                      _citizenshipBlock(s, progress, totals),
                      const SizedBox(height: 18),
                      Text(s.disclaimer, style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.5)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.accentSoft,
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              _open(const ReadingScreen());
            case 2:
              _open(const ProgressScreen());
            case 3:
              _open(const SettingsScreen());
          }
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: s.navHome),
          NavigationDestination(icon: const Icon(Icons.timer_outlined), label: s.navPractice),
          NavigationDestination(icon: const Icon(Icons.bar_chart_outlined), label: s.navProgress),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: s.navSettings),
        ],
      ),
    );
  }

  /// 1-blok: Doimiy yashash — faqat A2.
  Widget _residenceBlock(S s, ProgressStore progress, _Totals? totals) {
    var done = 0;
    var all = 0;
    if (totals != null) {
      totals.a2.forEach((exam, count) {
        all += count;
        done += progress.correctCount(exam);
      });
    }
    final percent = all == 0 ? 0 : (done * 100 / all).round().clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BlockHeader(label: s.forResidence, note: s.residenceNote),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(s.a2Title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                  _Badge(text: s.newFormat),
                ],
              ),
              const SizedBox(height: 4),
              Text(s.a2Subtitle, style: TextStyle(fontSize: 14, color: AppColors.muted)),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.2,
                children: [
                  _SkillButton(icon: Icons.menu_book_outlined, label: s.reading, onTap: () => _open(const ReadingScreen())),
                  _SkillButton(icon: Icons.headphones_outlined, label: s.listening, onTap: () => _open(const ListeningScreen())),
                  _SkillButton(icon: Icons.edit_outlined, label: s.writing, onTap: () => _open(const WritingScreen())),
                  _SkillButton(icon: Icons.chat_bubble_outline, label: s.speaking, onTap: () => _open(const SpeakingScreen())),
                ],
              ),
              const SizedBox(height: 14),
              ProgressLine(value: percent / 100),
              const SizedBox(height: 8),
              Text(s.mastered(percent), style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _UnlockBanner(
          title: s.trackResidence,
          subtitle: s.unlockFrom(Prices.of(Tariff.residence)),
          onTap: () => _open(const PremiumScreen(initial: Tariff.residence)),
        ),
      ],
    );
  }

  /// 2-blok: Fuqarolik — B1 til imtihoni va České reálie.
  Widget _citizenshipBlock(S s, ProgressStore progress, _Totals? totals) {
    final total = totals?.realie ?? 0;
    final mastered = progress.correctCount(Exams.realie);
    final percent = total == 0 ? 0 : (mastered * 100 / total).round().clamp(0, 100);
    final mistakes = progress.mistakes(Exams.realie).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BlockHeader(label: s.forCitizenship, note: s.citizenshipNote),
        const SizedBox(height: 10),
        AppCard(
          onTap: () => showComingSoon(context, s.comingSoon),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.czechB1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(s.b1Subtitle, style: TextStyle(fontSize: 14, color: AppColors.muted)),
                  ],
                ),
              ),
              _Badge(text: s.comingSoon, muted: true),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          onTap: () => _open(const QuizScreen(mode: QuizMode.practice)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('České reálie', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
                  Icon(Icons.chevron_right, color: AppColors.muted),
                ],
              ),
              const SizedBox(height: 4),
              Text(s.realieSubtitle, style: TextStyle(fontSize: 14, color: AppColors.muted)),
              const SizedBox(height: 14),
              ProgressLine(value: percent / 100),
              const SizedBox(height: 8),
              Text(
                '${s.mastered(percent)} · ${progress.answeredCount(Exams.realie) == 0 ? s.startPractice : s.continuePractice}',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SmallCard(
                title: s.mockExam,
                subtitle: s.mockExamSub,
                onTap: () => _open(const QuizScreen(mode: QuizMode.exam)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SmallCard(
                title: s.myMistakes,
                subtitle: s.toReview(mistakes),
                onTap: () => _open(const QuizScreen(mode: QuizMode.mistakes)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _UnlockBanner(
          title: s.trackCitizenship,
          subtitle: s.unlockFrom(Prices.of(Tariff.citizenship)),
          onTap: () => _open(const PremiumScreen(initial: Tariff.citizenship)),
        ),
      ],
    );
  }
}

class _BlockHeader extends StatelessWidget {
  const _BlockHeader({required this.label, required this.note});

  final String label;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.accent, letterSpacing: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(note, style: TextStyle(fontSize: 13, height: 1.45, color: AppColors.muted)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.muted = false});

  final String text;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: muted ? AppColors.surface : AppColors.successSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: muted ? AppColors.muted : AppColors.success),
      ),
    );
  }
}

class _SkillButton extends StatelessWidget {
  const _SkillButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.ink),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _UnlockBanner extends StatelessWidget {
  const _UnlockBanner({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.banner,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.lock_open_outlined, color: AppColors.onBanner),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onBanner)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.onBannerMuted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.onBanner),
            ],
          ),
        ),
      ),
    );
  }
}
