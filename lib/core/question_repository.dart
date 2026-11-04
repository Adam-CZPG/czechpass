import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:czech_pass/core/question.dart';

/// Savollarni ilova ichidagi JSON fayllardan yuklaydi (internet shart emas).
/// Keyinchalik shu yerga serverdan yangilanishlarni yuklash qo'shilishi mumkin.
class QuestionRepository {
  const QuestionRepository();

  static const realiePath = 'assets/questions/realie.json';
  static const a2ReadingPath = 'assets/questions/a2_reading.json';
  static const a2ListeningPath = 'assets/questions/a2_listening.json';
  static const a2SpeakingPath = 'assets/questions/a2_speaking.json';
  static const a2WritingPath = 'assets/questions/a2_writing.json';

  Future<QuestionBank> loadRealie() async {
    final raw = await rootBundle.loadString(realiePath);
    return QuestionBank.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<List<ReadingTask>> loadA2Reading() => _tasks(a2ReadingPath, ReadingTask.fromJson);

  Future<List<ListeningTask>> loadA2Listening() => _tasks(a2ListeningPath, ListeningTask.fromJson);

  Future<List<SpeakingTask>> loadA2Speaking() => _tasks(a2SpeakingPath, SpeakingTask.fromJson);

  Future<List<WritingTask>> loadA2Writing() => _tasks(a2WritingPath, WritingTask.fromJson);

  Future<List<T>> _tasks<T>(String path, T Function(Map<String, dynamic>) parse) async {
    final raw = await rootBundle.loadString(path);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return (json['tasks'] as List).map((item) => parse(item as Map<String, dynamic>)).toList();
  }
}
