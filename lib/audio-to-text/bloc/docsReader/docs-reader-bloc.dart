import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/docsReader/docs-reader-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/docsReader/docs-reader-state.dart';
import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';
import 'package:xml/xml.dart';

import 'package:file_picker/file_picker.dart';

class DocsReaderBloc extends Bloc<DocsReaderEvent, DocsReaderState> {
  DocsReaderBloc() : super(DocxInitial()) {
    on<PickDocxFile>(_onPickDocxFile);
  }
  Future<void> _onPickDocxFile(
      PickDocxFile event, Emitter<DocsReaderState> emit) async {
    emit(DocxLoading());

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        final content = await _readDocxFile(path);

        if (content.startsWith('Error')) {
          emit(DocxError(content));
          return;
        }

        final documentName = result.files.first.name.split('.').first;

        final document = Document(
          name: documentName,
          pdfContent: content,
          description: DateTime.now().toIso8601String(),
          contentType: "DOCX",
        );

        final dbHelper = DatabaseHelper();
        await dbHelper.insertDocument(document);

        emit(DocxLoaded(content));
      } else {
        emit(const DocxError("File path is null"));
      }
    } else {
      emit(const DocxError("No file selected"));
    }
  }

  Future<String> _readDocxFile(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      return 'File does not exist';
    }

    final tempDir = Directory.systemTemp.createTempSync();

    try {
      await ZipFile.extractToDirectory(
        zipFile: file,
        destinationDir: tempDir,
      );

      final documentFile = File('${tempDir.path}/word/document.xml');
      final documentContent = await documentFile.readAsString();

      final documentXml = XmlDocument.parse(documentContent);
      final paragraphs = documentXml.findAllElements('w:p');

      final textList = paragraphs.map((paragraph) {
        final texts = paragraph.findAllElements('w:t');
        return texts.map((text) => text.text).join('');
      }).toList();

      return textList.join('\n');
    } catch (e) {
      return 'Error reading DOCX file: $e';
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  }
}
