import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/helper/share_prefrence.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/utils/routes/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Top portion with images
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.only(top: 40),
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPhoneImage(AppImage.onboard1),
                _buildPhoneImage(AppImage.onboard2),
                _buildPhoneImage(AppImage.onboard3),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 0),
              child: CustomPaint(
                painter: CurvedContainerPainter(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      // Title
                      Text(
                        _getTitleForPage(_currentPage),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Description
                      Text(
                        'Lorem ipsum is A Placeholder Text\nCommonly Used To Demonstrate\nThe Visual Form',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.017,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      // Bottom navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              await AppPreferences.setFirstLaunchComplete();
                              Navigator.pushReplacementNamed(
                                  context, RoutesName.bottomNavigationPage);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xffEFF1FE)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_currentPage < 2) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                _completeOnboarding();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.pushReplacementNamed(context, RoutesName.bottomNavigationPage);
  }

  Widget _buildPhoneImage(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
        ),
      ),
    );
  }

  String _getTitleForPage(int page) {
    switch (page) {
      case 0:
        return 'Scanned Documents\n& Images';
      case 1:
        return 'Explore Books';
      case 2:
        return 'Transform PDF or\nother File Types';
      default:
        return '';
    }
  }
}

class CurvedContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();

    path.moveTo(0, 0);

    path.lineTo(size.width * 0, 0);

    path.quadraticBezierTo(
      size.width * 0.5,
      90,
      size.width * 1,
      0,
    );

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.lineTo(0, 0);
    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
