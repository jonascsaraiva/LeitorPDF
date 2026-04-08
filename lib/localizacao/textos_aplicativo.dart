import 'package:flutter/material.dart';

import '../modelos/configuracoes_tema_aplicativo.dart';
import '../temas/paleta_aplicativo.dart';

class TextosAplicativo {
  const TextosAplicativo._(this.idiomaAtual);

  final IdiomaAplicativo idiomaAtual;

  static const LocalizationsDelegate<TextosAplicativo> delegate =
      _TextosAplicativoDelegate();

  static TextosAplicativo of(BuildContext context) {
    return Localizations.of<TextosAplicativo>(context, TextosAplicativo) ??
        const TextosAplicativo._(IdiomaAplicativo.portugues);
  }

  static const List<Locale> localesSuportados = <Locale>[
    Locale('pt'),
    Locale('en'),
    Locale('es'),
  ];

  String _porIdioma({
    required String portugues,
    required String ingles,
    required String espanhol,
  }) {
    switch (idiomaAtual) {
      case IdiomaAplicativo.ingles:
        return ingles;
      case IdiomaAplicativo.espanhol:
        return espanhol;
      case IdiomaAplicativo.portugues:
        return portugues;
    }
  }

  String get tituloAplicativo => _porIdioma(
    portugues: 'Leitor PDF',
    ingles: 'PDF Reader',
    espanhol: 'Lector PDF',
  );

  String get idioma =>
      _porIdioma(portugues: 'Idioma', ingles: 'Language', espanhol: 'Idioma');

  String get inicio =>
      _porIdioma(portugues: 'Inicio', ingles: 'Home', espanhol: 'Inicio');

  String get historico => _porIdioma(
    portugues: 'Historico',
    ingles: 'History',
    espanhol: 'Historial',
  );

  String get favoritos => _porIdioma(
    portugues: 'Favoritos',
    ingles: 'Favorites',
    espanhol: 'Favoritos',
  );

  String get configuracoes => _porIdioma(
    portugues: 'Configuracoes',
    ingles: 'Settings',
    espanhol: 'Configuracion',
  );

  String get bibliotecaVazia => _porIdioma(
    portugues: 'Seu historico ainda esta vazio. Importe um PDF para comecar.',
    ingles: 'Your history is still empty. Import a PDF to get started.',
    espanhol: 'Tu historial aun esta vacio. Importa un PDF para comenzar.',
  );

  String get importarPdf => _porIdioma(
    portugues: 'Importar PDF',
    ingles: 'Import PDF',
    espanhol: 'Importar PDF',
  );

  String get favoritosVazio => _porIdioma(
    portugues: 'Voce ainda nao adicionou nenhum PDF aos favoritos.',
    ingles: 'You have not added any PDFs to favorites yet.',
    espanhol: 'Todavia no agregaste ningun PDF a favoritos.',
  );

  String get verDetalhes => _porIdioma(
    portugues: 'Ver detalhes',
    ingles: 'View details',
    espanhol: 'Ver detalles',
  );

  String get removerDosFavoritos => _porIdioma(
    portugues: 'Remover dos favoritos',
    ingles: 'Remove from favorites',
    espanhol: 'Quitar de favoritos',
  );

  String get adicionarAosFavoritos => _porIdioma(
    portugues: 'Adicionar aos favoritos',
    ingles: 'Add to favorites',
    espanhol: 'Agregar a favoritos',
  );

  String get detalhesArquivo => _porIdioma(
    portugues: 'Detalhes do arquivo',
    ingles: 'File details',
    espanhol: 'Detalles del archivo',
  );

  String get nome =>
      _porIdioma(portugues: 'Nome', ingles: 'Name', espanhol: 'Nombre');

  String get caminho =>
      _porIdioma(portugues: 'Caminho', ingles: 'Path', espanhol: 'Ruta');

  String get tamanho =>
      _porIdioma(portugues: 'Tamanho', ingles: 'Size', espanhol: 'Tamano');

  String get dataImportacao => _porIdioma(
    portugues: 'Data de importacao',
    ingles: 'Import date',
    espanhol: 'Fecha de importacion',
  );

  String get ultimoAcesso => _porIdioma(
    portugues: 'Ultimo acesso',
    ingles: 'Last access',
    espanhol: 'Ultimo acceso',
  );

  String get arquivoExiste => _porIdioma(
    portugues: 'Arquivo existe',
    ingles: 'File exists',
    espanhol: 'El archivo existe',
  );

  String get sim => _porIdioma(portugues: 'Sim', ingles: 'Yes', espanhol: 'Si');

  String get nao => _porIdioma(portugues: 'Nao', ingles: 'No', espanhol: 'No');

  String get personalizarAplicativo => _porIdioma(
    portugues: 'Personalize o aplicativo',
    ingles: 'Customize the app',
    espanhol: 'Personaliza la aplicacion',
  );

  String get descricaoConfiguracoes => _porIdioma(
    portugues:
        'Escolha o modo de aparencia e a paleta que melhor combina com o seu leitor.',
    ingles:
        'Choose the appearance mode and color palette that best matches your reader.',
    espanhol:
        'Elige el modo de apariencia y la paleta de colores que mejor combine con tu lector.',
  );

  String get modoDoApp => _porIdioma(
    portugues: 'Modo do app',
    ingles: 'App mode',
    espanhol: 'Modo de la app',
  );

  String get descricaoModoApp => _porIdioma(
    portugues:
        'Voce pode usar claro, escuro ou deixar o aplicativo seguir o sistema.',
    ingles: 'You can use light, dark, or let the app follow the system.',
    espanhol:
        'Puedes usar claro, oscuro o dejar que la aplicacion siga el sistema.',
  );

  String get leitura =>
      _porIdioma(portugues: 'Leitura', ingles: 'Reading', espanhol: 'Lectura');

  String get descricaoLeitura => _porIdioma(
    portugues:
        'Defina a direcao de rolagem que o leitor de PDF vai usar por padrao.',
    ingles: 'Set the default scroll direction used by the PDF reader.',
    espanhol:
        'Define la direccion de desplazamiento predeterminada del lector de PDF.',
  );

  String get descricaoIdioma => _porIdioma(
    portugues:
        'Preferencia salva para futuras traducoes da interface do aplicativo.',
    ingles: 'Saved preference for future translations in the app interface.',
    espanhol: 'Preferencia guardada para futuras traducciones de la interfaz.',
  );

  String get idiomaPreferido => _porIdioma(
    portugues: 'Idioma preferido',
    ingles: 'Preferred language',
    espanhol: 'Idioma preferido',
  );

  String get paletaDeCores => _porIdioma(
    portugues: 'Paleta de cores',
    ingles: 'Color palette',
    espanhol: 'Paleta de colores',
  );

  String get descricaoPaleta => _porIdioma(
    portugues:
        'As paletas mudam o visual geral do aplicativo e o destaque da interface.',
    ingles: 'Palettes change the overall look and highlights of the app.',
    espanhol:
        'Las paletas cambian la apariencia general y el destaque de la interfaz.',
  );

  String get claro =>
      _porIdioma(portugues: 'Claro', ingles: 'Light', espanhol: 'Claro');

  String get escuro =>
      _porIdioma(portugues: 'Escuro', ingles: 'Dark', espanhol: 'Oscuro');

  String get sistema =>
      _porIdioma(portugues: 'Sistema', ingles: 'System', espanhol: 'Sistema');

  String get vertical => _porIdioma(
    portugues: 'Vertical',
    ingles: 'Vertical',
    espanhol: 'Vertical',
  );

  String get horizontal => _porIdioma(
    portugues: 'Horizontal',
    ingles: 'Horizontal',
    espanhol: 'Horizontal',
  );

  String get importarArquivo => _porIdioma(
    portugues: 'Importar arquivo',
    ingles: 'Import file',
    espanhol: 'Importar archivo',
  );

  String get descricaoImportarArquivo => _porIdioma(
    portugues: 'Escolha um PDF do celular para abrir e salvar no historico.',
    ingles: 'Choose a PDF from your phone to open and save to history.',
    espanhol: 'Elige un PDF del celular para abrir y guardar en el historial.',
  );

  String get abrir =>
      _porIdioma(portugues: 'Abrir', ingles: 'Open', espanhol: 'Abrir');

  String get recentes => _porIdioma(
    portugues: 'Recentes',
    ingles: 'Recent',
    espanhol: 'Recientes',
  );

  String get descricaoRecentesVazio => _porIdioma(
    portugues: 'Os ultimos 5 PDFs abertos ou importados vao aparecer aqui.',
    ingles: 'The last 5 opened or imported PDFs will appear here.',
    espanhol: 'Los ultimos 5 PDFs abiertos o importados apareceran aqui.',
  );

  String get nenhumPdfAberto => _porIdioma(
    portugues: 'Nenhum PDF aberto por enquanto',
    ingles: 'No PDF opened yet',
    espanhol: 'Ningun PDF abierto por ahora',
  );

  String get descricaoNenhumPdfAberto => _porIdioma(
    portugues:
        'Toque em "Escolher arquivo PDF" para selecionar um documento armazenado no celular.',
    ingles: 'Tap "Choose PDF file" to select a document stored on your phone.',
    espanhol:
        'Toca "Elegir archivo PDF" para seleccionar un documento guardado en el celular.',
  );

  String get escolherArquivoPdf => _porIdioma(
    portugues: 'Escolher arquivo PDF',
    ingles: 'Choose PDF file',
    espanhol: 'Elegir archivo PDF',
  );

  String get buscandoPdf => _porIdioma(
    portugues: 'Buscando PDF...',
    ingles: 'Searching PDF...',
    espanhol: 'Buscando PDF...',
  );

  String get paletaAtivaPrefixo => _porIdioma(
    portugues: 'Paleta ativa:',
    ingles: 'Active palette:',
    espanhol: 'Paleta activa:',
  );

  String get telaVisualizadorCarregando => _porIdioma(
    portugues: 'Carregando documento...',
    ingles: 'Loading document...',
    espanhol: 'Cargando documento...',
  );

  String paginaDe(int atual, int total) => _porIdioma(
    portugues: 'Pagina $atual de $total',
    ingles: 'Page $atual of $total',
    espanhol: 'Pagina $atual de $total',
  );

  String get irParaPagina => _porIdioma(
    portugues: 'Ir para pagina',
    ingles: 'Go to page',
    espanhol: 'Ir a la pagina',
  );

  String paginaFaixa(int total) => '1 - $total';

  String get ir => _porIdioma(portugues: 'Ir', ingles: 'Go', espanhol: 'Ir');

  String get anterior => _porIdioma(
    portugues: 'Anterior',
    ingles: 'Previous',
    espanhol: 'Anterior',
  );

  String get proxima =>
      _porIdioma(portugues: 'Proxima', ingles: 'Next', espanhol: 'Siguiente');

  String textoLeitorCompacto({
    required bool vertical,
    required bool temaEscuro,
  }) {
    return _porIdioma(
      portugues:
          'Zoom por gesto ativo. Role no sentido ${vertical ? 'vertical' : 'horizontal'}. Tema atual: ${temaEscuro ? 'escuro' : 'claro'}.',
      ingles:
          'Gesture zoom enabled. Scroll ${vertical ? 'vertically' : 'horizontally'}. Current theme: ${temaEscuro ? 'dark' : 'light'}.',
      espanhol:
          'Zoom por gesto activo. Desplazate en sentido ${vertical ? 'vertical' : 'horizontal'}. Tema actual: ${temaEscuro ? 'oscuro' : 'claro'}.',
    );
  }

  String paginaInvalida(int total) => _porIdioma(
    portugues: 'Digite uma pagina entre 1 e $total.',
    ingles: 'Enter a page between 1 and $total.',
    espanhol: 'Ingresa una pagina entre 1 y $total.',
  );

  String get documentoCarregando => _porIdioma(
    portugues: 'O documento ainda esta sendo carregado.',
    ingles: 'The document is still loading.',
    espanhol: 'El documento aun se esta cargando.',
  );

  String get detalhes => _porIdioma(
    portugues: 'Detalhes',
    ingles: 'Details',
    espanhol: 'Detalles',
  );

  String get arquivoSelecionado => _porIdioma(
    portugues: 'Arquivo selecionado',
    ingles: 'Selected file',
    espanhol: 'Archivo seleccionado',
  );

  String get nenhumPdfSelecionado => _porIdioma(
    portugues: 'Nenhum PDF selecionado ainda.',
    ingles: 'No PDF selected yet.',
    espanhol: 'Todavia no hay un PDF seleccionado.',
  );

  String get descricaoArquivoSelecionado => _porIdioma(
    portugues:
        'Quando voce escolher um arquivo, ele aparecera aqui para reabrir rapidamente.',
    ingles:
        'When you choose a file, it will appear here so you can reopen it quickly.',
    espanhol:
        'Cuando elijas un archivo, aparecera aqui para volver a abrirlo rapidamente.',
  );

  String get lerPdf => _porIdioma(
    portugues: 'Ler PDF',
    ingles: 'Read PDF',
    espanhol: 'Leer PDF',
  );

  String get erroCarregarBiblioteca => _porIdioma(
    portugues: 'Nao foi possivel carregar a biblioteca de PDFs.',
    ingles: 'Could not load the PDF library.',
    espanhol: 'No fue posible cargar la biblioteca de PDF.',
  );

  String get erroLocalizarArquivoSelecionado => _porIdioma(
    portugues: 'Nao foi possivel localizar o arquivo selecionado.',
    ingles: 'Could not locate the selected file.',
    espanhol: 'No fue posible localizar el archivo seleccionado.',
  );

  String get erroImportarPdf => _porIdioma(
    portugues: 'Ocorreu um erro ao importar o PDF.',
    ingles: 'An error occurred while importing the PDF.',
    espanhol: 'Ocurrio un error al importar el PDF.',
  );

  String traduzirMensagemErroBiblioteca(String mensagem) {
    switch (mensagem) {
      case 'Nao foi possivel carregar a biblioteca de PDFs.':
        return erroCarregarBiblioteca;
      case 'Nao foi possivel localizar o arquivo selecionado.':
        return erroLocalizarArquivoSelecionado;
      case 'Ocorreu um erro ao importar o PDF.':
        return erroImportarPdf;
      default:
        return mensagem;
    }
  }

  String tituloPaleta(PaletaAplicativo paleta) {
    switch (paleta) {
      case PaletaAplicativo.laranjaSolar:
        return _porIdioma(
          portugues: 'Laranja Solar',
          ingles: 'Solar Orange',
          espanhol: 'Naranja Solar',
        );
      case PaletaAplicativo.azulVivo:
        return _porIdioma(
          portugues: 'Azul Vivo',
          ingles: 'Bright Blue',
          espanhol: 'Azul Vivo',
        );
      case PaletaAplicativo.douradoCalmo:
        return _porIdioma(
          portugues: 'Dourado Calmo',
          ingles: 'Calm Gold',
          espanhol: 'Dorado Suave',
        );
      case PaletaAplicativo.rubiNoturno:
        return _porIdioma(
          portugues: 'Rubi Noturno',
          ingles: 'Night Ruby',
          espanhol: 'Rubi Nocturno',
        );
      case PaletaAplicativo.verdeFloresta:
        return _porIdioma(
          portugues: 'Verde Floresta',
          ingles: 'Forest Green',
          espanhol: 'Verde Bosque',
        );
    }
  }

  String idiomaRotulo(IdiomaAplicativo idioma) {
    switch (idioma) {
      case IdiomaAplicativo.portugues:
        return _porIdioma(
          portugues: 'Portugues',
          ingles: 'Portuguese',
          espanhol: 'Portugues',
        );
      case IdiomaAplicativo.ingles:
        return _porIdioma(
          portugues: 'Ingles',
          ingles: 'English',
          espanhol: 'Ingles',
        );
      case IdiomaAplicativo.espanhol:
        return _porIdioma(
          portugues: 'Espanhol',
          ingles: 'Spanish',
          espanhol: 'Espanol',
        );
    }
  }

  String formatarTamanho(int tamanhoBytes) {
    if (tamanhoBytes < 1024) {
      return '$tamanhoBytes B';
    }
    if (tamanhoBytes < 1024 * 1024) {
      return '${(tamanhoBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(tamanhoBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

class _TextosAplicativoDelegate
    extends LocalizationsDelegate<TextosAplicativo> {
  const _TextosAplicativoDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['pt', 'en', 'es'].contains(locale.languageCode);

  @override
  Future<TextosAplicativo> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return const TextosAplicativo._(IdiomaAplicativo.ingles);
      case 'es':
        return const TextosAplicativo._(IdiomaAplicativo.espanhol);
      case 'pt':
      default:
        return const TextosAplicativo._(IdiomaAplicativo.portugues);
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<TextosAplicativo> old) =>
      false;
}

extension ExtensaoTextosAplicativo on BuildContext {
  TextosAplicativo get textos => TextosAplicativo.of(this);
}
