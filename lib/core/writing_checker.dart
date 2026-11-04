import 'package:czech_pass/core/speech_service.dart';

/// Yozish tekshiruvi natijalari.
enum WritingCheck {
  lengthOk,
  tooShort,
  greetingOk,
  greetingMissing,
  closingOk,
  closingMissing,
  fewDiacritics,
}

/// Ilova ichida, internetsiz ishlaydigan oddiy tekshiruv.
/// Grammatikani tekshirmaydi — bu keyinchalik AI orqali qo'shiladi (ai_writing_service.dart).
class WritingChecker {
  const WritingChecker();

  static const _greetings = [
    'ahoj', 'dobry den', 'mily', 'mila', 'mili', 'vazen', 'zdravim', 'cau', 'dobry vecer',
  ];
  static const _closings = [
    's pozdravem', 'pozdravem', 'mej se', 'mejte se', 'ahoj', 'cau', 'dekuji', 'diky',
    'zdravi', 'tvuj', 'tvoje', 'na shledanou', 's diky',
  ];

  static int wordCount(String text) =>
      text.split(RegExp(r'\s+')).where((w) => w.trim().isNotEmpty).length;

  List<WritingCheck> check(String text, {required int minWords}) {
    final folded = foldCzech(text.trim());
    final results = <WritingCheck>[];

    results.add(wordCount(text) >= minWords ? WritingCheck.lengthOk : WritingCheck.tooShort);

    final start = folded.length > 40 ? folded.substring(0, 40) : folded;
    results.add(_greetings.any(start.contains) ? WritingCheck.greetingOk : WritingCheck.greetingMissing);

    final end = folded.length > 80 ? folded.substring(folded.length - 80) : folded;
    results.add(_closings.any(end.contains) ? WritingCheck.closingOk : WritingCheck.closingMissing);

    // Chex harflari: matnda harflarning ~1 foizidan kam bo'lsa — ogohlantirish.
    final letters = RegExp(r'\p{L}', unicode: true).allMatches(text).length;
    final marked = RegExp('[áčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ]').allMatches(text).length;
    if (letters > 40 && marked / letters < 0.01) {
      results.add(WritingCheck.fewDiacritics);
    }
    return results;
  }
}
