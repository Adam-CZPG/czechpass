/// Bitta test savoli. Savol matni doim chex tilida, qolganlari tarjima.
class Question {
  const Question({
    required this.id,
    required this.topic,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.explanation = const {},
  });

  final String id;
  final String topic;

  /// Til kodi → savol matni. 'cs' har doim bo'ladi.
  final Map<String, String> text;

  /// Javob variantlari (chex tilida).
  final List<String> options;

  /// To'g'ri javobning `options` ichidagi tartib raqami.
  final int correctIndex;

  /// Til kodi → izoh (bo'lmasligi ham mumkin).
  final Map<String, String> explanation;

  String get czech => text['cs'] ?? '';

  /// Tanlangan tildagi tarjima. Chex tili tanlangan bo'lsa, tarjima kerak emas.
  String? translation(String lang) => lang == 'cs' ? null : text[lang];

  String explanationFor(String lang) => explanation[lang] ?? explanation['cs'] ?? '';

  factory Question.fromJson(Map<String, dynamic> json, {String idPrefix = ''}) {
    return Question(
      id: '$idPrefix${json['id']}',
      topic: json['topic'] as String? ?? '',
      text: Map<String, String>.from(json['question'] as Map),
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correct'] as int,
      explanation: json['explanation'] == null
          ? const {}
          : Map<String, String>.from(json['explanation'] as Map),
    );
  }
}

/// České reálie savollari to'plami (bitta JSON fayl).
class QuestionBank {
  const QuestionBank({
    required this.exam,
    required this.source,
    required this.topics,
    required this.questions,
  });

  final String exam;

  /// "own" — o'zimiz yozgan savollar; keyin "official" qo'shilishi mumkin.
  final String source;

  /// Mavzu kodi → (til kodi → nomi).
  final Map<String, Map<String, String>> topics;
  final List<Question> questions;

  String topicLabel(String topic, String lang) =>
      topics[topic]?[lang] ?? topics[topic]?['cs'] ?? topic;

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    final rawTopics = json['topics'] as Map;
    return QuestionBank(
      exam: json['exam'] as String,
      source: json['source'] as String,
      topics: rawTopics.map(
        (key, value) => MapEntry(key as String, Map<String, String>.from(value as Map)),
      ),
      questions: (json['questions'] as List)
          .map((item) => Question.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A2 o'qish topshirig'i: chexcha matn va unga oid savollar.
class ReadingTask {
  const ReadingTask({
    required this.id,
    required this.title,
    required this.text,
    required this.questions,
  });

  final String id;
  final Map<String, String> title;
  final String text;
  final List<Question> questions;

  String titleFor(String lang) => title[lang] ?? title['cs'] ?? '';

  factory ReadingTask.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return ReadingTask(
      id: id,
      title: Map<String, String>.from(json['title'] as Map),
      text: json['text'] as String,
      questions: (json['questions'] as List)
          .map((item) => Question.fromJson(item as Map<String, dynamic>, idPrefix: '$id/'))
          .toList(),
    );
  }
}

/// Tinglash yozuvidagi bitta gap (A yoki B so'zlovchi).
class ScriptLine {
  const ScriptLine({required this.speaker, required this.text});

  final String speaker;
  final String text;
}

/// A2 tinglash topshirig'i: telefon ovozi o'qib beradigan matn va savollar.
class ListeningTask {
  const ListeningTask({
    required this.id,
    required this.title,
    required this.lines,
    required this.questions,
  });

  final String id;
  final Map<String, String> title;
  final List<ScriptLine> lines;
  final List<Question> questions;

  String titleFor(String lang) => title[lang] ?? title['cs'] ?? '';

  String get transcript => lines.map((l) => '${l.speaker}: ${l.text}').join('\n');

  factory ListeningTask.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return ListeningTask(
      id: id,
      title: Map<String, String>.from(json['title'] as Map),
      lines: (json['lines'] as List)
          .map((l) => ScriptLine(
                speaker: (l as Map)['speaker'] as String,
                text: l['text'] as String,
              ))
          .toList(),
      questions: (json['questions'] as List)
          .map((item) => Question.fromJson(item as Map<String, dynamic>, idPrefix: '$id/'))
          .toList(),
    );
  }
}

/// A2 gapirish topshirig'i.
class SpeakingTask {
  const SpeakingTask({
    required this.id,
    required this.title,
    required this.prompt,
    required this.keywords,
    required this.model,
  });

  final String id;
  final Map<String, String> title;
  final Map<String, String> prompt;

  /// Javobda bo'lishi kerak bo'lgan iboralar.
  final List<String> keywords;

  /// Namunaviy javob (chex tilida).
  final String model;

  String titleFor(String lang) => title[lang] ?? title['cs'] ?? '';
  String get promptCs => prompt['cs'] ?? '';
  String? promptTranslation(String lang) => lang == 'cs' ? null : prompt[lang];

  factory SpeakingTask.fromJson(Map<String, dynamic> json) {
    return SpeakingTask(
      id: json['id'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      prompt: Map<String, String>.from(json['prompt'] as Map),
      keywords: List<String>.from(json['keywords'] as List),
      model: json['model'] as String,
    );
  }
}

/// A2 yozish topshirig'i.
class WritingTask {
  const WritingTask({
    required this.id,
    required this.title,
    required this.prompt,
    required this.points,
    required this.minWords,
    required this.model,
  });

  final String id;
  final Map<String, String> title;
  final Map<String, String> prompt;

  /// Matnda yoritilishi kerak bo'lgan bandlar (til kodi → matn).
  final List<Map<String, String>> points;
  final int minWords;
  final String model;

  String titleFor(String lang) => title[lang] ?? title['cs'] ?? '';
  String get promptCs => prompt['cs'] ?? '';
  String? promptTranslation(String lang) => lang == 'cs' ? null : prompt[lang];

  factory WritingTask.fromJson(Map<String, dynamic> json) {
    return WritingTask(
      id: json['id'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      prompt: Map<String, String>.from(json['prompt'] as Map),
      points: (json['points'] as List).map((p) => Map<String, String>.from(p as Map)).toList(),
      minWords: json['minWords'] as int,
      model: json['model'] as String,
    );
  }
}

/// Foydalanuvchining bitta javobi natijasi.
class AnswerRecord {
  const AnswerRecord({required this.questionId, required this.topic, required this.correct});

  final String questionId;
  final String topic;
  final bool correct;
}
