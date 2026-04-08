class DocumentoPdf {
  const DocumentoPdf({required this.nome, required this.caminho});

  final String nome;
  final String caminho;

  Map<String, String> toMap() {
    return <String, String>{'nome': nome, 'caminho': caminho};
  }

  factory DocumentoPdf.fromMap(Map<String, dynamic> map) {
    return DocumentoPdf(
      nome: map['nome'] as String? ?? '',
      caminho: map['caminho'] as String? ?? '',
    );
  }
}
