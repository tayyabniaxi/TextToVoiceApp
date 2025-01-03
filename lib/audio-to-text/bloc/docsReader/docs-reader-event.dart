import 'package:equatable/equatable.dart';

abstract class DocsReaderEvent extends Equatable {
  const DocsReaderEvent();

  @override
  List<Object> get props => [];
}

class PickDocxFile extends DocsReaderEvent {}
