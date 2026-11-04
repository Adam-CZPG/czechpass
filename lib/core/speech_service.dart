import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Telefon (yoki kompyuter) ning o'z nutq sintezi: matn → ovoz.
/// Internet va to'lov shart emas, lekin qurilmada chexcha ovoz bo'lishi kerak.
///
/// Ilova qurilmadagi chexcha ovozlarni o'zi qidiradi, sifatlisini tanlaydi va ayol/erkak
/// ovozini ajratadi. Qurilmada faqat bitta chexcha ovoz bo'lsa (ko'p Android telefonlarida
/// shunday), ikkinchi jins ovozi shu ovozning tembrini o'zgartirib hosil qilinadi.
class VoiceOutput {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _czechAvailable = true;

  Map<String, String>? _female;
  Map<String, String>? _male;
  Map<String, String>? _any;

  /// Ma'lum chexcha ovozlar nomlari (Microsoft, Apple va boshqalar).
  static const _femaleNames = ['vlasta', 'zuzana', 'iveta', 'jana', 'eliska', 'eliška', 'tereza', 'female', 'zena', 'žena'];
  static const _maleNames = ['antonin', 'antonín', 'jakub', 'tomas', 'tomáš', 'ondrej', 'ondřej', 'male', 'muz', 'muž'];

  bool get czechAvailable => _czechAvailable;

  Future<bool> init() async {
    if (_ready) return _czechAvailable;
    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('cs-CZ');
    // Android'da 0.5 — oddiy tezlik, vebda 1.0. A2 uchun biroz sekinroq.
    await _tts.setSpeechRate(kIsWeb ? 0.9 : 0.45);
    await _tts.setPitch(1.0);

    try {
      var voices = await _czechVoices();
      if (voices.isEmpty && kIsWeb) {
        // Brauzer ovozlar ro'yxatini biroz kechikib beradi.
        await Future<void>.delayed(const Duration(milliseconds: 600));
        voices = await _czechVoices();
      }
      _czechAvailable = voices.isNotEmpty;
      for (final v in voices) {
        final g = _genderOf(v);
        if (g == 'f') _female ??= v;
        if (g == 'm') _male ??= v;
      }
      _any = voices.isEmpty ? null : voices.first;
    } catch (_) {
      // Ba'zi platformalar ovozlar ro'yxatini bermaydi — standart ovoz ishlatiladi.
      _czechAvailable = true;
    }

    _ready = true;
    return _czechAvailable;
  }

  Future<List<Map<String, String>>> _czechVoices() async {
    final raw = await _tts.getVoices;
    if (raw is! List) return [];
    final voices = raw
        .whereType<Map>()
        .map((v) => v.map((key, value) => MapEntry('$key', '$value')))
        .where((v) => (v['locale'] ?? '').toLowerCase().replaceAll('_', '-').startsWith('cs'))
        .toList();
    voices.sort((a, b) => _quality(b).compareTo(_quality(a)));
    return voices;
  }

  /// Sifatliroq ovozlar oldinga: Edge'ning "Natural" ovozlari, Google ovozlari, tarmoq ovozlari.
  static int _quality(Map<String, String> voice) {
    final name = (voice['name'] ?? '').toLowerCase();
    var score = 0;
    if (name.contains('natural') || name.contains('neural') || name.contains('online')) score += 4;
    if (name.contains('google')) score += 2;
    if (name.contains('network')) score += 1;
    return score;
  }

  /// "f", "m" yoki null (aniqlab bo'lmasa).
  static String? _genderOf(Map<String, String> voice) {
    final declared = (voice['gender'] ?? '').toLowerCase();
    if (declared.startsWith('f')) return 'f';
    if (declared.startsWith('m')) return 'm';
    final name = (voice['name'] ?? '').toLowerCase();
    if (_femaleNames.any(name.contains)) return 'f';
    if (_maleNames.any(name.contains)) return 'm';
    return null;
  }

  /// [gender] — "f" (ayol) yoki "m" (erkak).
  Future<void> say(String text, {String gender = 'f'}) async {
    await init();
    final exact = gender == 'm' ? _male : _female;
    final voice = exact ?? _any;
    if (voice != null && voice['name'] != null && voice['locale'] != null) {
      await _tts.setVoice({'name': voice['name']!, 'locale': voice['locale']!});
    }
    // Kerakli jinsdagi ovoz yo'q bo'lsa, tembrni o'zgartiramiz. Jinsi noma'lum ovoz
    // (masalan, Android'dagi Google ovozi) odatda ayol ovozi.
    final voiceGender = voice == null ? 'f' : (_genderOf(voice) ?? 'f');
    var pitch = 1.0;
    if (exact == null && voiceGender != gender) {
      pitch = gender == 'm' ? 0.72 : 1.25;
    }
    await _tts.setPitch(pitch);
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}

/// Telefonning o'z nutqni aniqlash xizmati (ovoz → matn).
/// Ilova ovoz yozuvini saqlamaydi, faqat tayyor matnni oladi.
class VoiceInput {
  final SpeechToText _stt = SpeechToText();
  bool _initialized = false;
  bool _available = false;

  bool get isListening => _stt.isListening;

  Future<bool> init({required void Function(String status) onStatus}) async {
    if (_initialized) return _available;
    _initialized = true;
    try {
      _available = await _stt.initialize(
        onStatus: onStatus,
        onError: (error) => onStatus('error'),
      );
    } catch (_) {
      _available = false;
    }
    return _available;
  }

  Future<void> start(void Function(String words) onWords) async {
    await _stt.listen(
      onResult: (result) => onWords(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        localeId: 'cs_CZ',
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> stop() => _stt.stop();
}

/// Chex harflaridagi belgilarni olib tashlaydi: "bydlím" → "bydlim".
/// Nutqni aniqlash natijasini iboralar bilan solishtirish uchun.
String foldCzech(String input) {
  const from = 'áčďéěíňóřšťúůýž';
  const to = 'acdeeinorstuuyz';
  final buffer = StringBuffer();
  for (final ch in input.toLowerCase().split('')) {
    final i = from.indexOf(ch);
    buffer.write(i >= 0 ? to[i] : ch);
  }
  return buffer.toString();
}
