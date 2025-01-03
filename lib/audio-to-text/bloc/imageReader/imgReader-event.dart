import 'package:equatable/equatable.dart';

abstract class ImageReaderEvent extends Equatable {
  const ImageReaderEvent();

  @override
  List<Object> get props => [];
}

class PickImageAndRecognizeText extends ImageReaderEvent {
  //  isCamera field
  final bool isCamera;

// Constructor
  const PickImageAndRecognizeText({required this.isCamera});
// Update props
  @override
  List<Object> get props => [isCamera];
}
