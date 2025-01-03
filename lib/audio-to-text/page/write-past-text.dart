// ignore_for_file: prefer_const_constructors_in_immutables, unused_element, unused_local_variable, unused_field, non_constant_identifier_names, sort_child_properties_last, prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_state.dart';

import 'package:new_wall_paper_app/audio-to-text/page/note_paid_screen.dart';
import 'package:new_wall_paper_app/component/bottomsheet.dart';
import 'package:new_wall_paper_app/component/button_widget.dart';
import 'package:new_wall_paper_app/component/loading_dialog.dart';
import 'package:new_wall_paper_app/component/time_format.dart';
import 'package:new_wall_paper_app/helper/store_tts_audio.dart';
import 'package:new_wall_paper_app/model/tts_model.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:http/http.dart' as http;
import 'package:new_wall_paper_app/widget/height-widget.dart';
import 'package:new_wall_paper_app/widget/searchBar.dart';

class WriteAndTextPage extends StatefulWidget {
  final String? text;
  final bool isText;
  final bool? isMailPage;
  final String? title;
  final DateTime? dates;
  final bool isConvertable;

  final String? bossName;
  final String? senderEmail;
  final String? receiverEmail;
  final String? profileImage;

  WriteAndTextPage(
      {Key? key,
      this.text,
      required this.isText,
      this.isMailPage = false,
      this.title,
      this.dates,
      this.bossName,
      this.senderEmail,
      this.receiverEmail,
      this.profileImage,
      required this.isConvertable})
      : super(key: key);

  @override
  State<WriteAndTextPage> createState() => _WriteAndTextPageState();
}

class _WriteAndTextPageState extends State<WriteAndTextPage> {
  late TextEditingController _controller;
  Timer? _debounce;
  Map<int, GlobalKey> _wordKeys = {};
  String textfieldText = '';

  Map<int, GlobalKey> initializeWordKeysMap(String text) {
    Map<int, GlobalKey> keysMap = {};
    List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      keysMap[i] = GlobalKey();
    }

    return keysMap;
  }

  TextEditingController searhcController = TextEditingController();

  GlobalKey getKeyForWord(int index) {
    if (!_wordKeys.containsKey(index)) {
      _wordKeys[index] = GlobalKey();
    }
    return _wordKeys[index]!;
  }

  void _clearWordKeys() {
    _wordKeys.clear();
  }

  @override
  void dispose() {
    AudioStorageHelper.clearAllAudioRecordings();
    _clearWordKeys();
    _controller.dispose();
    context.read<TextToSpeechBloc>().scrollController.dispose();
    _debounce?.cancel();
    context.read<TextToSpeechBloc>().add(Stop());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.text ?? '');

    context.read<TextToSpeechBloc>().scrollController = ScrollController();

    if (widget.text != null) {
      final words = widget.text!.split(' ');
      for (int i = 0; i < words.length; i++) {
        getKeyForWord(i);
      }
      context.read<TextToSpeechBloc>().add(InitializeWordKeys(widget.text!));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<TextToSpeechBloc>();
      bloc.context = context;

      if (widget.text != null) {
        bloc.add(InitializeWordKeys(widget.text!));
      }
    });

    BlocProvider.of<TextToSpeechBloc>(context).add(FetchVoicesEvent());
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        textfieldText = value;
        context.read<TextToSpeechBloc>().add(InitializeWordKeys(value));
      });
      context.read<TextToSpeechBloc>().add(TextChanged(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocListener<TextToSpeechBloc, TextToSpeechState>(
      listener: (context, state) {
        context.read<TextToSpeechBloc>().context = context;
        if (state.isPlaying) {
          context
              .read<TextToSpeechBloc>()
              .scrollToHighlightedWord(context, state.currentWordIndex);
        }
      },
      child: BlocConsumer<TextToSpeechBloc, TextToSpeechState>(
        listener: (context, state) {
          if (state.isSummarizing) {
            LoadingDialog(
              title: "Summarizing...",
            );
          }
          if (state.isPlaying && state.wordKeys.isNotEmpty) {
            context
                .read<TextToSpeechBloc>()
                .scrollToHighlightedWord(context, state.currentWordIndex);
          }
        },
        builder: (context, state) {
          if (widget.text != null && widget.text!.isNotEmpty) {
            context.read<TextToSpeechBloc>().add(TextChanged(widget.text!));
          }

          final totalWords = state.summarizedText.isEmpty
              ? state.normarlText.split(' ').length
              : state.summarizedText.split(" ").length;
          final wordsRead = state.currentWordIndex;
          final wordsRemaining = totalWords - wordsRead;
          final currentWordPosition = state.currentWordIndex + 1;
          final progress = totalWords > 0
              ? (currentWordPosition / totalWords).clamp(0.0, 1.0)
              : 0.0;
          return GestureDetector(
            onTap: () {
              context.read<TextToSpeechBloc>().add(ScreenTouched());
            },
            child: WillPopScope(
              onWillPop: () async {
                context.read<TextToSpeechBloc>().add(Reset());

                return true;
              },
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: state.themeData,
                home: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (!state.isLoading) {
                              context
                                  .read<TextToSpeechBloc>()
                                  .add(SummarizeTextEvent(widget.text ?? ""));
                            }
                          },
                          child: Image.asset(
                            AppImage.ai_icon,
                            color: state.isChangeColor ? Colors.white : null,
                            height: height * 0.04,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text(
                          'Text to Speech',
                          style: TextStyle(
                              color: state.isChangeColor
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: height * 0.023),
                        ),
                      ],
                    ),
                    actions: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => NotesScreen()));
                        },
                        child: SvgPicture.asset(
                          "assets/icons/note_icon.svg",
                          height: height * 0.025,
                          color:
                              state.isChangeColor ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      InkWell(
                        onTap: () {
                          VoiceBottomSheetWidgets.show(context);
                        },
                        child: SvgPicture.asset(
                            "assets/icons/text_size_icon.svg",
                            color: state.isChangeColor
                                ? Colors.white
                                : Colors.black,
                            height: height * 0.03),
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      widget.isConvertable
                          ? InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                  "assets/icons/bx_file.svg",
                                  color: state.isChangeColor
                                      ? Colors.white
                                      : Colors.black,
                                  height: height * 0.03),
                            )
                          : Container(),
                      SizedBox(
                        width: width * 0.04,
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<TextToSpeechBloc>()
                              .add(OpenAllFuctinoBottomSheet());
                        },
                        child: SvgPicture.asset(
                          "assets/icons/nrk_more.svg",
                          color:
                              state.isChangeColor ? Colors.white : Colors.black,
                          height: height * 0.03,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.04,
                      ),
                    ],
                  ),
                  body: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          widget.isMailPage ?? false
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: CommonText(
                                        maxLine: 1,
                                        textOverflow: TextOverflow.ellipsis,
                                        title: widget.title ?? "",
                                        color: Colors.black,
                                        size: 0.022,
                                        fontFamly: AppFont.robot,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CommonText(
                                      title: formatEmailTime(widget.dates),
                                      color: Colors.grey,
                                      size: 0.018,
                                      fontFamly: AppFont.robot,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ).paddingSymmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.08)
                              : Container(),
                          widget.isMailPage ?? false
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                )
                              : Container(),
                          widget.isMailPage ?? false
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: CommonText(
                                    maxLine: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                    title: "To: ${widget.receiverEmail}",
                                    color: Colors.blue,
                                    size: 0.02,
                                    fontFamly: AppFont.robot,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).paddingSymmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.07)
                              : Container(),
                          widget.isMailPage ?? false
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                )
                              : Container(),
                          widget.isMailPage ?? false
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile image
                                    CircleAvatar(
                                      child: Text(
                                        _getAvatarText(widget.bossName ?? ""),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      backgroundImage: widget.profileImage !=
                                              null
                                          ? NetworkImage(widget.profileImage!)
                                          : null,
                                      radius:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                    ),
                                    const SizedBox(width: 12),
                                    // Message subject and timestamp
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText(
                                            // maxLine: 1,
                                            // textOverflow: TextOverflow.ellipsis,
                                            title: widget.bossName ?? "",
                                            color: Colors.black,
                                            size: 0.022,
                                            fontFamly: AppFont.robot,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          const SizedBox(height: 12.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatEmailTime(widget.dates),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              CommonText(
                                                maxLine: 1,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                title: "${widget.senderEmail}",
                                                color: Colors.grey,
                                                size: 0.018,
                                                fontFamly: AppFont.robot,
                                                fontWeight: FontWeight.w500,
                                              ).paddingOnly(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.07),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.06)
                              : Container(),
                          widget.isMailPage ?? false
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                )
                              : Container(),
                          widget.isMailPage ?? false
                              ? CommonText(
                                  title: widget.title ?? "",
                                  color: Colors.black,
                                  size: 0.022,
                                  fontFamly: AppFont.robot,
                                  fontWeight: FontWeight.w500,
                                ).paddingSymmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.07)
                              : Container(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02),
                              child: SingleChildScrollView(
                                  controller: context
                                      .read<TextToSpeechBloc>()
                                      .scrollController,
                                  child:

                                      /*    
                                 Column(
                                  children: [
                                    textfieldText == ""
                                        ? widget.isText
                                            ? TextField(
                                                maxLines: null,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context).size.height *
                                                          0.02,
                                                  wordSpacing: 1.2,
                                                  color: Colors.black54,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.02,
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: "Enter something ....",
                                                ),
                                                onChanged: _onTextChanged,
                                              )
                                            :
                                            //                         HighlightedText(
                                            //   text: state.text,
                                            //   currentWordIndex: state.currentWordIndex,
                                            //   fontSize: 18.0,
                                            // )
                      
                                            state.summarizedText.isNotEmpty
                                                ?
                      
                                                // summerize text
                                                RichText(
                                                    text: TextSpan(
                                                      children: context
                                                          .read<TextToSpeechBloc>()
                                                          .scrollToHighlightedWord(
                                                            context,
                                                            // text: state.editText.isNotEmpty
                                                            //     ? state.editText
                                                            //     : state.text,
                      
                                                            state.currentWordIndex,
                                                          ),
                                                    ),
                                                  )
                                                :
                                                // any docs or pdf text
                                                RichText(
                                                    text: TextSpan(
                                                      children: context
                                                          .read<TextToSpeechBloc>()
                                                          .scrollToHighlightedWord(
                                                            context,
                                                            // text: state.editText.isNotEmpty
                                                            //     ? state.editText
                                                            //     : state.text,
                      
                                                            state.currentWordIndex,
                                                          ),
                                                    ),
                                                  )
                                        // type text
                                        : RichText(
                                            text: TextSpan(
                                              children: context
                                                  .read<TextToSpeechBloc>()
                                                  .scrollToHighlightedWord(
                                                    context,
                                                    // text: state.editText.isNotEmpty
                                                    //     ? state.editText
                                                    //     : state.text,
                      
                                                    state.currentWordIndex,
                                                  ),
                                            ),
                                          ),
                      
                                    //                     : HighlightedText(
                                    //   text: state.text,
                                    //   currentWordIndex: state.currentWordIndex,
                                    //   fontSize: 18.0,
                                    // ),
                                    const SizedBox(height: 20),
                                    if (state.isLoading && state.isPlaying)
                                      const CircularProgressIndicator(),
                      
                                    /*
                                    if (textfieldText.isEmpty && widget.isText)
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: TextField(
                                          controller: _controller,
                                          maxLines: null,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.height * 0.02,
                                            wordSpacing: 1.2,
                                            color: Colors.black54,
                                          ),
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize:
                                                  MediaQuery.of(context).size.height * 0.02,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Enter something....",
                                          ),
                                          onChanged: _onTextChanged,
                                        ),
                                      )
                                    else if (state.text.isNotEmpty && state.wordKeys.isNotEmpty)
                                      context
                                          .read<TextToSpeechBloc>()
                                          .buildHighlightedTextSpans(
                                            context,
                                            state.text,
                                            state.currentWordIndex,
                                          ),
                                        */
                                    if (state.isLoading && state.isPlaying)
                                      const Center(child: CircularProgressIndicator()),
                                  ],
                                ),
                            
                            */

                                      Column(
                                    children: [
                                      if (textfieldText == "")
                                        widget.isText
                                            ? TextField(
                                                controller: _controller,
                                                maxLines: null,
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.02,
                                                  wordSpacing: 1.2,
                                                  color: Colors.black54,
                                                ),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Enter something ....",
                                                ),
                                                onChanged: _onTextChanged,
                                              )
                                            : GestureDetector(
                                                onTapDown:
                                                    (TapDownDetails details) {
                                                  final RenderBox box =
                                                      context.findRenderObject()
                                                          as RenderBox;
                                                  final localPosition =
                                                      box.globalToLocal(details
                                                          .globalPosition);
                                                  final TextPainter
                                                      textPainter = TextPainter(
                                                    text: TextSpan(
                                                        text: state
                                                                .summarizedText
                                                                .isEmpty
                                                            ? state.normarlText
                                                            : state
                                                                .summarizedText),
                                                    textDirection:
                                                        TextDirection.ltr,
                                                  );
                                                  textPainter.layout();
                                                  final TextPosition position =
                                                      textPainter
                                                          .getPositionForOffset(
                                                              localPosition);
                                                  if (state
                                                      .summarizedText.isEmpty) {
                                                    final int wordIndex = state
                                                            .summarizedText
                                                            .substring(0,
                                                                position.offset)
                                                            .split(' ')
                                                            .length -
                                                        1;
                                                    context
                                                        .read<
                                                            TextToSpeechBloc>()
                                                        .add(WordSelected(
                                                            wordIndex));
                                                  } else {
                                                    final int wordIndex = state
                                                            .normarlText
                                                            .substring(0,
                                                                position.offset)
                                                            .split(' ')
                                                            .length -
                                                        1;
                                                    context
                                                        .read<
                                                            TextToSpeechBloc>()
                                                        .add(WordSelected(
                                                            wordIndex));
                                                  }
                                                },
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.7,
                                                  child: context
                                                      .read<TextToSpeechBloc>()
                                                      .buildHighlightedTextSpans(
                                                          context,
                                                          state.summarizedText
                                                                  .isNotEmpty
                                                              ? state
                                                                  .summarizedText
                                                              : state
                                                                  .normarlText,
                                                          state
                                                              .currentWordIndex),
                                                ),
                                              )
                                      else
                                        GestureDetector(
                                          onTapDown: (TapDownDetails details) {
                                            final RenderBox box =
                                                context.findRenderObject()
                                                    as RenderBox;
                                            final localPosition =
                                                box.globalToLocal(
                                                    details.globalPosition);
                                            final TextPainter textPainter =
                                                TextPainter(
                                              text: TextSpan(
                                                  text: state.summarizedText
                                                          .isEmpty
                                                      ? state.normarlText
                                                      : state.summarizedText),
                                              textDirection: TextDirection.ltr,
                                            );
                                            textPainter.layout();
                                            final TextPosition position =
                                                textPainter
                                                    .getPositionForOffset(
                                                        localPosition);
                                            if (state.summarizedText.isEmpty) {
                                              final int wordIndex = state
                                                      .summarizedText
                                                      .substring(
                                                          0, position.offset)
                                                      .split(' ')
                                                      .length -
                                                  1;
                                              context
                                                  .read<TextToSpeechBloc>()
                                                  .add(WordSelected(wordIndex));
                                            } else {
                                              final int wordIndex = state
                                                      .normarlText
                                                      .substring(
                                                          0, position.offset)
                                                      .split(' ')
                                                      .length -
                                                  1;
                                              context
                                                  .read<TextToSpeechBloc>()
                                                  .add(WordSelected(wordIndex));
                                            }
                                          },
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                            child: context
                                                .read<TextToSpeechBloc>()
                                                .buildHighlightedTextSpans(
                                                  context,
                                                  state.summarizedText.isEmpty
                                                      ? state.normarlText
                                                      : state.summarizedText,
                                                  state.currentWordIndex,
                                                ),
                                          ),
                                        ),
                                      if (state.isLoading)
                                        const Center(
                                            child: CircularProgressIndicator()),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      state.isLoading
                          ? LoadingDialog(
                              title: "Summarizing...",
                            )
                          : Container(),
                    ],
                  ),
                  bottomNavigationBar: state.isSwitchedToHideShowPlayer
                      ? const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.04),
                              decoration: BoxDecoration(
                                  color: AppColor.primaryColor2,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                                child: Row(
                                  children: [
                                    // Text(
                                    //   formatDuration(state.currentPosition),
                                    //   style: TextStyle(
                                    //       color: state.isChangeColor
                                    //           ? Colors.white
                                    //           : Colors.grey),
                                    // ),
                                    // // count word

                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.18,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: CircularProgressIndicator(
                                              value: progress,
                                              backgroundColor: Colors.grey[300],
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.blue),
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              // child:
                                            ),
                                            CommonText(
                                              title:
                                                  "${((state.originalAudioDuration.inSeconds > 0 ? (state.currentPosition.inSeconds / state.originalAudioDuration.inSeconds) * 100 : 0)).toInt()}%",
                                              color: AppColor.primaryColor2,
                                              size: 0.02,
                                              fontFamly: AppFont.robot,
                                              fontWeight: FontWeight.w400,
                                            )
                                          ],
                                        )
                                      ],
                                    ),

                                    Column(
                                      children: [
                                        CommonText(
                                          title: "Preview Mood",
                                          color: Colors.white,
                                          size: 0.023,
                                          fontFamly: AppFont.robot,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.007,
                                        ),
                                        CommonText(
                                          title:
                                              "${wordsRemaining} Word Remaining",
                                          color: Colors.white60,
                                          size: 0.02,
                                          fontFamly: AppFont.robot,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    )
                                    // Text(
                                    //   formatDuration(state.originalAudioDuration),
                                    //   style: TextStyle(
                                    //       color: state.isChangeColor
                                    //           ? Colors.white
                                    //           : Colors.grey),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColor.primaryColor2,
                                inactiveTrackColor: state.isChangeColor
                                    ? Colors.white54
                                    : Colors.grey,
                                trackHeight: 7.0,
                                thumbColor: AppColor.primaryColor2,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 10.0,
                                  elevation: 4.0,
                                ),
                                overlayColor: AppColor.primaryColor2,
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 20.0),
                              ),
                              child: Slider(
                                min: 0,
                                max: state.originalAudioDuration.inMilliseconds
                                    .toDouble(),
                                value: state.currentPosition.inMilliseconds
                                    .toDouble()
                                    .clamp(
                                      0,
                                      state.originalAudioDuration.inMilliseconds
                                          .toDouble(),
                                    ),
                                onChanged: (value) {
                                  if (state.isPlaying) {
                                  } else {
                                    context
                                        .read<TextToSpeechBloc>()
                                        .add(TogglePlayPause());
                                  }
                                  if (value <=
                                      state.originalAudioDuration.inMilliseconds
                                          .toDouble()) {
                                    context.read<TextToSpeechBloc>().add(
                                          SeekTo(Duration(
                                              milliseconds: value.round())),
                                        );
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: InkWell(
                                        onTap: () {
                                          if (state.isPlaying) {
                                            context
                                                .read<TextToSpeechBloc>()
                                                .add(TogglePlayPause());
                                          }
                                          showLanguageSelectionBottomSheet(
                                              context);
                                        },
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Container(
                                              child: CircleAvatar(
                                                backgroundImage: state
                                                        .countryFlat.isEmpty
                                                    ? const NetworkImage(
                                                        "https://images.pexels.com/photos/15652226/pexels-photo-15652226/free-photo-of-the-national-flag-of-united-states.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                                                    : NetworkImage(
                                                        state.countryFlat),
                                              ),
                                            ),
                                            Positioned(
                                              right: -20,
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.black,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          AppImage.skipback,
                                          color: state.isChangeColor
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        onPressed: () => context
                                            .read<TextToSpeechBloc>()
                                            .add(SeekBy(
                                                const Duration(seconds: -10))),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          if (state.isLoading)
                                            CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                state.isChangeColor
                                                    ? Colors.white
                                                    : AppColor.primaryColor2,
                                              ),
                                              strokeWidth: 5,
                                            ),
                                          InkWell(
                                              onTap: () {
                                                context
                                                    .read<TextToSpeechBloc>()
                                                    .add(TogglePlayPause());
                                              },
                                              child: Icon(
                                                state.isPlaying
                                                    ? Icons.pause_circle_filled
                                                    : Icons
                                                        .play_circle_fill_outlined,
                                                color: AppColor.primaryColor2,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07,
                                              ))
                                        ],
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          AppImage.skipforward,
                                          color: state.isChangeColor
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        onPressed: () => context
                                            .read<TextToSpeechBloc>()
                                            .add(SeekBy(
                                                const Duration(seconds: 10))),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            SpeedRateBottomSheetWidget(
                                          initialValue: state.speechRate,
                                          onSpeedChanged: (value) {
                                            context
                                                .read<TextToSpeechBloc>()
                                                .add(ChangeSpeechRate(value));
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/watch.svg",
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.035,
                                          ),
                                          const SizedBox(width: 4),
                                          CommonText(
                                            title: "Speed ",
                                            color: state.isChangeColor
                                                ? Colors.white
                                                : Colors.black54,
                                            fontWeight: FontWeight.w700,
                                            size: 0.016,
                                          ),
                                          Text(
                                            "${state.speechRate.toStringAsFixed(1)}x",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.016,
                                              color: state.isChangeColor
                                                  ? Colors.white
                                                  : Colors.black54,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row popup_menu_item(String icon, String text) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        const SizedBox(
          width: 7,
        ),
        CommonText(title: text, color: Colors.black, size: 0.02),
      ],
    );
  }

  PopupMenuItem<double> _buildSpeedMenuItem(double value) {
    return PopupMenuItem<double>(
      value: value,
      height: 40,
      padding: EdgeInsets.zero,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(
          "${value}x",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.height * 0.023,
          ),
        ),
      ),
    );
  }

  Widget _buildChunkedText(TextToSpeechState state) {
    final text = state.summarizedText.isNotEmpty
        ? state.summarizedText
        : state.editText.isNotEmpty
            ? state.editText
            : state.summarizedText.isEmpty
                ? state.normarlText
                : state.summarizedText;

    final words = text.split(' ');

    return RichText(
      text: TextSpan(
        children: words.asMap().entries.map((entry) {
          final int index = entry.key;
          final String word = entry.value;
          final bool isHighlighted = index == state.currentWordIndex;

          return TextSpan(
            text: '$word ',
            style: TextStyle(
              fontSize: state.textSize.toDouble(),
              color: isHighlighted ? Colors.blue : Colors.black,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getAvatarText(String subject) {
    String cleanSubject = subject.trim();

    if (cleanSubject.isEmpty) return 'E';

    int startIndex = 0;
    while (
        startIndex < cleanSubject.length && (cleanSubject[startIndex] == '"')) {
      startIndex++;
    }

    if (startIndex >= cleanSubject.length) return 'E';

    return cleanSubject[startIndex].toUpperCase();
  }

  void showLanguageSelectionBottomSheet(BuildContext context) {
    final Map<String, String> countryNames = {
      'US': 'United States',
      'GB': 'United Kingdom',
      'AU': 'Australia',
      'IN': 'India',
      'CA': 'Canada',
      'IE': 'Ireland',
      'ZA': 'South Africa',
      'NZ': 'New Zealand',
      'PH': 'Philippines',
      'SG': 'Singapore',
      'HK': 'Hong Kong',
      'MY': 'Malaysia',
      'ES': 'Spain',
      'FR': 'France',
      'DE': 'Germany',
      'IT': 'Italy',
      'NL': 'Netherlands',
      'PL': 'Poland',
      'PT': 'Portugal',
      'BR': 'Brazil',
      'ID': 'Indonesia',
      'JP': 'Japan',
      'KR': 'South Korea',
      'TH': 'Thailand',
      'VN': 'Vietnam',
      'TR': 'Turkey',
      'RU': 'Russia',
      'ET': 'Ethiopia',
      'XA': 'XA',
      'BG': 'Bulgaria',
      'CN': 'China',
      'TW': 'Taiwan',
      'CZ': 'Czechia',
      'DK': 'Denmark',
      'GR': 'Greece',
      'EE': 'Estonia',
      'FI': 'Finland',
      'Ph': 'Philippines ',
      'IL': 'Israel',
      'HU': 'Hungary',
      'IS': 'Iceland',
      'LV': 'Latvia',
      'NO': 'Norway',
      'BE': 'Belgium',
      'RO': 'Romania',
      'SK': 'Slovakia',
      'RS': 'Serbia',
      'SE': 'Sweden',
      'UA': 'Ukraine',
    };

    final Map<String, String> voiceDisplayNames = {
      'Standard-A': 'John Smith',
      'Standard-B': 'Emma Wilson',
      'Standard-C': 'Michael Brown',
      'Standard-D': 'Sarah Johnson',
      'Wavenet-A': 'David Anderson',
      'Wavenet-B': 'Maria Garcia',
      'Wavenet-C': 'James Wilson',
      'Wavenet-D': 'Lisa Taylor',
      'Neural2-A': 'Thomas Lee',
      'Neural2-B': 'Jennifer White',
      'Neural2-C': 'Robert Martin',
      'Neural2-D': 'Emily Davis',
      'News-A': 'William Clark',
      'News-B': 'Sophia Martinez',
      'News-C': 'Daniel Thompson',
      'News-D': 'Olivia Moore',
    };

    final searchController = TextEditingController();
    String getVoiceDisplayName(String voiceName) {
      try {
        final parts = voiceName.split('-');
        if (parts.length >= 2) {
          // Combine voice type and variant for lookup
          final voiceKey = "${parts[2]}-${parts[3]}"; // e.g., "Standard-A"
          return voiceDisplayNames[voiceKey] ?? voiceName;
        }
      } catch (e) {
        print('Error parsing voice name: $e');
      }
      return voiceName;
    }

    // Helper function to safely extract country name
    String getCountryName(String voiceName) {
      try {
        final parts = voiceName.split('-');
        if (parts.length >= 2) {
          final countryCode = parts[1].toUpperCase();
          return countryNames[countryCode] ?? countryCode;
        }
      } catch (e) {
        print('Error extracting country code: $e');
      }
      return 'Unknown';
    }

    // Helper function to safely get country code for flag
    String getFlagCountryCode(String voiceName) {
      try {
        final parts = voiceName.split('-');
        if (parts.length >= 2) {
          return parts[1].toLowerCase();
        }
      } catch (e) {
        print('Error extracting flag country code: $e');
      }
      return 'unknown';
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
          builder: (context, state) {
            if (state.isLoading) {
              return LinearProgressIndicator(value: state.loadingProgress);
            }

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                final orderedVoices = <String, List<Voice>>{};
                final allVoices = <Voice>[];
                final groupedVoices = <String, List<Voice>>{};

                for (var voice in state.availableVoices) {
                  final countryCode = voice.name.split('-')[1] ?? 'Other';
                  groupedVoices.putIfAbsent(countryCode, () => []).add(voice);
                  allVoices.add(voice);
                }

                orderedVoices['ALL'] = allVoices;
                orderedVoices.addAll(groupedVoices);

                String initialCountry = 'ALL';
                if (state.selectedVoice != null) {
                  final selectedVoiceCountryCode =
                      state.selectedVoice!.name.split('-')[1];
                  if (groupedVoices.containsKey(selectedVoiceCountryCode)) {
                    initialCountry = selectedVoiceCountryCode;
                  }
                }

                final selectedCountryNotifier =
                    ValueNotifier<String>(initialCountry);

                return DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  expand: false,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          // Header with close button
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select Voice',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.robot,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primaryColor2,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          height(size: 0.01),

                          // Search bar
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SearchBars(
                              controllers: searchController,
                              hint: "Search voice",
                              // },
                            ),
                          ),

// Search bar
                          height(size: 0.02),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonWidget(
                                size: 0.023,
                                bgColor: AppColor.primaryColor2,
                                heigh:
                                    MediaQuery.of(context).size.height * 0.06,
                                onpress: () {},
                                text: "Premium",
                                textColor: Colors.white,
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                              ButtonWidget(
                                size: 0.023,
                                bgColor: Colors.grey.shade300,
                                heigh:
                                    MediaQuery.of(context).size.height * 0.06,
                                onpress: () {},
                                text: "Offline",
                                textColor: Colors.black,
                                width: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ],
                          ),

                          height(size: 0.01),

                          Container(
                            height: 35,
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: orderedVoices.length,
                              itemBuilder: (context, index) {
                                final countryCode =
                                    orderedVoices.keys.elementAt(index);
                                final countryName =
                                    countryNames[countryCode] ?? countryCode;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ValueListenableBuilder<String>(
                                    valueListenable: selectedCountryNotifier,
                                    builder: (context, selectedCountry, child) {
                                      final isSelected =
                                          selectedCountry == countryCode;
                                      return InkWell(
                                        onTap: () {
                                          selectedCountryNotifier.value =
                                              countryCode;
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColor.primaryColor2
                                                : Colors.white,
                                            border: Border.all(
                                                color: isSelected
                                                    ? Colors.transparent
                                                    : AppColor.primaryColor2
                                                        .withOpacity(0.6),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Text(
                                              countryName,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontFamily: AppFont.robot,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          // Voice list
                          Expanded(
                            child: ValueListenableBuilder<String>(
                              valueListenable: selectedCountryNotifier,
                              builder: (context, selectedCountry, child) {
                                final voices = selectedCountry == 'All'
                                    ? allVoices
                                    : orderedVoices[selectedCountry] ?? [];

                                final filteredVoices = searchController
                                        .text.isEmpty
                                    ? voices
                                    : voices.where((voice) {
                                        final voiceType =
                                            voice.name.split('-').last;
                                        final displayName =
                                            voiceDisplayNames[voiceType] ??
                                                'Voice $voiceType';
                                        final searchText =
                                            searchController.text.toLowerCase();
                                        return displayName
                                                .toLowerCase()
                                                .contains(searchText) ||
                                            voice.ssmlGender
                                                .toLowerCase()
                                                .contains(searchText);
                                      }).toList();

                                if (filteredVoices.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No voices found',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  controller: scrollController,
                                  itemCount: filteredVoices.length,
                                  itemBuilder: (context, index) {
                                    final voice = filteredVoices[index];
                                    final isSelected =
                                        state.selectedVoice?.name == voice.name;
                                    final voiceType =
                                        voice.name.split('-').last;
                                    final displayName =
                                        voiceDisplayNames[voiceType] ??
                                            'Voice $voiceType';
                                    final countryCode =
                                        voice.name.split('-')[1].toLowerCase();

                                    return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue.withOpacity(0.1)
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          leading: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      'https://flagcdn.com/48x36/$countryCode.png'),
                                                  backgroundColor:
                                                      Colors.grey[100],
                                                  onBackgroundImageError:
                                                      (_, __) {},
                                                  child: Text(
                                                    displayName[0],
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.blue
                                                          : Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  right: -4,
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.black,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04,
                                                  ))
                                            ],
                                          ),
                                          title: Text(
                                            displayName,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.blue
                                                  : Colors.black87,
                                              fontFamily: AppFont.robot,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              CommonText(
                                                title: "Pakistani",
                                                color: Colors.grey,
                                                size: 0.017,
                                                fontFamly: AppFont.robot,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              Width(size: 0.02),
                                              Icon(
                                                Icons.wifi_off_rounded,
                                                color: Colors.grey,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                              )
                                            ],
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              context
                                                  .read<TextToSpeechBloc>()
                                                  .add(SelectVoiceEvent(voice));
                                              Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                context
                                                    .read<TextToSpeechBloc>()
                                                    .add(Speak());
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: AppColor.primaryColor2,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            context
                                                .read<TextToSpeechBloc>()
                                                .add(SelectVoiceEvent(voice));

                                            if (state.summarizedText
                                                    .isNotEmpty ||
                                                state.normarlText.isNotEmpty) {
                                              Future.delayed(
                                                  Duration(milliseconds: 100),
                                                  () {
                                                context
                                                    .read<TextToSpeechBloc>()
                                                    .add(Speak());
                                              });
                                            }

                                            Navigator.pop(context);
                                          },
                                        ));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
