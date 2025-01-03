import 'package:equatable/equatable.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc.dart';
import 'package:new_wall_paper_app/model/word-position-model.dart';

class Voice extends Equatable {
  final List<String> languageCodes;
  final String name;
  final String ssmlGender;
  final int naturalSampleRateHertz;

  const Voice({
    required this.languageCodes,
    required this.name,
    required this.ssmlGender,
    required this.naturalSampleRateHertz,
  });

  factory Voice.fromJson(Map<String, dynamic> json) {
    return Voice(
      languageCodes: List<String>.from(json['languageCodes']),
      name: json['name'],
      ssmlGender: json['ssmlGender'],
      naturalSampleRateHertz: json['naturalSampleRateHertz'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCodes': languageCodes,
      'name': name,
      'ssmlGender': ssmlGender,
      'naturalSampleRateHertz': naturalSampleRateHertz,
    };
  }

  @override
  List<Object?> get props => [
        languageCodes,
        name,
        ssmlGender,
        naturalSampleRateHertz,
      ];
}

class TTSRequest {
  TextInput input;
  final VoiceSelectionParams voice;
  final AudioConfig audioConfig;

  TTSRequest({
    required this.input,
    required this.voice,
    required this.audioConfig,
  });

  Map<String, dynamic> toJson() {
    return {
      'input': input.toJson(),
      'voice': voice.toJson(),
      'audioConfig': audioConfig.toJson(),
    };
  }
}


class VoiceSelectionParams {
  final String languageCode;
  final String name;

  VoiceSelectionParams({
    required this.languageCode,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'name': name,
    };
  }
}

class AudioConfig {
  final String audioEncoding;
  final double? speakingRate;
  final double? pitch;
  final double? volumeGainDb;
  AudioConfig({
    required this.audioEncoding,
    this.speakingRate,
    this.pitch,
    this.volumeGainDb,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'audioEncoding': audioEncoding,
    };

    // Only add optional parameters if they are not null
    if (speakingRate != null) {
      json['speakingRate'] = speakingRate;
    }
    if (pitch != null) {
      json['pitch'] = pitch;
    }
    if (volumeGainDb != null) {
      json['volumeGainDb'] = volumeGainDb;
    }

    return json;
  }
}
