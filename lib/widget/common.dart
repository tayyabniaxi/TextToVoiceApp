// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/model/chatbot_model.dart';

class CommonFile {
  static scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }


}
