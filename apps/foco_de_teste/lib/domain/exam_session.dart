import 'question.dart';

enum FocusMode {
  cafe(
    'Café com leite',
    true,
    'Mantenha o Wi-Fi ligado e silencie as notificações no dispositivo.',
  ),
  orgulho(
    'Orgulho Bixo',
    false,
    'Ative o modo avião, desligue o Wi-Fi e silencie as notificações no dispositivo.',
  );

  const FocusMode(this.label, this.canPause, this.instructions);
  final String label;
  final bool canPause;
  final String instructions;
}

class ExamSession {
  ExamSession.start(this.exam, this.mode, DateTime now)
    : _deadline = now.add(duration),
      _answers = List.filled(exam.questions.length, null),
      _flags = List.filled(exam.questions.length, false);

  static const duration = Duration(minutes: 60);
  final PracticeExam exam;
  final FocusMode mode;
  final List<int?> _answers;
  final List<bool> _flags;
  DateTime _deadline;
  Duration? _pausedRemaining;
  Duration? _used;
  int _index = 0;
  bool _expired = false;

  List<int?> get answers => List.unmodifiable(_answers);
  List<bool> get flags => List.unmodifiable(_flags);
  int get index => _index;
  bool get paused => _pausedRemaining != null;
  bool get completed => _used != null;
  bool get expired => _expired;
  Duration get used => _used ?? Duration.zero;
  int get answeredCount => _answers.where((answer) => answer != null).length;
  int get score => List.generate(
    _answers.length,
    (i) => _answers[i] == exam.questions[i].correctIndex,
  ).where((correct) => correct).length;

  Duration remaining(DateTime now) {
    if (completed) return duration - used;
    if (_pausedRemaining != null) return _pausedRemaining!;
    return Duration(
      milliseconds: _deadline
          .difference(now)
          .inMilliseconds
          .clamp(0, duration.inMilliseconds),
    );
  }

  bool expireIfNeeded(DateTime now) {
    if (completed || remaining(now) > Duration.zero) return false;
    _expired = true;
    _used = duration;
    _pausedRemaining = null;
    return true;
  }

  bool answer(int choice, DateTime now) {
    expireIfNeeded(now);
    if (completed || paused || _answers[index] != null) return false;
    if (choice < 0 || choice >= exam.questions[index].options.length) {
      throw RangeError.index(choice, exam.questions[index].options);
    }
    _answers[index] = choice;
    return true;
  }

  bool pause(DateTime now) {
    expireIfNeeded(now);
    if (!mode.canPause || completed || paused) return false;
    _pausedRemaining = remaining(now);
    return true;
  }

  void resume(DateTime now) {
    if (completed || !paused) return;
    _deadline = now.add(_pausedRemaining!);
    _pausedRemaining = null;
  }

  void goTo(int next) {
    if (next < 0 || next >= exam.questions.length) {
      throw RangeError.index(next, exam.questions);
    }
    if (!paused && !completed) _index = next;
  }

  void toggleFlag(DateTime now) {
    expireIfNeeded(now);
    if (!paused && !completed) _flags[index] = !_flags[index];
  }

  void finish(DateTime now) {
    expireIfNeeded(now);
    if (completed) return;
    _used = duration - remaining(now);
    _pausedRemaining = null;
  }

  Map<String, dynamic> toJson() => {
    'examId': exam.id,
    'questionIds': exam.questions.map((q) => q.id).toList(),
    'mode': mode.name,
    'deadline': _deadline.toIso8601String(),
    'pausedMs': _pausedRemaining?.inMilliseconds,
    'usedMs': _used?.inMilliseconds,
    'index': index,
    'expired': expired,
    'answers': _answers,
    'flags': _flags,
  };

  factory ExamSession.fromJson(
    Map<String, dynamic> json,
    List<PracticeExam> exams,
  ) {
    final exam = exams.where((exam) => exam.id == json['examId']).firstOrNull;
    final mode = FocusMode.values
        .where((mode) => mode.name == json['mode'])
        .firstOrNull;
    if (exam == null || mode == null) {
      throw const FormatException('Treino indisponível.');
    }
    final ids = List<String>.from(json['questionIds'] as List);
    final answers = List<int?>.from(json['answers'] as List);
    final flags = List<bool>.from(json['flags'] as List);
    final index = json['index'] as int;
    final pausedMs = json['pausedMs'] as int?;
    final usedMs = json['usedMs'] as int?;
    final expired = json['expired'] as bool;
    final deadline = DateTime.parse(json['deadline'] as String);
    if (ids.length != exam.questions.length ||
        answers.length != ids.length ||
        flags.length != ids.length ||
        index < 0 ||
        index >= ids.length ||
        (pausedMs != null &&
            (!mode.canPause ||
                pausedMs <= 0 ||
                pausedMs > duration.inMilliseconds)) ||
        (usedMs != null && (usedMs < 0 || usedMs > duration.inMilliseconds)) ||
        (pausedMs != null && usedMs != null) ||
        (expired && usedMs != duration.inMilliseconds)) {
      throw const FormatException('Estado da tentativa inválido.');
    }
    for (var i = 0; i < ids.length; i++) {
      final choice = answers[i];
      if (ids[i] != exam.questions[i].id ||
          (choice != null &&
              (choice < 0 || choice >= exam.questions[i].options.length))) {
        throw const FormatException('As questões da tentativa mudaram.');
      }
    }
    final session = ExamSession.start(exam, mode, deadline.subtract(duration));
    session._answers.setAll(0, answers);
    session._flags.setAll(0, flags);
    session._index = index;
    session._pausedRemaining = pausedMs == null
        ? null
        : Duration(milliseconds: pausedMs);
    session._used = usedMs == null ? null : Duration(milliseconds: usedMs);
    session._expired = expired;
    return session;
  }
}
