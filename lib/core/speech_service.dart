import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Telefon (yoki kompyuter) ning o'z nutq sintezi: matn → ovoz.
/// Internet va to'lov shart emas, lekin qurilmada chexcha ovoz bo'lishi kerak.
///
/// Ilova qurilmadagi chexcha ovozlarni o'zi qidiradi va eng sifatlisini tanlaydi.
/// Dialogda ikkita turli ovoz bo'lsa (masalan, ayol va erkak), A va B so'zlovchiga
/// alohida ovoz beriladi.
class VoiceOutput {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool _czechAvailable = true;

  Map<String, String>? _voiceA;
  Map<String, String>? _voiceB;

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
      if (voices.isNotEmpty) {
        _voiceA = voices.first;
        // B uchun boshqa odamning ovozini qidiramiz (bir ovozning "network/local" nusxasi emas).
        final keyA = _personKey(_voiceA!);
        for (final v in voices.skip(1)) {
          if (_personKey(v) != keyA) {
            _voiceB = v;
            break;
          }
        }
      }
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

  static String _personKey(Map<String, String> voice) =>
      (voice['name'] ?? '').toLowerCase().replaceAll(RegExp(r'[-_ ]?(network|local)$'), '');

  /// [speaker] — dialogdagi so'zlovchi ("A" yoki "B").
  Future<void> say(String text, {String speaker = 'A'}) async {
    await init();
    final voice = speaker == 'B' && _voiceB != null ? _voiceB : _voiceA;
    if (voice != null && voice['name'] != null && voice['locale'] != null) {
      await _tts.setVoice({'name': voice['name']!, 'locale': voice['locale']!});
    }
    // Ikkinchi alohida ovoz bo'lmasa, B'ni ozgina farqlaymiz (ko'p o'zgartirilsa, robotga o'xshaydi).
    await _tts.setPitch(speaker == 'B' && _voiceB == null ? 1.1 : 1.0);
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
      localeId: 'cs_CZ',
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 5),
      listenOptions: SpeechListenOptions(partialResults: true, listenMode: ListenMode.dictation),
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
