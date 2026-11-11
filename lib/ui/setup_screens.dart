import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../domain/exam_session.dart';
import '../domain/question.dart';
import '../domain/study_profile.dart';
import 'components.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => PageFrame(
      actions: [
        IconButton(
          tooltip: 'Meu setup',
          icon: const Icon(Icons.person_outline),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => ProfileScreen(controller: controller),
            ),
          ),
        ),
      ],
      child: PageBody(
        children: [
          if (controller.storageWarning != null) ...[
            Text(
              controller.storageWarning!,
              style: const TextStyle(color: Color(0xff8b3426)),
            ),
            const SizedBox(height: 16),
          ],
          ResponsivePair(
            first: Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LABORATÓRIO DE ESTUDOS'),
                  const SizedBox(height: 20),
                  PageHeading(
                    controller.profile.name.isEmpty
                        ? 'Sua mesa de estudos.'
                        : 'Olá, ${controller.profile.name}.',
                  ),
                  const Text(
                    'Monte seu palhacinho e pratique para a certificação de testes de software.',
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => controller.hasActiveSession
                                ? QuizScreen(controller: controller)
                                : ExamListScreen(controller: controller),
                          ),
                        ),
                        child: Text(
                          controller.hasActiveSession
                              ? 'Retomar simulado'
                              : 'Focar',
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ProgressScreen(controller: controller),
                          ),
                        ),
                        child: const Text('Meu progresso'),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ProfileScreen(controller: controller),
                          ),
                        ),
                        child: const Text('Editar meu setup'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            second: StudyAvatar(
              svg: controller.avatarSvg,
              profile: controller.profile,
            ),
          ),
          const SizedBox(height: 20),
          const Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CTFL Foundation 4.0',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('40 questões · 60 min · Corte oficial de 26 pontos'),
                SizedBox(height: 8),
                Text(
                  'Os treinos A e B desta demonstração possuem quatro questões autorais cada.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sem conta: seu perfil, suas respostas e seu histórico ficam neste dispositivo. '
            'Limpar os dados do app ou do site apaga o progresso. '
            'No modo privado, os dados podem ser apagados ao fechar o navegador.',
          ),
          if (controller.session?.completed ?? false) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => QuizScreen(controller: controller),
                ),
              ),
              child: const Text('Ver último resultado'),
            ),
          ],
        ],
      ),
    ),
  );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.controller});
  final AppController controller;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _name;
  late String _hair;
  late String _background;

  @override
  void initState() {
    super.initState();
    final profile = widget.controller.profile;
    _name = TextEditingController(text: profile.name);
    _hair = profile.hair;
    _background = profile.background;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    child: PageBody(
      children: [
        const PageHeading('Monte seu setup.'),
        ResponsivePair(
          first: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _name,
                  maxLength: 24,
                  decoration: const InputDecoration(
                    labelText: 'Nome ou apelido',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _hair,
                  decoration: const InputDecoration(labelText: 'Cabelo'),
                  items: StudyProfile.hairColors.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _hair = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _background,
                  decoration: const InputDecoration(labelText: 'Fundo da mesa'),
                  items: StudyProfile.backgrounds.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _background = value!),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    widget.controller.updateProfile(
                      StudyProfile(
                        name: _name.text.trim(),
                        hair: _hair,
                        background: _background,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar setup'),
                ),
              ],
            ),
          ),
          second: StudyAvatar(
            svg: widget.controller.avatarSvg,
            profile: StudyProfile(hair: _hair, background: _background),
          ),
        ),
      ],
    ),
  );
}

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => PageFrame(
    child: PageBody(
      children: [
        const PageHeading(
          'Escolha um simulado.',
          subtitle: 'CTFL Foundation 4.0 · Questões autorais de demonstração',
        ),
        for (final exam in controller.exams) ...[
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(exam.description),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          ModeScreen(controller: controller, exam: exam),
                    ),
                  ),
                  child: Text('Selecionar ${exam.title}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    ),
  );
}

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key, required this.controller, required this.exam});
  final AppController controller;
  final PracticeExam exam;

  Widget _modeCard(BuildContext context, FocusMode mode) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(mode.canPause ? Icons.wifi : Icons.airplanemode_active, size: 36),
        const SizedBox(height: 12),
        Text(mode.label, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(mode.instructions),
        const SizedBox(height: 12),
        Text(mode.canPause ? 'Pausa disponível' : 'Tempo contínuo, sem pausa'),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) =>
                  ReadyScreen(controller: controller, exam: exam, mode: mode),
            ),
          ),
          child: Text('Escolher ${mode.label}'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => PageFrame(
    child: PageBody(
      children: [
        PageHeading(
          'Como quer focar?',
          subtitle: 'CTFL Foundation 4.0 · ${exam.title}',
        ),
        ResponsivePair(
          first: _modeCard(context, FocusMode.cafe),
          second: _modeCard(context, FocusMode.orgulho),
        ),
        const SizedBox(height: 20),
        const Text(
          'Configure a conexão e as notificações no próprio dispositivo.',
        ),
      ],
    ),
  );
}

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({
    super.key,
    required this.controller,
    required this.exam,
    required this.mode,
  });
  final AppController controller;
  final PracticeExam exam;
  final FocusMode mode;

  @override
  Widget build(BuildContext context) => PageFrame(
    child: PageBody(
      children: [
        const PageHeading('Prepare o cronômetro.'),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CTFL Foundation 4.0 · ${exam.title}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(mode.label),
              const SizedBox(height: 16),
              const Text(
                '60:00',
                style: TextStyle(fontSize: 64, fontWeight: FontWeight.w800),
              ),
              Text(mode.instructions),
              const SizedBox(height: 12),
              Text(
                '${exam.questions.length} questões autorais nesta demonstração. O formato oficial tem 40.',
              ),
              const SizedBox(height: 12),
              const Text(
                'A primeira alternativa escolhida é registrada e corrigida na hora.',
              ),
              const SizedBox(height: 12),
              Text(
                mode.canPause
                    ? 'Você pode pausar e retomar o tempo.'
                    : 'O tempo continua correndo em segundo plano.',
              ),
              const SizedBox(height: 12),
              const Text('A tentativa é entregue automaticamente ao zerar.'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (!controller.hasActiveSession) {
                    controller.startExam(exam, mode);
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => QuizScreen(controller: controller),
                    ),
                    (route) => route.isFirst,
                  );
                },
                child: const Text('Iniciar simulado'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final history = controller.history;
      final correct = history.fold(0, (sum, result) => sum + result.score);
      final total = history.fold(0, (sum, result) => sum + result.total);
      return PageFrame(
        child: PageBody(
          children: [
            const PageHeading(
              'Meu progresso',
              subtitle:
                  'Seu estudo fica salvo neste dispositivo, sem criar conta.',
            ),
            if (controller.storageWarning != null)
              Text(controller.storageWarning!),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.length == 1
                        ? '1 treino concluído'
                        : '${history.length} treinos concluídos',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    total == 0
                        ? 'Conclua um simulado para acompanhar seus resultados aqui.'
                        : '$correct de $total questões corretas · '
                              '${(correct * 100 / total).round()}% de aproveitamento',
                  ),
                  if (controller.hasActiveSession) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Em andamento: ${controller.session!.exam.title} · '
                      '${controller.session!.answeredCount} de '
                      '${controller.session!.exam.questions.length} questões respondidas',
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => QuizScreen(controller: controller),
                        ),
                      ),
                      child: const Text('Retomar simulado'),
                    ),
                  ],
                ],
              ),
            ),
            for (final result in history.reversed) ...[
              const SizedBox(height: 16),
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.examTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${MaterialLocalizations.of(context).formatShortDate(result.finishedAt.toLocal())} · '
                      '${result.mode.label}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${result.score} de ${result.total} acertos · '
                      '${(result.score * 100 / result.total).round()}%',
                    ),
                    Text(
                      '${result.answered} ${result.answered == 1 ? 'questão respondida' : 'questões respondidas'} · '
                      '${formatTime(Duration(seconds: result.usedSeconds))} de estudo',
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Os dados não são enviados para uma conta e não são sincronizados entre dispositivos. '
              'Use o mesmo navegador e endereço do app para continuar seu estudo.',
            ),
          ],
        ),
      );
    },
  );
}
