// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, unnecessary_null_comparison

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-state-class.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:xml/xml.dart';

import '../../../model/store-pdf-sqlite-db-model.dart';

class FileProcessorBloc extends Bloc<FileProcessorEvent, FileProcessorState> {
  bool isExtractContent = false;
  String extractString = '';
  FileProcessorBloc() : super(FileProcessorInitial()) {
    on<PickAndProcessFileEvent>(_onPickAndProcessFile);
  }
// Update the FileProcessorBloc's _onPickAndProcessFile method
Future<void> _onPickAndProcessFile(
    PickAndProcessFileEvent event, Emitter<FileProcessorState> emit) async {
  emit(FileProcessorLoading());
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'jpg', 'jpeg', 'png'],
    );

    // If no file is selected (user cancelled), return to initial state
    if (result == null || result.files.isEmpty) {
      emit(FileProcessorInitial());
      return;
    }

    if (result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;
      final extension = filePath.split('.').last.toLowerCase();

      String extractedText;
      String contentType;

      switch (extension) {
        case 'jpg':
        case 'jpeg':
        case 'png':
          extractedText = await _extractTextFromImage(filePath);
          contentType = "Image";
          break;
        case 'pdf':
          extractedText = await _extractTextFromPdf(filePath);
          contentType = "PDF";
          break;
        case 'docx':
          extractedText = await _extractTextFromDocx(filePath);
          contentType = "DOCX";
          break;
        default:
          extractedText = 'Unsupported file type';
          contentType = "Unsupported";
      }

      if (contentType != "Unsupported" && extractedText.isNotEmpty) {
        final document = Document(
          name: fileName.split('.').first,
          pdfContent: extractedText,
          description: DateTime.now().toIso8601String(),
          contentType: contentType,
        );
        extractString = extractedText;
        isExtractContent = true;
        final dbHelper = DatabaseHelper();
        await dbHelper.insertDocument(document);
      }

      emit(FileProcessorSuccess(extractedText));
    } else {
      emit(FileProcessorInitial()); // Return to initial state if path is null
    }
  } catch (e) {
    emit(FileProcessorError('Error: $e'));
  }
}
  Future<String> _extractTextFromImage(String filePath) async {
    try {
      final inputImage = InputImage.fromFile(File(filePath));
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();
      return recognizedText.text.isNotEmpty
          ? recognizedText.text
          : 'No text found in the image';
    } catch (e) {
      return 'Error processing image: $e';
    }
  }

  Future<String> _extractTextFromPdf(String filePath) async {
    try {
      final reader = await ReadPdfText.getPDFtext(filePath);
      return reader != null && reader.isNotEmpty
          ? reader
          : 'No text found in the PDF';
    } catch (e) {
      return 'Error processing PDF: $e';
    }
  }

  Future<String> _extractTextFromDocx(String filePath) async {
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
      return 'Error processing DOCX file: $e';
    } finally {
      tempDir.deleteSync(recursive: true);
    }
  }
}
