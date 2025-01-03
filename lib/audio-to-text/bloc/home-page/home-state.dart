// import 'package:new_wall_paper_app/audio-to-text/model/home_icon-model.dart';

import 'package:camera/camera.dart';
import 'package:new_wall_paper_app/model/home_icon-mode.dart';

abstract class HomePageSate {}

class ItemInitial extends HomePageSate {}

class ItemLoading extends HomePageSate {}

class ItemLoaded extends HomePageSate {
  final String extractedText;
  final List<Item> items;
  final double sliderValue;
  final Duration audioDuration;
  final Duration audioPosition;
  final double audioSpeed;
  final bool isPlaying;
  final String selectedCountry;
  final List<String>? texts;
  final bool isImageRecognitionLoading;
  final String? recognizedImageText;
  final bool showDialog;

  ItemLoaded(
    this.extractedText,
    this.items, {
    this.sliderValue = 0.0,
    this.audioDuration = Duration.zero,
    this.audioPosition = Duration.zero,
    this.audioSpeed = 1.0,
    this.isPlaying = false,
    this.selectedCountry = 'en-US',
    this.texts,
    this.showDialog = false,
    this.isImageRecognitionLoading = false,
    this.recognizedImageText,
  });

  ItemLoaded copyWith({
    bool? showDialog,
    String? extractedText,
    List<Item>? items,
    double? sliderValue,
    Duration? audioDuration,
    Duration? audioPosition,
    double? audioSpeed,
    bool? isPlaying,
    String? selectedCountry,
    List<String>? texts,
    bool? isImageRecognitionLoading,
    String? recognizedImageText,
  }) {
    return ItemLoaded(
      this.extractedText,
      this.items,
      sliderValue: this.sliderValue,
      audioDuration: this.audioDuration,
      audioPosition: this.audioPosition,
      audioSpeed: this.audioSpeed,
      isPlaying: this.isPlaying,
      selectedCountry: this.selectedCountry,
      texts: this.texts,
      showDialog: showDialog ?? this.showDialog,
      isImageRecognitionLoading:
          isImageRecognitionLoading ?? this.isImageRecognitionLoading,
      recognizedImageText: recognizedImageText ?? this.recognizedImageText,
    );
  }
}

class ItemError extends HomePageSate {
  final String message;
  ItemError(this.message);
}

class FanTranscriptionUpdated extends HomePageSate {
  final String transcription;
  final int SpeechTextState;
  final bool isValid;
  FanTranscriptionUpdated(
      this.transcription, this.SpeechTextState, this.isValid);
}

class SpeechTextError extends HomePageSate {
  final String error;
  SpeechTextError(this.error);
}

class PopupDialogShown extends HomePageSate {}

class CameraState extends HomePageSate {
  final bool isInitialized;
  final bool isProcessing;
  final CameraController? controller;
  final List<CameraDescription>? cameras;
  final int currentCameraIndex;

  CameraState({
    this.isInitialized = false,
    this.isProcessing = false,
    this.controller,
    this.cameras,
    this.currentCameraIndex = 0,
  });

  CameraState copyWith({
    CameraController? controller,
    List<CameraDescription>? cameras,
    bool? isInitialized,
    bool? isProcessing,
    int? currentCameraIndex,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      cameras: cameras ?? this.cameras,
      isInitialized: isInitialized ?? this.isInitialized,
      isProcessing: isProcessing ?? this.isProcessing,
      currentCameraIndex: currentCameraIndex ?? this.currentCameraIndex,
    );
  }
}

class ImageEditingState extends HomePageSate {
  final String imagePath;
  final int selectedFilterIndex;
  final double rotation;
  final double scale;
  final bool isProcessing;
  final String extractedText;
  final bool isFromGallery;

  ImageEditingState({
    required this.imagePath,
    this.selectedFilterIndex = 0,
    this.rotation = 0,
    this.scale = 1.0,
    this.isProcessing = false,
    this.extractedText = '',
    this.isFromGallery = false,
  });

  ImageEditingState copyWith({
    String? imagePath,
    int? selectedFilterIndex,
    double? rotation,
    double? scale,
    bool? isProcessing,
    String? extractedText,
    bool? isFromGallery,
  }) {
    return ImageEditingState(
      imagePath: imagePath ?? this.imagePath,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      isProcessing: isProcessing ?? this.isProcessing,
      extractedText: extractedText ?? this.extractedText,
      isFromGallery: isFromGallery ?? this.isFromGallery,
    );
  }
}

class FileProcessorInitial extends HomePageSate {}

class FileProcessorLoading extends HomePageSate {}

class FileProcessorSuccess extends HomePageSate {
  final String extractedText;

  FileProcessorSuccess(this.extractedText);

  @override
  List<Object?> get props => [extractedText];
}

class FileProcessorError extends HomePageSate {
  final String errorMessage;

  FileProcessorError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ImageRecognitionLoading extends HomePageSate {}

class ImageRecognitionSuccess extends HomePageSate {
  final String extractedText;
  ImageRecognitionSuccess(this.extractedText);
}

class ImageRecognitionError extends HomePageSate {
  final String message;
  ImageRecognitionError(this.message);
}
