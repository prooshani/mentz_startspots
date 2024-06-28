import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';
import 'package:mentz_startspots/home.dart';

class SplashScreen extends GetView<SplashScreenController> {
  static const String id = 'Splash_Screen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) => Get.to(() => const HomeScreen()));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/mentz_logo_dark.png",
                  scale: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "StartSpots",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Image.asset(
                          "images/logo-256.png",
                          scale: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
