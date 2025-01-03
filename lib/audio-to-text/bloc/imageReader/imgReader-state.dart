import 'package:equatable/equatable.dart';

abstract class ImageReaderState extends Equatable {
  const ImageReaderState();

  @override
  List<Object> get props => [];
}

class ImageReaderInitial extends ImageReaderState {}

class ImageReaderLoading extends ImageReaderState {}

class ImageReaderImagePicked extends ImageReaderState {
  final String extractedText;

  const ImageReaderImagePicked(this.extractedText);

  @override
  List<Object> get props => [extractedText];
}

class ImageReaderError extends ImageReaderState {
  final String message;

  const ImageReaderError(this.message);

  @override
  List<Object> get props => [message];
}
