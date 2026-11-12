import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:czech_pass/features/settings/privacy_screen.dart';

void main() {
  test("maxfiylik siyosati: sarlavha, ro'yxat va abzaslar ajratiladi", () {
    final blocks = parsePolicy('# Sarlavha\n\n## Bo\'lim\n- birinchi\n- ikkinchi\nOddiy matn.\n');
    expect(blocks.map((b) => b.kind), [
      PolicyBlockKind.heading,
      PolicyBlockKind.bullet,
      PolicyBlockKind.bullet,
      PolicyBlockKind.paragraph,
    ]);
    expect(blocks.first.text, "Bo'lim");
    expect(blocks[1].text, 'birinchi');
  });

  test('chexcha va inglizcha matnlar bir xil tuzilmada', () {
    int headings(String lang) => parsePolicy(File(policyAsset(lang)).readAsStringSync())
        .where((b) => b.kind == PolicyBlockKind.heading)
        .length;
    expect(headings('cs'), greaterThan(8));
    expect(headings('cs'), headings('en'));
    // Chex tilidan boshqa tillar inglizcha matnni ko'radi.
    expect(policyAsset('uz'), policyAsset('en'));
  });
}
