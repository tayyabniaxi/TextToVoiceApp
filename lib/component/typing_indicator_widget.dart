// First, create a typing indicator widget
// ignore_for_file: prefer_final_fields, unused_field, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/model/chatbot_model.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
class TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<double> _dotPositions = [0, 0, 0];
 ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();

    _controller.addListener(() {
      setState(() {
        for (int i = 0; i < 3; i++) {
          final double phase = i * 0.35;
          _dotPositions[i] = sin((_controller.value * 2 * pi) + phase) * 5;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColor.containerColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                shape: BoxShape.circle,
              ),
              transform: Matrix4.translationValues(0, _dotPositions[index], 0),
            );
          }),
        ),
      ),
    );
  }
}

// Animated text widget for message content
class AnimatedTextMessage extends StatefulWidget {
  final String text;
  final TextStyle? style;

  AnimatedTextMessage({required this.text, this.style});

  @override
  _AnimatedTextMessageState createState() => _AnimatedTextMessageState();
}

class _AnimatedTextMessageState extends State<AnimatedTextMessage>
    with SingleTickerProviderStateMixin {
  String _displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;
  bool _isComplete = false;
 ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText = widget.text.substring(0, _currentIndex + 1);
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}

// Modified message bubble builder
Widget _buildMessageBubble(
    ChatMessage message, int index, BuildContext context) {
  return Align(
    alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color:
            message.isUser ? AppColor.primaryColor2 : AppColor.containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(bottom: message.isUser ? 0 : 40, right: 10),
            child: message.isUser
                ? Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : AnimatedTextMessage(
                    text: message.text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
          ),
          if (!message.isUser)
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
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
                  color: AppColor.primaryColor2,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

