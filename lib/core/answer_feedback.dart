import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Javobdan keyingi qisqa ovoz va tebranish (Duolingo'dagi kabi).
/// To'g'ri javob — yorqin "ding" va yengil tebranish, noto'g'ri — past ovoz va kuchliroq tebranish.
/// Sozlamalarda o'chirish mumkin ([enabled]).
class AnswerFeedback {
  static bool enabled = true;
  static AudioPlayer? _player;

  static AudioPlayer get _audio => _player ??= AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  static Future<void> correct() => _play('sfx/correct.mp3', HapticFeedback.lightImpact);

  static Future<void> wrong() => _play('sfx/wrong.mp3', HapticFeedback.heavyImpact);

  /// Natijaga qarab: to'g'ri bo'lsa — [correct], aks holda — [wrong].
  static Future<void> of(bool right) => right ? correct() : wrong();

  static Future<void> _play(String asset, Future<void> Function() haptic) async {
    if (!enabled) return;
    try {
      if (!kIsWeb) await haptic();
      await _audio.stop();
      await _audio.play(AssetSource(asset), volume: 0.7);
    } catch (_) {
      // Ovoz yoki tebranish ishlamasa, mashg'ulot davom etadi.
    }
  }
}
