import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/study_profile.dart';

const paper = Color(0xfffbf8ee);
const ink = Color(0xff211936);
const lavender = Color(0xffdfd3fb);
const lime = Color(0xffe5f884);
const panelColor = Color(0xfffffdf7);
const correctColor = Color(0xffe7f3d6);
const incorrectColor = Color(0xfffce8e3);

ThemeData studyTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: paper,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ink,
    surface: panelColor,
  ).copyWith(primary: ink, onPrimary: Colors.white, secondary: lavender),
  appBarTheme: const AppBarTheme(
    backgroundColor: panelColor,
    foregroundColor: ink,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: lime,
      foregroundColor: ink,
      minimumSize: const Size(48, 48),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ink),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(48, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

String formatTime(Duration duration) {
  final seconds = (duration.inMilliseconds / 1000).ceil().clamp(0, 3600);
  return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.child,
    this.onBack,
    this.actions = const [],
  });
  final Widget child;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: onBack == null
          ? null
          : IconButton(
              tooltip: 'Voltar',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
            ),
      title: const Text(
        '✦ Foco de Teste',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      actions: [
        ...actions,
        IconButton(
          tooltip: 'Material oficial',
          icon: const Icon(Icons.open_in_new),
          onPressed: () => showOfficialMaterials(context),
        ),
      ],
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1160),
          child: child,
        ),
      ),
    ),
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 16 : 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.color = panelColor});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: ink),
      borderRadius: BorderRadius.circular(24),
    ),
    child: child,
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, {super.key, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: MediaQuery.sizeOf(context).width < 600 ? 32 : 44,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -1.2,
          ),
        ),
        if (subtitle != null) ...[const SizedBox(height: 12), Text(subtitle!)],
      ],
    ),
  );
}

class ResponsivePair extends StatelessWidget {
  const ResponsivePair({
    super.key,
    required this.first,
    required this.second,
    this.firstFlex = 1,
  });
  final Widget first;
  final Widget second;
  final int firstFlex;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 760) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [first, const SizedBox(height: 16), second],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: firstFlex, child: first),
          const SizedBox(width: 16),
          Expanded(child: second),
        ],
      );
    },
  );
}

class StudyAvatar extends StatelessWidget {
  const StudyAvatar({super.key, required this.svg, required this.profile});
  final String svg;
  final StudyProfile profile;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Color(int.parse('ff${profile.background}', radix: 16)),
      borderRadius: BorderRadius.circular(24),
    ),
    padding: const EdgeInsets.all(16),
    child: SvgPicture.string(
      svg
          .replaceAll('#7549c9', '#${profile.hair}')
          .replaceAll('#dfd3fb', '#${profile.background}'),
      height: 300,
      semanticsLabel: 'Seu palhacinho estudando em uma mesa',
    ),
  );
}

Future<void> showOfficialMaterials(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Material oficial CTFL'),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Você será redirecionado para o site oficial do BSTQB. Lá você pode baixar o syllabus, as provas de exemplo e os gabaritos.',
            ),
            SizedBox(height: 16),
            SelectableText('https://bstqb.online/ctfl'),
            SizedBox(height: 12),
            Text('O acesso ao site requer conexão com a internet.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Voltar'),
        ),
        FilledButton(
          onPressed: () async {
            // Launch directly from the gesture to preserve browser popup activation.
            try {
              final opened = await launchUrl(
                Uri.parse('https://bstqb.online/ctfl'),
                mode: LaunchMode.externalApplication,
                webOnlyWindowName: '_blank',
              );
              if (!opened) throw StateError('Navegador indisponível');
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            } on Object {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Não foi possível abrir o site. Copie o endereço e tente no navegador.',
                    ),
                  ),
                );
              }
            }
          },
          child: const Text('Abrir BSTQB'),
        ),
      ],
    ),
  );
}
