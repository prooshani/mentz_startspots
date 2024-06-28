import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/app_pages.dart';
import 'package:mentz_startspots/controllers/app_routes.dart';
import 'package:mentz_startspots/controllers/home_bindings.dart';
import 'package:mentz_startspots/home.dart';
import 'package:mentz_startspots/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // GetMaterialApp is a widget that provides access to GetX features.
    // specificly the initial routes and the theme.

    return GetMaterialApp(
      navigatorKey: Get.key,
      onReady: () async {},
      onDispose: () async {},
      initialBinding: HomeBinding(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Mentz StartSpots',
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
      getPages: AppPages.list,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}
