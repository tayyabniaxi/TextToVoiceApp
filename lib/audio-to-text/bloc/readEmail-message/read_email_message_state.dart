// gmail_state.dart
import 'package:equatable/equatable.dart';
import 'package:new_wall_paper_app/model/readEmail_modelClass.dart';

abstract class GmailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GmailInitial extends GmailState {}

class GmailLoading extends GmailState {}

class GmailSignedIn extends GmailState {
  final List<GmailMessage> folders;
  final List<GmailMessage> messages;
  final String selectedFolder;
  final bool hasMoreMessages;
  final bool isLoadingMessages; // Add this field

  GmailSignedIn({
    required this.folders,
    this.messages = const [],
    this.selectedFolder = 'INBOX',
    this.hasMoreMessages = false,
    this.isLoadingMessages = false, // Initialize it
  });

  @override
  List<Object?> get props =>
      [folders, messages, selectedFolder, hasMoreMessages, isLoadingMessages];

  GmailSignedIn copyWith({
    List<GmailMessage>? folders,
    List<GmailMessage>? messages,
    String? selectedFolder,
    bool? hasMoreMessages,
    bool? isLoadingMessages,
  }) {
    return GmailSignedIn(
      folders: folders ?? this.folders,
      messages: messages ?? this.messages,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
    );
  }
}

class GmailFoldersError extends GmailState {
  final String message;

  GmailFoldersError(this.message);

  @override
  List<Object?> get props => [message];
}

class GmailMessagesLoaded extends GmailState {
  final List<GmailMessage> messages;
  final bool hasMore;

  GmailMessagesLoaded(this.messages, {this.hasMore = true});

  @override
  List<Object> get props => [messages, hasMore];
}
