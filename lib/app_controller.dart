import 'dart:async';

import 'package:flutter/foundation.dart';

import 'data/study_store.dart';
import 'domain/exam_session.dart';
import 'domain/question.dart';
import 'domain/study_profile.dart';
import 'domain/study_result.dart';

class AppController extends ChangeNotifier {
  AppController({
    required this.exams,
    required this.avatarSvg,
    this.store,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final List<PracticeExam> exams;
  final String avatarSvg;
  final StudyStore? store;
  final DateTime Function() _now;
  StudyProfile profile = const StudyProfile();
  ExamSession? session;
  String? storageWarning;
  final List<StudyResult> _history = [];
  List<StudyResult> get history => List.unmodifiable(_history);
  bool _sessionRecorded = false;
  Future<void> _pendingSave = Future.value();
  Timer? _timer;
  bool _disposed = false;

  bool get hasActiveSession => session != null && !session!.completed;
  Duration get remaining => session?.remaining(_now()) ?? ExamSession.duration;

  void restore() {
    if (store == null) {
      storageWarning =
          'Armazenamento indisponível. O estudo ficará nesta sessão.';
      return;
    }
    try {
      final snapshot = store!.read();
      if (snapshot == null) return;
      if (snapshot['version'] != 1 && snapshot['version'] != 2) {
        throw const FormatException('Versão incompatível.');
      }
      profile = StudyProfile.fromJson(
        snapshot['profile'] as Map<String, dynamic>,
      );
      _history.clear();
      for (final entry in (snapshot['history'] as List? ?? [])) {
        _history.add(StudyResult.fromJson(entry as Map<String, dynamic>));
      }
      _sessionRecorded = snapshot['sessionRecorded'] == true;
      final attempt = snapshot['session'];
      if (attempt != null) {
        try {
          session = ExamSession.fromJson(
            attempt as Map<String, dynamic>,
            exams,
          );
          session!.expireIfNeeded(_now());
        } on Object {
          session = null;
          storageWarning =
              'A tentativa anterior não está disponível. Seu histórico foi preservado.';
        }
        if (session?.completed ?? false) persist();
      }
    } on Object {
      session = null;
      storageWarning =
          'O estudo salvo não pôde ser recuperado. Você pode iniciar um novo treino.';
    }
  }

  void startClock() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => refresh());
  }

  void refresh() {
    final attempt = session;
    if (attempt == null || attempt.completed || attempt.paused) return;
    if (attempt.expireIfNeeded(_now())) persist();
    notifyListeners();
  }

  void startExam(PracticeExam exam, FocusMode mode) {
    if (hasActiveSession) throw StateError('Retome a tentativa em andamento.');
    _sessionRecorded = false;
    session = ExamSession.start(exam, mode, _now());
    _changed();
  }

  void answer(int choice) {
    session!.answer(choice, _now());
    _changed();
  }

  void goTo(int index) {
    session!.expireIfNeeded(_now());
    session!.goTo(index);
    _changed();
  }

  void toggleFlag() {
    session!.toggleFlag(_now());
    _changed();
  }

  void pause() {
    session!.pause(_now());
    _changed();
  }

  void resume() {
    session!.resume(_now());
    _changed();
  }

  void finish() {
    session!.finish(_now());
    _changed();
  }

  void updateProfile(StudyProfile next) {
    profile = next;
    _changed();
  }

  void _changed() {
    persist();
    notifyListeners();
  }

  /// Serialize writes so an older snapshot cannot overwrite a newer answer.
  Future<void> persist() {
    if ((session?.completed ?? false) && !_sessionRecorded) {
      _history.add(StudyResult.fromSession(session!, _now()));
      _sessionRecorded = true;
    }
    if (store == null) return Future.value();
    final snapshot = {
      'version': 2,
      'history': _history.map((result) => result.toJson()).toList(),
      'sessionRecorded': _sessionRecorded,
      'profile': profile.toJson(),
      'session': session?.toJson(),
    };
    // Copy mutable answer/flag lists at capture time, before queuing the write.
    final attempt = snapshot['session'] as Map<String, dynamic>?;
    if (attempt != null) {
      attempt['answers'] = session!.answers;
      attempt['flags'] = session!.flags;
    }
    _pendingSave = _pendingSave.then((_) => store!.write(snapshot)).catchError((
      Object error,
    ) {
      storageWarning =
          'Não foi possível salvar. Mantenha o aplicativo aberto para continuar.';
      if (!_disposed) notifyListeners();
    });
    return _pendingSave;
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
