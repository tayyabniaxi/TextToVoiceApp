import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_state.dart';

class AudioDownloadFileList extends StatelessWidget {
  const AudioDownloadFileList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
  builder: (context, state) {
    if (state.savedFilePath.isNotEmpty) {
      return Column(
        children: [
          Text("Audio saved at: ${state.savedFilePath}"),
          
        ],
      );
    }
    return Container();
  },
)
    );
  }
}
