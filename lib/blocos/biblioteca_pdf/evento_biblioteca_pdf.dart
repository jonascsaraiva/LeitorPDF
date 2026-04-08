part of 'bloc_biblioteca_pdf.dart';

sealed class EventoBibliotecaPdf {
  const EventoBibliotecaPdf();
}

class BibliotecaPdfIniciada extends EventoBibliotecaPdf {
  const BibliotecaPdfIniciada();
}

class ImportacaoPdfSolicitada extends EventoBibliotecaPdf {
  const ImportacaoPdfSolicitada();
}

class DocumentoFavoritoAlternado extends EventoBibliotecaPdf {
  const DocumentoFavoritoAlternado(this.documento);

  final DocumentoPdf documento;
}

class DocumentoAcessado extends EventoBibliotecaPdf {
  const DocumentoAcessado(this.documento);

  final DocumentoPdf documento;
}
