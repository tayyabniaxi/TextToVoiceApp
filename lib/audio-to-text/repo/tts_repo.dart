import 'dart:async';
import 'dart:convert';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:new_wall_paper_app/model/tts_model.dart';
import 'package:new_wall_paper_app/res/app_url.dart';

class TtsRepo {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Future<List<Voice>> fetchVoices() async {
    try {
      final response = await http.get(
        Uri.parse('${Apis.cloudVoiceApi}?key=${Apis.cloudApi}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> voiceData = data['voices'];
        print("jjjjjjjjjjjjjjjjjjjj:${voiceData}");
        return voiceData.map((voice) => Voice.fromJson(voice)).toList();
      } else {
        throw Exception('Failed to load voices: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching voices: $e');
    }
  }

  Future<String> textToSpeech(TTSRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${Apis.cloudTextToSpeechApi}?key=${Apis.cloudApi}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['audioContent'];
      } else {
        throw Exception('Failed to convert text to speech: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error converting text to speech: $e');
    }
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }
  // // Method to stop speech
  // Future<void> stop() async {
  //   await _flutterTts.stop();
  // }
}
