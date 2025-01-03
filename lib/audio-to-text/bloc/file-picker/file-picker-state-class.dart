import 'package:equatable/equatable.dart';

abstract class FileProcessorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FileProcessorInitial extends FileProcessorState {}

class FileProcessorLoading extends FileProcessorState {}

class FileProcessorSuccess extends FileProcessorState {
  
  final String extractedText;

  FileProcessorSuccess(this.extractedText);

  @override
  List<Object?> get props => [extractedText];
}

class FileProcessorError extends FileProcessorState {
  final String errorMessage;

  FileProcessorError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
