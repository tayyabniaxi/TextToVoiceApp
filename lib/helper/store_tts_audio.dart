import 'dart:io';
import 'package:new_wall_paper_app/model/tts_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AudioStorageHelper {
  static const String _audioListKey = 'saved_audio_recordings';

  static String _generateTextHash(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  static Future<Directory> get _localAudioDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/AudioRecordings');

    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    return audioDir;
  }

  static Future<Map<String, dynamic>> saveAudioRecording({
    required String text,
    required List<int> audioBytes,
    Voice? selectedVoice,
    double? speechRate,
  }) async {
    final textHash = _generateTextHash(text);
    final fileName = 'audio_$textHash.mp3';

    final audioDir = await _localAudioDirectory;
    final filePath = '${audioDir.path}/$fileName';

    final audioFile = File(filePath);
    await audioFile.writeAsBytes(audioBytes);

    final recording = {
      'id': textHash,
      'text': text,
      'filePath': filePath,
      'createdAt': DateTime.now().toIso8601String(),
      'voiceName': selectedVoice?.name ?? '',
      'speechRate': speechRate ?? 1.0,
    };

    final prefs = await SharedPreferences.getInstance();

    final existingRecordingsJson = prefs.getStringList(_audioListKey) ?? [];

    final updatedRecordingsJson = existingRecordingsJson.where((json) {
      final recording = jsonDecode(json);
      return recording['id'] != textHash;
    }).toList();

    updatedRecordingsJson.add(jsonEncode(recording));

    await prefs.setStringList(_audioListKey, updatedRecordingsJson);

    return recording;
  }

  static Future<Map<String, dynamic>?> findExistingRecording(
      {required String text, required double speechRate}) async {
    final prefs = await SharedPreferences.getInstance();
    final recordingsJson = prefs.getStringList(_audioListKey) ?? [];

    final textHash = _generateTextHash(text);

    final recordings = recordingsJson.map((r) => jsonDecode(r));

    return recordings.firstWhere(
        (recording) =>
            recording['id'] == textHash &&
            (recording['speechRate'] as double).toStringAsFixed(1) ==
                speechRate.toStringAsFixed(1),
        orElse: () => null);
  }

  static Future<void> deleteExistingRecordings(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final recordingsJson = prefs.getStringList(_audioListKey) ?? [];

    final textHash = _generateTextHash(text);

    final updatedRecordingsJson = recordingsJson.where((json) {
      final recording = jsonDecode(json);
      return recording['id'] != textHash;
    }).toList();

    await prefs.setStringList(_audioListKey, updatedRecordingsJson);
  }

  static Future<void> clearAllAudioRecordings() async {
    final prefs = await SharedPreferences.getInstance();

    final recordingsJson = prefs.getStringList(_audioListKey) ?? [];

    for (var recordingJson in recordingsJson) {
      final recording = json.decode(recordingJson) as Map<String, dynamic>;
      final file = File(recording['filePath']);

      if (file.existsSync()) {
        try {
          await file.delete();
        } catch (e) {
          print('Error deleting file: ${file.path}');
        }
      }
    }

    await prefs.remove(_audioListKey);
  }
}


class TTSAudioStorageHelper {
  static const String _audioListKey = 'tts_audio_recordings';

  static String generateTextHash(String text, {
    double? speechRate, 
    String? voiceName, 
    double? pitch, 
    double? volume
  }) {
    final hashInput = '$text-$speechRate-$voiceName-$pitch-$volume';
    return md5.convert(utf8.encode(hashInput)).toString();
  }

  static Future<Directory> get _localAudioDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/TTSAudioRecordings');
    
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    
    return audioDir;
  }

  static Future<Map<String, dynamic>> saveAudioRecording({
    required String text, 
    required List<int> audioBytes,
    required String textHash,
    double? speechRate,
    String? voiceName,
    double? pitch,
    double? volume,
  }) async {
    final fileName = 'audio_$textHash.mp3';

    final audioDir = await _localAudioDirectory;
    final filePath = '${audioDir.path}/$fileName';

    final audioFile = File(filePath);
    await audioFile.writeAsBytes(audioBytes);

    final recording = {
      'id': textHash,
      'text': text,
      'filePath': filePath,
      'createdAt': DateTime.now().toIso8601String(),
      'speechRate': speechRate,
      'voiceName': voiceName,
      'pitch': pitch,
      'volume': volume,
    };

    final prefs = await SharedPreferences.getInstance();
    
    final existingRecordingsJson = prefs.getStringList(_audioListKey) ?? [];
    
    final updatedRecordingsJson = existingRecordingsJson
        .where((json) {
          final recording = jsonDecode(json);
          return recording['id'] != textHash;
        })
        .toList();
    
    updatedRecordingsJson.add(jsonEncode(recording));
    
    await prefs.setStringList(_audioListKey, updatedRecordingsJson);

    return recording;
  }

  static Future<Map<String, dynamic>?> findExistingRecording({
    required String text,
    double? speechRate,
    String? voiceName,
    double? pitch,
    double? volume,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final recordingsJson = prefs.getStringList(_audioListKey) ?? [];
    
    final textHash = generateTextHash(
      text, 
      speechRate: speechRate,
      voiceName: voiceName,
      pitch: pitch,
      volume: volume
    );

    final recordings = recordingsJson.map((r) => jsonDecode(r));
    
    return recordings.firstWhere(
      (recording) => recording['id'] == textHash, 
      orElse: () => null
    );
  }

  static List<Duration> calculateWordTimings(String text, Duration totalDuration) {
    List<String> words = text.split(' ');
    int totalCharacters = text.replaceAll(' ', '').length;
    double msPerCharacter = totalDuration.inMilliseconds / totalCharacters;

    List<Duration> startTimes = [Duration.zero];
    Duration cumulativeDuration = Duration.zero;

    for (String word in words) {
      cumulativeDuration +=
          Duration(milliseconds: (word.length * msPerCharacter).round());
      startTimes.add(cumulativeDuration);
    }

    return startTimes;
  }

  static Future<void> clearAllAudioRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final recordingsJson = prefs.getStringList(_audioListKey) ?? [];
    
    for (var recordingJson in recordingsJson) {
      final recording = json.decode(recordingJson) as Map<String, dynamic>;
      final file = File(recording['filePath']);
      
      if (file.existsSync()) {
        try {
          await file.delete();
        } catch (e) {
          print('Error deleting file: ${file.path}');
        }
      }
    }

    await prefs.remove(_audioListKey);
  }
}