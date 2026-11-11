import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foco_de_teste/app_controller.dart';
import 'package:foco_de_teste/data/study_store.dart';
import 'package:foco_de_teste/domain/exam_session.dart';
import 'package:foco_de_teste/domain/question.dart';
import 'package:foco_de_teste/domain/study_profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late StudyStore store;
  late List<PracticeExam> exams;
  var now = DateTime.utc(2026, 11, 10, 12);

  AppController controller() =>
      AppController(exams: exams, avatarSvg: '', store: store, now: () => now);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = StudyStore(await SharedPreferences.getInstance());
    final data =
        jsonDecode(await rootBundle.loadString('assets/exams.json')) as List;
    exams = data
        .map((e) => PracticeExam.fromJson(e as Map<String, dynamic>))
        .toList();
    now = DateTime.utc(2026, 11, 10, 12);
  });

  test('profile, answers, flags and paused timer survive restarting', () async {
    final first = controller();
    first.updateProfile(const StudyProfile(name: 'Ana'));
    first.startExam(exams.first, FocusMode.cafe);
    first.answer(0);
    first.toggleFlag();
    first.goTo(1);
    now = now.add(const Duration(minutes: 5));
    first.pause();
    await first.persist();
    first.dispose();

    now = now.add(const Duration(days: 1));
    final restored = controller()..restore();
    expect(restored.profile.name, 'Ana');
    expect(restored.session!.answers.first, 0);
    expect(restored.session!.flags.first, isTrue);
    expect(restored.session!.index, 1);
    expect(restored.remaining, const Duration(minutes: 55));
    expect(restored.session!.paused, isTrue);
    restored.dispose();
  });

  test('completed results survive new attempts without duplicates', () async {
    final first = controller();
    first.startExam(exams.first, FocusMode.cafe);
    first.answer(exams.first.questions.first.correctIndex);
    first.finish();
    await first.persist();
    await first.persist();
    expect(first.history, hasLength(1));
    first.dispose();

    final restored = controller()..restore();
    await restored.persist();
    expect(restored.history, hasLength(1));
    expect(restored.history.single.score, 1);
    restored.startExam(exams.last, FocusMode.orgulho);
    now = now.add(const Duration(hours: 2));
    restored.refresh();
    await restored.persist();
    restored.dispose();

    final again = controller()..restore();
    expect(again.history, hasLength(2));
    expect(again.session!.expired, isTrue);
    again.dispose();
  });

  test(
    'v1 local progress migrates without losing the current attempt',
    () async {
      final attempt = ExamSession.start(exams.first, FocusMode.cafe, now);
      attempt.answer(0, now);
      await store.write({
        'version': 1,
        'profile': const StudyProfile(name: 'Perfil antigo').toJson(),
        'session': attempt.toJson(),
      });
      final restored = controller()..restore();
      expect(restored.profile.name, 'Perfil antigo');
      expect(restored.session!.answeredCount, 1);
      await restored.persist();
      expect(store.read()!['version'], 2);
      restored.dispose();
    },
  );

  test('question changes preserve historical results and profile', () async {
    final first = controller();
    first.updateProfile(const StudyProfile(name: 'Ana'));
    first.startExam(exams.first, FocusMode.cafe);
    first.finish();
    first.startExam(exams.last, FocusMode.cafe);
    await first.persist();
    first.dispose();
    exams = [];
    final restored = controller()..restore();
    expect(restored.session, isNull);
    expect(restored.history, hasLength(1));
    expect(restored.profile.name, 'Ana');
    expect(restored.storageWarning, isNotNull);
    restored.dispose();
  });
}
