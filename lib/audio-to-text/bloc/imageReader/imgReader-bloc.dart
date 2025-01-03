// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/imageReader/imgReader-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/imageReader/imgReader-state.dart';

import 'package:image_picker/image_picker.dart';
import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';

class ImageReaderBloc extends Bloc<ImageReaderEvent, ImageReaderState> {
  final ImagePicker _picker = ImagePicker();

  ImageReaderBloc() : super(ImageReaderInitial()) {
    on<PickImageAndRecognizeText>(_onPickImageAndRecognizeText);
  }
  Future<void> _onPickImageAndRecognizeText(
    PickImageAndRecognizeText event, Emitter<ImageReaderState> emit) async {
  emit(ImageReaderLoading());

  final XFile? imageFile = event.isCamera
      ? await _picker.pickImage(source: ImageSource.camera)
      : await _picker.pickImage(source: ImageSource.gallery);

  if (imageFile != null) {
    File selectedImage = File(imageFile.path);
    final inputImage = InputImage.fromFile(selectedImage);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;

      if (text.isEmpty) {
        emit(ImageReaderError("No text found in the image"));
        return;
      }

     
      final document = Document(
        name: imageFile.name, 
        pdfContent: text, 
        description: DateTime.now().toIso8601String(),
        contentType: "Image", 
      );

      final dbHelper = DatabaseHelper();
      await dbHelper.insertDocument(document);

      emit(ImageReaderImagePicked(text));
    } catch (e) {
      emit(ImageReaderError("Error recognizing text: $e"));
    } finally {
      textRecognizer.close();
    }
  } else {
    emit(ImageReaderError("No image selected"));
  }
}

}
