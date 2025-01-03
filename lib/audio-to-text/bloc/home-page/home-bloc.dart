// ignore_for_file: unused_field, prefer_final_fields, deprecated_member_use, unnecessary_null_comparison

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/home-page/home-state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/imgReader-screen.dart';
import 'package:new_wall_paper_app/component/dialog_widget.dart';
import 'package:new_wall_paper_app/model/home_icon-mode.dart';
import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/res/app-text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:get/get.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageSate> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _currentTranscription = '';
  String _selectedLanguage = 'en-US';
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  BuildContext? context;
  String get selectedLanguage => _selectedLanguage;
  String get currentText => _currentTranscription;
  String docsString = '';
  final ImagePicker _picker = ImagePicker();
  HomePageBloc() : super(ItemInitial()) {
    // _speech = stt.SpeechToText();
    // on<OpenCameraEvent>(_onOpenCamera);
    on<CaptureImageEvent>(_onCaptureImage);
    on<EditImageEvent>(_onEditImage);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<RotateImageEvent>(_onRotateImage);
    on<ResizeImageEvent>(_onResizeImage);
    on<CropImageEvent>(_onCropImage);
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<OpenGalleryEvent>(_onOpenGallery);
    on<TakePictureEvent>(_onTakePicture);
    on<FlipCameraEvent>(_onFlipCamera);
    on<HomePickAndProcessFileEvent>(_onPickAndProcessFile);
    on<PickImageAndRecognizeTextEvent>(_onPickImageAndRecognizeText);
    on<ShowPopupDialog>((event, emit) {
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        emit(currentState.copyWith(showDialog: true));
      }
    });

    on<HidePopupDialog>((event, emit) {
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        emit(currentState.copyWith(showDialog: false));
      }
    });
    on<OpenCameraEvent>((event, emit) async {
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        emit(currentState.copyWith(showDialog: false));

        if (event.openCamera) {
          try {
            _cameras = await availableCameras();
            _cameraController =
                CameraController(_cameras![0], ResolutionPreset.high);
            await _cameraController?.initialize();
            emit(CameraState(isInitialized: true));
          } catch (e) {
            emit(ItemError('Failed to initialize camera: $e'));
          }
        } else {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            emit(ImageEditingState(imagePath: pickedFile.path));
          }
        }
      }
    });

    // on<PickImageAndRecognizeTextEvent>((event, emit) async {
    //   final XFile? imageFile = event.isCamera
    //       ? await ImagePicker().pickImage(source: ImageSource.camera)
    //       : await ImagePicker().pickImage(source: ImageSource.gallery);

    //   if (imageFile != null) {
    //     emit(ImageEditingState(imagePath: imageFile.path));
    //   }
    // });

    on<ProcessEditedImage>((event, emit) async {
      if (state is ImageEditingState) {
        final currentState = state as ImageEditingState;
        emit(currentState.copyWith(isProcessing: true));

        try {
          final inputImage = InputImage.fromFilePath(event.imagePath);
          final textRecognizer = GoogleMlKit.vision.textRecognizer();
          final RecognizedText recognizedText =
              await textRecognizer.processImage(inputImage);
          String text = recognizedText.text;
          if (text.isEmpty) {
            showNoTextDialog();
          } else {
            Get.to(CameraScreen(
              text: text,
            ));
          }
          await textRecognizer.close();

          if (text.trim().isEmpty) {
            emit(currentState.copyWith(
              isProcessing: false,
              extractedText: '',
            ));
          } else {
            final document = Document(
              name: 'Extracted_Text_${DateTime.now().toIso8601String()}',
              pdfContent: text,
              description: DateTime.now().toIso8601String(),
              contentType: "Image",
            );

            final dbHelper = DatabaseHelper();
            await dbHelper.insertDocument(document);

            emit(currentState.copyWith(
              isProcessing: false,
              extractedText: text,
            ));
          }
        } catch (e) {
          emit(currentState.copyWith(
            isProcessing: false,
            extractedText: '',
          ));
        }
      }
    });

    on<LoadItemsEvent>((event, emit) async {
      emit(ItemLoading());
      try {
        // Define base items and texts that are always needed
        final List<String> texts = [
          "Business",
          "Self-Improvement",
          "Non-Fiction",
          "Non-Fiction",
          "Non-Fiction",
        ];

        final List<Item> items = [
          Item(
              text: AppText.scan,
              imageUrl: AppImage.scan,
              color: AppColor.containerColor,
              des: AppText.scannedDes),
          Item(
              text: AppText.text,
              imageUrl: AppImage.docs,
              color: AppColor.containerColor,
              des: AppText.transformPdf),
          Item(
              text: AppText.link,
              imageUrl: AppImage.link,
              color: AppColor.containerColor,
              des: AppText.convertUrlDes),
          Item(
              text: AppText.more,
              imageUrl: AppImage.robot,
              color: AppColor.containerColor,
              des: AppText.chatwithFileDes),
        ];

        if (event.url != null && event.url.isNotEmpty) {
          Uri? parsedUrl = Uri.tryParse(event.url);
          if (parsedUrl == null || !parsedUrl.hasScheme) {
            emit(ItemError('Invalid URL format'));
            return;
          }

          final response = await http.get(parsedUrl);
          if (response.statusCode == 200) {
            var document = html_parser.parse(response.body);
            List<String> paragraphs = document
                .querySelectorAll('p')
                .map((element) => element.text.trim())
                .where((text) => text.isNotEmpty)
                .toList();

            final extractedText = paragraphs.join('\n\n');

            if (extractedText.isEmpty) {
              emit(ItemError('No meaningful text found on the webpage.'));
              return;
            }

            final documents = Document(
              name: parsedUrl.host,
              pdfContent: extractedText,
              description: DateTime.now().toIso8601String(),
              contentType: "Link",
            );

            final dbHelper = DatabaseHelper();
            await dbHelper.insertDocument(documents);

            emit(ItemLoaded(extractedText, items, texts: texts));
          } else {
            emit(ItemError(
                'Failed to fetch data. Status code: ${response.statusCode}'));
          }
        } else {
          emit(ItemLoaded('', items, texts: texts));
        }
      } catch (e) {
        emit(ItemError(AppText.failedToLoadItem));
      }
    });
  }
  void _onEditImage(EditImageEvent event, Emitter<HomePageSate> emit) {
    try {
      emit(ImageEditingState(
        imagePath: event.imagePath,
        selectedFilterIndex: 0,
        rotation: 0,
        scale: 1.0,
        isProcessing: false,
      ));
    } catch (e) {
      emit(ItemError('Failed to edit image: $e'));
    }
  }

  void _onApplyFilter(ApplyFilterEvent event, Emitter<HomePageSate> emit) {
    if (state is ImageEditingState) {
      final currentState = state as ImageEditingState;
      emit(currentState.copyWith(
        selectedFilterIndex: event.filterIndex,
        isProcessing: false,
      ));
    }
  }

  void _onRotateImage(RotateImageEvent event, Emitter<HomePageSate> emit) {
    if (state is ImageEditingState) {
      final currentState = state as ImageEditingState;
      double newRotation = currentState.rotation + 90;
      if (newRotation >= 360) {
        newRotation = 0;
      }
      emit(currentState.copyWith(
        rotation: newRotation,
        isProcessing: false,
      ));
    }
  }

  void _onResizeImage(ResizeImageEvent event, Emitter<HomePageSate> emit) {
    if (state is ImageEditingState) {
      final currentState = state as ImageEditingState;
      emit(currentState.copyWith(
        scale: event.scale,
        isProcessing: false,
      ));
    }
  }

  Future<void> _onCropImage(
      CropImageEvent event, Emitter<HomePageSate> emit) async {
    if (state is ImageEditingState) {
      final currentState = state as ImageEditingState;
      emit(currentState.copyWith(isProcessing: true));

      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: event.imagePath,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          // uiSettings: [
          //   AndroidUiSettings(
          //     toolbarTitle: 'Crop Image',
          //     toolbarColor: Colors.black,
          //     toolbarWidgetColor: Colors.white,
          //     initAspectRatio: CropAspectRatioPreset.original,
          //     lockAspectRatio: false,
          //   ),
          //   IOSUiSettings(
          //     title: 'Crop Image',
          //     cancelButtonTitle: 'Cancel',
          //     doneButtonTitle: 'Done',
          //   ),
          // ],
        );

        if (croppedFile != null) {
          emit(currentState.copyWith(
            imagePath: croppedFile.path,
            isProcessing: false,
          ));
        } else {
          emit(currentState.copyWith(isProcessing: false));
        }
      } catch (e) {
        print('Error cropping image: $e');
        emit(currentState.copyWith(isProcessing: false));
      }
    }
  }

  Future<void> _onInitializeCamera(
    InitializeCameraEvent event,
    Emitter<HomePageSate> emit,
  ) async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(cameras[0], ResolutionPreset.high);
      await _cameraController?.initialize();

      emit(CameraState(
        controller: _cameraController,
        cameras: cameras,
        isInitialized: true,
      ));
    } catch (e) {
      emit(ItemError('Failed to initialize camera: $e'));
    }
  }

  Future<void> _onOpenGallery(
    OpenGalleryEvent event,
    Emitter<HomePageSate> emit,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(ImageEditingState(imagePath: pickedFile.path));
      }
    } catch (e) {
      emit(ItemError('Failed to pick image: $e'));
    }
  }

  Future<void> _onTakePicture(
    TakePictureEvent event,
    Emitter<HomePageSate> emit,
  ) async {
    if (state is CameraState) {
      final currentState = state as CameraState;
      emit(currentState.copyWith(isProcessing: true));

      try {
        final image = await currentState.controller?.takePicture();
        if (image != null) {
          emit(ImageEditingState(imagePath: image.path));
        }
      } catch (e) {
        emit(ItemError('Failed to take picture: $e'));
      }
    }
  }

  Future<void> _onFlipCamera(
    FlipCameraEvent event,
    Emitter<HomePageSate> emit,
  ) async {
    if (state is CameraState) {
      final currentState = state as CameraState;
      emit(currentState.copyWith(isProcessing: true));

      try {
        final cameras = currentState.cameras;
        if (cameras != null && cameras.length > 1) {
          await currentState.controller?.dispose();

          final newIndex = currentState.currentCameraIndex == 0 ? 1 : 0;
          final newController = CameraController(
            cameras[newIndex],
            ResolutionPreset.high,
          );
          await newController.initialize();

          emit(currentState.copyWith(
            controller: newController,
            currentCameraIndex: newIndex,
            isProcessing: false,
          ));
        }
      } catch (e) {
        emit(ItemError('Failed to flip camera: $e'));
      }
    }
  }

  Future<void> _onCaptureImage(
      CaptureImageEvent event, Emitter<HomePageSate> emit) async {
    try {
      final image = await _cameraController?.takePicture();
      if (image != null) {
        emit(ImageEditingState(imagePath: image.path));
      }
    } catch (e) {
      emit(ItemError('Failed to capture image: $e'));
    }
  }

  final List<String> exploreBooksList = [
    // AppImage.book,
    AppImage.qr_scan,
    AppImage.group,
    // AppImage.other,
  ];
  final List<String> exploreBookstitleList = [
    // "explore books",
    "Scan QR Code",
    "Gmail",
    // "More",
  ];

  Future<void> _onPickAndProcessFile(
      HomePickAndProcessFileEvent event, Emitter<HomePageSate> emit) async {
    emit(FileProcessorLoading());
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
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
          docsString = extractedText;
          final dbHelper = DatabaseHelper();
          await dbHelper.insertDocument(document);
        }

        emit(FileProcessorSuccess(extractedText));
      } else {
        emit(FileProcessorError('No file selected'));
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

  Future<void> _onPickImageAndRecognizeText(
      PickImageAndRecognizeTextEvent event, Emitter<HomePageSate> emit) async {
    if (state is ItemLoaded) {
      final currentState = state as ItemLoaded;
      emit(currentState.copyWith(isImageRecognitionLoading: true));

      try {
        final XFile? imageFile = event.isCamera
            ? await ImagePicker().pickImage(source: ImageSource.camera)
            : await ImagePicker().pickImage(source: ImageSource.gallery);

        if (imageFile != null) {
          final inputImage = InputImage.fromFilePath(imageFile.path);
          final textRecognizer = GoogleMlKit.vision.textRecognizer();
          final RecognizedText recognizedText =
              await textRecognizer.processImage(inputImage);
          String text = recognizedText.text;
          await textRecognizer.close();

          if (text.isNotEmpty) {
            final document = Document(
              name: 'Image_${DateTime.now().millisecondsSinceEpoch}',
              pdfContent: text,
              description: imageFile.path,
              contentType: "Image",
            );
            emit(currentState.copyWith(
                isImageRecognitionLoading: true, showDialog: false));
            final dbHelper = DatabaseHelper();
            await dbHelper.insertDocument(document);
            emit(currentState.copyWith(
                isImageRecognitionLoading: true, showDialog: false));
            Get.to(CameraScreen(text: text));
          } else {
            emit(currentState.copyWith(
                isImageRecognitionLoading: false, showDialog: false));
            showNoTextDialog();
          }
        } else {
          emit(currentState.copyWith(
              isImageRecognitionLoading: false, showDialog: false));
        }
      } catch (e) {
        emit(currentState.copyWith(
            isImageRecognitionLoading: false, showDialog: false));
      }
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    _cameraController?.dispose();
    return super.close();
  }
}
