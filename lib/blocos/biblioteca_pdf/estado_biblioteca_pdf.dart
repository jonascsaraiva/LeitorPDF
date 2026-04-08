part of 'bloc_biblioteca_pdf.dart';

class EstadoBibliotecaPdf {
  const EstadoBibliotecaPdf({
    this.documentos = const <DocumentoPdf>[],
    this.estaCarregando = false,
    this.estaImportando = false,
    this.mensagemErro,
    this.documentoAbertoAgora,
  });

  final List<DocumentoPdf> documentos;
  final bool estaCarregando;
  final bool estaImportando;
  final String? mensagemErro;
  final DocumentoPdf? documentoAbertoAgora;

  List<DocumentoPdf> get documentosRecentes {
    final List<DocumentoPdf> lista = List<DocumentoPdf>.from(documentos);
    lista.sort((DocumentoPdf a, DocumentoPdf b) => b.ultimoAcesso.compareTo(a.ultimoAcesso));
    return lista.take(8).toList();
  }

  List<DocumentoPdf> get favoritos {
    final List<DocumentoPdf> lista =
        documentos.where((DocumentoPdf documento) => documento.estaFavorito).toList();
    lista.sort((DocumentoPdf a, DocumentoPdf b) => b.ultimoAcesso.compareTo(a.ultimoAcesso));
    return lista;
  }

  EstadoBibliotecaPdf copyWith({
    List<DocumentoPdf>? documentos,
    bool? estaCarregando,
    bool? estaImportando,
    String? mensagemErro,
    bool limparMensagemErro = false,
    DocumentoPdf? documentoAbertoAgora,
    bool limparDocumentoAbertoAgora = false,
  }) {
    return EstadoBibliotecaPdf(
      documentos: documentos ?? this.documentos,
      estaCarregando: estaCarregando ?? this.estaCarregando,
      estaImportando: estaImportando ?? this.estaImportando,
      mensagemErro: limparMensagemErro ? null : (mensagemErro ?? this.mensagemErro),
      documentoAbertoAgora: limparDocumentoAbertoAgora
          ? null
          : (documentoAbertoAgora ?? this.documentoAbertoAgora),
    );
  }
}
