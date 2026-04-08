class PdfDocumentItem {
  const PdfDocumentItem({required this.name, required this.path});

  final String name;
  final String path;

  Map<String, String> toMap() {
    return <String, String>{'name': name, 'path': path};
  }

  factory PdfDocumentItem.fromMap(Map<String, dynamic> map) {
    return PdfDocumentItem(
      name: map['name'] as String? ?? '',
      path: map['path'] as String? ?? '',
    );
  }
}
