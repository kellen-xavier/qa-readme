import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foco_de_teste/app_controller.dart';
import 'package:foco_de_teste/domain/question.dart';
import 'package:foco_de_teste/main.dart';

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets('study flow renders at width $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = (await tester.runAsync(() async {
        final data =
            jsonDecode(await rootBundle.loadString('assets/exams.json'))
                as List;
        return AppController(
          exams: data
              .map((e) => PracticeExam.fromJson(e as Map<String, dynamic>))
              .toList(),
          avatarSvg: await rootBundle.loadString('assets/study_buddy.svg'),
        );
      }))!;
      await tester.pumpWidget(StudyApp(controller: controller));
      await tester.pumpAndSettle();
      Future<void> tap(String text) async {
        final target = find.text(text);
        await tester.ensureVisible(target);
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      await tap('Focar');
      await tap('Selecionar Treino A');
      await tap('Escolher Café com leite');
      await tap('Iniciar simulado');
      await tap('A  Encontrar ambiguidades cedo');
      expect(find.text('✓ Resposta correta'), findsOneWidget);
      await tap('Pausar');
      expect(find.text('Simulado pausado'), findsOneWidget);
      await tap('Retomar cronômetro');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
