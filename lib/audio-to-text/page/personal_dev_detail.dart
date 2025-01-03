// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/component/loading_dialog.dart';
import 'package:new_wall_paper_app/model/chatbot_model.dart';
import 'package:new_wall_paper_app/model/course_model.dart';
import 'package:new_wall_paper_app/res/app_url.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/widget/height-widget.dart';
import 'package:http/http.dart' as http;
// quotes_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';


abstract class QuotesEvent {}

class FetchNewQuotes extends QuotesEvent {}

// quotes_state.dart
abstract class QuotesState {}

class QuotesInitial extends QuotesState {}

class QuotesLoading extends QuotesState {}

class QuotesLoaded extends QuotesState {
  final List<String> quotes;

  QuotesLoaded(this.quotes);
}

class QuotesError extends QuotesState {
  final String message;

  QuotesError(this.message);
}

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  final List<String> allQuotes = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "Ut enim ad minim veniam, quis nostrud exercitation ullamco.",
    "Duis aute irure dolor in reprehenderit in voluptate velit.",
    "Excepteur sint occaecat cupidatat non proident.",
    "Sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "Nemo enim ipsam voluptatem quia voluptas sit aspernatur.",
    "Neque porro quisquam est, qui dolorem ipsum quia dolor.",
  ];

  QuotesBloc() : super(QuotesInitial()) {
    on<FetchNewQuotes>(_handleFetchNewQuotes);
  }

  void _handleFetchNewQuotes(FetchNewQuotes event, Emitter<QuotesState> emit) {
    try {
      emit(QuotesLoading());

      // Shuffle quotes and get random number between 2-4
      final shuffled = List<String>.from(allQuotes)..shuffle();
      final randomCount = Random().nextInt(3) + 2; // 2 to 4
      final selectedQuotes = shuffled.take(randomCount).toList();

      emit(QuotesLoaded(selectedQuotes));
    } catch (e) {
      emit(QuotesError('Failed to fetch quotes: $e'));
    }
  }
}

class PersonalDevDetailScreen extends StatelessWidget {
  final String content;
  PersonalDevDetailScreen({required this.content});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuotesBloc(),
      child: QuotesView(content: content),
    );
  }
}

class QuotesView extends StatefulWidget {
  final String content;
  QuotesView({required this.content});
  @override
  State<QuotesView> createState() => _QuotesViewState();
}

class _QuotesViewState extends State<QuotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColor.containerColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: _isLoading
                    ? Center(
                        child: LoadingDialog(
                        title: "Loading...",
                      ))
                    : Center(
                        child: CommonText(
                          textAlign: TextAlign.center,
                          title: _enterSomethingsummary != ""
                              ? _enterSomethingsummary
                              : widget.content,
                          color: Colors.black,
                          size: 0.03,
                          fontFamly: AppFont.robot,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  context.read<QuotesBloc>().add(FetchNewQuotes());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Find New Quotes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              height(size: 0.02),
              Align(
                alignment: Alignment.topLeft,
                child: CommonText(
                  title: "Suggest Prompt:",
                  color: Colors.black,
                  size: 0.02,
                  fontFamly: AppFont.robot,
                  fontWeight: FontWeight.w600,
                ).paddingOnly(left: 5),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<QuotesBloc, QuotesState>(
                  builder: (context, state) {
                    if (state is QuotesLoading) {
                      return Center(
                          child: LoadingDialog(
                        title: "Loading...",
                      ));
                    } else if (state is QuotesLoaded) {
                      return ListView.builder(
                        itemCount: state.quotes.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              _isLoading
                                  ? null
                                  : _summarizeText(
                                      state.quotes[index], context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  state.quotes[index],
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is QuotesError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Future<void> _summarizeText(String text, BuildContext context) async {
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
}
