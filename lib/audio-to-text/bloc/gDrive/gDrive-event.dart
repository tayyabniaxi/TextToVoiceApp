import 'package:equatable/equatable.dart';

abstract class DriveEvent extends Equatable {
  const DriveEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends DriveEvent {}

class FetchFoldersEvent extends DriveEvent {
  final String accessToken;

  const FetchFoldersEvent(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

class FetchFilesEvent extends DriveEvent {
  final String folderId;
  final String accessToken;

  const FetchFilesEvent(this.folderId, this.accessToken);

  @override
  List<Object?> get props => [folderId, accessToken];
}

class ProcessFileEvent extends DriveEvent {
  final String fileId;
  final String fileName;
  final String mimeType;
  final String accessToken;

  const ProcessFileEvent(
      this.fileId, this.fileName, this.mimeType, this.accessToken);

  @override
  List<Object?> get props => [fileId, fileName, mimeType, accessToken];
}
