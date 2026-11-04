import 'package:flutter/material.dart';

import 'package:czech_pass/app/app_scope.dart';
import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/exam_rules.dart';
import 'package:czech_pass/core/reminder_service.dart';
import 'package:czech_pass/core/settings_store.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// Imtihon sanasi va kunlik maqsadni sozlash oynasi.
Future<void> showPlanSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.card,
    builder: (context) => const _PlanSheet(),
  );
}

class _PlanSheet extends StatelessWidget {
  const _PlanSheet();

  Future<void> _pickDate(BuildContext context) async {
    final controller = AppScope.read(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = controller.examDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current != null && !current.isBefore(today) ? current : today.add(const Duration(days: 30)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 730)),
    );
    if (picked != null) await controller.setExamDate(picked);
  }

  Future<void> _setReminder(BuildContext context, int? minutes) async {
    final controller = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final s = S.of(context);
    if (minutes == null) {
      await controller.disableReminder();
      return;
    }
    if (!ReminderService.supported) {
      messenger.showSnackBar(SnackBar(content: Text(s.reminderUnsupported)));
      return;
    }
    final ok = await controller.enableReminder(minutes);
    if (!ok) messenger.showSnackBar(SnackBar(content: Text(s.reminderDenied)));
  }

  Future<void> _pickTime(BuildContext context) async {
    final controller = AppScope.read(context);
    final current = controller.reminderMinutes ?? SettingsStore.defaultReminderMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked != null && context.mounted) await _setReminder(context, picked.hour * 60 + picked.minute);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final controller = AppScope.of(context);
    final date = controller.examDate;
    final reminder = controller.reminderMinutes;
    final localizations = MaterialLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.planTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            Text(s.examDate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.event_outlined),
              label: Text(date == null ? s.setExamDate : localizations.formatFullDate(date)),
            ),
            if (date != null) ...[
              const SizedBox(height: 6),
              Text(
                _countdownText(s, date),
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => controller.setExamDate(null),
                  child: Text(s.clearDate),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Text(s.dailyGoal, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final goal in SettingsStore.goalOptions)
                  ChoiceChip(
                    label: Text(s.answersPerDay(goal)),
                    selected: controller.dailyGoal == goal,
                    onSelected: (_) => controller.setDailyGoal(goal),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.reminderTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              subtitle: reminder == null ? null : Text(s.reminderAt(AppController.formatMinutes(reminder))),
              value: reminder != null,
              onChanged: (on) => _setReminder(context, on ? SettingsStore.defaultReminderMinutes : null),
            ),
            if (reminder != null)
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () => _pickTime(context),
                  icon: const Icon(Icons.schedule),
                  label: Text(AppController.formatMinutes(reminder)),
                ),
              ),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(s.save)),
          ],
        ),
      ),
    );
  }
}

/// "Imtihongacha 23 kun", "Imtihon bugun" yoki "sana o'tib ketdi".
String _countdownText(S s, DateTime date) {
  final days = daysUntil(date, DateTime.now());
  if (days > 0) return s.daysLeft(days);
  if (days == 0) return s.examToday;
  return s.examDatePassed;
}

/// Bosh sahifadagi "Mening rejam" kartasi: imtihongacha qolgan kunlar, kunlik maqsad, ketma-ket kunlar.
class PlanCard extends StatelessWidget {
  const PlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final controller = AppScope.of(context);
    final date = controller.examDate;
    final today = controller.progress.todayCount();
    final goal = controller.dailyGoal;
    final streak = controller.progress.streak();
    final reached = today >= goal;

    return AppCard(
      onTap: () => showPlanSheet(context),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.event_outlined, size: 20, color: AppColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date == null ? s.setExamDate : _countdownText(s, date),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Icon(Icons.edit_outlined, size: 18, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 12),
          ProgressLine(value: goal == 0 ? 0 : (today / goal).clamp(0.0, 1.0).toDouble(), color: reached ? AppColors.success : null),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  reached ? s.goalReached : s.todayProgress(today, goal),
                  style: TextStyle(fontSize: 13, color: reached ? AppColors.success : AppColors.muted),
                ),
              ),
              if (streak > 0)
                Text(s.streakDays(streak), style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    );
  }
}
