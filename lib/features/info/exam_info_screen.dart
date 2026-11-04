import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

/// Imtihon haqida bitta ma'lumot qatori (masalan, "To'lov — 3 200 Kč").
class ExamFact {
  const ExamFact(this.label, this.value);

  final Map<String, String> label;
  final Map<String, String> value;
}

/// Bitta imtihon: nomi, rasmiy havola va faktlar ro'yxati.
class ExamInfo {
  const ExamInfo({required this.id, required this.title, required this.url, required this.facts});

  final String id;
  final Map<String, String> title;
  final String url;
  final List<ExamFact> facts;

  static List<ExamInfo> parse(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    Map<String, String> m(Object? v) => Map<String, String>.from(v as Map);
    return [
      for (final e in json['exams'] as List)
        ExamInfo(
          id: (e as Map)['id'] as String,
          title: m(e['title']),
          url: e['url'] as String,
          facts: [
            for (final f in e['facts'] as List) ExamFact(m((f as Map)['label']), m(f['value'])),
          ],
        ),
    ];
  }
}

String _pick(Map<String, String> m, String lang) => m[lang] ?? m['cs'] ?? '';

/// Rasmiy imtihonlar haqida qisqa ma'lumot (assets/info/exams.json).
class ExamInfoScreen extends StatefulWidget {
  const ExamInfoScreen({super.key, this.focus});

  /// Ro'yxatda birinchi ko'rsatiladigan imtihon: "a2", "b1" yoki "realie".
  final String? focus;

  @override
  State<ExamInfoScreen> createState() => _ExamInfoScreenState();
}

class _ExamInfoScreenState extends State<ExamInfoScreen> {
  late final Future<List<ExamInfo>> _future = rootBundle.loadString('assets/info/exams.json').then(ExamInfo.parse);

  Future<void> _open(String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = S.of(context).linkError;
    final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).catchError((_) => false);
    if (!ok) messenger.showSnackBar(SnackBar(content: Text(error)));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<List<ExamInfo>>(
          future: _future,
          builder: (context, snapshot) {
            final exams = [...?snapshot.data];
            if (widget.focus != null) {
              exams.sort((a, b) => (a.id == widget.focus ? 0 : 1).compareTo(b.id == widget.focus ? 0 : 1));
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                ScreenHeader(title: s.examInfoTitle, tooltip: s.back),
                const SizedBox(height: 16),
                if (snapshot.hasError) Text('${s.loadError}\n${snapshot.error}'),
                if (!snapshot.hasData && !snapshot.hasError) const Center(child: CircularProgressIndicator()),
                for (final exam in exams) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            _pick(exam.title, s.lang),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ),
                        for (final fact in exam.facts) ...[
                          const SizedBox(height: 12),
                          Text(
                            _pick(fact.label, s.lang),
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.accent),
                          ),
                          const SizedBox(height: 2),
                          Text(_pick(fact.value, s.lang), style: const TextStyle(fontSize: 14, height: 1.5)),
                        ],
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => _open(exam.url),
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: Text(s.officialSite),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Text(s.dataAsOf, style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.muted)),
              ],
            );
          },
        ),
      ),
    );
  }
}
