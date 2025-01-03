import 'package:equatable/equatable.dart';

abstract class PDFReaderState extends Equatable {
  const PDFReaderState();

  @override
  List<Object> get props => [];
}

class PDFReaderInitial extends PDFReaderState {}

class PDFReaderLoading extends PDFReaderState {}

class PDFReaderLoaded extends PDFReaderState {
  final String pdfText;

  const PDFReaderLoaded(this.pdfText);

  @override
  List<Object> get props => [pdfText];
}

class PDFReaderError extends PDFReaderState {
  final String message;

  const PDFReaderError(this.message);

  @override
  List<Object> get props => [message];
}
