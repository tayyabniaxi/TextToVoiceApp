import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';

class BookCard extends StatelessWidget {
  final List<Color> backgroundColor;
  final String image;
  final String title;
  final String subtitle;

  const BookCard({
    required this.backgroundColor,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 170,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background container for the text
          Positioned(
            bottom: 0,
            child: Container(
              width: 170,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: backgroundColor,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16), top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  CommonText(
                    title: title,
                    color: Colors.white,
                    size: 0.019,
                    fontWeight: FontWeight.w700,
                  ),
                
                      CommonText(
                    title: subtitle,
                    color: Colors.white60,
                    size: 0.017,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
          // Image at the top
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              image,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
