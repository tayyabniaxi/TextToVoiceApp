import 'package:equatable/equatable.dart';

abstract class FileProcessorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickAndProcessFileEvent extends FileProcessorEvent {}
