import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/page_controllers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
  }
}
