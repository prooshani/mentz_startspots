import 'package:get/get.dart';
import 'package:mentz_startspots/controllers/app_routes.dart';
import 'package:mentz_startspots/controllers/home_bindings.dart';
import 'package:mentz_startspots/screens/home.dart';
import 'package:mentz_startspots/screens/splash.dart';

// This class is used to define the pages of the application
// It is used in the main.dart file to define the pages of the application
// This way we can expand the application with more pages in the future much more easily
// The class is using GetX's GetPage class to define the pages
class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      //  binding: DashboardBinding(),
    ),
  ];
}
