import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pdf_document_item.dart';

class PdfReaderController extends ChangeNotifier {
  static const String _recentDocumentsKey = 'recent_pdf_documents';

  final List<PdfDocumentItem> _recentDocuments = <PdfDocumentItem>[];

  bool _isPicking = false;
  bool _isLoading = false;
  String? _errorMessage;
  PdfDocumentItem? _selectedDocument;

  bool get isPicking => _isPicking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PdfDocumentItem? get selectedDocument => _selectedDocument;
  List<PdfDocumentItem> get recentDocuments =>
      List<PdfDocumentItem>.unmodifiable(_recentDocuments);

  Future<void> loadRecentDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final List<String> encodedItems =
          preferences.getStringList(_recentDocumentsKey) ?? <String>[];

      _recentDocuments
        ..clear()
        ..addAll(
          encodedItems
              .map(
                (String item) => PdfDocumentItem.fromMap(
                  jsonDecode(item) as Map<String, dynamic>,
                ),
              )
              .where((PdfDocumentItem item) => item.path.isNotEmpty),
        );

      if (_recentDocuments.isNotEmpty) {
        _selectedDocument ??= _recentDocuments.first;
      }
    } catch (_) {
      _errorMessage = 'Nao foi possivel carregar a lista de PDFs recentes.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PdfDocumentItem?> pickPdf() async {
    _isPicking = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>['pdf'],
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final PlatformFile file = result.files.single;
      final String? filePath = file.path;

      if (filePath == null || filePath.isEmpty) {
        _errorMessage =
            'Nao foi possivel localizar o arquivo selecionado no dispositivo.';
        notifyListeners();
        return null;
      }

      final PdfDocumentItem document = PdfDocumentItem(
        name: file.name.isNotEmpty ? file.name : path.basename(filePath),
        path: filePath,
      );

      _selectedDocument = document;
      await _addToRecentDocuments(document);
      return document;
    } catch (_) {
      _errorMessage =
          'Ocorreu um erro ao abrir o seletor de arquivos. Tente novamente.';
      return null;
    } finally {
      _isPicking = false;
      notifyListeners();
    }
  }

  Future<void> selectDocument(PdfDocumentItem document) async {
    _selectedDocument = document;
    await _addToRecentDocuments(document);
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _addToRecentDocuments(PdfDocumentItem document) async {
    _recentDocuments.removeWhere(
      (PdfDocumentItem item) => item.path == document.path,
    );
    _recentDocuments.insert(0, document);

    if (_recentDocuments.length > 8) {
      _recentDocuments.removeRange(8, _recentDocuments.length);
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _recentDocumentsKey,
      _recentDocuments
          .map((PdfDocumentItem item) => jsonEncode(item.toMap()))
          .toList(),
    );
  }
}
