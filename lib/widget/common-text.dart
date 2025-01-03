// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String title;
  final Color color;
  final double size;
  final String? fontFamly;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final int? maxLine;
  final TextOverflow? textOverflow;

  CommonText({
    required this.title,
    required this.color,
    required this.size,
    this.textAlign,
    this.fontFamly,
    this.fontWeight,
    this.maxLine,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: fontFamly,
        color: color,
        fontSize: MediaQuery.of(context).size.height * size,
        fontWeight: fontWeight,
      ),
    );
  }
}
