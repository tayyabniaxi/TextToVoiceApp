// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_final_fields, avoid_print, unnecessary_string_interpolations, unused_element, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-bloc-class.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-state.dart';
// import 'package:new_wall_paper_app/audio-to-text/page/typing_indicator_widget.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/component/loading_dialog.dart';
import 'package:new_wall_paper_app/component/typing_indicator_widget.dart';
// import 'package:new_wall_paper_app/component/loading_dialog.dart';
import 'package:new_wall_paper_app/model/chatbot_model.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
// import 'package:new_wall_paper_app/res/app-text.dart';
import 'package:new_wall_paper_app/res/app_url.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-bloc-class.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-state-class.dart';

class SummarizePage extends StatelessWidget {
  bool isOtherPage;
  bool isEnableBtn;
  String? content;
  bool? isButtonShow;
  SummarizePage(
      {required this.isOtherPage,
      this.content,
      required this.isEnableBtn,
      this.isButtonShow});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileProcessorBloc(),
      child: FileProcessorScreens(
          content: content,
          isOtherPage: isOtherPage,
          isEnableBtn: isEnableBtn,
          isButtonshoow: isButtonShow ?? false),
    );
  }
}

class FileProcessorScreens extends StatefulWidget {
  bool? isOtherPage;
  String? content;
  bool isEnableBtn;
  bool isButtonshoow;
  FileProcessorScreens(
      {this.isOtherPage,
      this.content,
      required this.isEnableBtn,
      required this.isButtonshoow});
  @override
  _FileProcessorScreensState createState() => _FileProcessorScreensState();
}

class _FileProcessorScreensState extends State<FileProcessorScreens> {
  final TextEditingController _askAnythingController = TextEditingController();
  final TextEditingController _enterSomethingController =
      TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String docsString = '';
  bool isDocsString = false;
  bool isFileSelectContent = false;
  ScrollController _scrollController = ScrollController();
  bool isChat = false;
  FocusNode _focusNode = FocusNode();
  bool _isTextFieldFocused = false;

  String _enterSomethingsummary = '';
  String enterSomething = '';
  bool isSummarizeText = false;
  String refreshContent = '';

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    refreshContent = widget.content ?? "";
    if (widget.content != null && widget.content!.isNotEmpty) {
      _enterSomethingController.text = widget.content!;
      setState(() {
        enterSomething = widget.content!;
      });
    }
    _enterSomethingController.addListener(() {
      setState(() {});
    });

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _askAnythingController.dispose();
    _enterSomethingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isTextFieldFocused = _focusNode.hasFocus;
    });
  }

  Future<void> _summarizeText(String text) async {
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to summarize')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _enterSomethingsummary = '';
    });

     String apiKey = Apis.cloudApi;
     String apiUrl =
        Apis.geminiProSummarizeApis;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "Summarize the following text:\n${text}"}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _enterSomethingsummary = data['candidates'][0]['content']['parts'][0]
                  ['text'] ??
              'No summary available';

          isSummarizeText = true;
          refreshContent = _enterSomethingsummary;
          _enterSomethingsummary = refreshContent;
          _enterSomethingController.text = _enterSomethingsummary;
        });
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to summarize text: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _enterSomethingsummary =
            'Error summarizing text. Please try again later.';
      });
      print('Error details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _handleUserMessage(String text) async {
    if (text.isEmpty) return;

    final messageText = text;
    _askAnythingController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _scrollToBottom();
    try {
      String contextContent = '';
      if (isSummarizeText && _enterSomethingsummary.isNotEmpty) {
    
        contextContent = _enterSomethingsummary;
      } else if (widget.content != null && widget.content!.isNotEmpty) {
  
        contextContent = widget.content!;
      } else if (context.read<FileProcessorBloc>().isExtractContent) {
      
        final state = context.read<FileProcessorBloc>().state;
        if (state is FileProcessorSuccess) {
          contextContent = state.extractedText;
        }
      }

  
      String prompt;
      if (contextContent.isNotEmpty) {
        prompt = '''Context: $contextContent

Question: $messageText

Please answer the question based on the context provided above.''';
      } else {
        prompt = messageText;
      }

      final response = await http.post(
        Uri.parse(
            Apis.geminiProSummarizeApis),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': Apis.cloudApi,
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['candidates'][0]['content']['parts'][0]
                ['text'] ??
            'No response available';

        setState(() {
          _messages.add(ChatMessage(
            text: botResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
          isChat = true;
        });
        _scrollToBottom();
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
      print('Error details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("jjjjjjjjjjjjjjjjjjjjj:${widget.content}");
    print("jjjjjjjjjjjjjjjjjjjjjj:${widget.content}");
    double heigh = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Scaffold(
              appBar: _appBar(context),
              bottomNavigationBar: bottomsheet(context),
              body: BlocBuilder<FileProcessorBloc, FileProcessorState>(
                builder: (context, state) {
                  if (state is FileProcessorLoading &&
                      !context.read<FileProcessorBloc>().isExtractContent) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: [
                      context.read<FileProcessorBloc>().isExtractContent
                          ? isSummarizeText
                              ? Container()
                              : Container(
                                  padding: const EdgeInsets.only(
                                      right: 2, left: 2, bottom: 3, top: 5),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.02,
                                      vertical: heigh * 0.02),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.containerColor),
                                  constraints:
                                      BoxConstraints(maxHeight: heigh * 0.3),
                                  width: double.infinity,
                                  child: _fileExtractContent(),
                                )
                          : widget.isOtherPage == true
                              ? Container()
                              : isSummarizeText
                                  ? Container()
                                  : widget.isOtherPage == true
                                      ? Container(
                                          height: heigh * 0.3,
                                          width: double.infinity,
                                          child: CommonText(
                                              title: enterSomething,
                                              color: Colors.black,
                                              size: 0.02),
                                        )
                                      : _enterSomethingMethod(),
                    
                      widget.isOtherPage == true || isSummarizeText || isChat
                          ? Container()
                          : const SizedBox(height: 20),
                    
                      widget.isEnableBtn == true || isSummarizeText || isChat
                          ? Container()
                          : _blueSummarizeButton2(context),
                  
                      widget.isEnableBtn || isChat
                          ? Container()
                          : widget.isOtherPage == true || isSummarizeText
                              ? Container()
                              : const SizedBox(height: 20),
                      widget.isEnableBtn || _focusNode.hasFocus
                          ? Container()
                          : widget.isOtherPage ??
                                  false ||
                                      context
                                          .read<FileProcessorBloc>()
                                          .isExtractContent
                              ? Container()
                              : isSummarizeText || isChat
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04),
                                      child: CommonText(
                                        title:
                                            "chat about the document, generate AI summary,ask follow-up question",
                                        color: Colors.black.withOpacity(0.6),
                                        textAlign: TextAlign.center,
                                        fontWeight: FontWeight.w400,
                                        fontFamly: AppFont.robot,
                                        size: 0.02,
                                      ),
                                    ),
                      // no data pic
                      widget.isEnableBtn || _focusNode.hasFocus
                          ? Container()
                          : widget.isOtherPage == true || isSummarizeText
                              ? Container()
                              : const SizedBox(height: 30),
                      widget.isEnableBtn || _focusNode.hasFocus || isChat
                          ? Container()
                          : widget.isOtherPage == true ||
                                  isSummarizeText ||
                                  context
                                      .read<FileProcessorBloc>()
                                      .isExtractContent
                              ? Container()
                              : Image.asset(
                                  "assets/icons/Frame.png",
                                  height: heigh * 0.3,
                                ),
                      widget.isEnableBtn == true || isSummarizeText || isChat
                          ? Container()
                          : _otherPageContent(),
                      
                      isChat ? height(size: 0.02) : Container(),
                      isChat
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(),
                            )
                          : Container(),
                      // space
                      widget.isEnableBtn || isChat
                          ? Container()
                          : widget.isOtherPage == true
                              ? Container()
                              : height(size: 0.02),
                      widget.isButtonshoow || isSummarizeText
                          ? Container()
                          : _blueSummarizeButton2(context),
                      // space
                      isSummarizeText || isChat
                          ? Container()
                          : height(size: 0.035),
                      // if (_isLoading)
                      //   const Center(child: CircularProgressIndicator())
                      // else
                      if (_enterSomethingsummary.isNotEmpty)
                        _enterSomethingSummarizeContent(),
                      isSummarizeText
                          ? Container()
                          : widget.isOtherPage == true ||
                                  _enterSomethingsummary.isNotEmpty
                              ? Container()
                              : Container(),
                      widget.isOtherPage == true ||
                              _enterSomethingsummary.isNotEmpty ||
                              _focusNode.hasFocus
                          ? _chatMessageContent()
                          : Container(),
                    ],
                  );
                },
              )),
          // if (_isLoading) const CircularProgressIndicator()
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      // centerTitle: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText(
            title: widget.isOtherPage ??
                    false || context.read<PDFReaderBloc>().isGetPdfContent
                ? "Summarize"
                : isSummarizeText
                    ? "Summarize"
                    : "AI Chatbot",
            color: Colors.black,
            size: 0.021,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          )),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        widget.isOtherPage == true || isSummarizeText || isChat
            ? Row(
                children: [
                  TextButton(
                      onPressed: () {
                        final state = context.read<FileProcessorBloc>().state;
                        if (state is FileProcessorSuccess) {}
                        if (_enterSomethingsummary != "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WriteAndTextPage(
                                isConvertable: true,
                                text: _enterSomethingsummary,
                                isText: false,
                              ),
                            ),
                          );
                        } else if (_enterSomethingController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WriteAndTextPage(
                                isConvertable: false,
                                text: _enterSomethingController.text,
                                isText: false,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please enter some text to summarize')),
                          );
                        }
                      },
                      child: const Icon(
                        Icons.play_circle_fill_outlined,
                        color: Colors.black,
                      )),
                ],
              )
            : Container()
      ],
    );
  }

  Expanded _extractLinkContent() {
    return Expanded(
      child: BlocBuilder<PDFReaderBloc, PDFReaderState>(
        builder: (context, state) {
          if (state is PDFReaderLoading) {
            return Center(child: Container());
          } else if (state is PDFReaderLoaded) {
            isFileSelectContent = context.read<PDFReaderBloc>().isGetPdfContent;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: Text(
                  state.pdfText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          } else if (state is PDFReaderError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No PDF selected"));
        },
      ),
    );
  }

  Widget _fileExtractContent() {
    return Expanded(
      child: BlocBuilder<FileProcessorBloc, FileProcessorState>(
        builder: (context, state) {
          if (state is FileProcessorLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FileProcessorSuccess) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: CommonText(
                  title: state.extractedText,
                  color: Colors.black.withOpacity(0.6),
                  size: 0.02,
                  fontFamly: AppFont.robot,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          } else if (state is FileProcessorError) {
            return Center(child: Text(state.errorMessage));
          }
          return Container();
        },
      ),
    );
  }

  Expanded _enterSomethingSummarizeContent() {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
            maxHeight: _focusNode.hasFocus
                ? MediaQuery.of(context).size.height * 0.45
                : MediaQuery.of(context).size.height),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Text(
            '$_enterSomethingsummary',
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w100),
          ),
        ),
      ),
    );
  }

  Container _otherPageContent() {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Text(
          widget.content ?? "",
          style: const TextStyle(
              fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w100),
        ),
      ),
    );
  }

  InkWell _blueSummarizeButton2(BuildContext context) {
    return InkWell(
      onTap: () {
        _isLoading
            ? null
            : _summarizeText(_enterSomethingController.text.isEmpty
                ? context.read<FileProcessorBloc>().extractString
                : _enterSomethingController.text.toString());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          color: AppColor.primaryColor2,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: CommonText(
              title: _isLoading ? "Summarizing" : "Summarize",
              color: Colors.white,
              size: 0.023),
        ),
      ),
    );
  }

  Container _enterSomethingMethod() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _enterSomethingController,
        decoration: InputDecoration(
          suffixIcon: _enterSomethingController.value.text.isNotEmpty
              ? null
              : InkWell(
                  onTap: () {
                    context
                        .read<FileProcessorBloc>()
                        .add(PickAndProcessFileEvent());
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        AppImage.circle,
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.09,
                      ),
                      const Icon(
                        Icons.upload,
                        color: AppColor.primaryColor2,
                      ),
                    ],
                  ),
                ),
          hintText: widget.content != null ? "" : "Enter Something...",
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: 10,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        expands: false,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final bool isUserMessage = message.isUser;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUserMessage
                  ? AppColor.containerColor
                  : AppColor.containerColor,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: isUserMessage
                    ? Colors.black.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ),
          if (!isUserMessage)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteAndTextPage(
                      isConvertable: false,
                      text: message.text,
                      isText: false,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget bottomsheet(BuildContext context) {
    return BlocBuilder<FileProcessorBloc, FileProcessorState>(
      builder: (context, state) {
        bool showBottomSheet = false;
        String extractedText = '';

        if (state is FileProcessorSuccess) {
          extractedText = state.extractedText;
          showBottomSheet = extractedText.isNotEmpty;
        }

        showBottomSheet =
            showBottomSheet || _enterSomethingController.text.isNotEmpty;

        if (!showBottomSheet && state is FileProcessorInitial) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _enterSomethingController.text.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColor.containerColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: TextField(
                                      focusNode: _focusNode,
                                      controller: _askAnythingController,
                                      enabled: _enterSomethingController
                                          .text.isNotEmpty,
                                      decoration: const InputDecoration(
                                        hintText: "Ask anything...",
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                      ),
                                      onSubmitted: (text) {
                                        if (_enterSomethingController
                                            .text.isNotEmpty) {
                                          _handleUserMessage(text);
                                        }
                                      },
                                    )),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () => _handleUserMessage(
                                          _askAnythingController.text),
                                      child: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }

        return showBottomSheet
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColor.containerColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: TextField(
                                    focusNode: _focusNode,
                                    controller: _askAnythingController,
                                    enabled: true,
                                    decoration: const InputDecoration(
                                      hintText: "Ask anything...",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    onSubmitted: (text) =>
                                        _handleUserMessage(text),
                                  )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () => _handleUserMessage(
                                        _askAnythingController.text),
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              )
            : LoadingDialog(title: "Loading....");
      },
    );
  }

  Widget _chatMessageContent() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _messages.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _messages.length && _isLoading) {
              return TypingIndicator();
            }
            final message = _messages[index];
            return _buildMessageBubble(message, index);
          },
        ),
      ),
    );
  }
}
