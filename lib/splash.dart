import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';
import 'package:mentz_startspots/home.dart';

// This is the splash screen widget which is the first screen that the user sees when the app is opened
// It will show the MENTZ logo, the app's title and the app's logo
// After 3 seconds, it will navigate to the home screen
// The splash screen is a getview widget which is a GetX widget that is used to manage the state of the app
// The controller of the splash screen is SplashScreenController
// The controller is used to manage the state of the splash screen
class SplashScreen extends GetView<SplashScreenController> {
  static const String id = 'Splash_Screen'; // This is the route name

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This will navigate to the home screen after 3 seconds.
    Future.delayed(const Duration(seconds: 3)).then((value) => Get.to(() => const HomeScreen()));
    // This is the main scaffold widget of the splash screen
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        // a column of 3 widgets. The first is the MENTZ logo, the second is the title and the third is the app's logo
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                // This is the image widget which includes the MENTZ logo
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
                      // This is the text widget which includes the title of application
                      "StartSpots",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Image.asset(
                        // This is the image widget which includes the app's logo
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
    );
  }
}
