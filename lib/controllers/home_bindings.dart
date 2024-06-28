import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';

// This class is used to define the bindings of the home screen
// It is used in the main.dart file to define the bindings of the home screen and Splash Screen
// This way we can expand the application with more bindings in the future much more easily
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // This will create a new instance of the SplashScreenController and HomeScreenController
    // lazyPut is used to create a new instance of the controller only when it is needed for memory optimization
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
  }
}
