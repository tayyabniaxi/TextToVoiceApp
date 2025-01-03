// gmail_event.dart
import 'package:equatable/equatable.dart';

abstract class GmailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInEvent extends GmailEvent {}

class FetchFoldersEvent extends GmailEvent {}

class FetchMessagesEvent extends GmailEvent {
  final String folderId;
  final String accessToken;
  final bool isFirstLoad;

  FetchMessagesEvent(this.folderId, this.accessToken,
      {this.isFirstLoad = false});

  @override
  List<Object?> get props => [folderId, accessToken, isFirstLoad];
}
class StarMessageEvent extends GmailEvent {
  final String messageId;
  final String accessToken;
  final bool star; // true to star, false to unstar

  StarMessageEvent(this.messageId, this.accessToken, {this.star = true});

  @override
  List<Object?> get props => [messageId, accessToken, star];
}