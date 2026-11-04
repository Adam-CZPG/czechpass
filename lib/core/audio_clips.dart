import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// Ilova ichidagi tayyor MP3 yozuvlar (tinglash dialoglari, Azure Neural TTS:
/// ayol — Vlasta, erkak — Antonín). Fayllar `tool/generate_audio.py` bilan yaratiladi.
///
/// Yozuv bo'lmasa, ekranlar telefonning o'z nutq sinteziga (VoiceOutput) qaytadi.
class ListeningAudio {
  ListeningAudio() {
    _completion = _player.onPlayerComplete.listen((_) => _complete());
  }

  static const _dir = 'audio/listening';
  static Set<String>? _clips;

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completion;
  Completer<void>? _current;

  /// manifest.json'dagi mavjud yozuvlar (topshiriq id'lari).
  static Future<Set<String>> clips() async {
    final cached = _clips;
    if (cached != null) return cached;
    Set<String> result;
    try {
      final raw = await rootBundle.loadString('assets/$_dir/manifest.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      result = {for (final id in json['clips'] as List) '$id'};
    } catch (_) {
      result = <String>{};
    }
    _clips = result;
    return result;
  }

  static Future<bool> has(String taskId) async => (await clips()).contains(taskId);

  void _complete() {
    final current = _current;
    _current = null;
    if (current != null && !current.isCompleted) current.complete();
  }

  /// Yozuvni o'ynaydi va tugashini (yoki [stop] chaqirilishini) kutadi.
  Future<void> play(String taskId) async {
    _complete();
    final done = Completer<void>();
    _current = done;
    try {
      await _player.play(AssetSource('$_dir/$taskId.mp3'));
    } catch (_) {
      _complete();
      rethrow;
    }
    return done.future;
  }

  Future<void> stop() async {
    await _player.stop();
    _complete();
  }

  Future<void> dispose() async {
    _complete();
    await _completion?.cancel();
    await _player.dispose();
  }
}
