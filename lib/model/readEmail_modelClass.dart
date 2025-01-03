// class GmailMessage {
//   final String id;
//   final String subject;
//   final String body;

//   GmailMessage({
//     required this.id,
//     required this.subject,
//     required this.body,
//   });

//   factory GmailMessage.fromJson(Map<String, dynamic> json) {
//     return GmailMessage(
//       id: json['id'],
//       subject: json['subject'] ?? 'No Subject',
//       body: json['body'] ?? 'No Body Content',
//     );
//   }
// }

// class GmailMessage {
//   final String id;
//   final String subject;
//   final dynamic body;
//   final List<String>? from;
//   final DateTime? date;
//   final bool hasAttachment;
//   final String? snippet;
//   final bool isRead;
//   final bool isStarred;
//   final int messageCount;

//   GmailMessage({
//     required this.id,
//     required this.subject,
//     this.body,
//     this.from,
//     this.date,
//     this.hasAttachment = false,
//     this.snippet,
//     this.isRead = false,
//     this.isStarred = false,
//     this.messageCount = 0,
//   });

//   factory GmailMessage.fromJson(Map<String, dynamic> json) {
//     return GmailMessage(
//       id: json['id'] ?? '',
//       subject: json['subject'] ?? 'No Subject',
//       body: json['body'],
//       from: (json['from'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       date: json['date'] != null
//           ? DateTime.tryParse(json['date'])
//           : DateTime.now(),
//       hasAttachment: json['hasAttachment'] ?? false,
//       snippet: json['snippet'] ?? '',
//       isRead: json['isRead'] ?? false,
//       isStarred: json['isStarred'] ?? false,
//       messageCount: json['messageCount'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'subject': subject,
//       'body': body,
//       'from': from,
//       'date': date?.toIso8601String(),
//       'hasAttachment': hasAttachment,
//       'snippet': snippet,
//       'isRead': isRead,
//       'isStarred': isStarred,
//       'messageCount': messageCount,
//     };
//   }

//   GmailMessage copyWith({
//     String? id,
//     String? subject,
//     dynamic body,
//     List<String>? from,
//     DateTime? date,
//     bool? hasAttachment,
//     String? snippet,
//     bool? isRead,
//     bool? isStarred,
//     int? messageCount,
//   }) {
//     return GmailMessage(
//       id: id ?? this.id,
//       subject: subject ?? this.subject,
//       body: body ?? this.body,
//       from: from ?? this.from,
//       date: date ?? this.date,
//       hasAttachment: hasAttachment ?? this.hasAttachment,
//       snippet: snippet ?? this.snippet,
//       isRead: isRead ?? this.isRead,
//       isStarred: isStarred ?? this.isStarred,
//       messageCount: messageCount ?? this.messageCount,
//     );
//   }

//   // Helper method to get display body
//   String getDisplayBody() {
//     if (body is String) {
//       return body as String;
//     } else if (body is int) {
//       return '$body messages'; // For folder message count
//     }
//     return '';
//   }

//   @override
//   String toString() {
//     return 'GmailMessage{'
//         'id: $id, '
//         'subject: $subject, '
//         'body: $body, '
//         'messageCount: $messageCount}';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is GmailMessage &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           subject == other.subject;

//   @override
//   int get hashCode => id.hashCode ^ subject.hashCode;
// }

// class GmailMessage {
//   final String id;
//   final String subject;
//   final String? body;
//   final int messageCount;

//   GmailMessage({
//     required this.id,
//     required this.subject,
//     this.body,
//     this.messageCount = 0,
//   });
// }

// First, update the GmailMessage model
import 'package:new_wall_paper_app/audio-to-text/bloc/readEmail-message/read_email_message_event.dart';

class AttachmentInfo {
  final String filename;
  final String mimeType;

  AttachmentInfo({
    required this.filename,
    required this.mimeType,
  });
}

class GmailMessage {
  final String id;
  final String subject;
  final String? body;
  final int messageCount;
  final bool isStarred;
  final bool hasAttachments;
  final DateTime? timestamp;
  final List<AttachmentInfo> attachments;
  final String? profileImage; // Add this line

  GmailMessage({
    required this.id,
    required this.subject,
    this.body,
    this.messageCount = 0,
    required this.isStarred,
    required this.hasAttachments,
    this.timestamp,
    required this.attachments,
    this.profileImage, // Add this line
  });

  GmailMessage copyWith({
    String? id,
    String? subject,
    String? body,
    bool? isStarred,
    bool? hasAttachments,
    int? messageCount,
    DateTime? timestamp,
    List<AttachmentInfo>? attachments,
    String? profileImage, // Add this line
  }) {
    return GmailMessage(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      messageCount: messageCount ?? this.messageCount,
      isStarred: isStarred ?? this.isStarred,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      profileImage: profileImage ?? this.profileImage, // Add this line
    );
  }
}
