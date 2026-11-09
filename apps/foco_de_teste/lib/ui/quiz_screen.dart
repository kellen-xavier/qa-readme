import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../domain/exam_session.dart';
import 'components.dart';

enum _LeaveChoice { stay, leave, pause }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.controller});
  final AppController controller;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _allowPop = false;
  bool _showReview = false;
  BuildContext? _dialogContext;
  final _scroll = ScrollController();
  AppController get controller => widget.controller;
  ExamSession get attempt => controller.session!;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (attempt.completed && _dialogContext != null) {
      final dialog = _dialogContext!;
      _dialogContext = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (dialog.mounted) Navigator.pop(dialog);
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onChanged);
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _leave() async {
    if (_dialogContext != null) return;
    controller.refresh();
    if (attempt.completed) {
      _pop();
      return;
    }
    final choice = await showDialog<_LeaveChoice>(
      context: context,
      builder: (dialogContext) {
        _dialogContext = dialogContext;
        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) => AlertDialog(
            title: const Text('Sair do simulado?'),
            content: Text(
              '${attempt.answeredCount} de ${attempt.exam.questions.length} questões respondidas. '
              'Restam ${formatTime(controller.remaining)}. '
              '${attempt.paused ? 'O cronômetro está pausado.' : 'O tempo continuará correndo se você sair.'} '
              'Você pode retomar pela mesa de estudos.',
            ),
            actions: [
              FilledButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, _LeaveChoice.stay),
                child: const Text('Continuar simulado'),
              ),
              if (attempt.mode.canPause && !attempt.paused)
                OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, _LeaveChoice.pause),
                  child: const Text('Pausar e sair'),
                ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, _LeaveChoice.leave),
                child: const Text('Sair da tela'),
              ),
            ],
          ),
        );
      },
    );
    _dialogContext = null;
    if (!mounted || choice == null || choice == _LeaveChoice.stay) return;
    if (choice == _LeaveChoice.pause) controller.pause();
    await controller.persist();
    if (mounted && !attempt.completed) _pop();
  }

  void _pop() {
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<void> _submit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        _dialogContext = dialogContext;
        return AlertDialog(
          title: const Text('Entregar o simulado?'),
          content: Text(
            '${attempt.answeredCount} de ${attempt.exam.questions.length} questões respondidas. '
            'Depois de entregar, você poderá revisar as respostas.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Voltar às questões'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Confirmar entrega'),
            ),
          ],
        );
      },
    );
    _dialogContext = null;
    if (mounted && confirmed == true) controller.finish();
  }

  void _goTo(int index) {
    controller.goTo(index);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Widget _timer() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ink,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Wrap(
      spacing: 20,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'CTFL Foundation 4.0 · ${attempt.exam.title}\n${attempt.mode.label}',
          style: const TextStyle(color: Colors.white),
        ),
        Semantics(
          label: 'Tempo restante',
          child: Text(
            formatTime(controller.remaining),
            style: const TextStyle(
              color: lime,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        if (attempt.mode.canPause && !attempt.paused)
          FilledButton(
            onPressed: controller.pause,
            child: const Text('Pausar'),
          ),
      ],
    ),
  );

  Widget _question() {
    final question = attempt.exam.questions[attempt.index];
    final answer = attempt.answers[attempt.index];
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'QUESTÃO ${attempt.index + 1} DE ${attempt.exam.questions.length}',
          ),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(
              question.prompt,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ao escolher uma alternativa, sua resposta será registrada.',
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < question.options.length; i++) ...[
            Builder(
              builder: (context) {
                final correct = answer != null && i == question.correctIndex;
                final chosen = answer == i;
                final annotation = correct
                    ? 'Resposta correta'
                    : chosen
                    ? 'Sua resposta'
                    : null;
                return OutlinedButton(
                  onPressed: answer == null ? () => controller.answer(i) : null,
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor: correct
                        ? correctColor
                        : chosen
                        ? incorrectColor
                        : Colors.white,
                    disabledForegroundColor: ink,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${String.fromCharCode(65 + i)}  ${question.options[i]}',
                      ),
                      if (annotation != null)
                        Text(
                          annotation,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
          if (answer != null) ...[
            Semantics(
              liveRegion: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: answer == question.correctIndex
                      ? correctColor
                      : incorrectColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer == question.correctIndex
                          ? '✓ Resposta correta'
                          : '✕ Resposta incorreta',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(question.explanation),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton(
                onPressed: attempt.index == 0
                    ? null
                    : () => _goTo(attempt.index - 1),
                child: const Text('Anterior'),
              ),
              OutlinedButton.icon(
                onPressed: controller.toggleFlag,
                icon: Icon(
                  attempt.flags[attempt.index]
                      ? Icons.flag
                      : Icons.outlined_flag,
                ),
                label: Text(
                  attempt.flags[attempt.index]
                      ? 'Desmarcar revisão'
                      : 'Marcar para revisão',
                ),
              ),
              if (attempt.index + 1 < attempt.exam.questions.length)
                FilledButton(
                  onPressed: () => _goTo(attempt.index + 1),
                  child: const Text('Próxima'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _map() => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Mapa de questões',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          '${attempt.answeredCount} de ${attempt.exam.questions.length} respondidas',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < attempt.exam.questions.length; i++)
              Semantics(
                selected: i == attempt.index,
                label:
                    'Questão ${i + 1}, ${attempt.answers[i] == null ? 'em branco' : 'respondida'}'
                    '${attempt.flags[i] ? ', marcada para revisão' : ''}',
                child: OutlinedButton(
                  onPressed: () => _goTo(i),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: attempt.flags[i]
                        ? lavender
                        : attempt.answers[i] != null
                        ? lime
                        : panelColor,
                    side: BorderSide(
                      color: ink,
                      width: i == attempt.index ? 2.5 : 1,
                    ),
                  ),
                  child: Text('${i + 1}${attempt.flags[i] ? ' ⚑' : ''}'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: _submit,
          child: const Text('Entregar simulado'),
        ),
      ],
    ),
  );

  Widget _result() => PageBody(
    children: [
      PageHeading(
        _showReview ? 'Revise suas respostas.' : 'Seu resultado.',
        subtitle: attempt.expired ? 'Tempo encerrado' : 'Tentativa entregue',
      ),
      if (!_showReview)
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${attempt.score} / ${attempt.exam.questions.length}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${attempt.mode.label} · Tempo usado ${formatTime(attempt.used)}',
              ),
              const SizedBox(height: 12),
              Text(
                '${attempt.answeredCount} respondidas · ${attempt.exam.questions.length - attempt.answeredCount} em branco',
              ),
              const SizedBox(height: 12),
              const Text(
                'Resultado da amostra de estudo. O corte oficial da CTFL é 26 de 40 pontos.',
              ),
            ],
          ),
        ),
      if (_showReview)
        for (var i = 0; i < attempt.exam.questions.length; i++)
          Card(
            child: ExpansionTile(
              initiallyExpanded: i == 0,
              title: Text(
                'Questão ${i + 1} · ${attempt.answers[i] == null
                    ? 'Em branco'
                    : attempt.answers[i] == attempt.exam.questions[i].correctIndex
                    ? 'Correta'
                    : 'Incorreta'}',
              ),
              subtitle: Text(attempt.exam.questions[i].topic),
              childrenPadding: const EdgeInsets.all(20),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(attempt.exam.questions[i].prompt),
                const SizedBox(height: 12),
                Text(
                  'Sua resposta: ${attempt.answers[i] == null ? 'Em branco' : attempt.exam.questions[i].options[attempt.answers[i]!]}',
                ),
                const SizedBox(height: 12),
                Text(
                  'Resposta esperada: ${attempt.exam.questions[i].options[attempt.exam.questions[i].correctIndex]}',
                ),
                const SizedBox(height: 12),
                Text(attempt.exam.questions[i].explanation),
              ],
            ),
          ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FilledButton(
            onPressed: () => setState(() => _showReview = !_showReview),
            child: Text(_showReview ? 'Ver resultado' : 'Revisar respostas'),
          ),
          OutlinedButton(
            onPressed: _pop,
            child: const Text('Voltar à mesa de estudos'),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => PopScope(
      canPop: _allowPop || attempt.completed,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _leave();
      },
      child: PageFrame(
        onBack: _leave,
        child: attempt.completed
            ? _result()
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _timer(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scroll,
                        child: attempt.paused
                            ? Panel(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Simulado pausado',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'O tempo restante e suas respostas foram preservados.',
                                    ),
                                    const SizedBox(height: 20),
                                    FilledButton(
                                      onPressed: controller.resume,
                                      child: const Text('Retomar cronômetro'),
                                    ),
                                  ],
                                ),
                              )
                            : ResponsivePair(
                                first: _question(),
                                second: _map(),
                                firstFlex: 2,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    ),
  );
}
