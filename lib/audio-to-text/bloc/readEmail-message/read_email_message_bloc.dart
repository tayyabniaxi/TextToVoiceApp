// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';
import 'package:new_wall_paper_app/res/app_url.dart';
import 'dart:convert';

import 'read_email_message_event.dart';
import 'read_email_message_state.dart';
import 'package:new_wall_paper_app/model/readEmail_modelClass.dart';

class GmailBloc extends Bloc<GmailEvent, GmailState> {
  String? nextPageToken;
  bool isLoadingMore = false;
  List<AttachmentInfo> attachments = [];
  String selectedFilter = 'INBOX';

  static const int messagesPerPage = 15;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/gmail.readonly',
      'https://www.googleapis.com/auth/gmail.modify',
      'https://www.googleapis.com/auth/gmail.labels',
    ],
  );

  GmailBloc() : super(GmailInitial()) {
    on<SignInEvent>(_onSignIn);
    on<FetchFoldersEvent>(_onFetchFolders);
    on<FetchMessagesEvent>(_onFetchMessages);
    on<StarMessageEvent>(_onStarMessage);
  }
  Future<void> _onStarMessage(
      StarMessageEvent event, Emitter<GmailState> emit) async {
    try {
      final currentState = state;
      if (currentState is GmailSignedIn) {
        // Update local state first for immediate feedback
        final updatedMessages = currentState.messages.map((message) {
          if (message.id == event.messageId) {
            return message.copyWith(isStarred: event.star);
          }
          return message;
        }).toList();

        emit(currentState.copyWith(messages: updatedMessages));

        // Call Gmail API to modify labels
        final response = await http.post(
          Uri.parse(
              'https://gmail.googleapis.com/gmail/v1/users/me/messages/${event.messageId}/modify'),
          headers: {
            'Authorization': 'Bearer ${event.accessToken}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'addLabelIds': event.star ? ['STARRED'] : [],
            'removeLabelIds': event.star ? [] : ['STARRED'],
          }),
        );

        if (response.statusCode == 200) {
          // If in STARRED folder and unstarring, remove the message
          if (currentState.selectedFolder == 'STARRED' && !event.star) {
            final filteredMessages = updatedMessages
                .where((msg) => msg.id != event.messageId)
                .toList();
            emit(currentState.copyWith(messages: filteredMessages));
          }
        } else {
          print('Failed to update star status: ${response.body}');
          // Revert the local state if API call failed
          final revertedMessages = currentState.messages.map((message) {
            if (message.id == event.messageId) {
              return message.copyWith(isStarred: !event.star);
            }
            return message;
          }).toList();
          emit(currentState.copyWith(messages: revertedMessages));
        }
      }
    } catch (error) {
      print('Error starring message: $error');
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<GmailState> emit) async {
    emit(GmailLoading());

    try {
      final account = await googleSignIn.signIn();
      if (account != null) {
        final auth = await account.authentication;
        // First emit signed in state with empty folders
        emit(GmailSignedIn(folders: []));
        // Then fetch folders
        await _fetchFolders(auth.accessToken!, emit);
      } else {
        emit(GmailFoldersError('Sign-in failed.'));
      }
    } catch (error) {
      emit(GmailFoldersError('Error signing in: $error'));
    }
  }

  Future<void> _onFetchFolders(
      FetchFoldersEvent event, Emitter<GmailState> emit) async {
    emit(GmailLoading());

    try {
      final account = await googleSignIn.signInSilently();
      if (account != null) {
        final auth = await account.authentication;
        await _fetchFolders(auth.accessToken!, emit);
      } else {
        emit(GmailFoldersError('User not signed in'));
      }
    } catch (error) {
      emit(GmailFoldersError('Error fetching folders: $error'));
    }
  }

/*
// correct
  Future<void> _fetchFolders(
      String accessToken, Emitter<GmailState> emit) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.googleapis.com/gmail/v1/users/me/labels'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<GmailMessage> folders = [];

        for (var folder in data['labels']) {
          final messageCountResponse = await http.get(
            Uri.parse(
                'https://www.googleapis.com/gmail/v1/users/me/labels/${folder['id']}'),
            headers: {'Authorization': 'Bearer $accessToken'},
          );

          if (messageCountResponse.statusCode == 200) {
            final countData = json.decode(messageCountResponse.body);
            folders.add(GmailMessage(
              id: folder['id'],
              subject: folder['name'],
              messageCount: countData['messagesTotal'] ?? 0,
            ));
          }
        }

        emit(GmailSignedIn(folders));
      } else {
        emit(GmailFoldersError('Failed to load labels: ${response.body}'));
      }
    } catch (error) {
      emit(GmailFoldersError('Error fetching folders: $error'));
    }
  }
*/
  Future<void> _fetchFolders(
      String accessToken, Emitter<GmailState> emit) async {
    try {
      final response = await http.get(
        Uri.parse('${Apis.gmailLabels}'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<GmailMessage> folders = [];

        final allowedFolders = [
          'INBOX',
          'UNREAD',
          'SPAM',
          'IMPORTANT',
          'STARRED'
        ];

        for (var folder in data['labels']) {
          if (allowedFolders.contains(folder['id'])) {
            final messageCountResponse = await http.get(
              Uri.parse('${Apis.gmailLabels}${folder['id']}'),
              headers: {'Authorization': 'Bearer $accessToken'},
            );

            if (messageCountResponse.statusCode == 200) {
              final countData = json.decode(messageCountResponse.body);
              String displayName = folder['name'];

              switch (folder['id']) {
                case 'INBOX':
                  displayName = 'Inbox';
                  break;
                case 'UNREAD':
                  displayName = 'Unread';
                  break;
                case 'SPAM':
                  displayName = 'Spam';
                  break;
                case 'IMPORTANT':
                  displayName = 'Important';
                  break;
                case 'STARRED':
                  displayName = 'Starred';
                  break;
              }

              folders.add(GmailMessage(
                attachments: attachments,
                id: folder['id'],
                subject: displayName,
                messageCount: countData['messagesTotal'] ?? 0,
                isStarred: false, 
                hasAttachments: false,
              ));
            }
          }
        }

        final currentState = state;
        if (currentState is GmailSignedIn) {
          emit(currentState.copyWith(folders: folders));
        } else {
          emit(GmailSignedIn(folders: folders));
        }

        add(FetchMessagesEvent('INBOX', accessToken, isFirstLoad: true));
      } else {
        emit(GmailFoldersError('Failed to load labels: ${response.body}'));
      }
    } catch (error) {
      emit(GmailFoldersError('Error fetching folders: $error'));
    }
  }

  Future<void> _onFetchMessages(
      FetchMessagesEvent event, Emitter<GmailState> emit) async {
    final currentState = state;
    if (event.isFirstLoad) {
      if (currentState is GmailSignedIn) {
        // Show loading state when changing folders
        emit(currentState.copyWith(
          messages: [],
          selectedFolder: event.folderId,
          hasMoreMessages: false,
          isLoadingMessages: true, 
        ));
      }
      nextPageToken = null;
    }

    if (isLoadingMore) return;
    isLoadingMore = true;

    try {
      String queryParam = '';
      if (event.folderId == 'STARRED') {
        queryParam = '&q=is:starred';
      }

      final url = Uri.parse('${Apis.gmailMessageLabelId}${event.folderId}'
          '&maxResults=${GmailBloc.messagesPerPage}'
          '$queryParam'
          '${nextPageToken != null ? "&pageToken=$nextPageToken" : ""}');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${event.accessToken}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!data.containsKey('messages')) {
          if (currentState is GmailSignedIn) {
            emit(currentState.copyWith(
              messages: [],
              hasMoreMessages: false,
              selectedFolder: event.folderId,
              isLoadingMessages: false, 
            ));
          }
          return;
        }

        final messageList = data['messages'] as List;
        final futures = messageList.map((message) =>
            _fetchMessageDetails(event.accessToken, message['id']));

        final messages = await Future.wait(futures);
        final hasMore = data['nextPageToken'] != null &&
            messageList.length >= GmailBloc.messagesPerPage;
        nextPageToken = hasMore ? data['nextPageToken'] : null;

        if (currentState is GmailSignedIn) {
          if (event.isFirstLoad) {
            emit(currentState.copyWith(
              messages: messages,
              selectedFolder: event.folderId,
              hasMoreMessages: hasMore,
              isLoadingMessages: false, 
            ));
          } else {
            emit(currentState.copyWith(
              messages: [...currentState.messages, ...messages],
              hasMoreMessages: hasMore,
              selectedFolder: event.folderId,
              isLoadingMessages: false,
            ));
          }
        }
      }
    } catch (error) {
      if (currentState is GmailSignedIn) {
        emit(currentState.copyWith(
          messages: [],
          hasMoreMessages: false,
          selectedFolder: event.folderId,
          isLoadingMessages: false, // Set loading to false on error
        ));
      }
    } finally {
      isLoadingMore = false;
    }
  }

  List<AttachmentInfo> _extractAttachments(dynamic payload) {
    List<AttachmentInfo> attachments = [];

    if (payload['parts'] != null) {
      void processPayloadPart(dynamic part) {
        if (part['mimeType'] != 'text/plain' &&
            part['mimeType'] != 'text/html' &&
            part['filename'] != null &&
            part['filename'].toString().isNotEmpty) {
          attachments.add(AttachmentInfo(
            filename: part['filename'],
            mimeType: part['mimeType'],
          ));
        }

        // Check for nested parts
        if (part['parts'] != null) {
          for (var nestedPart in part['parts']) {
            processPayloadPart(nestedPart);
          }
        }
      }

      for (var part in payload['parts']) {
        processPayloadPart(part);
      }
    }

    return attachments;
  }

  Future<GmailMessage> _fetchMessageDetails(
      String accessToken, String messageId) async {
    try {
      final response = await http.get(
        Uri.parse('${Apis.gmailMessage}$messageId?format=full'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final headers = data['payload']['headers'] as List<dynamic>;

        final subjectHeader = headers.firstWhere(
          (header) => header['name'] == 'Subject',
          orElse: () => {'value': 'No Subject'},
        );

        final dateHeader = headers.firstWhere(
          (header) => header['name'] == 'Date',
          orElse: () => {'value': null},
        );

        DateTime? timestamp;
        if (dateHeader['value'] != null) {
          try {
            timestamp = DateTime.parse(dateHeader['value']);
          } catch (e) {
            try {
              timestamp = data['internalDate'] != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      int.parse(data['internalDate']))
                  : null;
            } catch (_) {
              timestamp = null;
            }
          }
        }

        // Safe body extraction
        String body = 'No Body Content';
        bool hasAttachments = false;
        List<AttachmentInfo> attachments = [];

        try {
          if (data['payload']['parts'] != null) {
            final parts = data['payload']['parts'] as List<dynamic>;

            // Extract attachments safely
            for (var part in parts) {
              if (part['filename'] != null &&
                  part['filename'].toString().isNotEmpty &&
                  part['mimeType'] != null) {
                attachments.add(AttachmentInfo(
                  filename: part['filename'].toString(),
                  mimeType: part['mimeType'].toString(),
                ));
              }
            }

            hasAttachments = attachments.isNotEmpty;

            // Try to find text content
            final textPart = parts.firstWhere(
              (part) =>
                  part['mimeType'] == 'text/plain' ||
                  part['mimeType'] == 'text/html',
              orElse: () => null,
            );

            if (textPart != null &&
                textPart['body'] != null &&
                textPart['body']['data'] != null) {
              try {
                final bodyData = textPart['body']['data'].toString();
                body = _safeBase64Decode(bodyData);
              } catch (e) {
                print('Error decoding message body: $e');
                body = 'Error loading message content';
              }
            }
          } else if (data['payload']['body'] != null &&
              data['payload']['body']['data'] != null) {
            try {
              final bodyData = data['payload']['body']['data'].toString();
              body = _safeBase64Decode(bodyData);
            } catch (e) {
              print('Error decoding message body: $e');
              body = 'Error loading message content';
            }
          }
        } catch (e) {
          print('Error processing message parts: $e');
          body = 'Error loading message content';
        }

        final labelIds = (data['labelIds'] as List<dynamic>?) ?? [];
        final isStarred = labelIds.contains('STARRED');
        String? profileImage;
        if (data['payload']['parts'] != null) {
          final parts = data['payload']['parts'] as List<dynamic>;
          final photoPartIndex = parts.indexWhere((part) =>
              part['filename'] != null &&
              part['filename'].toString().contains('Photo'));
          if (photoPartIndex != -1) {
            final photoPartData = parts[photoPartIndex];
            if (photoPartData['body'] != null &&
                photoPartData['body']['attachmentId'] != null) {
              final attachmentId = photoPartData['body']['attachmentId'];
              profileImage =
                  '${Apis.gmailMessage}$messageId/attachments/$attachmentId?alt=media';
            }
          }
        }
        return GmailMessage(
          id: data['id'] ?? '',
          subject: subjectHeader['value'] ?? 'No Subject',
          body: body,
          isStarred: isStarred,
          hasAttachments: hasAttachments,
          timestamp: timestamp,
          attachments: attachments,
          profileImage: profileImage, // Assign the profile image URL
        );
      } else {
        throw Exception('Failed to fetch message details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching message details: $e');
      // Return a fallback message instead of throwing
      return GmailMessage(
          id: messageId,
          subject: 'Error loading message',
          body: 'Could not load message content',
          isStarred: false,
          hasAttachments: false,
          attachments: attachments);
    }
  }

// Add this helper method for safe base64 decoding
  String _safeBase64Decode(String input) {
    try {
      // Add padding if needed
      final padded = input.replaceAll('-', '+').replaceAll('_', '/');
      final paddingLength = 4 - (padded.length % 4);
      final fullPadded = padded + ('=' * (paddingLength % 4));

      // Try to decode
      return utf8.decode(base64.decode(fullPadded), allowMalformed: true);
    } catch (e) {
      print('Base64 decode error: $e');
      return 'Error decoding message content';
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    emit(GmailInitial());
  }
}
