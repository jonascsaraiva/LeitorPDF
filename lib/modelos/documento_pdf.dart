class DocumentoPdf {
  const DocumentoPdf({
    required this.nome,
    required this.caminho,
    required this.tamanhoBytes,
    required this.dataImportacaoIso,
    required this.ultimoAcessoIso,
    this.estaFavorito = false,
  });

  final String nome;
  final String caminho;
  final int tamanhoBytes;
  final String dataImportacaoIso;
  final String ultimoAcessoIso;
  final bool estaFavorito;

  DateTime get dataImportacao => DateTime.tryParse(dataImportacaoIso) ?? DateTime.now();
  DateTime get ultimoAcesso => DateTime.tryParse(ultimoAcessoIso) ?? dataImportacao;

  DocumentoPdf copyWith({
    String? nome,
    String? caminho,
    int? tamanhoBytes,
    String? dataImportacaoIso,
    String? ultimoAcessoIso,
    bool? estaFavorito,
  }) {
    return DocumentoPdf(
      nome: nome ?? this.nome,
      caminho: caminho ?? this.caminho,
      tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
      dataImportacaoIso: dataImportacaoIso ?? this.dataImportacaoIso,
      ultimoAcessoIso: ultimoAcessoIso ?? this.ultimoAcessoIso,
      estaFavorito: estaFavorito ?? this.estaFavorito,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'caminho': caminho,
      'tamanhoBytes': tamanhoBytes,
      'dataImportacaoIso': dataImportacaoIso,
      'ultimoAcessoIso': ultimoAcessoIso,
      'estaFavorito': estaFavorito,
    };
  }

  factory DocumentoPdf.fromMap(Map<String, dynamic> map) {
    final DateTime agora = DateTime.now();
    return DocumentoPdf(
      nome: (map['nome'] ?? map['name'] ?? '') as String,
      caminho: (map['caminho'] ?? map['path'] ?? '') as String,
      tamanhoBytes: (map['tamanhoBytes'] ?? 0) as int,
      dataImportacaoIso: (map['dataImportacaoIso'] ?? agora.toIso8601String()) as String,
      ultimoAcessoIso: (map['ultimoAcessoIso'] ?? map['dataImportacaoIso'] ?? agora.toIso8601String()) as String,
      estaFavorito: (map['estaFavorito'] ?? false) as bool,
    );
  }
}
