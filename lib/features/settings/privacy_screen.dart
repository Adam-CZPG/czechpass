import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/l10n/strings.dart';
import 'package:czech_pass/widgets/common.dart';

enum PolicyBlockKind { heading, bullet, paragraph }

/// Maxfiylik siyosati matnining bitta bo'lagi.
class PolicyBlock {
  const PolicyBlock(this.kind, this.text);

  final PolicyBlockKind kind;
  final String text;
}

/// Matn fayli: chexcha — asosiy (huquqiy kuchga ega), qolgan tillar uchun inglizcha.
String policyAsset(String lang) => lang == 'cs' ? 'assets/legal/privacy_cs.md' : 'assets/legal/privacy_en.md';

/// Oddiy formatni o'qiydi: "## " — sarlavha, "- " — ro'yxat, qolgani — abzas.
/// Birinchi qatordagi "# " sarlavha tashlab ketiladi (u ekran tepasida ko'rsatiladi).
List<PolicyBlock> parsePolicy(String raw) {
  final blocks = <PolicyBlock>[];
  for (final line in const LineSplitter().convert(raw)) {
    final text = line.trim();
    if (text.isEmpty || text.startsWith('# ')) continue;
    if (text.startsWith('## ')) {
      blocks.add(PolicyBlock(PolicyBlockKind.heading, text.substring(3)));
    } else if (text.startsWith('- ')) {
      blocks.add(PolicyBlock(PolicyBlockKind.bullet, text.substring(2)));
    } else {
      blocks.add(PolicyBlock(PolicyBlockKind.paragraph, text));
    }
  }
  return blocks;
}

/// Maxfiylik siyosati (assets/legal/). Internet shart emas.
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Future<List<PolicyBlock>>? _future;
  String? _lang;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (_lang != s.lang) {
      _lang = s.lang;
      _future = rootBundle.loadString(policyAsset(s.lang)).then(parsePolicy);
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<List<PolicyBlock>>(
          future: _future,
          builder: (context, snapshot) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                ScreenHeader(title: s.privacyPolicy, tooltip: s.back),
                const SizedBox(height: 16),
                if (snapshot.hasError) Text('${s.loadError}\n${snapshot.error}'),
                if (!snapshot.hasData && !snapshot.hasError) const Center(child: CircularProgressIndicator()),
                for (final block in snapshot.data ?? const <PolicyBlock>[]) _block(block),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _block(PolicyBlock block) {
    switch (block.kind) {
      case PolicyBlockKind.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 6),
          child: Semantics(
            header: true,
            child: Text(block.text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          ),
        );
      case PolicyBlockKind.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('•  ', style: TextStyle(fontSize: 14, height: 1.5)),
              Expanded(child: Text(block.text, style: const TextStyle(fontSize: 14, height: 1.5))),
            ],
          ),
        );
      case PolicyBlockKind.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(block.text, style: const TextStyle(fontSize: 14, height: 1.5)),
        );
    }
  }
}
