// ignore_for_file: use_key_in_widget_constructors, unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/component/typing_indicator_widget.dart';
import 'package:new_wall_paper_app/model/chatbot_model.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:new_wall_paper_app/res/app_url.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-bloc-class.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-state-class.dart';

class CameraScreen extends StatefulWidget {
  final String text;
  CameraScreen({required this.text});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final TextEditingController _urlController = TextEditingController();
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
  var data = "";

  void _onFocusChange() {
    setState(() {
      _isTextFieldFocused = _focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double hieht = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: bottomsheet(context),
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
              padding: EdgeInsets.only(right: width * 0.03, top: hieht * 0.023),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteAndTextPage(
                        isConvertable: false,
                        text: widget.text,
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
              margin: EdgeInsets.symmetric(horizontal: width * 0.02),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              constraints: BoxConstraints(maxHeight: hieht * 0.4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: Text(
                  widget.text.isNotEmpty ? widget.text : 'No text extracted.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            isChat ? Container() : height(size: 0.04),
            _focusNode.hasFocus || isChat
                ? Container()
                : Column(
                    children: [
                      CommonText(
                        title: "Summarize this Link",
                        color: AppColor.primaryColor2,
                        size: 0.03,
                        fontWeight: FontWeight.bold,
                        fontFamly: AppFont.robot,
                      ),
                      height(size: 0.023),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
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
                      height(size: 0.04),
                      _summerButton(context),
                    ],
                  ),
            _chatMessageContent()
          ],
        ),
      ),
    );
  }

  InkWell _summerButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _isLoading ? null : _summarizeText(widget.text);
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

  Widget bottomsheet(BuildContext contex) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
                        onSubmitted: (text) => _handleUserMessage(widget.text),
                      ),
                    ),
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
                                _askAnythingController.text,
                              ),
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

  Widget _chatMessageContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
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
    const String apiUrl = Apis.geminiProSummarizeApis;

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
                text: _enterSomethingsummary,
                isConvertable: false,
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
      // ignore: avoid_print
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
      // Determine which content to use as context
      String contextContent = '';
      if (isSummarizeText && _enterSomethingsummary.isNotEmpty) {
        // Use summarized content if available
        contextContent = _enterSomethingsummary;
      } else if (widget.text != null && widget.text!.isNotEmpty) {
        // Use constructor content if available
        contextContent = widget.text!;
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
}
