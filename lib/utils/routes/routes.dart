// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/audio-to-text/page/bottom-nav.dart/bottom-nav-page.dart';
import 'package:new_wall_paper_app/audio-to-text/page/personal_development_screen.dart';
import 'package:new_wall_paper_app/utils/routes/route_name.dart';
import 'package:new_wall_paper_app/view/onboard_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argum = settings.arguments;

    switch (settings.name) {
      case RoutesName.onboardingScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingScreen());
      case RoutesName.bottomNavigationPage:
        return MaterialPageRoute(
            builder: (BuildContext context) => BottomNavigationPage());
      case RoutesName.PersonalDevelopmentScreeen:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                 PersonalDevelopmentScreeen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text("No route defined")),
          );
        });
    }
  }
}
