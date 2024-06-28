import 'package:flutter/material.dart';
import 'package:mentz_startspots/home.dart';
import 'package:mentz_startspots/splash.dart';

// This class is used to define the routes of the application
// It is used in the main.dart file to define the routes of the application
// This way we can expand the application with more routes in the future much more easily
class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        switch (settings.name) {
          case home:
            return const HomeScreen();
          case splash:
            return const SplashScreen();
          default:
            return const SplashScreen();
        }
      },
    );
  }
}
