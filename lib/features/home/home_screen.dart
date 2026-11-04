import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/progress_store.dart';
import 'package:czech_pass/core/question.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<QuestionBank>? _bank;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bank ??= AppScope.read(context).repository.loadRealie();
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
        child: FutureBuilder<QuestionBank>(
          future: _bank,
          builder: (context, snapshot) {
            final total = snapshot.data?.questions.length ?? 0;
            final mastered = progress.correctCount(Exams.realie);
            final percent = total == 0 ? 0 : (mastered * 100 / total).round().clamp(0, 100);
            final mistakes = progress.mistakes(Exams.realie).length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                Text(s.welcome, style: TextStyle(fontSize: 14, color: AppColors.muted)),
                const SizedBox(height: 4),
                Text(
                  s.homeTitle,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.2),
                ),
                const SizedBox(height: 18),
                _ExamCard(
                  label: s.forCitizenship,
                  title: 'České reálie',
                  subtitle: s.realieSubtitle,
                  onTap: () => _open(const QuizScreen(mode: QuizMode.practice)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProgressLine(value: percent / 100),
                      const SizedBox(height: 8),
                      Text(
                        '${s.mastered(percent)} · ${progress.answeredCount(Exams.realie) == 0 ? s.startPractice : s.continuePractice}',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _ExamCard(
                  label: s.forResidence,
                  title: s.a2Title,
                  subtitle: s.a2Subtitle,
                  badge: s.newFormat,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3.2,
                    children: [
                      _SkillButton(
                        icon: Icons.menu_book_outlined,
                        label: s.reading,
                        onTap: () => _open(const ReadingScreen()),
                      ),
                      _SkillButton(
                        icon: Icons.headphones_outlined,
                        label: s.listening,
                        onTap: () => _open(const ListeningScreen()),
                      ),
                      _SkillButton(
                        icon: Icons.edit_outlined,
                        label: s.writing,
                        onTap: () => _open(const WritingScreen()),
                      ),
                      _SkillButton(
                        icon: Icons.chat_bubble_outline,
                        label: s.speaking,
                        onTap: () => _open(const SpeakingScreen()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
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
                const SizedBox(height: 14),
                _PremiumBanner(
                  title: s.unlockFull,
                  subtitle: s.oneTimePayment,
                  onTap: () => _open(const PremiumScreen()),
                ),
                const SizedBox(height: 14),
                Text(s.disclaimer, style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.5)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.accentSoft,
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              _open(const QuizScreen(mode: QuizMode.practice));
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
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.child,
    this.badge,
    this.onTap,
  });

  final String label;
  final String title;
  final String subtitle;
  final String? badge;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.muted, letterSpacing: 0.7),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.successSoft, borderRadius: BorderRadius.circular(999)),
                  child: Text(
                    badge!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success),
                  ),
                )
              else if (onTap != null)
                Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 14, color: AppColors.muted)),
          const SizedBox(height: 14),
          child,
        ],
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

class _PremiumBanner extends StatelessWidget {
  const _PremiumBanner({required this.title, required this.subtitle, required this.onTap});

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
