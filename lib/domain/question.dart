class Question {
  Question({
    required this.id,
    required this.prompt,
    required List<String> options,
    required this.correctIndex,
    required this.explanation,
    required this.topic,
  }) : options = List.unmodifiable(options) {
    if (id.isEmpty ||
        prompt.isEmpty ||
        options.length < 2 ||
        correctIndex < 0 ||
        correctIndex >= options.length ||
        options.any((option) => option.isEmpty) ||
        explanation.isEmpty) {
      throw const FormatException('Questão inválida.');
    }
  }

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as String,
    prompt: json['prompt'] as String,
    options: List<String>.from(json['options'] as List),
    correctIndex: json['correctIndex'] as int,
    explanation: json['explanation'] as String,
    topic: json['topic'] as String,
  );

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String topic;
}

class PracticeExam {
  PracticeExam({
    required this.id,
    required this.title,
    required this.description,
    required List<Question> questions,
  }) : questions = List.unmodifiable(questions) {
    if (questions.isEmpty ||
        questions.map((q) => q.id).toSet().length != questions.length) {
      throw const FormatException(
        'O treino precisa de questões com IDs únicos.',
      );
    }
  }

  factory PracticeExam.fromJson(Map<String, dynamic> json) => PracticeExam(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    questions: (json['questions'] as List)
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  final String id;
  final String title;
  final String description;
  final List<Question> questions;
}
