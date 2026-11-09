import 'package:flutter_test/flutter_test.dart';
import 'package:foco_de_teste/domain/exam_session.dart';
import 'package:foco_de_teste/domain/question.dart';

void main() {
  final start = DateTime.utc(2026, 11, 9, 12);
  final exam = PracticeExam(
    id: 'A',
    title: 'Treino A',
    description: 'Demonstração',
    questions: [
      Question(
        id: 'a1',
        prompt: 'Questão',
        options: ['A', 'B'],
        correctIndex: 0,
        explanation: 'Explicação',
        topic: 'Fundamentos',
      ),
      Question(
        id: 'a2',
        prompt: 'Outra questão',
        options: ['A', 'B'],
        correctIndex: 1,
        explanation: 'Explicação',
        topic: 'Fundamentos',
      ),
    ],
  );

  test('first answer is final after feedback and blank answers score zero', () {
    final session = ExamSession.start(exam, FocusMode.cafe, start);
    expect(session.answer(1, start), isTrue);
    expect(session.answer(0, start), isFalse);
    session.finish(start.add(const Duration(minutes: 2)));
    expect(session.score, 0);
    expect(session.answeredCount, 1);
    expect(session.used, const Duration(minutes: 2));
    expect(session.answer(0, start), isFalse);
  });

  test('pause excludes elapsed wall time and hides answer operations', () {
    final session = ExamSession.start(exam, FocusMode.cafe, start);
    final pauseAt = start.add(const Duration(minutes: 5));
    expect(session.pause(pauseAt), isTrue);
    expect(
      session.remaining(start.add(const Duration(hours: 2))),
      const Duration(minutes: 55),
    );
    expect(session.answer(0, pauseAt), isFalse);
    session.resume(start.add(const Duration(hours: 2)));
    expect(
      session.remaining(start.add(const Duration(hours: 2, minutes: 2))),
      const Duration(minutes: 53),
    );
  });

  test('Orgulho Bixo cannot pause and expires even without periodic ticks', () {
    final session = ExamSession.start(exam, FocusMode.orgulho, start);
    expect(session.pause(start.add(const Duration(minutes: 1))), isFalse);
    expect(session.answer(0, start.add(const Duration(hours: 1))), isFalse);
    expect(session.completed, isTrue);
    expect(session.expired, isTrue);
    expect(session.used, const Duration(hours: 1));
  });

  test('running and paused attempts restore with their original timing', () {
    final session = ExamSession.start(exam, FocusMode.cafe, start);
    session.answer(0, start);
    session.toggleFlag(start);
    session.goTo(1);
    final restored = ExamSession.fromJson(session.toJson(), [exam]);
    expect(
      restored.remaining(start.add(const Duration(minutes: 4))),
      const Duration(minutes: 56),
    );
    expect(restored.score, 1);
    expect(restored.flags, [true, false]);
    expect(restored.index, 1);
    restored.pause(start.add(const Duration(minutes: 4)));
    final paused = ExamSession.fromJson(restored.toJson(), [exam]);
    expect(
      paused.remaining(start.add(const Duration(days: 1))),
      const Duration(minutes: 56),
    );
  });

  test('restoration rejects changed content and invalid indices', () {
    final session = ExamSession.start(exam, FocusMode.cafe, start);
    expect(
      () => ExamSession.fromJson({...session.toJson(), 'index': 7}, [exam]),
      throwsFormatException,
    );
    expect(
      () => ExamSession.fromJson(
        {
          ...session.toJson(),
          'answers': [8, null],
        },
        [exam],
      ),
      throwsFormatException,
    );
    expect(
      () => ExamSession.fromJson(
        {
          ...session.toJson(),
          'questionIds': ['old'],
        },
        [exam],
      ),
      throwsFormatException,
    );
  });
}
