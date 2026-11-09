# Foco de Teste

Aplicativo Flutter para estudos da CTFL Foundation 4.0. Interface responsiva para web, Android e iOS/iPadOS, derivada do protótipo HTML.

## Executar

Use Flutter 3.47.9 ou superior.

```bash
cd apps/foco_de_teste
flutter pub get
flutter run -d chrome
```

Para dispositivos Android conectados ou emuladores, execute `flutter devices` e `flutter run -d ID_DO_DISPOSITIVO`. Para iOS e iPadOS, use macOS com Xcode configurado.

## Validar

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
flutter build apk --debug
```

## Organização

- `lib/domain` contém questões, perfil e estado da tentativa em Dart. O cronômetro recebe o horário nas operações para permitir testes determinísticos.
- `lib/data` salva um snapshot versionado em SharedPreferences.
- `lib/app_controller.dart` coordena o ciclo de vida e serializa gravações para preservar a ordem das respostas.
- `lib/ui` contém telas e componentes responsivos.
- `assets/exams.json` mantém o conteúdo das questões separado da interface.
- `test` verifica correção, pausa, expiração e recuperação da tentativa.

A primeira resposta é definitiva após mostrar o gabarito. Café com leite permite pausar. Orgulho Bixo usa um prazo contínuo, inclusive ao fechar e reabrir o aplicativo. O perfil e a última tentativa ficam salvos localmente. A versão web mantém dados no navegador utilizado.

Wi-Fi, modo avião e notificações são configurados pelo usuário no dispositivo. O banco de questões faz parte do aplicativo. Abrir o BSTQB exige conexão. O aplicativo oferece o aviso de redirecionamento antes de abrir o site.

## Conteúdo

Os treinos A e B contêm quatro questões autorais cada, conforme o protótipo. A ficha oficial informa 40 questões, 60 minutos padrão e 26 pontos para aprovação. O resultado da demonstração usa a quantidade real de questões.

Fonte oficial de conteúdo e provas de exemplo — [BSTQB CTFL](https://bstqb.online/ctfl).

Documentação do framework — [Flutter web](https://docs.flutter.dev/platform-integration/web/building) e [configuração de iOS](https://docs.flutter.dev/platform-integration/ios/setup).

## Validação desta entrega

Flutter 3.47.9 e Dart 3.13.7. Análise estática sem problemas, cinco testes de domínio e dois testes de interface aprovados e build web release concluído. Builds Android e iOS dependem dos SDKs nativos e da assinatura da aplicação.
