import 'package:equatable/equatable.dart';

abstract class DriveState extends Equatable {
  const DriveState();

  @override
  List<Object?> get props => [];
}

class DriveInitial extends DriveState {}

class DriveLoading extends DriveState {}

class DriveSignedIn extends DriveState {
  final String accessToken;

  const DriveSignedIn(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

class DriveFoldersLoaded extends DriveState {
  final List<dynamic> folders;

  const DriveFoldersLoaded(this.folders);

  @override
  List<Object?> get props => [folders];
}

class DriveFilesLoaded extends DriveState {
  final List<dynamic> files;

  const DriveFilesLoaded(this.files);

  @override
  List<Object?> get props => [files];
}

class DriveFileTextExtracted extends DriveState {
  final String fileName;
  final String extractedText;

  const DriveFileTextExtracted(this.fileName, this.extractedText);

  @override
  List<Object?> get props => [fileName, extractedText];
}

class DriveError extends DriveState {
  final String error;

  const DriveError(this.error);

  @override
  List<Object?> get props => [error];
}
