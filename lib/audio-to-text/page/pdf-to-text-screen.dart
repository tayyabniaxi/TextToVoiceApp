// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-bloc-class.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/pdf-to-text-bloc/pdf-to-text-state.dart';

import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/component/typing_indicator_widget.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';
import 'dart:convert';
import 'package:new_wall_paper_app/model/chatbot_model.dart';
import 'package:new_wall_paper_app/res/app_url.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-bloc-class.dart';
import 'package:http/http.dart' as http;
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-state-class.dart';

class PDFToTextScreen extends StatefulWidget {
  const PDFToTextScreen({super.key});

  @override
  State<PDFToTextScreen> createState() => _PDFToTextScreenState();
}

class _PDFToTextScreenState extends State<PDFToTextScreen> {
  final TextEditingController _askAnythingController = TextEditingController();
  final TextEditingController _enterSomethingController =
      TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String docsString = '';
  bool isDocsString = false;
  bool isFileSelectContent = false;
  bool isChat = false;
  ScrollController _scrollController = ScrollController();

  FocusNode _focusNode = FocusNode();
  bool _isTextFieldFocused = false;

  String _enterSomethingsummary = '';
  String enterSomething = '';
  bool isSummarizeText = false;
  String refreshContent = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    _askAnythingController.dispose();
    _enterSomethingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hieht = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        context.read<PDFReaderBloc>().add(ResetToPreviousStateEvent());
        return true;
      },
      child: BlocConsumer<PDFReaderBloc, PDFReaderState>(
        listener: (context, state) {
          if (state is PDFReaderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PDFReaderLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is PDFReaderLoaded) {
            return Scaffold(
              bottomNavigationBar: bottomsheet(context, state),
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: hieht * 0.03,
                    )),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: width * 0.03, top: hieht * 0.023),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteAndTextPage(
                              isConvertable: true,
                              text: state.pdfText,
                              isText: false,
                            ),
                          ),
                        );
                      },
                      child: CommonText(
                        title: "Next",
                        color: Colors.black,
                        size: 0.02,
                        fontFamly: AppFont.robot,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              body: ListView(
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: hieht * 0.45),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: hieht * 0.02),
                            // height: hieht*0.3,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 7),

                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(10)),
                            child: CommonText(
                              title: state.pdfText,
                              color: Colors.black54,
                              size: 0.02,
                              fontWeight: FontWeight.w400,
                              fontFamly: AppFont.robot,
                            ),
                          ),
                          height(size: 0.04),
                          isChat
                              ? Container()
                              : CommonText(
                                  title: "Summarize this Doc",
                                  color: AppColor.primaryColor2,
                                  size: 0.03,
                                  fontWeight: FontWeight.bold,
                                  fontFamly: AppFont.robot,
                                ),
                          isChat ? Container() : height(size: 0.023),
                          isChat
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.1),
                                  child: CommonText(
                                    title:
                                        "Get short summaries from long web articles. just paste the link and get a quick summary in seconds",
                                    color: Colors.black54,
                                    size: 0.02,
                                    fontWeight: FontWeight.w400,
                                    fontFamly: AppFont.robot,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          isChat ? Container() : height(size: 0.04),
                          isChat
                              ? Container()
                              : _starSummarizeButton(context, state),
                        ],
                      ),
                    ),
                  ),
                  _chatMessageContent()
                ],
              ),
            );
          } else if (state is PDFReaderError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No PDF fselected"));
        },
      ),
    );
  }

  Widget _chatMessageContent() {
    return Container(
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
    );
  }

  InkWell _starSummarizeButton(BuildContext context, PDFReaderLoaded state) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => SummarizePage(
        //             isOtherPage: false,
        //             content: state.pdfText,
        //             isEnableBtn: true,
        //           )),

        // );
        _isLoading ? null : _summarizeText(state.pdfText);
      },
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.37,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.primaryColor2),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/star.png",
                color: Colors.amber,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              const SizedBox(
                width: 6,
              ),
              CommonText(
                title: _isLoading ? "Summarizing" : "Summarize",
                color: Colors.black,
                size: 0.02,
                fontWeight: FontWeight.w500,
                fontFamly: AppFont.robot,
              ),
            ],
          ),
        ),
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
                      ? Colors.black.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontFamily: AppFont.robot,
                  fontWeight: FontWeight.w400),
            ),
          ),
          if (!isUserMessage)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteAndTextPage(
                      isConvertable: true,
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

  Future<void> _summarizeText(String text) async {
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text to summarize')),
      );
      return;
    }
    // // Show loading dialog
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) => const LoadingDialog(),
    // );
    setState(() {
      _isLoading = true;
      _enterSomethingsummary = '';
    });

    const String apiKey = Apis.cloudApi;
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent';

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteAndTextPage(
                isConvertable: false,
                text: _enterSomethingsummary,
                isText: false,
              ),
            ),
          );
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

  Future<void> _handleUserMessage(String text, PDFReaderLoaded state) async {
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
      // Determine which content to use as context
      String contextContent = '';
      if (isSummarizeText && _enterSomethingsummary.isNotEmpty) {
        // Use summarized content if available
        contextContent = _enterSomethingsummary;
      } else if (state.pdfText != null && state.pdfText!.isNotEmpty) {
        // Use constructor content if available
        contextContent = state.pdfText!;
      } else if (context.read<FileProcessorBloc>().isExtractContent) {
        // Use extracted file content if available
        final state = context.read<FileProcessorBloc>().state;
        if (state is FileProcessorSuccess) {
          contextContent = state.extractedText;
        }
      }

      // Construct the prompt based on available content
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
            'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent'),
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
          isChat = true;
          _isLoading = false;
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

  Widget bottomsheet(BuildContext context, PDFReaderLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
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
                        decoration: const InputDecoration(
                          hintText: "Ask anything...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (text) => _handleUserMessage(text, state),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.03,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => _handleUserMessage(
                            _askAnythingController.text, state),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
