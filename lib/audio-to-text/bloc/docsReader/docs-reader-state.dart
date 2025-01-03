import 'package:equatable/equatable.dart';

abstract class DocsReaderState extends Equatable {
  const DocsReaderState();

  @override
  List<Object> get props => [];
}

class DocxInitial extends DocsReaderState {}

class DocxLoading extends DocsReaderState {}

class DocxLoaded extends DocsReaderState {
  final String content;

  const DocxLoaded(this.content);

  @override
  List<Object> get props => [content];
}

class DocxError extends DocsReaderState {
  final String message;

  const DocxError(this.message);

  @override
  List<Object> get props => [message];
}
