// Create a RenameBottomSheet widget
// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_final_fields, sort_child_properties_last, deprecated_member_use, prefer_const_declarations, unused_local_variable, unused_element, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_state.dart';
import 'package:new_wall_paper_app/audio-to-text/page/show-history.dart';

import 'package:new_wall_paper_app/component/button_widget.dart';
import 'package:new_wall_paper_app/component/timer_Circle.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

List<String> iconList = [
  AppImage.edit,
  AppImage.edit,
  AppImage.auto_skip,
  AppImage.sleep_time,
  AppImage.feedback,
  AppImage.visible,
];

List<String> titleList = [
  "History",
  "download audio",
  "Auto Skip Content",
  "Sleep timer",
  "feedback",
  "Auto-Hide Player",
];
List<String> desList = [
  "History check and Enjoy",
  "Listen with the best Voice Offline ",
  "Headers, Footers, Citations, Etc.",
  "add a sleep timer",
  "add user feedback and enjoy",
  "Hider your player automatically",
];
bool isSwitched = false;

class AudioFormatBottomSheet extends StatelessWidget {
  final Function(String) onFormatSelect;

  const AudioFormatBottomSheet({Key? key, required this.onFormatSelect})
      : super(key: key);

  String _calculateSize(String format, int textLength) {
    final Map<String, double> sizeMultipliers = {
      '.MP3': 0.16,
      '.WAV': 0.48,
      '.OGG': 0.24,
      '.M4A': 0.20,
    };

    final double wordsPerMinute = 150;
    final double minutes = textLength / 5 / wordsPerMinute;
    final double sizeInKB = minutes * 60 * (sizeMultipliers[format] ?? 0.16);

    if (sizeInKB > 1024) {
      return '${(sizeInKB / 1024).toStringAsFixed(1)} MB';
    }
    return '${sizeInKB.toStringAsFixed(1)} KB';
  }

  Map<String, String> _getFormatDetails(String format, int textLength) {
    final Map<String, String> bitrates = {
      '.MP3': '128 kbps',
      '.WAV': '384 kbps',
      '.OGG': '192 kbps',
      '.M4A': '160 kbps',
    };

    return {
      'bitrate': bitrates[format] ?? '128 kbps',
      'size': _calculateSize(format, textLength)
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
      builder: (context, state) {
        final textLength = state.summarizedText.isEmpty
            ? state.normarlText.length
            : state.summarizedText.length;
        final formats = ['.MP3', '.WAV', '.OGG', '.M4A'];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("      "),
                    Text('Download audio',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: AppFont.robot,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: formats.length,
                  itemBuilder: (context, index) {
                    final format = formats[index];
                    final details = _getFormatDetails(format, textLength);
                    return _buildFormatTile(context, format,
                        details['bitrate']! + ' · ' + details['size']!, state);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormatTile(BuildContext context, String format, String quality,
      TextToSpeechState state) {
    final bool isDownloading =
        state.isDownloadingFormat && state.selectedAudioFormat == format;

    return ListTile(
        onTap: state.isDownloadingFormat
            ? null
            : () {
                onFormatSelect(format);
                Navigator.pop(context);
              },
        leading: Icon(Icons.volume_up_sharp),
        title: Text(format),
        subtitle: Text(quality),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: MediaQuery.of(context).size.height * 0.03,
        ));
  }
}

class OpenAllFuctinoBottomSheetWidget extends StatelessWidget {
  final Function(String) onFormatSelect;

  const OpenAllFuctinoBottomSheetWidget({
    Key? key,
    required this.onFormatSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.96,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              height(size: 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
                                builder: (context, state) {
                              return CommonText(
                                  title:
                                      state.currentFileName ?? 'Untitled Text',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  size: 0.022);
                            }),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                SvgPicture.asset(AppImage.pdf_pic),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlocBuilder<TextToSpeechBloc,
                                            TextToSpeechState>(
                                        builder: (context, state) {
                                      return CommonText(
                                          title: context
                                              .read<TextToSpeechBloc>()
                                              .getFileName(),
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          size: 0.022);
                                    }),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        BlocBuilder<TextToSpeechBloc,
                                                TextToSpeechState>(
                                            builder: (context, state) {
                                          final wordCount = state.normarlText
                                              .split(' ')
                                              .where((w) => w.isNotEmpty)
                                              .length;
                                          return CommonText(
                                              title: "$wordCount Words",
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              size: 0.016);
                                        }),
                                        Container(
                                          height: 10,
                                          width: 10,
                                          child: VerticalDivider(
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        CommonText(
                                            title: "Text to Speech",
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            size: 0.016),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            size: MediaQuery.of(context).size.height * 0.03,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              height(size: 0.04),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: iconList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistoryPage()));
                          } else if (index == 1) {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => BlocBuilder<
                                  TextToSpeechBloc, TextToSpeechState>(
                                builder: (context, state) =>
                                    AudioFormatBottomSheet(
                                  onFormatSelect: (format) {
                                    if (state.normarlText.isNotEmpty) {
                                      state.summarizedText.isNotEmpty
                                          ? context
                                              .read<TextToSpeechBloc>()
                                              .add(
                                                DownloadAudioWithFormat(
                                                    state.summarizedText,
                                                    format),
                                              )
                                          : context
                                              .read<TextToSpeechBloc>()
                                              .add(
                                                DownloadAudioWithFormat(
                                                    state.normarlText, format),
                                              );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Please enter some text')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          } else if (index == 2) {
                          } else if (index == 3) {
                            Navigator.pop(context);
                            // context
                            //     .read<TextToSpeechBloc>()
                            //     .add(WeeklySchuduleBottomSheet());

                            context
                                .read<TextToSpeechBloc>()
                                .add(OpenTimePickerEvent());
                          } else if (index == 5) {
                            Navigator.pop(context);
                            context
                                .read<TextToSpeechBloc>()
                                .add(HideShowPlayerToggle());
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: AppColor.containerColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                iconList[index],
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                              ),
                              height(size: 0.01),
                              Text(
                                titleList[index],
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.016,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              height(size: 0.007),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  desList[index],
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.015,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.primaryColor2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset(AppImage.back_music),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Column(
                            children: [
                              CommonText(
                                title: "Mix With Background Music",
                                color: Colors.white,
                                size: 0.017,
                                fontWeight: FontWeight.w600,
                              ),
                              CommonText(
                                  title: "Don’t Pause From other Apps",
                                  color: Colors.white.withOpacity(0.6),
                                  size: 0.016),
                            ],
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: isSwitched,
                          onChanged: (value) {},
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.white,
                          activeTrackColor: Colors.lightGreenAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              )
            ],
          );
        },
      ),
    );
  }
}

class SpeedRateBottomSheetWidget extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onSpeedChanged;

  const SpeedRateBottomSheetWidget({
    Key? key,
    required this.initialValue,
    required this.onSpeedChanged,
  }) : super(key: key);

  @override
  _SpeedRateBottomSheetWidgetState createState() =>
      _SpeedRateBottomSheetWidgetState();
}

class _SpeedRateBottomSheetWidgetState
    extends State<SpeedRateBottomSheetWidget> {
  final List<double> _tickValues = [1.0, 1.2, 1.5, 1.8, 2.0];
  late double _sliderValue;
  late double _pitchValue;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<TextToSpeechBloc>();
    _sliderValue = bloc.state.speechRate;
    _pitchValue = bloc.state.setPitch;
  }

  void _updatePitch(double newValue) {
    final clampedValue = newValue.clamp(0.5, 2.0);

    BlocProvider.of<TextToSpeechBloc>(context)
        .add(PitchValueChange(clampedValue));

    setState(() {
      _pitchValue = clampedValue;
    });
  }

  void _updateSpeed(double newValue) {
    setState(() {
      _sliderValue = newValue;
    });
    widget.onSpeedChanged(newValue);
  }

  Duration _baseDuration = Duration(minutes: 2, seconds: 13);

  String _getAdjustedDuration(double speed) {
    final adjustedSeconds = (_baseDuration.inSeconds / speed).round();
    final minutes = adjustedSeconds ~/ 60;
    final seconds = adjustedSeconds % 60;
    return '~${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sliderWidth = constraints.maxWidth - 32;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(size: 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: MediaQuery.of(context).size.height * 0.037,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                height(size: 0.023),

                // User Info Row
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.containerColor,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://plus.unsplash.com/premium_photo-1726743697632-5790d2ebf36b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                        radius: MediaQuery.of(context).size.height * 0.03,
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              title: "John",
                              color: Colors.black,
                              size: 0.021,
                              fontWeight: FontWeight.w600,
                              fontFamly: AppFont.robot,
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                CommonText(
                                  title: "United State .",
                                  color: Colors.grey,
                                  size: 0.016,
                                  fontWeight: FontWeight.w500,
                                ),
                                Icon(
                                  Icons.wifi_off_rounded,
                                  color: Colors.grey,
                                  size: MediaQuery.of(context).size.height *
                                      0.023,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: MediaQuery.of(context).size.height * 0.022,
                        child: Icon(Icons.play_arrow, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                height(size: 0.02),
                Row(
                  children: [
                    _buildCard(
                      title: "Normal",
                      subtitle:
                          "Duration: ${_getAdjustedDuration(_sliderValue)}",
                      isHighlighted: false,
                    ),
                  ],
                ),

                height(size: 0.045),

                CommonText(
                  title: "Pitch : ${_pitchValue.toStringAsFixed(1)}%",
                  color: Colors.black,
                  size: 0.025,
                  fontFamly: AppFont.robot,
                  fontWeight: FontWeight.w500,
                ),
                height(size: 0.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _updatePitch(_pitchValue - 0.1);
                      },
                      child: Icon(
                        Icons.remove,
                        color: AppColor.primaryColor2,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _pitchValue.clamp(0.5, 2.0),
                        min: 0.5,
                        max: 2.0,
                        onChanged: _updatePitch,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          _updatePitch(_pitchValue + 0.1);
                        },
                        child: Icon(Icons.add, color: AppColor.primaryColor2)),
                  ],
                ),
                CommonText(
                  title: "${_sliderValue.toStringAsFixed(1)}x",
                  color: AppColor.primaryColor2,
                  size: 0.05,
                  fontWeight: FontWeight.bold,
                ),

                height(size: 0.04),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final position =
                        renderBox.globalToLocal(details.globalPosition);
                    final double newValue = 1.0 + (position.dx / sliderWidth);
                    _updateSpeed(newValue.clamp(1.0, 2.0));
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          11,
                          (index) => Container(
                            width: 2,
                            height: index % 5 == 0 ? 16 : 8,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      Positioned(
                        left: ((_sliderValue - 1.0) / 1.0) * sliderWidth - 1,
                        top: -24,
                        child: Column(
                          children: [
                            Icon(Icons.arrow_drop_down,
                                color: Colors.blue, size: 24),
                            Container(
                              width: 2,
                              height: 24,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1.0', style: TextStyle(color: Colors.grey[400])),
                    Text('1.5', style: TextStyle(color: Colors.grey[600])),
                    Text('2.0', style: TextStyle(color: Colors.grey[400])),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _tickValues
                        .map((value) => InkWell(
                            onTap: () => _updateSpeed(value),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.containerColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CommonText(
                                    title: value.toString(),
                                    color: Colors.black,
                                    size: 0.02),
                              ),
                            )))
                        .toList()),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    bool isHighlighted = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          _updateSpeed(1.0);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade100,
                  offset: Offset(2, 3),
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
            color: AppColor.containerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                title: subtitle,
                color: Colors.black,
                size: 0.022,
                fontWeight: FontWeight.w500,
                fontFamly: AppFont.robot,
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFont.robot,
                  fontSize: MediaQuery.of(context).size.height * 0.023,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyScheduleWidget extends StatefulWidget {
  @override
  _WeeklyScheduleWidgetState createState() => _WeeklyScheduleWidgetState();
}

class _WeeklyScheduleWidgetState extends State<WeeklyScheduleWidget> {
  late List<Map<String, String>> currentWeekDays;

  @override
  void initState() {
    super.initState();
    currentWeekDays = getCurrentWeekDays();
    context.read<TextToSpeechBloc>().add(LoadSavedScheduleEvent());
  }

  void _refreshWeekDays() {
    setState(() {
      currentWeekDays = getCurrentWeekDays();
    });
  }

  List<Map<String, String>> getCurrentWeekDays() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday % 7));
    return List.generate(7, (index) {
      final day = firstDayOfWeek.add(Duration(days: index));
      return {
        'day': [
          'Sun',
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat'
        ][day.weekday % 7],
        'date': day.day.toString().padLeft(2, '0'),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextToSpeechBloc, TextToSpeechState>(
      listener: (context, state) {
        if (state.currentSchedule == null) {
          setState(() {
            currentWeekDays = getCurrentWeekDays();
          });
        }
      },
      builder: (context, state) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    "Weekly Schedule",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        return _buildDayColumn(index, state);
                      }),
                    ),
                  ),
                  SizedBox(height: 16),

                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGoalCard(
                        'Goal Per Day',
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.goalPerDay.isNotEmpty
                                  ? state.goalPerDay
                                  : state.currentSchedule != null
                                      ? state.currentSchedule!['goalPerDay'] ??
                                          '1 Hour'
                                      : '1 Hour',
                            ),
                            SvgPicture.asset("assets/icons/arrowIcon.svg"),
                          ],
                        ),
                        () => _showGoalSelectionSheet(context),
                      ),
                      SizedBox(width: 12),
                      _buildGoalCard(
                        'Reminder Time',
                        Text(
                          (state.selectedHour != 0 || state.selectedMinute != 0)
                              ? "${state.selectedHour.toString().padLeft(2, '0')}:${state.selectedMinute.toString().padLeft(2, '0')}"
                              : state.currentSchedule != null
                                  ? _formatTime(
                                      state.currentSchedule!['reminderTime'])
                                  : "00:00",
                          style: TextStyle(fontSize: 16),
                        ),
                        () {
                          context
                              .read<TextToSpeechBloc>()
                              .add(OpenTimePickerEvent());
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Remind Me To Read
                  _buildSettingCard(
                    'Remind Me To Read',
                    Switch(
                      value: state.remindMeToRead,
                      onChanged: (value) {
                        context
                            .read<TextToSpeechBloc>()
                            .add(ToggleRemindMeEvent(value));
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Reset All button
                  // if (state.currentSchedule != null)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       TextButton(
                  //         onPressed: () => _showResetConfirmation(context),
                  //         child: Text('Reset',
                  //             style: TextStyle(color: Colors.red)),
                  //       ),
                  //     ],
                  //   ),

                  // Save Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveSchedule(context, state),
                      child: Text(
                          state.currentSchedule == null ? 'Save ' : 'Update'),
                    ),
                  ),

                  // Saved Schedules
                  if (state.currentSchedule != null) ...[
                    SizedBox(height: 20),
                    Text(
                      'Current Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.containerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.currentSchedule!['goalPerDay'] ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                _formatDuration(Duration(
                                        hours: state.selectedHour,
                                        minutes: state.selectedMinute,
                                        seconds: state.selectedSecond) -
                                    state.elapsedTime),
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          if (state.currentSchedule!['selectedDays'] !=
                              null) ...[
                            SizedBox(height: 4),
                            Text(
                              'Days: ${(state.currentSchedule!['selectedDays'] as List<dynamic>).join(", ")}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ]
                ])));
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _formatTime(Map<String, dynamic>? timeMap) {
    if (timeMap == null) return '';
    final hour = timeMap['hour'] as int? ?? 0;
    final minute = timeMap['minute'] as int? ?? 0;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  Widget _buildDayColumn(int index, TextToSpeechState state) {
    bool isSelected = state.selectedDays.contains(index);
    return GestureDetector(
      onTap: () {
        final updatedDays = List<int>.from(state.selectedDays);
        if (isSelected) {
          updatedDays.remove(index);
        } else {
          updatedDays.add(index);
        }
        context
            .read<TextToSpeechBloc>()
            .add(UpdateSelectedDaysEvent(updatedDays));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: isSelected ? Colors.blue : Colors.transparent,
        ),
        child: Column(
          children: [
            Text(
              currentWeekDays[index]['day']!,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: Text(
                currentWeekDays[index]['date']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalSelectionSheet(BuildContext context) {
    final goals = ['30 Minutes', '1 Hour', '2 Hours', '3 Hours'];
    final currentState = context.read<TextToSpeechBloc>().state;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...goals
                .map((goal) => ListTile(
                      title: Text(goal),
                      selected: currentState.currentSchedule != null
                          ? currentState.currentSchedule!['goalPerDay'] == goal
                          : currentState.goalPerDay == goal,
                      trailing: currentState.currentSchedule != null
                          ? currentState.currentSchedule!['goalPerDay'] == goal
                              ? Icon(Icons.check, color: Colors.blue)
                              : null
                          : currentState.goalPerDay == goal
                              ? Icon(Icons.check, color: Colors.blue)
                              : null,
                      onTap: () {
                        context
                            .read<TextToSpeechBloc>()
                            .add(UpdateGoalEvent(goal));
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text('Reset Schedule'),
        content: Text(
            'Are you sure you want to reset the schedule? This will permanently delete the current schedule.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset everything
              context.read<TextToSpeechBloc>().add(ResetScheduleEvent());

              // Close dialog
              Navigator.pop(dialogContext);

              // Close bottom sheet if open
              Navigator.pop(context);
            },
            child: Text('Reset'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _saveSchedule(BuildContext context, TextToSpeechState state) {
    if (state.selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    final schedule = {
      'selectedDays': state.selectedDays,
      'goalPerDay': state.goalPerDay,
      'reminderTime': {
        'hour': state.selectedHour,
        'minute': state.selectedMinute,
      },
      'remindMeToRead': state.remindMeToRead,
      'timestamp': DateTime.now().toIso8601String(),
    };

    context.read<TextToSpeechBloc>().add(SaveCurrentScheduleEvent(
          selectedDays: state.selectedDays,
          goalPerDay: state.goalPerDay,
          reminderTime:
              TimeOfDay(hour: state.selectedHour, minute: state.selectedMinute),
          remindMeToRead: state.remindMeToRead,
          selectedHour: state.selectedHour,
          selectedMinute: state.selectedMinute,
        ));
  }

  Widget _buildSettingCard(String title, Widget trailing) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildGoalCard(String title, Widget trailing, Function() onpress) {
    return InkWell(
      onTap: onpress,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.containerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

class TimePickerBottomSheet extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay, int) onTimeSelected;

  const TimePickerBottomSheet({
    Key? key,
    required this.initialTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _TimePickerBottomSheetState createState() => _TimePickerBottomSheetState();
}

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<TextToSpeechBloc>().add(UpdateTimePickerEvent(
  //         widget.initialTime.hour,
  //         widget.initialTime.minute,
  //         0,
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
      builder: (context, state) {
        return state.isPlaying
            ? _buildTimerUI(context, state)
            : buildMainUi(context, state);
      },
    );
  }

  Container buildMainUi(BuildContext context, TextToSpeechState state) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                title: "Sleep Timer",
                color: Colors.black,
                size: 0.025,
                fontFamly: AppFont.robot,
                fontWeight: FontWeight.w600,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CommonText(
            title: "Set up custom Time",
            color: Colors.black,
            size: 0.023,
            fontFamly: AppFont.robot,
            fontWeight: FontWeight.w400,
          ),
          height(size: 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CommonText(
                title: "Hr",
                color: Colors.black,
                size: 0.025,
                fontFamly: AppFont.robot,
                fontWeight: FontWeight.w500,
              ),
              CommonText(
                title: "Min",
                color: Colors.black,
                size: 0.025,
                fontFamly: AppFont.robot,
                fontWeight: FontWeight.w500,
              ),
              CommonText(
                title: "Sec",
                color: Colors.black,
                size: 0.025,
                fontFamly: AppFont.robot,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          height(size: 0.01),
          Divider(
            thickness: 1,
            color: Colors.grey.shade100,
          ),
          height(size: 0.01),
          Container(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    controller: FixedExtentScrollController(
                      initialItem: state.selectedHour,
                    ),
                    onSelectedItemChanged: (index) {
                      context.read<TextToSpeechBloc>().add(
                            UpdateTimePickerEvent(
                              index,
                              state.selectedMinute,
                              state.selectedSecond,
                            ),
                          );
                    },
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(
                        24,
                        (index) => Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: state.selectedHour == index
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 22,
                                color: state.selectedHour == index
                                    ? Colors.blue
                                    : Colors.black54,
                                fontWeight: state.selectedHour == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: AppFont.robot,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    controller: FixedExtentScrollController(
                      initialItem: state.selectedMinute,
                    ),
                    onSelectedItemChanged: (index) {
                      context.read<TextToSpeechBloc>().add(
                            UpdateTimePickerEvent(
                              state.selectedHour,
                              index,
                              state.selectedSecond,
                            ),
                          );
                    },
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(
                        60,
                        (index) => Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: state.selectedMinute == index
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 22,
                                color: state.selectedMinute == index
                                    ? Colors.blue
                                    : Colors.black54,
                                fontWeight: state.selectedMinute == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: AppFont.robot,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    controller: FixedExtentScrollController(
                      initialItem: state.selectedSecond,
                    ),
                    onSelectedItemChanged: (index) {
                      context.read<TextToSpeechBloc>().add(
                            UpdateTimePickerEvent(
                              state.selectedHour,
                              state.selectedMinute,
                              index,
                            ),
                          );
                    },
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: List.generate(
                        60,
                        (index) => Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: state.selectedSecond == index
                                  ? Colors.blue.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 22,
                                color: state.selectedSecond == index
                                    ? Colors.blue
                                    : Colors.black54,
                                fontWeight: state.selectedSecond == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontFamily: AppFont.robot,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          height(size: 0.032),
          /*
          ElevatedButton(
            onPressed: () {
              final newDuration = Duration(
                hours: state.selectedHour,
                minutes: state.selectedMinute,
                seconds: state.selectedSecond,
              );
              context.read<TextToSpeechBloc>().add(UpdateTimePickerEvent(
                    state.selectedHour,
                    state.selectedMinute,
                    state.selectedSecond,
                  ));
              context.read<TextToSpeechBloc>().add(StartCountdownEvent(duration: newDuration,reminderTime: ,));
              widget.onTimeSelected(
                TimeOfDay(
                    hour: state.selectedHour, minute: state.selectedMinute),
                state.selectedSecond,
              );
              Navigator.pop(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Start',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
       
        */

          BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  final newDuration = Duration(
                    hours: state.selectedHour,
                    minutes: state.selectedMinute,
                    seconds: state.selectedSecond,
                  );

                  // Calculate the reminder time as a Duration (e.g., 10 seconds before the countdown ends)
                  final reminderTimeDuration =
                      newDuration - Duration(seconds: 10);

                  // Convert reminder time (Duration) to TimeOfDay
                  final reminderTime = TimeOfDay(
                    hour: reminderTimeDuration.inHours,
                    minute: reminderTimeDuration.inMinutes % 60,
                  );

                  context.read<TextToSpeechBloc>().add(StartCountdownEvent(
                      duration: newDuration, reminderTime: reminderTime));

                  // Trigger the TextToSpeech events
                  context.read<TextToSpeechBloc>().add(UpdateTimePickerEvent(
                        state.selectedHour,
                        state.selectedMinute,
                        state.selectedSecond,
                      ));

                  // Call the callback for time selection
                  widget.onTimeSelected(
                    TimeOfDay(
                        hour: state.selectedHour, minute: state.selectedMinute),
                    state.selectedSecond,
                  );

                  // context.read<TextToSpeechBloc>().add(StartTimer());

                  print(
                      "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj:${state.isTimePickerActive}");

                  // Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Start ${state.isTimePickerActive}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTimerUI(BuildContext context, TextToSpeechState state) {
    final remainingDuration = Duration(
            hours: state.selectedHour,
            minutes: state.selectedMinute,
            seconds: state.selectedSecond) -
        state.elapsedTime;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.only(bottom: 20, top: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        height(size: 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              title: "Sleep Timer",
              color: Colors.black,
              size: 0.025,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w600,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey.shade300),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                  )),
            ),
          ],
        ),
        height(size: 0.01),
        CommonText(
          title: "Stop Reading After",
          color: Colors.black,
          size: 0.02,
          fontFamly: AppFont.robot,
          fontWeight: FontWeight.w400,
        ),
        height(size: 0.02),
        TimerCircle(
          duration: Duration(
              hours: state.selectedHour,
              minutes: state.selectedMinute,
              seconds: state.selectedSecond),
          elapsed: state.elapsedTime,
        ),
        height(size: 0.03),
        Text(
          '${remainingDuration.inHours.toString().padLeft(2, '0')}:' +
              '${(remainingDuration.inMinutes % 60).toString().padLeft(2, '0')}:' +
              '${(remainingDuration.inSeconds % 60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(width: 1, color: AppColor.primaryColor2)),
            onPressed: () {
              context.read<TextToSpeechBloc>().add(CancelCountdownEvent());
            },
            child: CommonText(
              title: "Cancel",
              color: Colors.black,
              size: 0.021,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w400,
            ),
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.4,
            color: AppColor.primaryColor2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(width: 1, color: AppColor.primaryColor2)),
            onPressed: () {
              if (state.timerStatus == TimerStatus.running) {
                context.read<TextToSpeechBloc>().add(PauseCountdownEvent());
              } else {
                context.read<TextToSpeechBloc>().add(StartCountdownEvent(
                      duration: Duration(
                          hours: state.selectedHour,
                          minutes: state.selectedMinute,
                          seconds: state.selectedSecond),
                      reminderTime: TimeOfDay(
                          hour: state.selectedHour,
                          minute: state.selectedMinute),
                    ));
              }
            },
            child: CommonText(
              title: state.isPlaying ? "Pause" : "Play",
              color: Colors.white,
              size: 0.021,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w400,
            ),
          ),
        ])
      ]),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class VoiceBottomSheetWidgets extends StatelessWidget {
  const VoiceBottomSheetWidgets({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => const VoiceBottomSheetWidgets(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fonts = [
      'AvenirNextLTPro',
      'DejaVuSerCondensed',
      'OpenDyslexicAlta',
      'Roboto',
      'Roboto'
    ];
    return BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
      builder: (context, state) {
        final brightness = MediaQuery.of(context).platformBrightness;
        final isDarkMode = brightness == Brightness.dark;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("           "),
                  CommonText(
                    title: "Change Appearance",
                    color: Colors.black,
                    size: 0.022,
                    fontFamly: AppFont.robot,
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primaryColor2,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              height(size: 0.03),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildThemeButton(
                      context: context,
                      icon: AppImage.setting_light,
                      title: "Light",
                      isSelected: !state.isDarkMode && !state.useDeviceTheme,
                      onTap: () {
                        context
                            .read<TextToSpeechBloc>()
                            .add(ChangeBackgroundColor(Colors.white));
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    buildThemeButton(
                      context: context,
                      icon: AppImage.setting_dark,
                      title: "Dark",
                      isSelected: state.isDarkMode && !state.useDeviceTheme,
                      onTap: () {
                        context
                            .read<TextToSpeechBloc>()
                            .add(ChangeBackgroundColor(Colors.black));
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    buildThemeButton(
                      context: context,
                      icon: AppImage.setting_darkfilled,
                      title: "Device",
                      isSelected: state.useDeviceTheme,
                      onTap: () {
                        final brightness =
                            MediaQuery.of(context).platformBrightness;
                        context
                            .read<TextToSpeechBloc>()
                            .add(SetDeviceTheme(true));
                      },
                    ),
                  ],
                ),
              ),
              height(size: 0.03),
              Align(
                alignment: Alignment.topLeft,
                child: CommonText(
                  title: "Select Font",
                  color: Colors.black,
                  size: 0.023,
                  fontFamly: AppFont.robot,
                  fontWeight: FontWeight.w600,
                ),
              ),
              height(size: 0.015),
              InkWell(
                onTap: () {
                  FontSelectorBottomSheet.show(context, fonts);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.containerColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                        title: "Font",
                        color: Colors.black,
                        size: 0.023,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w400,
                      ),
                      Row(
                        children: [
                          CommonText(
                            title: state.selectedFont,
                            color: Colors.black,
                            size: 0.02,
                            fontFamly: state.selectedFont,
                            fontWeight: FontWeight.w400,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: MediaQuery.of(context).size.height * 0.023,
                          )
                        ],
                      ).paddingSymmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                    ],
                  ).paddingSymmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                ),
              ),
              height(size: 0.02),
              Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.containerColor),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonText(
                          title: "${state.textSize} pt",
                          color: Colors.black,
                          size: 0.023,
                          fontFamly: AppFont.robot,
                          fontWeight: FontWeight.w500,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.primaryColor2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    context
                                        .read<TextToSpeechBloc>()
                                        .add(DecreaseTextSize());
                                  },
                                  child: const Icon(Icons.remove,
                                      color: Colors.white)),
                              Container(
                                child: VerticalDivider(
                                  color: Colors.white,
                                  thickness: 1.3,
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              InkWell(
                                  onTap: () {
                                    context
                                        .read<TextToSpeechBloc>()
                                        .add(IncreaseTextSize());
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ],
                          ).paddingSymmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.005,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.03),
                        ),
                      ]))
            ],
          ),
        );
      },
    );
  }

  buildThemeButton({
    required BuildContext context,
    required String icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor2 : AppColor.containerColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor2 : Colors.transparent,
            width: 2,
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.05,
        child: Center(
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: MediaQuery.of(context).size.height * 0.03,
                color: isSelected ? Colors.white : Colors.black,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              CommonText(
                title: title,
                color: isSelected ? Colors.white : Colors.black,
                size: 0.02,
                fontFamly: AppFont.robot,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ],
          ).paddingSymmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
        ),
      ),
    );
  }
}

class FontSelectorBottomSheet extends StatelessWidget {
  final List<String> fonts;
  final ScrollController scrollController;

  const FontSelectorBottomSheet({
    Key? key,
    required this.fonts,
    required this.scrollController,
  }) : super(key: key);

  static void show(BuildContext context, List<String> fonts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FontSelectorBottomSheet(
          fonts: fonts,
          scrollController: ScrollController(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bottom sheet handle
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: MediaQuery.of(context).size.height * 0.023,
                  ),
                  CommonText(
                    title: "Fonts",
                    color: Colors.black,
                    size: 0.023,
                    fontFamly: AppFont.robot,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.containerColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Divider(),

        // Font list
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: fonts.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final fontName = fonts[index];
              return BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
                  builder: (context, state) {
                final isSelected = state.selectedFont == fontName;
                return InkWell(
                  onTap: () {
                    context.read<TextToSpeechBloc>().add(SelectFont(fontName));
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            fontName,
                            style: TextStyle(
                              fontFamily: fontName,
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check, color: Colors.blue)
                        else
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
