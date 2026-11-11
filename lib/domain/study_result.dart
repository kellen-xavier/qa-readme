import 'exam_session.dart';

/// A compact result survives replacing the current exam or updating its questions.
class StudyResult {
  const StudyResult({
    required this.examTitle,
    required this.mode,
    required this.finishedAt,
    required this.score,
    required this.total,
    required this.answered,
    required this.usedSeconds,
  });

  final String examTitle;
  final FocusMode mode;
  final DateTime finishedAt;
  final int score;
  final int total;
  final int answered;
  final int usedSeconds;

  factory StudyResult.fromSession(ExamSession session, DateTime now) =>
      StudyResult(
        examTitle: session.exam.title,
        mode: session.mode,
        finishedAt: now,
        score: session.score,
        total: session.exam.questions.length,
        answered: session.answeredCount,
        usedSeconds: session.used.inSeconds,
      );

  Map<String, dynamic> toJson() => {
    'examTitle': examTitle,
    'mode': mode.name,
    'finishedAt': finishedAt.toIso8601String(),
    'score': score,
    'total': total,
    'answered': answered,
    'usedSeconds': usedSeconds,
  };

  factory StudyResult.fromJson(Map<String, dynamic> json) {
    final result = StudyResult(
      examTitle: json['examTitle'] as String,
      mode: FocusMode.values.byName(json['mode'] as String),
      finishedAt: DateTime.parse(json['finishedAt'] as String),
      score: json['score'] as int,
      total: json['total'] as int,
      answered: json['answered'] as int,
      usedSeconds: json['usedSeconds'] as int,
    );
    if (result.total <= 0 ||
        result.score < 0 ||
        result.score > result.answered ||
        result.answered > result.total ||
        result.usedSeconds < 0 ||
        result.usedSeconds > ExamSession.duration.inSeconds) {
      throw const FormatException('Resultado inválido.');
    }
    return result;
  }
}
