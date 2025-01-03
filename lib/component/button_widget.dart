import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.width,
      required this.heigh,
      required this.text,
      required this.onpress,
      required this.textColor,
      this.size = 0.02,
      required this.bgColor});

  final double width;
  final double heigh;
  final String text;
  final Function()? onpress;
  final Color textColor;
  final double size;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        width: width,
        height: heigh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonText(
              title: text,
              color: textColor,
              size: size,
              fontFamly: AppFont.robot,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
