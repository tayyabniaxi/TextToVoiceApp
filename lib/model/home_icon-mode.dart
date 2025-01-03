// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Item {
  final String text;
  final String des;
  final String imageUrl;
  final Color color;

  Item(
      {required this.text,
      required this.imageUrl,
      required this.color,
      required this.des});
}

class statusType {
  final String text;

  statusType({required this.text});
}

// lib/models/summary_model.dart
class SummaryModel {
  final String text;
  final DateTime createdAt;

  SummaryModel({
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from JSON
  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      text: json['text'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };
}
