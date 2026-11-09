import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_controller.dart';
import 'data/study_store.dart';
import 'domain/question.dart';
import 'ui/components.dart';
import 'ui/setup_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final json =
        jsonDecode(await rootBundle.loadString('assets/exams.json')) as List;
    final exams = json
        .map((e) => PracticeExam.fromJson(e as Map<String, dynamic>))
        .toList();
    final svg = await rootBundle.loadString('assets/study_buddy.svg');
    StudyStore? store;
    try {
      store = StudyStore(await SharedPreferences.getInstance());
    } on Object {
      store = null;
    }
    final controller = AppController(exams: exams, avatarSvg: svg, store: store)
      ..restore();
    runApp(StudyApp(controller: controller));
  } on Object {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Não foi possível carregar os treinos. Feche e abra o aplicativo para tentar novamente.',
            ),
          ),
        ),
      ),
    );
  }
}

class StudyApp extends StatefulWidget {
  const StudyApp({super.key, required this.controller});
  final AppController controller;
  @override
  State<StudyApp> createState() => _StudyAppState();
}

class _StudyAppState extends State<StudyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.startClock();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.controller.refresh();
    widget.controller.persist();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Foco de Teste',
    debugShowCheckedModeBanner: false,
    theme: studyTheme(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: HomeScreen(controller: widget.controller),
  );
}
