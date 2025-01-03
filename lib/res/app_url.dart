// class Apis {
//   static const String cloudApi = "AIzaSyDiuMO-8jjb4hCgI8y4rPi_QNcTPE43pNE";

//   static const String cloudVoiceApi =
//       "https://texttospeech.googleapis.com/v1/voices";
//   static String uri = 'http://192.168.43.72:3000';
//   // gmail api
//   static const String gmailLabels =
//       "https://www.googleapis.com/gmail/v1/users/me/labels/";
//   static const String gmailMessageLabelId =
//       "https://www.googleapis.com/gmail/v1/users/me/messages?labelIds=";
//   static const String gmailReadOnly =
//       "https://www.googleapis.com/auth/gmail.readonly";
//   static const String gmailMessage =
//       "https://www.googleapis.com/gmail/v1/users/me/messages/";

//   static const String cloudTextToSpeechApi =
//       "https://texttospeech.googleapis.com/v1/text:synthesize";
//   static const String summarize =
//       "https://api-name.googleapis.com/v1/summarize";

//   static const String geminiProSummarizeApis =
//       "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent";
// }

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Apis {
  static String get cloudApi => dotenv.env['CLOUD_API'] ?? '';
  static String get cloudVoiceApi => dotenv.env['CLOUD_VOICE_API'] ?? '';
  static String get gmailLabels => dotenv.env['GMAIL_LABELS'] ?? '';
  static String get gmailMessageLabelId =>
      dotenv.env['GMAIL_MESSAGE_LABEL_ID'] ?? '';
  static String get gmailReadOnly => dotenv.env['GMAIL_READONLY'] ?? '';
  static String get gmailMessage => dotenv.env['GMAIL_MESSAGE'] ?? '';
  static String get cloudTextToSpeechApi =>
      dotenv.env['CLOUD_TEXT_TO_SPEECH_API'] ?? '';
  static String get summarize => dotenv.env['SUMMARIZE_API'] ?? '';
  static String get geminiProSummarizeApis =>
      dotenv.env['GEMINI_PRO_SUMMARIZE_APIS'] ?? '';

}
