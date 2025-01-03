import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/gDrive/gDrive-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/gDrive/gDrive-state.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:xml/xml.dart';
import 'package:flutter_archive/flutter_archive.dart';


class DriveBloc extends Bloc<DriveEvent, DriveState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.readonly',
    ],
  );

  DriveBloc() : super(DriveInitial()) {
    on<SignInEvent>(_onSignInEvent);
    on<FetchFoldersEvent>(_onFetchFoldersEvent);
    on<FetchFilesEvent>(_onFetchFilesEvent);
    on<ProcessFileEvent>(_onProcessFileEvent);
  }

  Future<void> _onSignInEvent(SignInEvent event, Emitter<DriveState> emit) async {
    emit(DriveLoading());
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        final auth = await account.authentication;
        final accessToken = auth.accessToken!;
        emit(DriveSignedIn(accessToken));
        add(FetchFoldersEvent(accessToken));
      } else {
        emit(const DriveError('Sign in failed'));
      }
    } catch (error) {
      emit(DriveError('Error signing in: $error'));
    }
  }
Future<void> _onFetchFoldersEvent(
    FetchFoldersEvent event, Emitter<DriveState> emit) async {
  emit(DriveLoading());
  try {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/drive/v3/files?fields=files(id,name,mimeType,parents)'),
      headers: {'Authorization': 'Bearer ${event.accessToken}'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      emit(DriveFoldersLoaded(data['files'] ?? []));
    } else {
      emit(DriveError('Failed to fetch folders: ${response.body}'));
    }
  } catch (error) {
    emit(DriveError('Error fetching folders: $error'));
  }
}


  Future<void> _onFetchFilesEvent(
      FetchFilesEvent event, Emitter<DriveState> emit) async {
    emit(DriveLoading());
    try {
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/drive/v3/files?q=\'${event.folderId}\' in parents and (mimeType=\'application/pdf\' or mimeType=\'application/vnd.openxmlformats-officedocument.wordprocessingml.document\' or mimeType contains \'image/\')&fields=files(id,name,mimeType)'),
        headers: {'Authorization': 'Bearer ${event.accessToken}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(DriveFilesLoaded(data['files'] ?? []));
      } else {
        emit(DriveError('Failed to load files: ${response.body}'));
      }
    } catch (error) {
      emit(DriveError('Error fetching files: $error'));
    }
  }


  Future<void> _onProcessFileEvent(
      ProcessFileEvent event, Emitter<DriveState> emit) async {
    emit(DriveLoading());
    try {
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/drive/v3/files/${event.fileId}?alt=media'),
        headers: {'Authorization': 'Bearer ${event.accessToken}'},
      );

      if (response.statusCode == 200) {
        final tempDir = Directory.systemTemp.createTempSync();
        final filePath = '${tempDir.path}/${event.fileName}';
        final file = File(filePath)..writeAsBytesSync(response.bodyBytes);

        String extractedText;
        if (event.mimeType == 'application/pdf') {
          extractedText = await ReadPdfText.getPDFtext(filePath) ?? 'No text found in PDF';
        } else if (event.mimeType.startsWith('image/')) {
          final inputImage = InputImage.fromFile(file);
          final textRecognizer = GoogleMlKit.vision.textRecognizer();
          final recognizedText = await textRecognizer.processImage(inputImage);
          await textRecognizer.close();
          extractedText = recognizedText.text.isNotEmpty
              ? recognizedText.text
              : 'No text found in image';
        } else if (event.mimeType ==
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
          await ZipFile.extractToDirectory(zipFile: file, destinationDir: tempDir);
          final docXml = File('${tempDir.path}/word/document.xml').readAsStringSync();
          final document = XmlDocument.parse(docXml);
          extractedText = document.findAllElements('w:t').map((e) => e.text).join(' ');
        } else {
          extractedText = 'Unsupported file type';
        }

        emit(DriveFileTextExtracted(event.fileName, extractedText));
      } else {
        emit(DriveError('Failed to download file: ${response.body}'));
      }
    } catch (error) {
      emit(DriveError('Error processing file: $error'));
    }
  }
}
