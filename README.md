# Leitor PDF

<p align="center">
  <img src="./assets/logo.png" alt="Logo do Leitor PDF" width="140" />
</p>

<p align="center">
  <strong>Leitor de PDF sem propaganda, sem enrolação e com foco total na leitura.</strong>
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white">
  <img alt="Android" src="https://img.shields.io/badge/Android-APK%20ready-3DDC84?style=for-the-badge&logo=android&logoColor=white">
  <img alt="BLoC" src="https://img.shields.io/badge/Estado-BLoC-F57C00?style=for-the-badge">
  <img alt="SharedPreferences" src="https://img.shields.io/badge/Dados-SharedPreferences-5E35B1?style=for-the-badge">
</p>

<p align="center">
  <img alt="Sem anúncios" src="https://img.shields.io/badge/Sem%20an%C3%BAncios-0F9D58?style=flat-square">
  <img alt="Leitura focada" src="https://img.shields.io/badge/Modo%20foco-202124?style=flat-square">
  <img alt="Multilíngue" src="https://img.shields.io/badge/Idiomas-PT%20%7C%20EN%20%7C%20ES-1A73E8?style=flat-square">
</p>

---

## O motivo deste projeto

Eu fiz este app porque acho um absurdo precisar ver propaganda para abrir um PDF no celular.

Abrir um boleto, contrato, apostila, comprovante ou qualquer arquivo pessoal deveria ser uma tarefa banal. Em vez disso, muitos aplicativos transformam isso em:

- tela de anúncio
- banner piscando
- limitação artificial de função básica
- tentativa de empurrar assinatura
- interface poluída para algo simples

O **Leitor PDF** nasceu como resposta direta a isso:

> **se o arquivo é seu, abrir e ler deveria ser simples**

---

## O que o app faz

- Importa PDF direto do armazenamento do celular
- Mantém histórico persistido com `SharedPreferences`
- Salva favoritos localmente
- Exibe recentes na tela inicial com limite enxuto
- Mostra biblioteca/histórico completo
- Abre tela de detalhes do arquivo
- Permite navegar por páginas
- Permite ir para uma página específica
- Suporta zoom por gesto
- Suporta leitura vertical contínua
- Suporta leitura horizontal em modo apresentação, uma página por vez
- Tem modo foco com toque rápido para esconder controles
- Suporta tema claro, escuro e sistema
- Suporta paletas de cor personalizadas
- Suporta português, inglês e espanhol

---

## Experiência de leitura

O leitor foi pensado para priorizar conteúdo.

- No modo vertical, a leitura continua fluida
- No modo horizontal, o PDF entra em visualização isolada por página
- Um toque rápido ativa o modo foco e esconde os controles
- A navegação funciona por botões visuais e teclado quando disponível

Isso deixa o app com uma sensação mais próxima de um visualizador de apresentação do que de uma lista de páginas.

---

## Estrutura do projeto

```text
lib/
  blocos/
    biblioteca_pdf/
    tema_aplicativo/
  localizacao/
  modelos/
  paginas/
    biblioteca/
    configuracoes/
    detalhes_arquivo/
    favoritos/
    inicio/
    visualizador_pdf/
  temas/
  aplicativo.dart
  main.dart
```

### Organização

- `blocos`: estado global do app, tema e biblioteca
- `localizacao`: textos do aplicativo para PT, EN e ES
- `modelos`: dados persistidos e estruturas principais
- `paginas`: telas e widgets de interface
- `temas`: paletas e geração dos temas do aplicativo

---

## Tecnologias usadas

- Flutter
- Dart
- `flutter_bloc`
- `shared_preferences`
- `file_picker`
- `syncfusion_flutter_pdfviewer`
- `flutter_localizations`

---

## Como executar

```bash
flutter pub get
flutter run
```

Para validar localmente:

```bash
flutter analyze
flutter test
```

Para gerar APK:

```bash
flutter build apk --release
```

---

## Estado atual

O projeto está funcional para uso real como leitor de PDF no celular, com foco em simplicidade, leitura limpa e persistência local.

---

## Próximos passos possíveis

- lembrar última página lida por documento
- busca de texto no PDF
- compartilhamento de arquivos
- filtros no histórico
- ordenação por nome, data ou tamanho

---

## Licença

Este repositório pode ser adaptado conforme a necessidade do projeto.
