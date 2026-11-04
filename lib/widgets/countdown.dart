import 'dart:async';

import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/l10n/strings.dart';

/// "mm:ss" ko'rinishida teskari hisoblovchi soat (sinov imtihonlari uchun).
/// Vaqt tugaganda [onFinished] bir marta chaqiriladi.
class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.duration, required this.onFinished});

  final Duration duration;
  final VoidCallback onFinished;

  static String format(Duration d) {
    final total = d.inSeconds < 0 ? 0 : d.inSeconds;
    final m = (total ~/ 60).toString().padLeft(2, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final DateTime _end;
  Timer? _timer;
  late Duration _left = widget.duration;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _end = DateTime.now().add(widget.duration);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final left = _end.difference(DateTime.now());
    if (!mounted) return;
    setState(() => _left = left.isNegative ? Duration.zero : left);
    if (left <= Duration.zero && !_done) {
      _done = true;
      _timer?.cancel();
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final text = Countdown.format(_left);
    final warning = _left.inMinutes < 5;
    return Semantics(
      label: s.timeLeft(text),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: warning ? AppColors.errorSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, size: 16, color: warning ? AppColors.error : AppColors.ink),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: warning ? AppColors.error : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
